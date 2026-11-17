from django.urls import path

from login_app.views import viewsAnnonce

urlpatterns = [
    path("annonces/", viewsAnnonce.AnnonceListCreateView.as_view(), name="annonce-list-create"),
    path("annonces/mes/", viewsAnnonce.MesAnnoncesView.as_view(), name="mes-annonces"),
    path("annonces/recommandees/", viewsAnnonce.AnnoncesRecommandeesView.as_view(), name="annonces-recommandees"),
    path("annonces/<int:pk>/", viewsAnnonce.AnnonceRetrieveUpdateDeleteView.as_view(), name="annonce-detail"),
    path("annonces/<int:pk>/ical/", viewsAnnonce.AnnonceICalView.as_view(), name="annonce-ical"),
]
