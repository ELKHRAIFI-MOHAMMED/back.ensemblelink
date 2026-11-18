from django.apps import AppConfig
from django.db.models.signals import post_migrate


class LoginAppConfig(AppConfig):
    default_auto_field = "django.db.models.BigAutoField"
    name = "login_app"

    def ready(self):
        from . import signals  # noqa: F401  (synchronisation des groupes de discussion)
        from .supabase_securite import securiser_apres_migration

        # Sur Supabase : ferme l'accès de l'API publique aux tables après chaque migration
        post_migrate.connect(securiser_apres_migration, sender=self, dispatch_uid="ensemblelink_supabase_rls")
