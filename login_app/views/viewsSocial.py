from django.contrib.auth import get_user_model
from django.db.models import Count, Max, Q
from django.shortcuts import get_object_or_404
from django.utils import timezone
from rest_framework import generics
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework.views import APIView

from login_app.models import Avis, Candidature, Message, Notification
from login_app.serializers import (
    AvisSerializer,
    MessageSerializer,
    NotificationSerializer,
    SignalementSerializer,
    UserMiniSerializer,
)
from login_app.services import notifier

User = get_user_model()


# ------------------------------------------------------------------ avis

class AvisListCreateView(generics.ListCreateAPIView):
    """GET ?cible=<user_id> : avis publics reçus. POST : laisser un avis après une mission."""

    serializer_class = AvisSerializer
    filterset_fields = ["cible", "annonce", "auteur"]

    def get_permissions(self):
        return [AllowAny()] if self.request.method == "GET" else super().get_permissions()

    def get_queryset(self):
        return Avis.objects.select_related("auteur", "cible", "annonce")

    def perform_create(self, serializer):
        avis = serializer.save(auteur=self.request.user)
        notifier(avis.cible, "Nouvel avis reçu ⭐", f"{avis.note}/5 pour « {avis.annonce.titre} ».", "/espace")


class AvisADonnerView(APIView):
    """Missions et activités terminées pour lesquelles l'utilisateur n'a pas encore laissé d'avis :
    en tant que participant (évaluer l'organisateur) et en tant qu'organisateur (évaluer les participants)."""

    def get(self, request):
        user = request.user
        deja = set(Avis.objects.filter(auteur=user).values_list("annonce_id", "cible_id"))
        acceptees = Candidature.objects.filter(
            statut=Candidature.Statut.ACCEPTEE, annonce__date_fin__lt=timezone.now()
        ).select_related(
            "annonce", "annonce__association", "annonce__association__user", "annonce__createur",
            "annonce__createur__user", "citoyen", "citoyen__user",
        )
        resultats = []

        def ajouter(c, cible, nom):
            if (c.annonce_id, cible.id) not in deja and cible.id != user.id:
                resultats.append({"annonce": c.annonce_id, "annonce_titre": c.annonce.titre, "cible": cible.id, "cible_nom": nom})

        if hasattr(user, "citoyen_profile"):
            for c in acceptees.filter(citoyen=user.citoyen_profile):
                ajouter(c, c.annonce.organisateur_user, c.annonce.organisateur_nom)
        for c in acceptees.filter(Q(annonce__association__user=user) | Q(annonce__createur__user=user)):
            ajouter(c, c.citoyen.user, str(c.citoyen))
        return Response(resultats)


# ------------------------------------------------------------------ notifications

class NotificationListView(generics.ListAPIView):
    serializer_class = NotificationSerializer
    filterset_fields = ["lue"]

    def get_queryset(self):
        return Notification.objects.filter(destinataire=self.request.user)

    def list(self, request, *args, **kwargs):
        response = super().list(request, *args, **kwargs)
        response.data["non_lues"] = Notification.objects.filter(destinataire=request.user, lue=False).count()
        return response


class NotificationLueView(APIView):
    def post(self, request, pk=None):
        qs = Notification.objects.filter(destinataire=request.user, lue=False)
        if pk is not None:
            qs = qs.filter(pk=pk)
        n = qs.update(lue=True)
        return Response({"marquees": n})


# ------------------------------------------------------------------ signalements

class SignalementCreateView(generics.CreateAPIView):
    serializer_class = SignalementSerializer

    def perform_create(self, serializer):
        sig = serializer.save(auteur=self.request.user)
        for admin in User.objects.filter(Q(type="ADMIN") | Q(is_superuser=True), is_active=True):
            notifier(admin, "Nouveau signalement", sig.motif[:120], "/espace/admin")


# ------------------------------------------------------------------ messagerie

class ConversationListView(APIView):
    """Interlocuteurs de l'utilisateur, avec dernier message et nombre de non-lus."""

    def get(self, request):
        me = request.user
        partenaires = (
            Message.objects.filter(Q(sender=me) | Q(receiver=me))
            .values("sender", "receiver")
            .annotate(dernier=Max("date_envoi"))
        )
        ids = {p["receiver"] if p["sender"] == me.id else p["sender"] for p in partenaires}
        users = User.objects.filter(id__in=ids).select_related("association_profile", "citoyen_profile")
        non_lus = dict(
            Message.objects.filter(receiver=me, lu=False).values_list("sender").annotate(n=Count("id"))
        )
        resultats = []
        for u in users:
            dernier = Message.objects.filter(Q(sender=me, receiver=u) | Q(sender=u, receiver=me)).order_by("-date_envoi").first()
            resultats.append(
                {
                    "user": UserMiniSerializer(u, context={"request": request}).data,
                    "dernier_message": dernier.contenu[:120] if dernier else "",
                    "date": dernier.date_envoi if dernier else None,
                    "non_lus": non_lus.get(u.id, 0),
                }
            )
        resultats.sort(key=lambda r: r["date"] or timezone.now(), reverse=True)
        return Response(resultats)


class MessageHistoryView(generics.ListAPIView):
    """Historique avec un utilisateur ; marque les messages reçus comme lus."""

    serializer_class = MessageSerializer
    pagination_class = None

    def get_queryset(self):
        other = get_object_or_404(User, id=self.kwargs["user_id"])
        me = self.request.user
        Message.objects.filter(sender=other, receiver=me, lu=False).update(lu=True)
        return (
            Message.objects.filter(Q(sender=me, receiver=other) | Q(sender=other, receiver=me))
            .select_related("sender", "receiver")
            .order_by("date_envoi")
        )


class MessageCreateView(generics.CreateAPIView):
    serializer_class = MessageSerializer

    def perform_create(self, serializer):
        receiver = get_object_or_404(User, id=self.kwargs["user_id"], is_active=True)
        if receiver == self.request.user:
            from rest_framework.exceptions import ValidationError

            raise ValidationError("Vous ne pouvez pas vous écrire à vous-même.")
        serializer.save(sender=self.request.user, receiver=receiver)


class UnreadMessagesCountView(APIView):
    def get(self, request):
        return Response({"non_lus": Message.objects.filter(receiver=request.user, lu=False).count()})


class ContactCheckView(APIView):
    """Renvoie les infos publiques minimales d'un utilisateur pour ouvrir une conversation."""

    def get(self, request, user_id):
        u = get_object_or_404(User, id=user_id, is_active=True)
        return Response(UserMiniSerializer(u, context={"request": request}).data)

