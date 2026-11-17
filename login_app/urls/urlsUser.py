from django.urls import path
from rest_framework_simplejwt.views import TokenRefreshView

from login_app.views import viewsUser

urlpatterns = [
    # Authentification
    path("signup/", viewsUser.SignUpView.as_view(), name="signup"),
    path("login/", viewsUser.LoginView.as_view(), name="login"),
    path("token/refresh/", TokenRefreshView.as_view(), name="token-refresh"),
    path("me/", viewsUser.UserDetailView.as_view(), name="user-detail"),
    # Profils
    path("signup/association/", viewsUser.SignUpAssociationView.as_view(), name="signupassociation"),
    path("association/edit/", viewsUser.AssociationProfileUpdateView.as_view(), name="association-profile-update"),
    path("signup/citoyen/", viewsUser.SignUpCitoyenView.as_view(), name="signUpcitoyen"),
    path("citoyen/edit/", viewsUser.CitoyenProfileUpdateView.as_view(), name="citoyen-profile-update"),
    path("citoyen/album/", viewsUser.AlbumPhotoView.as_view(), name="citoyen-album"),
    path("citoyen/album/<int:pk>/", viewsUser.AlbumPhotoDeleteView.as_view(), name="citoyen-album-delete"),
    # Pages publiques
    path("association/", viewsUser.AssociationListView.as_view(), name="get_all_association"),
    path("associations/<int:pk>/", viewsUser.AssociationPublicDetailView.as_view(), name="association-public"),
    path("citoyens/<int:pk>/", viewsUser.CitoyenPublicDetailView.as_view(), name="citoyen-public"),
    path("stats/", viewsUser.StatsView.as_view(), name="stats"),
]
