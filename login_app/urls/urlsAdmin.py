from django.urls import path

from login_app.views import viewsAdmin

urlpatterns = [
    # Référentiels (lecture publique, écriture admin)
    path("categories/", viewsAdmin.CategorieListCreateView.as_view(), name="categorie-list-create"),
    path("categories/<int:pk>/", viewsAdmin.CategorieRetrieveUpdateDeleteView.as_view(), name="categorie-detail"),
    path("competences/", viewsAdmin.CompetenceListCreateView.as_view(), name="competence-list-create"),
    path("competences/<int:pk>/", viewsAdmin.CompetenceDeleteView.as_view(), name="competence-detail"),
    # Administration
    path("activate/<int:user_id>/", viewsAdmin.UserStatusView.as_view(), name="toggle_user_status"),
    path("admin/users/", viewsAdmin.AdminUserListView.as_view(), name="admin-users"),
    path("admin/dashboard/", viewsAdmin.AdminDashboardView.as_view(), name="admin-dashboard"),
    path("admin/associations/", viewsAdmin.AdminAssociationListView.as_view(), name="admin-associations"),
    path("admin/associations/<int:pk>/verifier/", viewsAdmin.VerifierAssociationView.as_view(), name="admin-verifier"),
    path("admin/signalements/", viewsAdmin.SignalementAdminListView.as_view(), name="admin-signalements"),
    path("admin/signalements/<int:pk>/", viewsAdmin.SignalementAdminUpdateView.as_view(), name="admin-signalement"),
]
