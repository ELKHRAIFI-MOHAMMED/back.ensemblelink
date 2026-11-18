"""Logique métier partagée : notifications, badges, statistiques d'engagement."""

import logging

from asgiref.sync import async_to_sync
from channels.layers import get_channel_layer
from django.db.models import Avg, Count, Q, Sum
from django.utils import timezone

from .models import (
    Annonce, AssociationProfile, Avis, Candidature, CitoyenProfile, GroupeDiscussion, MembreGroupe, MessageGroupe,
    Notification,
)

logger = logging.getLogger(__name__)


# ---------------------------------------------------------------- notifications

def notifier(destinataire, titre, message="", lien=""):
    """Crée une notification et la pousse en temps réel via WebSocket (si connecté)."""
    notif = Notification.objects.create(destinataire=destinataire, titre=titre, message=message, lien=lien)
    try:
        layer = get_channel_layer()
        if layer is not None:
            async_to_sync(layer.group_send)(
                f"notif_{destinataire.id}",
                {
                    "type": "notification",
                    "notification": {
                        "id": notif.id,
                        "titre": notif.titre,
                        "message": notif.message,
                        "lien": notif.lien,
                        "lue": notif.lue,
                        "date_creation": notif.date_creation.isoformat(),
                    },
                },
            )
    except Exception:  # la notification reste en base même si le push échoue
        logger.exception("Échec de l'envoi temps réel de la notification %s", notif.id)
    return notif


# ---------------------------------------------------------------- statistiques

def stats_citoyen(citoyen: CitoyenProfile):
    acceptees = citoyen.candidatures.filter(statut=Candidature.Statut.ACCEPTEE)
    agg = acceptees.aggregate(
        heures=Sum("heures_effectuees"),
        missions=Count("id", filter=Q(presence_confirmee=True, annonce__association__isnull=False)),
        dons=Count("id", filter=Q(annonce__type=Annonce.AnnonceType.DON)),
        activites=Count("id", filter=Q(annonce__type=Annonce.AnnonceType.ACTIVITE)),
    )
    avis = Avis.objects.filter(cible=citoyen.user).aggregate(moyenne=Avg("note"), total=Count("id"))
    stats = {
        "heures_benevolat": float(agg["heures"] or 0),
        "missions_realisees": agg["missions"] or 0,
        "dons_effectues": agg["dons"] or 0,
        "activites_rejointes": agg["activites"] or 0,
        "activites_organisees": citoyen.activites_organisees.count(),
        "candidatures_total": citoyen.candidatures.count(),
        "candidatures_en_attente": citoyen.candidatures.filter(statut=Candidature.Statut.EN_ATTENTE).count(),
        "note_moyenne": round(avis["moyenne"], 1) if avis["moyenne"] else None,
        "nombre_avis": avis["total"],
    }
    stats["badges"] = calculer_badges(stats)
    return stats


def stats_association(association: AssociationProfile):
    annonces = association.annonces.all()
    candidatures = Candidature.objects.filter(annonce__association=association)
    agg = candidatures.filter(statut=Candidature.Statut.ACCEPTEE).aggregate(
        heures=Sum("heures_effectuees"),
        benevoles=Count("citoyen", distinct=True),
    )
    avis = Avis.objects.filter(cible=association.user).aggregate(moyenne=Avg("note"), total=Count("id"))
    total_cand = candidatures.count()
    # Taux de présence : uniquement les missions terminées où une présence physique est attendue (hors DON)
    attendues = candidatures.filter(
        statut=Candidature.Statut.ACCEPTEE, annonce__date_fin__lt=timezone.now()
    ).exclude(annonce__type=Annonce.AnnonceType.DON)
    acceptees = attendues.count()
    presents = attendues.filter(presence_confirmee=True).count()
    return {
        "annonces_total": annonces.count(),
        "annonces_actives": annonces.filter(est_active=True).count(),
        "candidatures_total": total_cand,
        "candidatures_en_attente": candidatures.filter(statut=Candidature.Statut.EN_ATTENTE).count(),
        "benevoles_mobilises": agg["benevoles"] or 0,
        "heures_benevolat": float(agg["heures"] or 0),
        "taux_presence": round(presents * 100 / acceptees) if acceptees else None,
        "note_moyenne": round(avis["moyenne"], 1) if avis["moyenne"] else None,
        "nombre_avis": avis["total"],
    }


def stats_globales():
    acceptees = Candidature.objects.filter(statut=Candidature.Statut.ACCEPTEE)
    return {
        "associations": AssociationProfile.objects.filter(
            statut_verification=AssociationProfile.StatutVerification.VERIFIEE
        ).count(),
        "benevoles": CitoyenProfile.objects.count(),
        "missions": Annonce.objects.count(),
        "missions_actives": Annonce.objects.filter(est_active=True).count(),
        "activites": Annonce.objects.filter(type=Annonce.AnnonceType.ACTIVITE).count(),
        "pays": len(
            set(Annonce.objects.values_list("pays", flat=True).distinct())
            | set(CitoyenProfile.objects.values_list("pays", flat=True).distinct())
        ),
        "heures_benevolat": float(acceptees.aggregate(h=Sum("heures_effectuees"))["h"] or 0),
        "engagements": acceptees.count(),
    }


# ---------------------------------------------------------------- badges

BADGES = [
    # (code, libellé, emoji, description, condition)
    ("premiere_mission", "Premier pas", "🌱", "Première mission réalisée", lambda s: s["missions_realisees"] >= 1),
    ("engage", "Engagé·e", "🤝", "5 missions réalisées", lambda s: s["missions_realisees"] >= 5),
    ("pilier", "Pilier solidaire", "🏛️", "15 missions réalisées", lambda s: s["missions_realisees"] >= 15),
    ("heures_10", "10 heures", "⏱️", "10 heures de bénévolat", lambda s: s["heures_benevolat"] >= 10),
    ("heures_50", "50 heures", "🔥", "50 heures de bénévolat", lambda s: s["heures_benevolat"] >= 50),
    ("rassembleur", "Rassembleur", "🎉", "A organisé une activité", lambda s: s["activites_organisees"] >= 1),
    ("sociable", "Sociable", "🫂", "3 activités rejointes", lambda s: s["activites_rejointes"] >= 3),
    ("donateur", "Cœur généreux", "💝", "Au moins un don effectué", lambda s: s["dons_effectues"] >= 1),
    (
        "apprecie",
        "Très apprécié·e",
        "⭐",
        "Note moyenne ≥ 4,5 avec au moins 3 avis",
        lambda s: (s["note_moyenne"] or 0) >= 4.5 and s["nombre_avis"] >= 3,
    ),
]


def calculer_badges(stats):
    return [
        {"code": code, "libelle": libelle, "emoji": emoji, "description": desc, "obtenu": bool(cond(stats))}
        for code, libelle, emoji, desc, cond in BADGES
    ]


# ---------------------------------------------------------------- groupes de discussion

def _nom_affiche(user):
    if hasattr(user, "association_profile"):
        return user.association_profile.nom
    if hasattr(user, "citoyen_profile"):
        return str(user.citoyen_profile)
    return user.username


def serialiser_message_groupe(msg: MessageGroupe):
    auteur = None
    if msg.auteur_id:
        auteur = {"id": msg.auteur_id, "nom_affiche": _nom_affiche(msg.auteur)}
    return {
        "id": msg.id,
        "contenu": msg.contenu,
        "auteur": auteur,
        "systeme": msg.systeme,
        "date_envoi": msg.date_envoi.isoformat(),
    }


def poster_message_groupe(groupe, contenu, auteur=None, systeme=False):
    """Enregistre un message et le diffuse en temps réel aux membres connectés."""
    msg = MessageGroupe.objects.create(groupe=groupe, auteur=auteur, contenu=contenu, systeme=systeme)
    try:
        layer = get_channel_layer()
        if layer is not None:
            async_to_sync(layer.group_send)(
                f"groupe_{groupe.id}", {"type": "groupe_message", "message": serialiser_message_groupe(msg)}
            )
    except Exception:
        logger.exception("Échec du push temps réel vers le groupe %s", groupe.id)
    return msg


def creer_groupe(annonce, nom=""):
    """Crée le groupe d'une annonce : l'organisateur + tous les participants déjà acceptés."""
    groupe = GroupeDiscussion.objects.create(annonce=annonce, nom=(nom or "").strip() or annonce.titre)
    MembreGroupe.objects.create(groupe=groupe, user=annonce.organisateur_user, role=MembreGroupe.Role.ORGANISATEUR)
    poster_message_groupe(
        groupe,
        f"👋 Groupe créé par {annonce.organisateur_nom}. Les participants acceptés le rejoignent automatiquement ; "
        "il sera fermé à la fin de l'activité.",
        systeme=True,
    )
    for cand in annonce.candidatures.filter(statut=Candidature.Statut.ACCEPTEE).select_related("citoyen__user"):
        ajouter_membre(groupe, cand.citoyen.user)
    return groupe


def ajouter_membre(groupe, user):
    membre, cree = MembreGroupe.objects.get_or_create(groupe=groupe, user=user)
    if cree and not groupe.est_ferme:
        poster_message_groupe(groupe, f"{_nom_affiche(user)} a rejoint le groupe.", systeme=True)
        notifier(user, "Vous avez rejoint un groupe 💬", f"« {groupe.nom} »", f"/messages?groupe={groupe.id}")
    return membre


def retirer_membre(groupe, user):
    supprimes, _ = MembreGroupe.objects.filter(groupe=groupe, user=user, role=MembreGroupe.Role.MEMBRE).delete()
    if supprimes and not groupe.est_ferme:
        poster_message_groupe(groupe, f"{_nom_affiche(user)} a quitté le groupe.", systeme=True)


def fermer_groupe(groupe, raison="L'activité est terminée"):
    if groupe.ferme:
        return False
    groupe.ferme = True
    groupe.date_fermeture = timezone.now()
    groupe.save(update_fields=["ferme", "date_fermeture"])
    poster_message_groupe(groupe, f"🔒 {raison} : le groupe est maintenant fermé (lecture seule).", systeme=True)
    return True


def fermer_groupes_expires():
    """Ferme automatiquement les groupes dont l'annonce est terminée. Appelé à chaque consultation
    des groupes et par la commande `fermer_groupes` (tâche planifiée)."""
    n = 0
    expires = GroupeDiscussion.objects.filter(ferme=False, annonce__date_fin__lt=timezone.now())
    for groupe in expires.select_related("annonce"):
        n += fermer_groupe(groupe)
    return n
