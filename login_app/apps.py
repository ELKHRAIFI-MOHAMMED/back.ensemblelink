from django.apps import AppConfig


class LoginAppConfig(AppConfig):
    default_auto_field = "django.db.models.BigAutoField"
    name = "login_app"

    def ready(self):
        from . import signals  # noqa: F401  (branche les signaux de synchronisation des groupes)
