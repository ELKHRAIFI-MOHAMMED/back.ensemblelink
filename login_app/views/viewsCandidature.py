import io
import uuid

from django.http import FileResponse
from django.shortcuts import get_object_or_404
from django.utils import timezone
from rest_framework import generics, status
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from login_app.models import Candidature
from login_app.permissions import IsAdmin, IsAssociation, IsCitoyen
from login_app.serializers import CandidatureGestionSerializer, CandidatureSerializer
from login_app.services import notifier

Statut = Candidature.Statut


def _queryset_base():
    return Candidature.objects.select_related(
        "citoyen", "citoyen__user", "annonce", "annonce__association", "annonce__association__user"
    )


class CandidatureCreateView(generics.CreateAPIView):
    """POST /api/candidatures/ : un citoyen postule à une annonce."""

    serializer_class = CandidatureSerializer
    permission_classes = [IsCitoyen]

    def perform_create(self, serializer):
        cand = serializer.save()
        notifier(
            cand.annonce.association.user,
            "Nouvelle candidature",
            f"{cand.citoyen} a postulé à « {cand.annonce.titre} ».",
            "/espace",
        )


class CandidatureAdminListView(generics.ListAPIView):
    serializer_class = CandidatureSerializer
    permission_classes = [IsAdmin]
    filterset_fields = ["statut", "annonce"]
    queryset = _queryset_base()


class MesCandidaturesView(generics.ListAPIView):
    """Citoyen : ses candidatures. Association : les candidatures reçues sur ses annonces."""

    serializer_class = CandidatureSerializer
    filterset_fields = ["statut", "annonce"]
    ordering_fields = ["date_candidature"]

    def get_queryset(self):
        user = self.request.user
        if hasattr(user, "citoyen_profile"):
            return _queryset_base().filter(citoyen=user.citoyen_profile)
        if hasattr(user, "association_profile"):
            return _queryset_base().filter(annonce__association=user.association_profile)
        return Candidature.objects.none()


class CandidatureDetailView(APIView):
    """
    GET    : citoyen propriétaire ou association de l'annonce.
    PATCH  : citoyen → message / quantite_don (si en attente) ;
             association → statut, note, présence, heures.
    DELETE : le citoyen retire sa candidature tant qu'elle est en attente.

    Correctifs : avant, personne ne pouvait supprimer une candidature, et un
    PUT permettait de réattribuer la candidature à un autre citoyen.
    """

    permission_classes = [IsAuthenticated]

    def _get(self, request, pk):
        user = request.user
        if hasattr(user, "citoyen_profile"):
            return get_object_or_404(_queryset_base(), pk=pk, citoyen=user.citoyen_profile)
        if hasattr(user, "association_profile"):
            return get_object_or_404(_queryset_base(), pk=pk, annonce__association=user.association_profile)
        return None

    def get(self, request, pk):
        cand = self._get(request, pk)
        if cand is None:
            return Response({"detail": "Profil non autorisé."}, status=status.HTTP_403_FORBIDDEN)
        return Response(CandidatureSerializer(cand, context={"request": request}).data)

    def patch(self, request, pk):
        cand = self._get(request, pk)
        if cand is None:
            return Response({"detail": "Profil non autorisé."}, status=status.HTTP_403_FORBIDDEN)
        ctx = {"request": request}

        if request.user.type == "CITOYEN":
            data = {k: v for k, v in request.data.items() if k in ("message", "quantite_don")}
            serializer = CandidatureSerializer(cand, data=data, partial=True, context=ctx)
            serializer.is_valid(raise_exception=True)
            serializer.save()
            return Response(serializer.data)

        ancien_statut, ancienne_presence = cand.statut, cand.presence_confirmee
        serializer = CandidatureGestionSerializer(cand, data=request.data, partial=True, context=ctx)
        serializer.is_valid(raise_exception=True)
        if "statut" in serializer.validated_data and serializer.validated_data["statut"] != ancien_statut:
            cand = serializer.save(date_reponse=timezone.now())
            accepte = cand.statut == Statut.ACCEPTEE
            notifier(
                cand.citoyen.user,
                "Candidature acceptée 🎉" if accepte else "Candidature non retenue",
                f"Votre candidature pour « {cand.annonce.titre} » a été {'acceptée' if accepte else 'refusée'}.",
                "/espace",
            )
        else:
            cand = serializer.save()
        if cand.presence_confirmee and not ancienne_presence:
            if not cand.heures_effectuees:
                cand.heures_effectuees = cand.annonce.duree_heures
                cand.save(update_fields=["heures_effectuees"])
            notifier(cand.citoyen.user, "Présence confirmée", f"Merci pour votre participation à « {cand.annonce.titre} » !", "/espace")
        return Response(CandidatureSerializer(cand, context=ctx).data)

    put = patch

    def delete(self, request, pk):
        if request.user.type != "CITOYEN":
            return Response(
                {"detail": "Une association refuse une candidature, elle ne la supprime pas."},
                status=status.HTTP_403_FORBIDDEN,
            )
        cand = self._get(request, pk)
        if cand.statut not in (Statut.EN_ATTENTE, Statut.REFUSEE):
            return Response(
                {"detail": "Candidature acceptée : utilisez « annuler » pour prévenir l'association."},
                status=status.HTTP_400_BAD_REQUEST,
            )
        cand.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class AnnulerCandidatureView(APIView):
    """Le citoyen se désiste d'une candidature acceptée (libère la place et prévient l'association)."""

    permission_classes = [IsCitoyen]

    def post(self, request, pk):
        cand = get_object_or_404(_queryset_base(), pk=pk, citoyen=request.user.citoyen_profile)
        if cand.statut not in (Statut.EN_ATTENTE, Statut.ACCEPTEE):
            return Response({"detail": "Cette candidature ne peut pas être annulée."}, status=status.HTTP_400_BAD_REQUEST)
        if cand.annonce.date_debut <= timezone.now():
            return Response({"detail": "La mission a déjà commencé."}, status=status.HTTP_400_BAD_REQUEST)
        cand.statut = Statut.ANNULEE
        cand.save(update_fields=["statut"])
        notifier(
            cand.annonce.association.user,
            "Désistement d'un bénévole",
            f"{cand.citoyen} s'est désisté de « {cand.annonce.titre} ».",
            "/espace",
        )
        return Response(CandidatureSerializer(cand, context={"request": request}).data)


class PointageView(APIView):
    """L'association scanne (ou saisit) le code QR du bénévole pour confirmer sa présence."""

    permission_classes = [IsAssociation]

    def post(self, request):
        code = (request.data.get("code") or "").strip()
        try:
            code = uuid.UUID(code)
        except ValueError:
            return Response({"detail": "Code invalide."}, status=status.HTTP_400_BAD_REQUEST)
        cand = (
            _queryset_base()
            .filter(code_presence=code, annonce__association=request.user.association_profile)
            .first()
        )
        if cand is None:
            return Response({"detail": "Aucune candidature ne correspond à ce code."}, status=status.HTTP_404_NOT_FOUND)
        if cand.statut != Statut.ACCEPTEE:
            return Response({"detail": "Ce bénévole n'est pas accepté sur la mission."}, status=status.HTTP_400_BAD_REQUEST)
        if cand.presence_confirmee:
            return Response(
                {"detail": "Présence déjà confirmée.", "candidature": CandidatureSerializer(cand, context={"request": request}).data}
            )
        cand.presence_confirmee = True
        if not cand.heures_effectuees:
            cand.heures_effectuees = cand.annonce.duree_heures
        cand.save(update_fields=["presence_confirmee", "heures_effectuees"])
        notifier(cand.citoyen.user, "Présence confirmée ✅", f"Merci pour « {cand.annonce.titre} » !", "/espace")
        return Response(
            {"detail": f"Présence de {cand.citoyen} confirmée.", "candidature": CandidatureSerializer(cand, context={"request": request}).data}
        )


class AttestationView(APIView):
    """Génère l'attestation de bénévolat (PDF) d'une mission réalisée."""

    permission_classes = [IsCitoyen]

    def get(self, request, pk):
        cand = get_object_or_404(_queryset_base(), pk=pk, citoyen=request.user.citoyen_profile)
        if cand.statut != Statut.ACCEPTEE or not cand.presence_confirmee:
            return Response(
                {"detail": "L'attestation est disponible une fois la présence confirmée par l'association."},
                status=status.HTTP_400_BAD_REQUEST,
            )
        buffer = io.BytesIO()
        _generer_attestation_pdf(buffer, cand)
        buffer.seek(0)
        return FileResponse(buffer, as_attachment=True, filename=f"attestation-benevolat-{cand.id}.pdf")


def _generer_attestation_pdf(buffer, cand):
    from reportlab.lib import colors
    from reportlab.lib.pagesizes import A4
    from reportlab.pdfgen import canvas

    annonce, citoyen, asso = cand.annonce, cand.citoyen, cand.annonce.association
    largeur, hauteur = A4
    c = canvas.Canvas(buffer, pagesize=A4)
    c.setTitle(f"Attestation de bénévolat - {citoyen}")

    # Bandeau
    c.setFillColor(colors.HexColor("#F26B3A"))
    c.rect(0, hauteur - 110, largeur, 110, fill=1, stroke=0)
    c.setFillColor(colors.white)
    c.setFont("Helvetica-Bold", 26)
    c.drawString(50, hauteur - 65, "SolidarLink")
    c.setFont("Helvetica", 12)
    c.drawString(50, hauteur - 88, "La plateforme qui relie associations et bénévoles")

    c.setFillColor(colors.HexColor("#1F3B2D"))
    c.setFont("Helvetica-Bold", 22)
    c.drawCentredString(largeur / 2, hauteur - 180, "ATTESTATION DE BÉNÉVOLAT")

    c.setFont("Helvetica", 12)
    c.setFillColor(colors.black)
    lignes = [
        f"L'association « {asso.nom} »{(' (' + asso.ville + ')') if asso.ville else ''} atteste que",
        "",
        f"{citoyen.prenom} {citoyen.nom}",
        "",
        "a participé bénévolement à la mission suivante :",
        "",
        f"Mission : {annonce.titre}",
        f"Lieu : {annonce.lieu}{(', ' + annonce.ville) if annonce.ville else ''}",
        f"Dates : du {timezone.localtime(annonce.date_debut):%d/%m/%Y %H:%M} au {timezone.localtime(annonce.date_fin):%d/%m/%Y %H:%M}",
        f"Heures de bénévolat validées : {cand.heures_effectuees:g} h",
    ]
    if cand.note_engagement:
        lignes.append(f"Évaluation de l'engagement : {cand.note_engagement}/5")
    y = hauteur - 240
    for ligne in lignes:
        if ligne == f"{citoyen.prenom} {citoyen.nom}":
            c.setFont("Helvetica-Bold", 18)
            c.drawCentredString(largeur / 2, y, ligne)
            c.setFont("Helvetica", 12)
        else:
            c.drawString(70, y, ligne)
        y -= 22

    y -= 30
    c.drawString(70, y, f"Fait le {timezone.localtime():%d/%m/%Y}, pour servir et valoir ce que de droit.")
    c.setFont("Helvetica-Oblique", 9)
    c.setFillColor(colors.grey)
    c.drawString(50, 50, f"Document généré par SolidarLink — vérification : {cand.code_presence}")
    c.showPage()
    c.save()
