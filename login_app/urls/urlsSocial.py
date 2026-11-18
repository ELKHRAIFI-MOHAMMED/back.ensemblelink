from django.urls import path

from login_app.views import viewsSocial as v
from login_app.views.viewsAujourdhui import AujourdhuiView
from login_app.views.viewsHistorique import HistoriqueView

urlpatterns = [
    # Historique personnel
    path("historique/", HistoriqueView.as_view(), name="historique"),
    path("aujourdhui/", AujourdhuiView.as_view(), name="aujourdhui"),
    # Avis
    path("avis/", v.AvisListCreateView.as_view(), name="avis"),
    path("avis/a-donner/", v.AvisADonnerView.as_view(), name="avis-a-donner"),
    # Notifications
    path("notifications/", v.NotificationListView.as_view(), name="notifications"),
    path("notifications/tout-lire/", v.NotificationLueView.as_view(), name="notifications-tout-lire"),
    path("notifications/<int:pk>/lue/", v.NotificationLueView.as_view(), name="notification-lue"),
    # Signalements
    path("signalements/", v.SignalementCreateView.as_view(), name="signalement-create"),
    # Messagerie
    path("conversations/", v.ConversationListView.as_view(), name="conversations"),
    path("messages/non-lus/", v.UnreadMessagesCountView.as_view(), name="messages-non-lus"),
    path("messages/<int:user_id>/", v.MessageHistoryView.as_view(), name="message-history"),
    path("messages/<int:user_id>/send/", v.MessageCreateView.as_view(), name="message-send"),
    path("users/<int:user_id>/contact/", v.ContactCheckView.as_view(), name="user-contact"),
]
