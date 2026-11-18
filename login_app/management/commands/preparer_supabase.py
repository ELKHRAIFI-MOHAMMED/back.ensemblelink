"""Prépare la base Supabase pour la bêta : sécurité des tables + bucket des médias.

    ENV_FILE=.env.supabase python manage.py preparer_supabase
"""

from django.conf import settings
from django.core.management.base import BaseCommand, CommandError

from login_app.storage import creer_bucket_public
from login_app.supabase_securite import est_supabase, securiser_tables


class Command(BaseCommand):
    help = "Sécurise les tables (RLS) et crée le bucket public des médias sur Supabase."

    def handle(self, *args, **options):
        if not est_supabase():
            raise CommandError("La base active n'est pas Supabase (DATABASE_URL / SUPABASE_URL manquants).")
        nb, roles = securiser_tables()
        self.stdout.write(self.style.SUCCESS(f"{nb} tables protégées : RLS activé, droits retirés à {', '.join(roles)}."))
        if settings.SUPABASE_SERVICE_ROLE_KEY:
            etat = creer_bucket_public()
            self.stdout.write(self.style.SUCCESS(f"Bucket « {settings.SUPABASE_STORAGE_BUCKET} » : {etat}."))
