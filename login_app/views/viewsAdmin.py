from django.contrib.auth import get_user_model
from django.db.models import Count
from django.shortcuts import get_object_or_404
from rest_framework import generics, status
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework.views import APIView

from login_app.models import AssociationProfile, Categorie, Competence, Signalement
from login_app.permissions import IsAdmin, IsAdminOrReadOnly
from login_app.serializers import (
    AssociationAdminSerializer,
    CategorieSerializer,
    CompetenceSerializer,
    SignalementSerializer,
    UserSerializer,
)
from login_app.services import notifier, stats_globales

User = get_user_model()


# ------------------------------------------------------------------ référentiels (lecture publique)

class CategorieListCreateView(generics.ListCreateAPIView):
    queryset = Categorie.objects.annotate(nombre_annonces=Count("annonces")).order_by("nom")
    serializer_class = CategorieSerializer
    permission_classes = [IsAdminOrReadOnly]
    pagination_class = None


class CategorieRetrieveUpdateDeleteView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Categorie.objects.all()
    serializer_class = CategorieSerializer
    permission_classes = [IsAdminOrReadOnly]


class CompetenceListCreateView(generics.ListCreateAPIView):
    queryset = Competence.objects.all()
    serializer_class = CompetenceSerializer
    permission_classes = [IsAdminOrReadOnly]
    pagination_class = None


class CompetenceDeleteView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Competence.objects.all()
    serializer_class = CompetenceSerializer
    permission_classes = [IsAdminOrReadOnly]


# ------------------------------------------------------------------ gestion des comptes (admin)

class AdminUserListView(generics.ListAPIView):
    """Correctif : la liste complète des utilisateurs (avec emails) est réservée à l'admin."""

    serializer_class = UserSerializer
    permission_classes = [IsAdmin]
    filterset_fields = ["type", "is_active"]
    search_fields = ["username", "email"]
    queryset = User.objects.order_by("-date_joined")


class UserStatusView(APIView):
    """Active / désactive un compte.

    Correctif sécurité : auparavant, n'importe quel utilisateur connecté
    pouvait désactiver n'importe quel compte.
    """

    permission_classes = [IsAdmin]

    def post(self, request, user_id):
        user = get_object_or_404(User, pk=user_id)
        if user == request.user:
            return Response({"error": "Vous ne pouvez pas modifier votre propre statut."}, status=status.HTTP_400_BAD_REQUEST)
        if user.is_superuser and not request.user.is_superuser:
            return Response({"error": "Impossible de modifier un super-administrateur."}, status=status.HTTP_403_FORBIDDEN)
        user.is_active = not user.is_active
        user.save(update_fields=["is_active"])
        return Response(
            {
                "id": user.id,
                "username": user.username,
                "new_status": "active" if user.is_active else "inactive",
                "message": "Statut du compte mis à jour.",
            }
        )


class AdminAssociationListView(generics.ListAPIView):
    serializer_class = AssociationAdminSerializer
    permission_classes = [IsAdmin]
    filterset_fields = ["statut_verification", "ville"]
    search_fields = ["nom", "user__email"]

    def get_queryset(self):
        return AssociationProfile.objects.select_related("user").order_by("statut_verification", "-date_creation")


class VerifierAssociationView(APIView):
    """POST {"decision": "VERIFIEE" | "REJETEE", "motif": "..."}"""

    permission_classes = [IsAdmin]

    def post(self, request, pk):
        asso = get_object_or_404(AssociationProfile, pk=pk)
        decision = request.data.get("decision")
        motif = (request.data.get("motif") or "").strip()
        statuts = AssociationProfile.StatutVerification
        if decision not in (statuts.VERIFIEE, statuts.REJETEE):
            return Response({"error": "Décision invalide."}, status=status.HTTP_400_BAD_REQUEST)
        if decision == statuts.REJETEE and not motif:
            return Response({"error": "Un motif est requis pour un rejet."}, status=status.HTTP_400_BAD_REQUEST)

        asso.statut_verification = decision
        asso.motif_rejet = motif if decision == statuts.REJETEE else ""
        asso.save(update_fields=["statut_verification", "motif_rejet"])

        if decision == statuts.VERIFIEE:
            notifier(asso.user, "Association vérifiée ✅", "Vous pouvez maintenant publier des annonces.", "/espace")
        else:
            notifier(asso.user, "Vérification refusée", f"Motif : {motif}", "/espace")
        return Response(AssociationAdminSerializer(asso, context={"request": request}).data)


class SignalementAdminListView(generics.ListAPIView):
    serializer_class = SignalementSerializer
    permission_classes = [IsAdmin]
    filterset_fields = ["statut"]
    queryset = Signalement.objects.select_related("auteur", "annonce", "utilisateur_signale")


class SignalementAdminUpdateView(APIView):
    permission_classes = [IsAdmin]

    def patch(self, request, pk):
        sig = get_object_or_404(Signalement, pk=pk)
        statut = request.data.get("statut")
        if statut not in Signalement.Statut.values:
            return Response({"error": "Statut invalide."}, status=status.HTTP_400_BAD_REQUEST)
        sig.statut = statut
        sig.save(update_fields=["statut"])
        return Response(SignalementSerializer(sig, context={"request": request}).data)


class AdminDashboardView(APIView):
    permission_classes = [IsAdmin]

    def get(self, request):
        data = stats_globales()
        data.update(
            {
                "associations_en_attente": AssociationProfile.objects.filter(
                    statut_verification=AssociationProfile.StatutVerification.EN_ATTENTE
                ).count(),
                "signalements_ouverts": Signalement.objects.filter(statut=Signalement.Statut.OUVERT).count(),
                "utilisateurs": User.objects.count(),
                "comptes_inactifs": User.objects.filter(is_active=False).count(),
            }
        )
        return Response(data)


class PublicCategoriesView(generics.ListAPIView):
    permission_classes = [AllowAny]
    serializer_class = CategorieSerializer
    pagination_class = None
    queryset = Categorie.objects.annotate(nombre_annonces=Count("annonces")).order_by("nom")
