"""Historique personnel : tout ce que l'utilisateur a organisé, rejoint, donné ou évalué, en une seule frise."""

from django.db.models import Count, Q
from django.utils import timezone
from rest_framework.response import Response
from rest_framework.views import APIView

from login_app.models import Annonce, Avis, Candidature, GroupeDiscussion
from login_app.serializers import AnnonceMiniSerializer

ACCEPTEE = Candidature.Statut.ACCEPTEE


def _categorie_candidature(annonce):
    if annonce.type == Annonce.AnnonceType.ACTIVITE:
        return "PARTICIPATION"
    if annonce.type == Annonce.AnnonceType.DON:
        return "DON"
    return "BENEVOLAT"


def _groupe(annonce, user):
    try:
        g = annonce.groupe
    except GroupeDiscussion.DoesNotExist:
        return None
    if not g.membres.filter(user=user).exists():
        return None
    return {"id": g.id, "est_ferme": g.est_ferme}


class HistoriqueView(APIView):
    """
    GET /api/historique/
    Catégories d'évènements : ORGANISEE (annonce que j'organise), PARTICIPATION (activité rejointe),
    BENEVOLAT (mission ou évènement associatif), DON, AVIS_DONNE, AVIS_RECU.
    """

    def get(self, request):
        user = request.user
        now = timezone.now()
        ctx = {"request": request}
        evenements = []

        # ------------------------------------------------ annonces organisées
        organisees = (
            Annonce.objects.filter(Q(association__user=user) | Q(createur__user=user))
            .select_related("association", "createur", "categorie")
            .annotate(
                nb_participants=Count("candidatures", filter=Q(candidatures__statut=ACCEPTEE), distinct=True),
                nb_demandes=Count("candidatures", filter=Q(candidatures__statut=Candidature.Statut.EN_ATTENTE), distinct=True),
            )
        )
        for a in organisees:
            evenements.append({
                "id": f"a-{a.id}",
                "categorie": "ORGANISEE",
                "date": a.date_debut,
                "date_action": a.date_creation,
                "statut": "TERMINEE" if a.date_fin < now else ("CLOTUREE" if not a.est_active else "A_VENIR"),
                "annonce": AnnonceMiniSerializer(a, context=ctx).data,
                "details": {
                    "participants": a.nb_participants,
                    "places": a.nombre_places,
                    "demandes": a.nb_demandes,
                    "groupe": _groupe(a, user),
                    "icone": a.categorie.icone if a.categorie else "",
                },
            })

        # ------------------------------------------------ participations, bénévolat, dons
        if hasattr(user, "citoyen_profile"):
            candidatures = Candidature.objects.filter(citoyen=user.citoyen_profile).select_related(
                "annonce", "annonce__association", "annonce__createur", "annonce__categorie"
            )
            for c in candidatures:
                a = c.annonce
                evenements.append({
                    "id": f"c-{c.id}",
                    "categorie": _categorie_candidature(a),
                    "date": a.date_debut,
                    "date_action": c.date_candidature,
                    "statut": c.statut,
                    "annonce": AnnonceMiniSerializer(a, context=ctx).data,
                    "details": {
                        "candidature": c.id,
                        "terminee": a.date_fin < now,
                        "presence_confirmee": c.presence_confirmee,
                        "heures": float(c.heures_effectuees),
                        "note_engagement": c.note_engagement,
                        "quantite_don": float(c.quantite_don) if c.quantite_don is not None else None,
                        "unite_don": a.unite_don,
                        "attestation": c.statut == ACCEPTEE and c.presence_confirmee and a.association_id is not None,
                        "groupe": _groupe(a, user) if c.statut == ACCEPTEE else None,
                        "icone": a.categorie.icone if a.categorie else "",
                    },
                })

        # ------------------------------------------------ avis
        avis = Avis.objects.filter(Q(auteur=user) | Q(cible=user)).select_related(
            "auteur", "cible", "annonce", "annonce__association", "annonce__createur",
            "auteur__citoyen_profile", "auteur__association_profile", "cible__citoyen_profile", "cible__association_profile",
        )
        for av in avis:
            donne = av.auteur_id == user.id
            autre = av.cible if donne else av.auteur
            evenements.append({
                "id": f"v-{av.id}",
                "categorie": "AVIS_DONNE" if donne else "AVIS_RECU",
                "date": av.date_creation,
                "date_action": av.date_creation,
                "statut": "PUBLIE",
                "annonce": AnnonceMiniSerializer(av.annonce, context=ctx).data,
                "details": {"note": av.note, "commentaire": av.commentaire, "personne": _nom(autre)},
            })

        evenements.sort(key=lambda e: e["date"], reverse=True)

        def compte(cat, **filtre):
            return sum(1 for e in evenements if e["categorie"] == cat and all(e.get(k) == v for k, v in filtre.items()))

        resume = {
            "organisees": compte("ORGANISEE"),
            "participations": compte("PARTICIPATION", statut=ACCEPTEE),
            "benevolat": compte("BENEVOLAT", statut=ACCEPTEE),
            "dons": compte("DON", statut=ACCEPTEE),
            "avis_recus": compte("AVIS_RECU"),
            "avis_donnes": compte("AVIS_DONNE"),
            "heures": sum(e["details"].get("heures", 0) or 0 for e in evenements if e["categorie"] == "BENEVOLAT"),
            "a_venir": sum(
                1 for e in evenements
                if e["date"] >= now and e["categorie"] != "ORGANISEE" and e["statut"] in (ACCEPTEE, Candidature.Statut.EN_ATTENTE)
            ) + sum(1 for e in evenements if e["categorie"] == "ORGANISEE" and e["statut"] == "A_VENIR"),
        }
        return Response({"resume": resume, "evenements": evenements})


def _nom(user):
    if hasattr(user, "association_profile"):
        return user.association_profile.nom
    if hasattr(user, "citoyen_profile"):
        return str(user.citoyen_profile)
    return user.username
