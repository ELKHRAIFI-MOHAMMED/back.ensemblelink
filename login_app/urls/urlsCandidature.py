from django.urls import path

from login_app.views import viewsCandidature as v

urlpatterns = [
    path("candidatures/", v.CandidatureCreateView.as_view(), name="candidature-create"),
    path("candidatures/toutes/", v.CandidatureAdminListView.as_view(), name="candidature-admin-list"),
    path("candidatures/mes/", v.MesCandidaturesView.as_view(), name="mes-candidatures"),
    path("candidatures/mes/<int:pk>/", v.CandidatureDetailView.as_view(), name="candidature-detail"),
    path("candidatures/<int:pk>/annuler/", v.AnnulerCandidatureView.as_view(), name="candidature-annuler"),
    path("candidatures/<int:pk>/attestation/", v.AttestationView.as_view(), name="candidature-attestation"),
    path("candidatures/pointage/", v.PointageView.as_view(), name="candidature-pointage"),
]
