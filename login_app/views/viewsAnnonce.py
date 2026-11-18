from datetime import timezone as dt_timezone

import django_filters
from django.db.models import Count, F, OuterRef, Q, Subquery, Sum
from django.db.models.functions import Coalesce
from django.http import HttpResponse
from django.shortcuts import get_object_or_404
from django.utils import timezone
from rest_framework import generics, status
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework.views import APIView

from login_app.models import Annonce, Candidature, GroupeDiscussion
from login_app.permissions import AnnoncePermission, IsCitoyen
from login_app.serializers import AnnonceSerializer, CitoyenMiniSerializer, GroupeSerializer
from login_app.services import creer_groupe


def organisees_par(user):
    """Annonces dont l'utilisateur est l'organisateur (association ou citoyen)."""
    return Q(association__user=user) | Q(createur__user=user)

ACCEPTEE = Candidature.Statut.ACCEPTEE


def annonces_annotees():
    """Queryset optimisé : places prises et dons collectés calculés par sous-requêtes (pas de N+1,
    et pas de doublons quand d'autres jointures sont ajoutées)."""
    acceptees = Candidature.objects.filter(annonce=OuterRef("pk"), statut=ACCEPTEE).values("annonce")
    return (
        Annonce.objects.select_related("association", "createur", "categorie", "groupe")
        .prefetch_related("competences_requises")
        .annotate(
            nb_acceptees=Coalesce(Subquery(acceptees.annotate(c=Count("id")).values("c")), 0),
            total_dons=Subquery(acceptees.annotate(s=Sum("quantite_don")).values("s")),
        )
    )


class AnnonceFilter(django_filters.FilterSet):
    ville = django_filters.CharFilter(lookup_expr="icontains")
    a_venir = django_filters.BooleanFilter(method="filter_a_venir")
    competence = django_filters.NumberFilter(field_name="competences_requises")
    places_disponibles = django_filters.BooleanFilter(method="filter_places")
    # Recherche géographique : ?lat=..&lng=..&rayon_km=..
    lat = django_filters.NumberFilter(method="filter_noop")
    lng = django_filters.NumberFilter(method="filter_noop")
    rayon_km = django_filters.NumberFilter(method="filter_rayon")
    # ?organisateur=CITOYEN (activités entre citoyens) ou ASSOCIATION
    organisateur = django_filters.ChoiceFilter(
        choices=[("CITOYEN", "Citoyen"), ("ASSOCIATION", "Association")], method="filter_organisateur"
    )

    class Meta:
        model = Annonce
        fields = ["type", "categorie", "association", "createur", "pays", "est_active"]

    def filter_organisateur(self, queryset, name, value):
        return queryset.filter(createur__isnull=False) if value == "CITOYEN" else queryset.filter(association__isnull=False)

    def filter_noop(self, queryset, name, value):
        return queryset

    def filter_a_venir(self, queryset, name, value):
        now = timezone.now()
        return queryset.filter(date_fin__gte=now) if value else queryset.filter(date_fin__lt=now)

    def filter_places(self, queryset, name, value):
        if not value:
            return queryset
        return queryset.filter(Q(nombre_places__isnull=True) | Q(nombre_places__gt=F("nb_acceptees")))

    def filter_rayon(self, queryset, name, value):
        lat, lng = self.data.get("lat"), self.data.get("lng")
        if not lat or not lng:
            return queryset
        lat, lng, rayon = float(lat), float(lng), float(value)
        # Pré-filtre rectangulaire (1° ≈ 111 km), suffisant pour une recherche « près de moi »
        delta_lat = rayon / 111.0
        import math

        delta_lng = rayon / (111.0 * max(math.cos(math.radians(lat)), 0.01))
        return queryset.filter(
            latitude__range=(lat - delta_lat, lat + delta_lat),
            longitude__range=(lng - delta_lng, lng + delta_lng),
        )


class AnnonceListCreateView(generics.ListCreateAPIView):
    serializer_class = AnnonceSerializer
    permission_classes = [AnnoncePermission]
    filterset_class = AnnonceFilter
    search_fields = ["titre", "description", "lieu", "ville", "association__nom", "createur__prenom", "createur__nom"]
    ordering_fields = ["date_debut", "date_creation", "titre"]

    def get_queryset(self):
        qs = annonces_annotees()
        # Par défaut le public ne voit que les annonces actives
        params = self.request.query_params
        if params.get("est_active") is None and "association" not in params and "createur" not in params:
            qs = qs.filter(est_active=True)
        return qs

    def perform_create(self, serializer):
        serializer.save()


class AnnonceRetrieveUpdateDeleteView(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = AnnonceSerializer
    permission_classes = [AnnoncePermission]

    def get_queryset(self):
        return annonces_annotees()


class MesAnnoncesView(generics.ListAPIView):
    """Annonces organisées par l'utilisateur connecté (association ou citoyen), actives et clôturées."""

    serializer_class = AnnonceSerializer
    search_fields = ["titre"]
    filterset_fields = ["type", "est_active"]

    def get_queryset(self):
        return annonces_annotees().filter(organisees_par(self.request.user)).annotate(
            nb_candidatures=Count("candidatures", distinct=True)
        )


class AnnoncesRecommandeesView(generics.ListAPIView):
    """Recommandations : annonces à venir correspondant aux compétences, centres d'intérêt et ville du citoyen."""

    serializer_class = AnnonceSerializer
    permission_classes = [IsCitoyen]
    pagination_class = None

    def get_queryset(self):
        cit = self.request.user.citoyen_profile
        competences = list(cit.competences.values_list("id", flat=True))
        interets = list(cit.centres_interet.values_list("id", flat=True))
        deja = cit.candidatures.values_list("annonce_id", flat=True)

        critere = Q()
        if competences:
            critere |= Q(competences_requises__in=competences)
        if interets:
            critere |= Q(categorie__in=interets)
        if cit.ville:
            critere |= Q(ville__iexact=cit.ville)

        qs = annonces_annotees().filter(est_active=True, date_fin__gte=timezone.now()).exclude(id__in=deja)
        if critere:
            ids = Annonce.objects.filter(critere).values("id")
            qs = qs.filter(id__in=ids).annotate(
                score=Count("competences_requises", filter=Q(competences_requises__in=competences), distinct=True)
            ).order_by("-score", "date_debut")
        else:
            qs = qs.order_by("date_debut")
        return qs[:6]


class AnnonceICalView(APIView):
    """Export iCalendar (.ics) pour ajouter la mission à son agenda."""

    permission_classes = [AllowAny]

    def get(self, request, pk):
        annonce = get_object_or_404(Annonce.objects.select_related("association", "createur"), pk=pk)

        def fmt(dt):
            return dt.astimezone(dt_timezone.utc).strftime("%Y%m%dT%H%M%SZ")

        def esc(txt):
            return (txt or "").replace("\\", "\\\\").replace(";", "\\;").replace(",", "\\,").replace("\n", "\\n")

        contenu = "\r\n".join(
            [
                "BEGIN:VCALENDAR",
                "VERSION:2.0",
                "PRODID:-//EnsembleLink//FR",
                "BEGIN:VEVENT",
                f"UID:annonce-{annonce.id}@ensemblelink.com",
                f"DTSTAMP:{fmt(timezone.now())}",
                f"DTSTART:{fmt(annonce.date_debut)}",
                f"DTEND:{fmt(annonce.date_fin)}",
                f"SUMMARY:{esc(annonce.titre)}",
                f"DESCRIPTION:{esc(annonce.organisateur_nom + ' — ' + annonce.description[:500])}",
                f"LOCATION:{esc(annonce.lieu + (', ' + annonce.ville if annonce.ville else ''))}",
                "END:VEVENT",
                "END:VCALENDAR",
                "",
            ]
        )
        response = HttpResponse(contenu, content_type="text/calendar; charset=utf-8")
        response["Content-Disposition"] = f'attachment; filename="mission-{annonce.id}.ics"'
        return response


class ParticipantsView(APIView):
    """Participants acceptés d'une annonce.
    Activités : visibles par tout utilisateur connecté. Missions d'association : organisateur uniquement."""

    def get(self, request, pk):
        annonce = get_object_or_404(Annonce.objects.select_related("association", "createur"), pk=pk)
        est_orga = annonce.organisateur_user.id == request.user.id
        if annonce.type != Annonce.AnnonceType.ACTIVITE and not est_orga:
            return Response({"detail": "Liste réservée à l'organisateur."}, status=status.HTTP_403_FORBIDDEN)
        cands = annonce.candidatures.filter(statut=ACCEPTEE).select_related("citoyen")
        return Response(CitoyenMiniSerializer([c.citoyen for c in cands], many=True, context={"request": request}).data)


class CreerGroupeView(APIView):
    """POST : l'organisateur crée le groupe de discussion de son annonce.
    Les participants acceptés (actuels et futurs) y sont ajoutés automatiquement."""

    def post(self, request, pk):
        annonce = get_object_or_404(Annonce.objects.select_related("association", "createur"), pk=pk)
        if annonce.organisateur_user.id != request.user.id:
            return Response({"detail": "Seul l'organisateur peut créer le groupe."}, status=status.HTTP_403_FORBIDDEN)
        if annonce.est_terminee:
            return Response({"detail": "L'activité est terminée."}, status=status.HTTP_400_BAD_REQUEST)
        if GroupeDiscussion.objects.filter(annonce=annonce).exists():
            return Response({"detail": "Un groupe existe déjà pour cette annonce."}, status=status.HTTP_400_BAD_REQUEST)
        groupe = creer_groupe(annonce, request.data.get("nom", ""))
        return Response(GroupeSerializer(groupe, context={"request": request}).data, status=status.HTTP_201_CREATED)
