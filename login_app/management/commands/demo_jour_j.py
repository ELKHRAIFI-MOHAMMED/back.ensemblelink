"""
Crée (ou recrée) des activités qui ont lieu AUJOURD'HUI pour les comptes de démo, afin de tester l'alerte « Jour J ».

    python manage.py demo_jour_j

Les horaires sont calculés par rapport à l'heure actuelle : relancez la commande un autre jour pour retester.
Comptes concernés : emma.martin (mission en cours à Lyon), yassine.elamrani (footing à Casablanca),
imane.alaoui (organisatrice du footing), oliver.smith (organisateur à Londres), panier_solidaire (organisatrice).
"""

from datetime import timedelta
from decimal import Decimal

from django.core.management.base import BaseCommand, CommandError
from django.db import transaction
from django.utils import timezone

from login_app.models import Annonce, AssociationProfile, Candidature, Categorie, CitoyenProfile, Notification
from login_app.services import creer_groupe

MARQUEUR = "[Démo Jour J]"


def _arrondi(dt):
    return dt.replace(minute=(dt.minute // 15) * 15, second=0, microsecond=0)


class Command(BaseCommand):
    help = "Crée des activités du jour pour tester l'alerte Jour J."

    @transaction.atomic
    def handle(self, *args, **options):
        now = _arrondi(timezone.now())
        anciennes = Annonce.objects.filter(description__contains=MARQUEUR)
        lien_anciennes = [f"/missions/{i}" for i in anciennes.values_list("id", flat=True)]
        Notification.objects.filter(lien__in=lien_anciennes).delete()
        anciennes.delete()

        try:
            panier = AssociationProfile.objects.get(user__username="panier_solidaire")
            cit = {c.user.username: c for c in CitoyenProfile.objects.select_related("user").filter(user__username__in=[
                "emma.martin", "adam.benali", "imane.alaoui", "yassine.elamrani", "karim.berrada",
                "oliver.smith", "amelia.jones", "priya.patel",
            ])}
        except AssociationProfile.DoesNotExist:
            raise CommandError("Lancez d'abord `python manage.py seed_demo`.")

        cat = {c.nom: c for c in Categorie.objects.all()}

        def creer(titre, debut, duree_h, ville, pays, fuseau, lat, lng, categorie, description, participants,
                  association=None, createur=None, type_="ACTIVITE", places=None):
            a = Annonce.objects.create(
                titre=titre, description=f"{description}\n\n{MARQUEUR}", type=type_, association=association,
                createur=createur, categorie=cat.get(categorie), lieu=f"Point de rendez-vous — {ville}", ville=ville,
                pays=pays, fuseau_horaire=fuseau, latitude=Decimal(lat), longitude=Decimal(lng),
                date_debut=debut, date_fin=debut + timedelta(hours=duree_h), nombre_places=places,
                inscription_automatique=type_ == "ACTIVITE",
            )
            for username in participants:
                Candidature.objects.create(
                    citoyen=cit[username], annonce=a, statut=Candidature.Statut.ACCEPTEE,
                    message="Inscrit·e pour aujourd'hui !", date_reponse=now - timedelta(days=1),
                )
            creer_groupe(a)
            return a

        missions = [
            # Mission associative EN COURS (démarrée il y a 30 min) : Emma voit son QR de présence
            creer("Tri des dons du jour", now - timedelta(minutes=30), 3.5, "Lyon", "FR", "Europe/Paris",
                  "45.748000", "4.846000", "Solidarité alimentaire",
                  "Tri et rangement des denrées reçues cette semaine. Gants fournis.",
                  ["emma.martin", "adam.benali"], association=panier, type_="APPEL_BENEVOLAT", places=8),
            # Activité citoyenne dans 2 h à Casablanca : Yassine participe, Imane organise
            creer("Footing du soir sur la Corniche", now + timedelta(hours=2), 1.5, "Casablanca", "MA",
                  "Africa/Casablanca", "33.595000", "-7.660000", "Sport entre amis",
                  "Footing tranquille de 6 km le long de la Corniche d'Aïn Diab, tous niveaux.",
                  ["yassine.elamrani", "karim.berrada"], createur=cit["imane.alaoui"], places=15),
            # Activité citoyenne dans 1 h à Londres : Oliver organise
            creer("Evening run along the Thames", now + timedelta(hours=1), 1, "London", "GB", "Europe/London",
                  "51.505000", "-0.090000", "Sport entre amis",
                  "Easy 5k from London Bridge to Westminster and back.",
                  ["amelia.jones", "priya.patel"], createur=cit["oliver.smith"], places=12),
        ]
        self.stdout.write(self.style.SUCCESS(
            f"{len(missions)} activités du jour créées : " + ", ".join(f"#{m.id} {m.titre}" for m in missions)
        ))
