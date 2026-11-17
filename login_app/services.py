"""Logique métier partagée : notifications, badges, statistiques d'engagement."""

import logging

from asgiref.sync import async_to_sync
from channels.layers import get_channel_layer
from django.db.models import Avg, Count, Q, Sum
from django.utils import timezone

from .models import Annonce, AssociationProfile, Avis, Candidature, CitoyenProfile, Notification

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
        missions=Count("id", filter=Q(presence_confirmee=True)),
        dons=Count("id", filter=Q(annonce__type=Annonce.AnnonceType.DON)),
    )
    avis = Avis.objects.filter(cible=citoyen.user).aggregate(moyenne=Avg("note"), total=Count("id"))
    stats = {
        "heures_benevolat": float(agg["heures"] or 0),
        "missions_realisees": agg["missions"] or 0,
        "dons_effectues": agg["dons"] or 0,
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
