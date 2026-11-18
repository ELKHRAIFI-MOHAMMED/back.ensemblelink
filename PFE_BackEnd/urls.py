from django.conf import settings
from django.conf.urls.static import static
from django.contrib import admin
from django.urls import include, path

urlpatterns = [
    path("admin/", admin.site.urls),
    path("api/", include("login_app.urls.urlsUser")),
    path("api/", include("login_app.urls.urlsAdmin")),
    path("api/", include("login_app.urls.urlsAnnonce")),
    path("api/", include("login_app.urls.urlsCandidature")),
    path("api/", include("login_app.urls.urlsSocial")),
    path("api/", include("login_app.urls.urlsGroupe")),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
