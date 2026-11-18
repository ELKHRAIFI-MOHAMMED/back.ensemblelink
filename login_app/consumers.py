"""
WebSockets EnsembleLink.

Correctif sécurité : l'ancienne version acceptait les messages avant toute
authentification et faisait confiance au `sender_id` envoyé par le client.
Désormais :
  - la connexion est refusée sans JWT valide (?token=...) ;
  - l'expéditeur est toujours l'utilisateur authentifié ;
  - l'URL ne contient que l'interlocuteur : ws/chat/<other_user_id>/
"""

import json

from channels.db import database_sync_to_async
from channels.generic.websocket import AsyncWebsocketConsumer
from django.contrib.auth import get_user_model

from login_app.models import Message

User = get_user_model()
MAX_LONGUEUR = 5000


class ChatConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        self.user = self.scope.get("user")
        if not self.user or not self.user.is_authenticated:
            await self.close(code=4401)
            return
        self.other_id = int(self.scope["url_route"]["kwargs"]["other_id"])
        if self.other_id == self.user.id or not await self._user_exists(self.other_id):
            await self.close(code=4404)
            return
        a, b = sorted([self.user.id, self.other_id])
        self.room_group_name = f"chat_{a}_{b}"
        await self.channel_layer.group_add(self.room_group_name, self.channel_name)
        await self.accept()

    async def disconnect(self, close_code):
        if hasattr(self, "room_group_name"):
            await self.channel_layer.group_discard(self.room_group_name, self.channel_name)

    async def receive(self, text_data=None, bytes_data=None):
        try:
            data = json.loads(text_data or "{}")
        except json.JSONDecodeError:
            await self._error("Format JSON invalide.")
            return
        contenu = (data.get("message") or "").strip()
        if not contenu:
            return
        if len(contenu) > MAX_LONGUEUR:
            await self._error("Message trop long.")
            return

        msg = await self._save(contenu)
        payload = {
            "type": "chat_message",
            "message": msg.contenu,
            "sender_id": self.user.id,
            "receiver_id": self.other_id,
            "timestamp": msg.date_envoi.isoformat(),
            "message_id": msg.id,
        }
        await self.channel_layer.group_send(self.room_group_name, payload)
        # Prévient le destinataire même s'il n'a pas la conversation ouverte
        await self.channel_layer.group_send(
            f"notif_{self.other_id}", {"type": "nouveau_message", "sender_id": self.user.id, "apercu": contenu[:80]}
        )

    async def chat_message(self, event):
        await self.send(text_data=json.dumps({k: v for k, v in event.items() if k != "type"} | {"type": "chat_message"}))

    async def _error(self, message):
        await self.send(text_data=json.dumps({"type": "error", "message": message}))

    @database_sync_to_async
    def _user_exists(self, user_id):
        return User.objects.filter(id=user_id, is_active=True).exists()

    @database_sync_to_async
    def _save(self, contenu):
        return Message.objects.create(sender=self.user, receiver_id=self.other_id, contenu=contenu)


class NotificationConsumer(AsyncWebsocketConsumer):
    """Canal personnel de notifications temps réel : ws/notifications/?token=..."""

    async def connect(self):
        user = self.scope.get("user")
        if not user or not user.is_authenticated:
            await self.close(code=4401)
            return
        self.group = f"notif_{user.id}"
        await self.channel_layer.group_add(self.group, self.channel_name)
        await self.accept()

    async def disconnect(self, close_code):
        if hasattr(self, "group"):
            await self.channel_layer.group_discard(self.group, self.channel_name)

    async def receive(self, text_data=None, bytes_data=None):
        pass  # canal en lecture seule

    async def notification(self, event):
        await self.send(text_data=json.dumps({"type": "notification", "notification": event["notification"]}))

    async def nouveau_message(self, event):
        await self.send(
            text_data=json.dumps({"type": "nouveau_message", "sender_id": event["sender_id"], "apercu": event["apercu"]})
        )


class GroupeConsumer(AsyncWebsocketConsumer):
    """Chat de groupe : ws/groupe/<id>/?token=...  Réservé aux membres ; lecture seule une fois fermé."""

    async def connect(self):
        self.user = self.scope.get("user")
        if not self.user or not self.user.is_authenticated:
            await self.close(code=4401)
            return
        self.groupe_id = int(self.scope["url_route"]["kwargs"]["groupe_id"])
        if not await self._est_membre():
            await self.close(code=4403)
            return
        self.room = f"groupe_{self.groupe_id}"
        await self.channel_layer.group_add(self.room, self.channel_name)
        await self.accept()

    async def disconnect(self, close_code):
        if hasattr(self, "room"):
            await self.channel_layer.group_discard(self.room, self.channel_name)

    async def receive(self, text_data=None, bytes_data=None):
        try:
            data = json.loads(text_data or "{}")
        except json.JSONDecodeError:
            return
        contenu = (data.get("message") or "").strip()
        if not contenu or len(contenu) > MAX_LONGUEUR:
            return
        erreur = await self._envoyer(contenu)
        if erreur:
            await self.send(text_data=json.dumps({"type": "error", "message": erreur}))

    async def groupe_message(self, event):
        await self.send(text_data=json.dumps({"type": "groupe_message", "message": event["message"]}))

    @database_sync_to_async
    def _est_membre(self):
        from login_app.models import MembreGroupe
        from login_app.services import fermer_groupes_expires

        fermer_groupes_expires()
        return MembreGroupe.objects.filter(groupe_id=self.groupe_id, user=self.user).exists()

    @database_sync_to_async
    def _envoyer(self, contenu):
        from login_app.models import GroupeDiscussion
        from login_app.services import poster_message_groupe

        groupe = GroupeDiscussion.objects.select_related("annonce").filter(id=self.groupe_id, membres__user=self.user).first()
        if groupe is None:
            return "Vous ne faites plus partie de ce groupe."
        if groupe.est_ferme:
            return "Ce groupe est fermé : l'activité est terminée."
        poster_message_groupe(groupe, contenu, auteur=self.user)  # diffuse aussi via le channel layer
        return None
