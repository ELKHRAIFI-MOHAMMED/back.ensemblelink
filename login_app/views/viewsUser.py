from django.contrib.auth import authenticate, get_user_model
from django.db.models import Avg, Count, Q
from django.shortcuts import get_object_or_404
from rest_framework import generics, status
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from rest_framework.throttling import ScopedRateThrottle
from rest_framework.views import APIView
from rest_framework_simplejwt.tokens import RefreshToken

from login_app.models import Annonce, AssociationProfile, Avis, CitoyenProfile, PhotoAlbum
from login_app.permissions import IsAssociation, IsCitoyen
from login_app.serializers import (
    AnnonceSerializer,
    AssociationProfileSerializer,
    AvisSerializer,
    CitoyenProfileSerializer,
    PhotoAlbumSerializer,
    UserSerializer,
    UserSignUpSerializer,
)
from login_app.services import notifier, stats_association, stats_citoyen

User = get_user_model()


def _tokens(user):
    refresh = RefreshToken.for_user(user)
    return {"access": str(refresh.access_token), "refresh": str(refresh)}


def _profil_utilisateur(user, request):
    """Profil + statistiques de l'utilisateur connecté."""
    ctx = {"request": request}
    if hasattr(user, "association_profile"):
        asso = user.association_profile
        return AssociationProfileSerializer(asso, context=ctx).data, stats_association(asso)
    if hasattr(user, "citoyen_profile"):
        cit = user.citoyen_profile
        return CitoyenProfileSerializer(cit, context=ctx).data, stats_citoyen(cit)
    return None, None


class SignUpView(generics.CreateAPIView):
    permission_classes = [AllowAny]
    serializer_class = UserSignUpSerializer
    throttle_classes = [ScopedRateThrottle]
    throttle_scope = "login"

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()
        return Response(
            {"user": UserSerializer(user).data, **_tokens(user), "message": "Compte créé avec succès."},
            status=status.HTTP_201_CREATED,
        )


class LoginView(APIView):
    permission_classes = [AllowAny]
    throttle_classes = [ScopedRateThrottle]
    throttle_scope = "login"

    def post(self, request):
        identifiant = (request.data.get("username_email") or "").strip()
        password = request.data.get("password") or ""
        user = authenticate(request, username=identifiant, password=password)
        if not user:
            return Response(
                {"error": "Identifiants incorrects ou compte désactivé."}, status=status.HTTP_401_UNAUTHORIZED
            )
        return Response({**_tokens(user), "user": UserSerializer(user).data})


class UserDetailView(APIView):
    """GET /api/me/ : utilisateur connecté, son profil et ses statistiques."""

    def get(self, request):
        profil, stats = _profil_utilisateur(request.user, request)
        return Response({"user": UserSerializer(request.user).data, "profil": profil, "stats": stats})


# ------------------------------------------------------------------ associations

class SignUpAssociationView(generics.CreateAPIView):
    serializer_class = AssociationProfileSerializer

    def create(self, request, *args, **kwargs):
        user = request.user
        if user.type != User.UserType.ASSOCIATION:
            return Response({"detail": "Réservé aux comptes de type ASSOCIATION."}, status=status.HTTP_403_FORBIDDEN)
        if hasattr(user, "association_profile"):
            return Response({"detail": "Ce compte possède déjà un profil association."}, status=status.HTTP_400_BAD_REQUEST)
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        profil = serializer.save(user=user)

        # Le compte reste actif ; seule la publication d'annonces attend la vérification admin.
        for admin in User.objects.filter(Q(type=User.UserType.ADMIN) | Q(is_superuser=True), is_active=True):
            notifier(admin, "Nouvelle association à vérifier", f"{profil.nom} attend une vérification.", "/espace/admin")
        return Response(
            {
                "profil": self.get_serializer(profil).data,
                "message": "Profil créé. Vous pourrez publier des annonces après vérification par un administrateur.",
            },
            status=status.HTTP_201_CREATED,
        )


class AssociationProfileUpdateView(generics.RetrieveUpdateAPIView):
    serializer_class = AssociationProfileSerializer
    permission_classes = [IsAssociation]

    def get_object(self):
        return self.request.user.association_profile

    def perform_update(self, serializer):
        ancien_logo = serializer.instance.logo
        profil = serializer.save()
        # Supprime l'ancien fichier si un nouveau logo a été envoyé
        if ancien_logo and "logo" in serializer.validated_data and ancien_logo != profil.logo:
            ancien_logo.delete(save=False)


class AssociationListView(generics.ListAPIView):
    """Liste publique des associations vérifiées, avec note moyenne."""

    permission_classes = [AllowAny]
    serializer_class = AssociationProfileSerializer
    search_fields = ["nom", "description", "ville"]
    filterset_fields = ["ville", "pays"]
    ordering_fields = ["nom", "note_moyenne", "nombre_annonces"]

    def get_queryset(self):
        return (
            AssociationProfile.objects.filter(statut_verification=AssociationProfile.StatutVerification.VERIFIEE)
            .annotate(
                note_moyenne=Avg("user__avis_recus__note"),
                nombre_avis=Count("user__avis_recus", distinct=True),
                nombre_annonces=Count("annonces", distinct=True),
            )
            .order_by("nom")
        )


class AssociationPublicDetailView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, pk):
        asso = get_object_or_404(
            AssociationProfile, pk=pk, statut_verification=AssociationProfile.StatutVerification.VERIFIEE
        )
        ctx = {"request": request}
        annonces = Annonce.objects.filter(association=asso).select_related("categorie", "association")
        avis = Avis.objects.filter(cible=asso.user).select_related("auteur", "annonce")[:20]
        return Response(
            {
                "association": AssociationProfileSerializer(asso, context=ctx).data,
                "stats": stats_association(asso),
                "annonces": AnnonceSerializer(annonces, many=True, context=ctx).data,
                "avis": AvisSerializer(avis, many=True, context=ctx).data,
            }
        )


# ------------------------------------------------------------------ citoyens

class SignUpCitoyenView(generics.CreateAPIView):
    serializer_class = CitoyenProfileSerializer

    def create(self, request, *args, **kwargs):
        user = request.user
        if user.type != User.UserType.CITOYEN:
            return Response({"detail": "Réservé aux comptes de type CITOYEN."}, status=status.HTTP_403_FORBIDDEN)
        if hasattr(user, "citoyen_profile"):
            return Response({"detail": "Ce compte possède déjà un profil citoyen."}, status=status.HTTP_400_BAD_REQUEST)
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        profil = serializer.save(user=user)
        for image in request.FILES.getlist("album_photos")[:10]:
            photo = PhotoAlbumSerializer(data={"image": image})
            if photo.is_valid():
                photo.save(citoyen=profil)
        return Response(
            {"profil": self.get_serializer(profil).data, "message": "Profil citoyen créé avec succès."},
            status=status.HTTP_201_CREATED,
        )


class CitoyenProfileUpdateView(generics.RetrieveUpdateAPIView):
    """Correctif : l'ancienne signature `get_object(self, request)` provoquait une erreur 500."""

    serializer_class = CitoyenProfileSerializer
    permission_classes = [IsCitoyen]

    def get_object(self):
        return self.request.user.citoyen_profile


class CitoyenPublicDetailView(APIView):
    """Profil d'un bénévole, visible par les utilisateurs connectés (sans email)."""

    def get(self, request, pk):
        cit = get_object_or_404(CitoyenProfile, pk=pk)
        ctx = {"request": request}
        avis = Avis.objects.filter(cible=cit.user).select_related("auteur", "annonce")[:20]
        return Response(
            {
                "citoyen": CitoyenProfileSerializer(cit, context=ctx).data,
                "stats": stats_citoyen(cit),
                "avis": AvisSerializer(avis, many=True, context=ctx).data,
            }
        )


class AlbumPhotoView(generics.ListCreateAPIView):
    serializer_class = PhotoAlbumSerializer
    permission_classes = [IsCitoyen]
    pagination_class = None

    def get_queryset(self):
        return self.request.user.citoyen_profile.album.all()

    def perform_create(self, serializer):
        serializer.save(citoyen=self.request.user.citoyen_profile)


class AlbumPhotoDeleteView(generics.DestroyAPIView):
    permission_classes = [IsCitoyen]

    def get_queryset(self):
        return PhotoAlbum.objects.filter(citoyen=self.request.user.citoyen_profile)

    def perform_destroy(self, instance):
        instance.image.delete(save=False)
        instance.delete()


class StatsView(APIView):
    """Statistiques d'impact publiques (page d'accueil)."""

    permission_classes = [AllowAny]

    def get(self, request):
        from login_app.services import stats_globales

        return Response(stats_globales())
