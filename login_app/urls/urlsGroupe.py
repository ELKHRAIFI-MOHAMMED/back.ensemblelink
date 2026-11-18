from django.urls import path

from login_app.views import viewsGroupe as v

urlpatterns = [
    path("groupes/", v.GroupeListView.as_view(), name="groupes"),
    path("groupes/non-lus/", v.GroupesNonLusView.as_view(), name="groupes-non-lus"),
    path("groupes/<int:pk>/", v.GroupeDetailView.as_view(), name="groupe-detail"),
    path("groupes/<int:pk>/messages/", v.GroupeMessagesView.as_view(), name="groupe-messages"),
    path("groupes/<int:pk>/fermer/", v.FermerGroupeView.as_view(), name="groupe-fermer"),
]
