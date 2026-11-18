"""Ferme les groupes de discussion des activités terminées.

Les groupes sont déjà fermés automatiquement à la consultation ; cette commande
permet en plus de le faire via une tâche planifiée (cron / Planificateur Windows) :

    python manage.py fermer_groupes
"""

from django.core.management.base import BaseCommand

from login_app.services import fermer_groupes_expires


class Command(BaseCommand):
    help = "Ferme les groupes dont l'activité est terminée."

    def handle(self, *args, **options):
        n = fermer_groupes_expires()
        self.stdout.write(self.style.SUCCESS(f"{n} groupe(s) fermé(s)."))
