"""Groupes de discussion liés aux activités et missions."""

from django.db.models import Count, IntegerField, Max, OuterRef, Subquery
from django.db.models.functions import Coalesce
from django.shortcuts import get_object_or_404
from django.utils import timezone
from rest_framework import generics, status
from rest_framework.response import Response
from rest_framework.views import APIView

from login_app.models import GroupeDiscussion, MembreGroupe
from login_app.serializers import GroupeSerializer, MembreGroupeSerializer, MessageGroupeSerializer
from login_app.services import fermer_groupe, fermer_groupes_expires, poster_message_groupe


def _mes_groupes(user):
    return GroupeDiscussion.objects.filter(membres__user=user).select_related(
        "annonce", "annonce__association", "annonce__createur"
    )


def _groupe_membre(request, pk):
    """Renvoie (groupe, membre) ou 404 si l'utilisateur n'en fait pas partie."""
    groupe = get_object_or_404(_mes_groupes(request.user), pk=pk)
    return groupe, groupe.membres.get(user=request.user)


class GroupeListView(generics.ListAPIView):
    """Mes groupes, les plus récemment actifs en premier. Ferme au passage les groupes expirés."""

    serializer_class = GroupeSerializer
    pagination_class = None

    def get_queryset(self):
        fermer_groupes_expires()
        return (
            _mes_groupes(self.request.user)
            .annotate(
                # Sous-requêtes : la jointure « membres__user=moi » fausserait un Count direct
                nb_membres=Coalesce(
                    Subquery(
                        MembreGroupe.objects.filter(groupe=OuterRef("pk")).values("groupe")
                        .annotate(n=Count("id")).values("n"),
                        output_field=IntegerField(),
                    ),
                    0,
                ),
                activite=Max("messages__date_envoi"),
            )
            .order_by("-activite", "-date_creation")
        )


class GroupeDetailView(APIView):
    def get(self, request, pk):
        fermer_groupes_expires()
        groupe, _ = _groupe_membre(request, pk)
        groupe.nb_membres = groupe.membres.count()
        membres = groupe.membres.select_related("user", "user__citoyen_profile", "user__association_profile").order_by(
            "-role", "date_ajout"
        )
        ctx = {"request": request}
        return Response(
            {"groupe": GroupeSerializer(groupe, context=ctx).data, "membres": MembreGroupeSerializer(membres, many=True, context=ctx).data}
        )


class GroupeMessagesView(APIView):
    """GET : historique (marque le groupe comme lu). POST : envoi (repli HTTP du WebSocket)."""

    def get(self, request, pk):
        groupe, membre = _groupe_membre(request, pk)
        membre.dernier_lu = timezone.now()
        membre.save(update_fields=["dernier_lu"])
        messages = groupe.messages.select_related(
            "auteur", "auteur__citoyen_profile", "auteur__association_profile"
        ).order_by("date_envoi")
        return Response(MessageGroupeSerializer(messages, many=True, context={"request": request}).data)

    def post(self, request, pk):
        groupe, _ = _groupe_membre(request, pk)
        if groupe.est_ferme:
            return Response({"detail": "Ce groupe est fermé : l'activité est terminée."}, status=status.HTTP_400_BAD_REQUEST)
        contenu = (request.data.get("contenu") or "").strip()
        if not contenu or len(contenu) > 5000:
            return Response({"detail": "Message vide ou trop long."}, status=status.HTTP_400_BAD_REQUEST)
        msg = poster_message_groupe(groupe, contenu, auteur=request.user)
        return Response(MessageGroupeSerializer(msg, context={"request": request}).data, status=status.HTTP_201_CREATED)


class FermerGroupeView(APIView):
    """L'organisateur peut fermer le groupe avant la fin de l'activité."""

    def post(self, request, pk):
        groupe, membre = _groupe_membre(request, pk)
        if membre.role != MembreGroupe.Role.ORGANISATEUR:
            return Response({"detail": "Seul l'organisateur peut fermer le groupe."}, status=status.HTTP_403_FORBIDDEN)
        fermer_groupe(groupe, raison="L'organisateur a fermé le groupe")
        return Response(GroupeSerializer(groupe, context={"request": request}).data)


class GroupesNonLusView(APIView):
    def get(self, request):
        groupes = _mes_groupes(request.user)
        ctx = {"request": request}
        total = sum(GroupeSerializer(g, context=ctx).data["non_lus"] for g in groupes)
        return Response({"non_lus": total})
