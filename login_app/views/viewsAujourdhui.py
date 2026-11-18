"""Jour J : activités et missions de l'utilisateur qui ont lieu aujourd'hui (ou sont en cours)."""

from datetime import timedelta
from zoneinfo import ZoneInfo

from django.db.models import Count, Q
from django.utils import timezone
from rest_framework.response import Response
from rest_framework.views import APIView

from login_app.models import Annonce, Candidature, GroupeDiscussion, Notification
from login_app.serializers import AnnonceMiniSerializer
from login_app.services import notifier

ACCEPTEE = Candidature.Statut.ACCEPTEE


def est_jour_j(annonce, now):
    """Vrai si l'annonce est en cours, ou commence aujourd'hui dans SON fuseau horaire (et n'est pas finie)."""
    if annonce.date_fin < now:
        return False
    if annonce.date_debut <= now:
        return True
    try:
        tz = ZoneInfo(annonce.fuseau_horaire)
    except Exception:
        tz = timezone.get_current_timezone()
    return annonce.date_debut.astimezone(tz).date() == now.astimezone(tz).date()


def _groupe(annonce, user):
    try:
        g = annonce.groupe
    except GroupeDiscussion.DoesNotExist:
        return None
    if not g.membres.filter(user=user).exists():
        return None
    return {"id": g.id, "est_ferme": g.est_ferme}


class AujourdhuiView(APIView):
    """
    GET /api/aujourdhui/
    Renvoie les engagements du jour (participant accepté ou organisateur) et envoie, une seule fois par jour
    et par annonce, une notification « C'est aujourd'hui ».
    """

    def get(self, request):
        user = request.user
        now = timezone.now()
        ctx = {"request": request}
        # Fenêtre large (36 h) puis filtrage précis selon le fuseau de chaque annonce
        mes_ids = Annonce.objects.filter(
            Q(association__user=user)
            | Q(createur__user=user)
            | Q(candidatures__citoyen__user=user, candidatures__statut=ACCEPTEE)
        ).values("id")
        candidates = (
            Annonce.objects.filter(
                id__in=mes_ids, date_fin__gte=now, date_debut__lte=now + timedelta(hours=36), est_active=True
            )
            .select_related("association", "createur", "categorie")
            .annotate(nb_participants=Count("candidatures", filter=Q(candidatures__statut=ACCEPTEE), distinct=True))
            .order_by("date_debut")
        )

        items = []
        for a in candidates:
            if not est_jour_j(a, now):
                continue
            organisateur = a.organisateur_user.id == user.id
            cand = None
            if not organisateur and hasattr(user, "citoyen_profile"):
                cand = a.candidatures.filter(citoyen=user.citoyen_profile, statut=ACCEPTEE).first()
            items.append({
                "annonce": AnnonceMiniSerializer(a, context=ctx).data,
                "role": "ORGANISATEUR" if organisateur else "PARTICIPANT",
                "en_cours": a.date_debut <= now,
                "lieu": a.lieu,
                "latitude": a.latitude,
                "longitude": a.longitude,
                "icone": a.categorie.icone if a.categorie else "",
                "participants": a.nb_participants,
                "places": a.nombre_places,
                "groupe": _groupe(a, user),
                "candidature": cand.id if cand else None,
                # QR de présence : missions d'association, pour le participant accepté non encore pointé
                "code_presence": str(cand.code_presence) if cand and a.association_id and not cand.presence_confirmee else None,
                "presence_confirmee": bool(cand and cand.presence_confirmee),
            })
            self._notifier_une_fois(user, a, organisateur, now)

        return Response({"maintenant": now, "evenements": items})

    @staticmethod
    def _notifier_une_fois(user, annonce, organisateur, now):
        lien = f"/missions/{annonce.id}"
        deja = Notification.objects.filter(
            destinataire=user, lien=lien, titre__startswith="📅", date_creation__gte=now - timedelta(hours=20)
        ).exists()
        if deja:
            return
        tz = ZoneInfo(annonce.fuseau_horaire)
        heure = annonce.date_debut.astimezone(tz).strftime("%H:%M")
        if organisateur:
            titre = "📅 C'est aujourd'hui : vous organisez !"
        else:
            titre = "📅 C'est aujourd'hui !"
        notifier(user, titre, f"« {annonce.titre} » à {heure} ({annonce.ville or annonce.lieu}).", lien)
