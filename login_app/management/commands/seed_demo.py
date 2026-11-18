"""
Données de démonstration EnsembleLink (v4 bêta, internationale).

    python manage.py seed_demo            # remplit une base vide
    python manage.py seed_demo --reset    # vide les données de l'app puis remplit

Pays : Maroc, France, Royaume-Uni, États-Unis, Canada.
Tous les comptes de démo utilisent le mot de passe : Demo1234!
"""

import random
from datetime import datetime, time, timedelta
from decimal import Decimal
from zoneinfo import ZoneInfo

from django.core.management import call_command
from django.core.management.base import BaseCommand, CommandError
from django.db import transaction
from django.utils import timezone

from login_app.models import (
    Annonce, AssociationProfile, Avis, Candidature, Categorie, CitoyenProfile, Competence, GroupeDiscussion,
    MembreGroupe, Message, MessageGroupe, Notification, Signalement, User,
)
from login_app.services import creer_groupe, fermer_groupe

MOT_DE_PASSE = "Demo1234!"

# ville : (latitude, longitude, pays, fuseau, langue)
VILLES = {
    "Paris": (48.8566, 2.3522, "FR", "Europe/Paris", "fr"),
    "Lyon": (45.7640, 4.8357, "FR", "Europe/Paris", "fr"),
    "Marseille": (43.2965, 5.3698, "FR", "Europe/Paris", "fr"),
    "Nantes": (47.2184, -1.5536, "FR", "Europe/Paris", "fr"),
    "Bordeaux": (44.8378, -0.5792, "FR", "Europe/Paris", "fr"),
    "Toulouse": (43.6047, 1.4442, "FR", "Europe/Paris", "fr"),
    "Lille": (50.6292, 3.0573, "FR", "Europe/Paris", "fr"),
    "Casablanca": (33.5731, -7.5898, "MA", "Africa/Casablanca", "fr"),
    "Rabat": (34.0209, -6.8416, "MA", "Africa/Casablanca", "fr"),
    "Marrakech": (31.6295, -7.9811, "MA", "Africa/Casablanca", "fr"),
    "Tanger": (35.7595, -5.8340, "MA", "Africa/Casablanca", "fr"),
    "London": (51.5072, -0.1276, "GB", "Europe/London", "en"),
    "Manchester": (53.4808, -2.2426, "GB", "Europe/London", "en"),
    "New York": (40.7128, -74.0060, "US", "America/New_York", "en"),
    "San Francisco": (37.7749, -122.4194, "US", "America/Los_Angeles", "en"),
    "Chicago": (41.8781, -87.6298, "US", "America/Chicago", "en"),
    "Montréal": (45.5019, -73.5674, "CA", "America/Toronto", "fr"),
    "Toronto": (43.6532, -79.3832, "CA", "America/Toronto", "en"),
    "Vancouver": (49.2827, -123.1207, "CA", "America/Vancouver", "en"),
}

CATEGORIES = [
    ("Solidarité alimentaire", "🥕", "#F26B3A"),
    ("Environnement", "🌿", "#2E9E6A"),
    ("Éducation", "📚", "#3D6FD8"),
    ("Animaux", "🐾", "#B5651D"),
    ("Seniors", "🫶", "#C2477A"),
    ("Sport & handicap", "🏅", "#0E9AA7"),
    ("Santé", "🩺", "#D64545"),
    ("Culture", "🎨", "#8A5CF6"),
    ("Logement", "🏠", "#6B7B3A"),
    ("Sport entre amis", "⚽", "#E4572E"),
    ("Lecture", "📖", "#5B8C5A"),
    ("Loisirs & sorties", "🧺", "#D98E04"),
]

COMPETENCES = [
    "Cuisine", "Logistique", "Animation", "Soutien scolaire", "Informatique", "Communication",
    "Bricolage", "Permis B", "Langues étrangères", "Premiers secours", "Jardinage", "Photographie",
]

ASSOCIATIONS = [
    # username, nom, ville, statut, description
    ("panier_solidaire", "Le Panier Solidaire", "Lyon", "VERIFIEE",
     "Épicerie solidaire et distributions de repas pour les familles en difficulté du 7e arrondissement."),
    ("vert_demain", "Vert Demain", "Nantes", "VERIFIEE",
     "Nettoyage des berges, jardins partagés et ateliers zéro déchet le long de la Loire."),
    ("lire_ensemble", "Lire Ensemble", "Paris", "VERIFIEE",
     "Soutien scolaire gratuit et ateliers lecture pour les enfants de 6 à 15 ans."),
    ("pattes_coeurs", "Pattes & Cœurs", "Marseille", "VERIFIEE",
     "Refuge associatif : soins, promenades et adoptions responsables de chiens et chats."),
    ("aines_connectes", "Les Aînés Connectés", "Bordeaux", "VERIFIEE",
     "Lutte contre l'isolement des personnes âgées : visites, appels et initiation au numérique."),
    ("sport_pour_tous", "Sport Pour Tous 31", "Toulouse", "VERIFIEE",
     "Rendre le sport accessible à tous, en particulier aux personnes en situation de handicap."),
    ("toit_dabord", "Toit d'Abord", "Lille", "EN_ATTENTE",
     "Maraudes et accompagnement vers le logement des personnes sans-abri."),
    ("recup_art", "Collectif Récup'Art", "Paris", "EN_ATTENTE",
     "Ateliers artistiques à partir de matériaux recyclés, ouverts à tous les quartiers."),
    # Maroc
    ("atlas_solidaire", "Atlas Solidaire", "Marrakech", "VERIFIEE",
     "Paniers solidaires, soutien aux villages du Haut Atlas et chantiers bénévoles."),
    ("casa_entraide", "Casa Entraide", "Casablanca", "VERIFIEE",
     "Soutien scolaire et bibliothèques de quartier pour les enfants de Casablanca."),
    ("tanja_verte", "Tanja Verte", "Tanger", "EN_ATTENTE",
     "Nettoyage des plages et sensibilisation à l'environnement sur le détroit."),
    # Royaume-Uni
    ("london_food_share", "London Food Share", "London", "VERIFIEE",
     "Redistributing surplus food to community kitchens across London."),
    ("manchester_reads", "Manchester Reads", "Manchester", "VERIFIEE",
     "Free reading sessions and literacy support for children and adults."),
    # États-Unis
    ("brooklyn_green", "Brooklyn Green Hands", "New York", "VERIFIEE",
     "Community gardens, tree planting and park clean-ups in Brooklyn."),
    ("bay_area_paws", "Bay Area Paws", "San Francisco", "VERIFIEE",
     "Volunteer-run animal rescue: walks, fostering and adoption days."),
    # Canada
    ("montreal_coeur", "Montréal Cœur Ouvert", "Montréal", "VERIFIEE",
     "Visites, appels et sorties pour les aînés isolés de Montréal."),
    ("toronto_warm", "Toronto Warm Hearts", "Toronto", "VERIFIEE",
     "Winter coat drives, shelter breakfasts and support for unhoused neighbours."),
]

CITOYENS = [
    # username, prénom, nom, ville, compétences, centres d'intérêt
    ("emma.martin", "Emma", "Martin", "Lyon", ["Cuisine", "Logistique"], ["Solidarité alimentaire", "Seniors", "Loisirs & sorties"]),
    ("lucas.bernard", "Lucas", "Bernard", "Paris", ["Soutien scolaire", "Informatique"], ["Éducation", "Culture", "Lecture"]),
    ("ines.haddad", "Inès", "Haddad", "Marseille", ["Premiers secours", "Communication"], ["Animaux", "Santé", "Sport entre amis"]),
    ("hugo.petit", "Hugo", "Petit", "Nantes", ["Jardinage", "Bricolage"], ["Environnement", "Sport entre amis"]),
    ("chloe.dubois", "Chloé", "Dubois", "Bordeaux", ["Animation", "Informatique"], ["Seniors", "Éducation"]),
    ("yanis.moreau", "Yanis", "Moreau", "Toulouse", ["Animation", "Premiers secours"], ["Sport & handicap", "Sport entre amis"]),
    ("lea.laurent", "Léa", "Laurent", "Paris", ["Photographie", "Communication"], ["Culture", "Environnement", "Loisirs & sorties"]),
    ("adam.benali", "Adam", "Benali", "Lyon", ["Permis B", "Logistique"], ["Solidarité alimentaire", "Logement"]),
    ("manon.girard", "Manon", "Girard", "Lille", ["Langues étrangères", "Soutien scolaire"], ["Éducation", "Logement"]),
    ("nathan.roux", "Nathan", "Roux", "Nantes", ["Bricolage", "Permis B"], ["Environnement", "Sport entre amis"]),
    # Maroc
    ("yassine.elamrani", "Yassine", "El Amrani", "Casablanca", ["Animation", "Premiers secours"], ["Sport entre amis", "Éducation"]),
    ("imane.alaoui", "Imane", "Alaoui", "Casablanca", ["Communication", "Cuisine"], ["Loisirs & sorties", "Éducation"]),
    ("salma.benjelloun", "Salma", "Benjelloun", "Rabat", ["Soutien scolaire", "Langues étrangères"], ["Lecture", "Culture"]),
    ("omar.tazi", "Omar", "Tazi", "Marrakech", ["Cuisine", "Logistique"], ["Solidarité alimentaire", "Loisirs & sorties"]),
    ("karim.berrada", "Karim", "Berrada", "Tanger", ["Jardinage", "Permis B"], ["Environnement", "Sport entre amis"]),
    ("nora.chraibi", "Nora", "Chraibi", "Marrakech", ["Photographie", "Animation"], ["Loisirs & sorties", "Solidarité alimentaire"]),
    # Royaume-Uni
    ("oliver.smith", "Oliver", "Smith", "London", ["Logistique", "Animation"], ["Sport entre amis", "Solidarité alimentaire"]),
    ("amelia.jones", "Amelia", "Jones", "London", ["Cuisine", "Communication"], ["Solidarité alimentaire", "Lecture"]),
    ("priya.patel", "Priya", "Patel", "London", ["Soutien scolaire", "Informatique"], ["Lecture", "Éducation"]),
    ("harry.wilson", "Harry", "Wilson", "Manchester", ["Bricolage", "Premiers secours"], ["Loisirs & sorties", "Sport entre amis"]),
    # États-Unis
    ("james.miller", "James", "Miller", "New York", ["Premiers secours", "Logistique"], ["Sport entre amis", "Environnement"]),
    ("emily.davis", "Emily", "Davis", "New York", ["Jardinage", "Photographie"], ["Environnement", "Loisirs & sorties"]),
    ("sofia.garcia", "Sofia", "Garcia", "San Francisco", ["Langues étrangères", "Communication"], ["Animaux", "Loisirs & sorties"]),
    ("michael.brown", "Michael", "Brown", "Chicago", ["Informatique", "Animation"], ["Éducation", "Sport entre amis"]),
    # Canada
    ("liam.tremblay", "Liam", "Tremblay", "Montréal", ["Animation", "Cuisine"], ["Seniors", "Loisirs & sorties"]),
    ("chloe.gagnon", "Chloé", "Gagnon", "Montréal", ["Premiers secours", "Photographie"], ["Sport entre amis", "Seniors"]),
    ("noah.wong", "Noah", "Wong", "Toronto", ["Logistique", "Informatique"], ["Sport entre amis", "Logement"]),
    ("olivia.martin", "Olivia", "Martin", "Vancouver", ["Animation", "Jardinage"], ["Sport entre amis", "Environnement"]),
]

# Missions des associations :
# (asso, titre, type, catégorie, jours, heure, durée h, places, compétences, objectif, unité, description)
MISSIONS = [
    # --- France (passées)
    ("panier_solidaire", "Distribution de colis alimentaires", "APPEL_BENEVOLAT", "Solidarité alimentaire", -21, 9, 4, 8,
     ["Logistique"], None, "", "Préparation et distribution de 200 colis pour les familles inscrites."),
    ("vert_demain", "Grand nettoyage des berges de la Loire", "EVENEMENT", "Environnement", -14, 9, 3, 30,
     ["Jardinage"], None, "", "Matinée de ramassage des déchets, gants et sacs fournis. Pique-nique offert !"),
    ("lire_ensemble", "Stage de révisions du brevet", "APPEL_BENEVOLAT", "Éducation", -10, 9, 6, 5,
     ["Soutien scolaire"], None, "", "Accompagner des collégiens de 3e en maths et français pendant une journée."),
    ("aines_connectes", "Après-midi jeux en EHPAD", "EVENEMENT", "Seniors", -7, 14, 3, 6,
     ["Animation"], None, "", "Belote, scrabble et goûter partagé avec les résidents de la résidence Les Tilleuls."),
    ("sport_pour_tous", "Tournoi de basket fauteuil", "EVENEMENT", "Sport & handicap", -5, 10, 5, 12,
     ["Animation", "Premiers secours"], None, "", "Accueil du public, arbitrage de table et buvette."),
    # --- France (à venir)
    ("panier_solidaire", "Cuisine solidaire du samedi", "APPEL_BENEVOLAT", "Solidarité alimentaire", 4, 9, 4, 6,
     ["Cuisine"], None, "", "Préparer 150 repas chauds avec notre cheffe bénévole. Tablier fourni."),
    ("panier_solidaire", "Collecte de denrées pour l'hiver", "DON", "Solidarité alimentaire", 2, 8, 72, None,
     [], Decimal("500"), "kg", "Pâtes, riz, conserves, produits d'hygiène : chaque kilo compte."),
    ("vert_demain", "Plantation d'une forêt urbaine", "EVENEMENT", "Environnement", 11, 9, 5, 40,
     ["Jardinage"], None, "", "Plantation de 600 arbres selon la méthode Miyawaki à Rezé."),
    ("vert_demain", "Atelier réparation de vélos", "APPEL_BENEVOLAT", "Environnement", 6, 14, 3, 4,
     ["Bricolage"], None, "", "Aider les habitants à réparer eux-mêmes leur vélo. Outils fournis."),
    ("lire_ensemble", "Aide aux devoirs hebdomadaire", "APPEL_BENEVOLAT", "Éducation", 3, 17, 2, 10,
     ["Soutien scolaire"], None, "", "Tous les mardis de 17h à 19h, niveau primaire et collège."),
    ("lire_ensemble", "Dons de livres jeunesse", "DON", "Éducation", 1, 8, 240, None,
     [], Decimal("300"), "livres", "Albums, romans jeunesse et BD en bon état pour notre bibliothèque."),
    ("pattes_coeurs", "Promenade des chiens du refuge", "APPEL_BENEVOLAT", "Animaux", 2, 10, 2, 8,
     [], None, "", "Sortir nos pensionnaires pour une balade au parc Borély."),
    ("pattes_coeurs", "Collecte de couvertures et croquettes", "DON", "Animaux", 1, 8, 336, None,
     [], Decimal("120"), "couvertures", "L'hiver arrive : couvertures, paniers et croquettes sont les bienvenus."),
    ("aines_connectes", "Initiation tablette pour seniors", "APPEL_BENEVOLAT", "Seniors", 8, 14, 2, 4,
     ["Informatique"], None, "", "Apprendre aux aînés à appeler leurs proches en visio."),
    ("aines_connectes", "Repas de Noël partagé", "EVENEMENT", "Seniors", 36, 12, 4, 15,
     ["Cuisine", "Animation"], None, "", "Préparer et partager un repas festif avec 60 personnes âgées isolées."),
    ("sport_pour_tous", "Accompagnateurs course inclusive", "APPEL_BENEVOLAT", "Sport & handicap", 13, 9, 4, 20,
     ["Premiers secours"], None, "", "Guider des coureurs malvoyants sur le parcours de 5 km."),
    # --- Maroc
    ("atlas_solidaire", "Distribution de paniers dans le Haut Atlas", "APPEL_BENEVOLAT", "Solidarité alimentaire", 6, 8, 8, 10,
     ["Logistique", "Permis B"], None, "", "Départ en minibus depuis Marrakech pour distribuer 150 paniers dans trois douars."),
    ("atlas_solidaire", "Collecte de couvertures pour les villages", "DON", "Solidarité alimentaire", 1, 8, 240, None,
     [], Decimal("200"), "couvertures", "Les nuits sont glaciales en montagne : couvertures et vêtements chauds bienvenus."),
    ("casa_entraide", "Soutien scolaire du mercredi", "APPEL_BENEVOLAT", "Éducation", 2, 15, 2, 8,
     ["Soutien scolaire", "Langues étrangères"], None, "", "Aide aux devoirs en français, arabe et maths pour des collégiens de Hay Mohammadi."),
    ("casa_entraide", "Inauguration de la bibliothèque de quartier", "EVENEMENT", "Éducation", -9, 10, 4, 15,
     ["Animation"], None, "", "Lectures contées, ateliers dessin et rangement des 2 000 livres donnés."),
    # --- Royaume-Uni
    ("london_food_share", "Saturday food sorting", "APPEL_BENEVOLAT", "Solidarité alimentaire", 3, 10, 4, 12,
     ["Logistique"], None, "", "Sort and pack surplus food for 20 community kitchens. Tea and biscuits provided!"),
    ("london_food_share", "Community kitchen night", "EVENEMENT", "Solidarité alimentaire", -6, 18, 3, 10,
     ["Cuisine"], None, "", "Cook and serve a three-course dinner for 80 guests in Hackney."),
    ("manchester_reads", "Reading buddies for kids", "APPEL_BENEVOLAT", "Éducation", 5, 16, 2, 6,
     ["Soutien scolaire"], None, "", "Read one-to-one with primary school children at Ancoats library."),
    # --- États-Unis
    ("brooklyn_green", "Prospect Park clean-up", "EVENEMENT", "Environnement", 4, 9, 3, 30,
     ["Jardinage"], None, "", "Join us to clean the lakeside trails. Gloves, bags and coffee provided."),
    ("brooklyn_green", "Community garden planting", "EVENEMENT", "Environnement", -8, 9, 4, 20,
     ["Jardinage"], None, "", "Spring planting at the Bed-Stuy community garden."),
    ("bay_area_paws", "Dog walking volunteers", "APPEL_BENEVOLAT", "Animaux", 2, 10, 2, 8,
     [], None, "", "Walk our rescue dogs around the Presidio. Short training on arrival."),
    ("bay_area_paws", "Pet food drive", "DON", "Animaux", 1, 8, 336, None,
     [], Decimal("400"), "lbs", "Dry and canned food for 60 rescue dogs and cats."),
    # --- Canada
    ("montreal_coeur", "Après-midi jeux avec les aînés", "EVENEMENT", "Seniors", 7, 14, 3, 8,
     ["Animation"], None, "", "Bingo, cartes et chocolat chaud au centre communautaire du Plateau."),
    ("toronto_warm", "Winter coat drive", "DON", "Logement", 1, 8, 480, None,
     [], Decimal("300"), "coats", "Warm coats, hats and gloves for shelters across downtown Toronto."),
    ("toronto_warm", "Shelter breakfast team", "APPEL_BENEVOLAT", "Logement", 3, 7, 3, 6,
     ["Cuisine"], None, "", "Prepare and serve breakfast for 120 guests at the Queen Street shelter."),
]

# Activités organisées par des citoyens :
# (créateur, titre, catégorie, jours, heure, durée h, places, inscription auto, description)
ACTIVITES = [
    ("yassine.elamrani", "Match de foot du dimanche à Aïn Diab", "Sport entre amis", 4, 17, 2, 14, True,
     "On cherche des joueurs pour un 7 contre 7 amical sur le terrain synthétique. Tous niveaux, ramenez de l'eau !"),
    ("salma.benjelloun", "Club de lecture : L'Alchimiste", "Lecture", 6, 18, 2, 10, True,
     "On discute du roman de Paulo Coelho autour d'un thé à la menthe, au café du jardin d'essais."),
    ("omar.tazi", "Atelier cuisine marocaine : tajine et msemen", "Loisirs & sorties", 9, 10, 3, 8, False,
     "Je vous apprends les recettes de ma grand-mère. Ingrédients partagés, inscription validée par mes soins."),
    ("imane.alaoui", "Pique-nique au parc de la Ligue arabe", "Loisirs & sorties", -3, 12, 3, 20, True,
     "Chacun apporte un plat, on s'occupe des jeux pour les enfants."),
    ("oliver.smith", "Sunday 5-a-side football in Hyde Park", "Sport entre amis", 4, 10, 2, 10, True,
     "Friendly 5-a-side near the Serpentine. All levels welcome, bring a dark and a light t-shirt."),
    ("priya.patel", "Book club: The Midnight Library", "Lecture", 8, 19, 2, 12, True,
     "Monthly book club at a cosy café in Islington. New faces always welcome!"),
    ("harry.wilson", "Picnic at Heaton Park", "Loisirs & sorties", -4, 12, 3, 25, True,
     "Bring a blanket and something to share. Frisbee and rounders afterwards."),
    ("james.miller", "Central Park morning run", "Sport entre amis", 2, 7, 1.5, None, True,
     "Easy 8 km loop around the reservoir, conversational pace. Coffee after!"),
    ("emily.davis", "Board game night", "Loisirs & sorties", 6, 19, 3, 8, False,
     "Catan, Ticket to Ride and Codenames in my Brooklyn apartment. Limited seats, I'll confirm by message."),
    ("sofia.garcia", "Picnic at Dolores Park", "Loisirs & sorties", 5, 12, 3, 30, True,
     "Sunny afternoon picnic with a view of the city. Potluck style!"),
    ("liam.tremblay", "Pique-nique au parc La Fontaine", "Loisirs & sorties", 5, 12, 3, 25, True,
     "Pique-nique partagé près de l'étang, guitare bienvenue !"),
    ("chloe.gagnon", "Randonnée au mont Royal", "Sport entre amis", 3, 9, 2.5, 15, True,
     "Montée jusqu'au belvédère Kondiaronk par les sentiers, rythme tranquille."),
    ("noah.wong", "Pickup basketball at Christie Pits", "Sport entre amis", 4, 18, 2, 10, True,
     "Casual 3-on-3 and 5-on-5 games. All skill levels."),
    ("olivia.martin", "Sunrise yoga in Stanley Park", "Sport entre amis", 6, 7, 1, 20, True,
     "Gentle flow by the seawall. Bring your own mat."),
    ("emma.martin", "Pique-nique au parc de la Tête d'Or", "Loisirs & sorties", 5, 12, 3, 20, True,
     "Grand pique-nique partagé près de la roseraie. Chacun apporte un plat ou une boisson !"),
    ("lucas.bernard", "Soirée jeux de société", "Loisirs & sorties", 3, 19, 3, 8, False,
     "Soirée jeux dans un bar à jeux du 11e. Places limitées : je valide les inscriptions."),
    ("ines.haddad", "Partie de pétanque sur la Corniche", "Sport entre amis", 2, 17, 2, 12, True,
     "Pétanque détente face à la mer, boules prêtées si besoin."),
    ("hugo.petit", "Balade à vélo le long de la Loire", "Sport entre amis", -2, 10, 3, 15, True,
     "Boucle de 30 km entre Nantes et Trentemoult, pause goûter à mi-parcours."),
]

# Annonces qui reçoivent un groupe de discussion (titres)
GROUPES = [
    "Match de foot du dimanche à Aïn Diab", "Club de lecture : L'Alchimiste", "Pique-nique au parc de la Ligue arabe",
    "Sunday 5-a-side football in Hyde Park", "Book club: The Midnight Library", "Picnic at Heaton Park",
    "Central Park morning run", "Picnic at Dolores Park", "Pique-nique au parc La Fontaine", "Randonnée au mont Royal",
    "Pique-nique au parc de la Tête d'Or", "Partie de pétanque sur la Corniche", "Balade à vélo le long de la Loire",
    "Cuisine solidaire du samedi", "Distribution de paniers dans le Haut Atlas", "Saturday food sorting",
    "Prospect Park clean-up", "Community garden planting",
]

CONVERSATIONS_GROUPE = {
    "fr": [
        "Bonjour à tous, ravi·e de participer !",
        "On se retrouve à l'entrée principale ?",
        "Oui, 10 minutes avant le début, ce sera parfait.",
        "J'apporte de l'eau et des gobelets pour tout le monde 🙂",
        "Super, merci ! Pensez à la crème solaire.",
    ],
    "en": [
        "Hi everyone, looking forward to it!",
        "Shall we meet at the main entrance?",
        "Sounds good, 10 minutes before the start.",
        "I'll bring some water and snacks for the group 🙂",
        "Amazing, thanks! See you all there.",
    ],
}

MESSAGES_PRIVES = [
    ("emma.martin", "panier_solidaire", [
        "Bonjour ! Faut-il apporter quelque chose pour la cuisine solidaire ?",
        "Bonjour Emma, juste de bonnes chaussures fermées, on fournit le reste 🙂",
        "Parfait, à samedi !",
    ]),
    ("lucas.bernard", "lire_ensemble", [
        "Je peux aussi aider pour l'atelier code si besoin.",
        "Super, on vous ajoute à la liste. Merci Lucas !",
    ]),
    ("oliver.smith", "london_food_share", [
        "Hi! Is there parking near the warehouse?",
        "Hi Oliver, yes, free parking on Wick Lane on Saturdays.",
    ]),
    ("yassine.elamrani", "casa_entraide", [
        "Salam ! Je peux venir aider pour le soutien scolaire en maths.",
    ]),
]


def date_locale(jours, heure, fuseau):
    """Date à `heure` (heure locale de la ville), dans `jours` jours."""
    tz = ZoneInfo(fuseau)
    jour = (timezone.now().astimezone(tz) + timedelta(days=jours)).date()
    h = int(heure)
    return datetime.combine(jour, time(h, int((heure - h) * 60)), tzinfo=tz)


class Command(BaseCommand):
    help = "Insère des données de démonstration internationales (comptes, annonces, activités, groupes, avis)."

    def add_arguments(self, parser):
        parser.add_argument("--reset", action="store_true", help="Supprime les données existantes avant l'insertion.")

    @transaction.atomic
    def handle(self, *args, **options):
        random.seed(42)
        if options["reset"]:
            self._reset()
        elif User.objects.filter(username="admin").exists():
            raise CommandError("Les données de démo existent déjà. Utilisez --reset pour les recréer.")

        admin = User.objects.create_superuser("admin", "admin@ensemblelink.demo", MOT_DE_PASSE, type=User.UserType.ADMIN)
        self.cats = {nom: Categorie.objects.create(nom=nom, icone=ic, couleur=col) for nom, ic, col in CATEGORIES}
        self.comps = {nom: Competence.objects.create(nom=nom) for nom in COMPETENCES}

        self.assos = {}
        for username, nom, ville, statut, desc in ASSOCIATIONS:
            pays = VILLES[ville][2]
            u = User.objects.create_user(username, f"{username}@asso.ensemblelink.demo", MOT_DE_PASSE, type=User.UserType.ASSOCIATION)
            self.assos[username] = AssociationProfile.objects.create(
                user=u, nom=nom, ville=ville, pays=pays, description=desc, statut_verification=statut,
                contact=f"contact@{username.replace('_', '')}.org",
                telephone={"FR": "01 23 45 67 89", "MA": "+212 5 22 00 00 00", "GB": "+44 20 7946 0000",
                           "US": "+1 212 555 0100", "CA": "+1 514 555 0100"}[pays],
                site_web=f"https://{username.replace('_', '-')}.example.org",
                adresse=f"12 rue de la Solidarité, {ville}" if VILLES[ville][4] == "fr" else f"12 Community Street, {ville}",
                reseaux_sociaux={"instagram": f"https://instagram.com/{username}"},
                date_creation=timezone.now() - timedelta(days=random.randint(30, 400)),
            )

        self.citoyens = {}
        for username, prenom, nom, ville, cmp, interets in CITOYENS:
            pays = VILLES[ville][2]
            anglais = VILLES[ville][4] == "en"
            u = User.objects.create_user(username, f"{username}@mail.ensemblelink.demo", MOT_DE_PASSE,
                                         type=User.UserType.CITOYEN, first_name=prenom, last_name=nom)
            c = CitoyenProfile.objects.create(
                user=u, prenom=prenom, nom=nom, ville=ville, pays=pays,
                bio=(f"{prenom} from {ville}. I love meeting people and helping out locally." if anglais
                     else f"{prenom}, de {ville}. J'aime me rendre utile et rencontrer du monde près de chez moi."),
                experiences="Volunteering for 2 years." if anglais else "Bénévolat associatif depuis 2 ans.",
            )
            c.competences.set([self.comps[x] for x in cmp])
            c.centres_interet.set([self.cats[x] for x in interets])
            self.citoyens[username] = c

        self.annonces = {}
        for (asso, titre, type_, cat, jours, heure, duree, places, cmp, objectif, unite, desc) in MISSIONS:
            a = self.assos[asso]
            self._creer_annonce(titre=titre, type_=type_, cat=cat, ville=a.ville, jours=jours, heure=heure, duree=duree,
                                places=places, desc=desc, association=a, competences=cmp, objectif=objectif, unite=unite)
        for (createur, titre, cat, jours, heure, duree, places, auto, desc) in ACTIVITES:
            c = self.citoyens[createur]
            self._creer_annonce(titre=titre, type_="ACTIVITE", cat=cat, ville=c.ville, jours=jours, heure=heure,
                                duree=duree, places=places, desc=desc, createur=c, auto=auto)

        self._candidatures()
        self._avis()
        self._groupes()
        self._messages_prives()
        self._divers(admin)
        call_command("demo_jour_j", stdout=self.stdout)  # activités du jour pour tester l'alerte « Jour J »

        self.stdout.write(self.style.SUCCESS(
            f"Démo prête : {User.objects.count()} comptes ({CitoyenProfile.objects.count()} citoyens, "
            f"{AssociationProfile.objects.count()} associations) dans "
            f"{len(set(CitoyenProfile.objects.values_list('pays', flat=True)))} pays, "
            f"{Annonce.objects.count()} annonces dont {Annonce.objects.filter(type='ACTIVITE').count()} activités, "
            f"{Candidature.objects.count()} candidatures, {GroupeDiscussion.objects.count()} groupes, "
            f"{Avis.objects.count()} avis. Mot de passe : {MOT_DE_PASSE}"
        ))

    # ------------------------------------------------------------------
    def _reset(self):
        for model in (MessageGroupe, MembreGroupe, GroupeDiscussion, Message, Notification, Signalement, Avis,
                      Candidature, Annonce, CitoyenProfile, AssociationProfile, Competence, Categorie):
            model.objects.all().delete()
        User.objects.all().delete()
        self.stdout.write("Données existantes supprimées.")

    def _creer_annonce(self, *, titre, type_, cat, ville, jours, heure, duree, places, desc,
                       association=None, createur=None, competences=(), objectif=None, unite="", auto=False):
        lat, lng, pays, fuseau, _ = VILLES[ville]
        debut = date_locale(jours, heure, fuseau)
        lieux = (["Parc", "Maison de quartier", "Centre-ville", "Local associatif"] if VILLES[ville][4] == "fr"
                 else ["Park", "Community centre", "Downtown", "Main hall"])
        annonce = Annonce.objects.create(
            association=association, createur=createur, titre=titre, type=type_, categorie=self.cats[cat],
            description=desc, lieu=f"{random.choice(lieux)} — {ville}", ville=ville, pays=pays, fuseau_horaire=fuseau,
            latitude=Decimal(str(round(lat + random.uniform(-0.03, 0.03), 6))),
            longitude=Decimal(str(round(lng + random.uniform(-0.04, 0.04), 6))),
            date_debut=debut, date_fin=debut + timedelta(hours=duree), nombre_places=places,
            inscription_automatique=auto, objectif_don=objectif, unite_don=unite,
        )
        annonce.competences_requises.set([self.comps[x] for x in competences])
        self.annonces[titre] = annonce
        return annonce

    def _candidatures(self):
        now = timezone.now()
        tous = list(self.citoyens.values())
        for annonce in self.annonces.values():
            passee = annonce.date_fin < now
            exclus = {annonce.createur_id}
            locaux = [c for c in tous if c.ville == annonce.ville and c.id not in exclus]
            pays = [c for c in tous if c.pays == annonce.pays and c.ville != annonce.ville and c.id not in exclus]
            capacite = annonce.nombre_places or 6
            if annonce.type == Annonce.AnnonceType.ACTIVITE:
                candidats = (locaux + random.sample(pays, min(len(pays), 4)))[: min(capacite, random.randint(4, 8))]
            else:
                candidats = (locaux + random.sample(pays, min(len(pays), 2)))[: capacite + 1]
            for i, cit in enumerate(candidats):
                if annonce.inscription_automatique or annonce.type == Annonce.AnnonceType.DON:
                    statut = Candidature.Statut.ACCEPTEE
                elif passee:
                    statut = Candidature.Statut.ACCEPTEE if i < max(len(candidats) - 1, 1) else Candidature.Statut.REFUSEE
                else:
                    statut = random.choice([Candidature.Statut.EN_ATTENTE, Candidature.Statut.EN_ATTENTE, Candidature.Statut.ACCEPTEE])
                if annonce.nombre_places and statut == Candidature.Statut.ACCEPTEE and annonce.places_prises >= annonce.nombre_places:
                    statut = Candidature.Statut.EN_ATTENTE
                anglais = VILLES[annonce.ville][4] == "en"
                cand = Candidature(
                    citoyen=cit, annonce=annonce, statut=statut,
                    message=random.choice(
                        ["Count me in!", "Happy to help, see you there.", "First time joining, can't wait!"] if anglais
                        else ["Je suis partant·e !", "Disponible et motivé·e, à bientôt.", "Première fois, j'ai hâte !"]
                    ),
                )
                if statut != Candidature.Statut.EN_ATTENTE:
                    cand.date_reponse = annonce.date_debut - timedelta(days=2)
                if annonce.type == Annonce.AnnonceType.DON:
                    cand.quantite_don = Decimal(random.choice([5, 10, 15, 20, 30]))
                if passee and statut == Candidature.Statut.ACCEPTEE:
                    cand.presence_confirmee = True
                    if annonce.association_id:
                        cand.heures_effectuees = Decimal(str(annonce.duree_heures))
                        cand.note_engagement = random.choice([4, 5, 5])
                cand.save()

    def _avis(self):
        fr_orga = ["Participant·e très sympa et ponctuel·le, merci !", "Super énergie, à refaire !", "Très fiable, un vrai plaisir."]
        fr_part = ["Organisation au top, ambiance géniale.", "Belle expérience, je recommande !", "Très bien encadré, j'y retourne."]
        en_orga = ["Great energy and always on time, thank you!", "Lovely person to have on the team.", "Super reliable, hope to see you again."]
        en_part = ["Brilliantly organised, great vibe.", "Wonderful experience, highly recommend!", "Really well run, will join again."]
        for annonce in self.annonces.values():
            if not annonce.est_terminee:
                continue
            anglais = VILLES[annonce.ville][4] == "en"
            orga = annonce.organisateur_user
            for cand in annonce.candidatures.filter(statut=Candidature.Statut.ACCEPTEE):
                Avis.objects.create(auteur=orga, cible=cand.citoyen.user, annonce=annonce,
                                    note=random.choice([4, 5, 5]), commentaire=random.choice(en_orga if anglais else fr_orga))
                if random.random() < 0.7:
                    Avis.objects.create(auteur=cand.citoyen.user, cible=orga, annonce=annonce, note=random.choice([4, 5, 5, 5]),
                                        commentaire=random.choice(en_part if anglais else fr_part))

    def _groupes(self):
        """Groupes de discussion : membres ajoutés automatiquement, conversations, fermeture des groupes passés."""
        now = timezone.now()
        for titre in GROUPES:
            annonce = self.annonces[titre]
            passee = annonce.date_fin < now
            groupe = creer_groupe(annonce)
            if passee:
                # creer_groupe n'ajoute pas les messages « a rejoint » à un groupe déjà terminé : on reconstitue l'historique
                for cand in annonce.candidatures.filter(statut=Candidature.Statut.ACCEPTEE).select_related("citoyen__user"):
                    MembreGroupe.objects.get_or_create(groupe=groupe, user=cand.citoyen.user)
            membres = [m.user for m in groupe.membres.select_related("user").order_by("role", "id")]
            lignes = CONVERSATIONS_GROUPE[VILLES[annonce.ville][4]]
            depart = (annonce.date_debut - timedelta(days=2)) if passee else (now - timedelta(hours=6))
            for i, texte in enumerate(lignes[: random.randint(3, len(lignes))]):
                msg = MessageGroupe.objects.create(groupe=groupe, auteur=membres[i % len(membres)], contenu=texte)
                MessageGroupe.objects.filter(pk=msg.pk).update(date_envoi=depart + timedelta(minutes=17 * (i + 1)))
            # Les messages automatiques (création, arrivées) précèdent la conversation
            MessageGroupe.objects.filter(groupe=groupe, systeme=True).update(date_envoi=depart)
            if passee:
                fermer_groupe(groupe)
                MessageGroupe.objects.filter(groupe=groupe, systeme=True, contenu__startswith="🔒").update(date_envoi=annonce.date_fin)
                groupe.date_fermeture = annonce.date_fin
                groupe.save(update_fields=["date_fermeture"])

    def _messages_prives(self):
        for cit_name, asso_name, lignes in MESSAGES_PRIVES:
            cit, asso = self.citoyens[cit_name].user, self.assos[asso_name].user
            for i, txt in enumerate(lignes):
                sender, receiver = (cit, asso) if i % 2 == 0 else (asso, cit)
                Message.objects.create(sender=sender, receiver=receiver, contenu=txt, lu=i < len(lignes) - 1)

    def _divers(self, admin):
        for asso in self.assos.values():
            if asso.statut_verification == AssociationProfile.StatutVerification.EN_ATTENTE:
                Notification.objects.create(destinataire=admin, titre="Nouvelle association à vérifier",
                                            message=f"{asso.nom} attend une vérification.", lien="/espace/admin")
        Signalement.objects.create(auteur=self.citoyens["lea.laurent"].user, annonce=self.annonces["Accompagnateurs course inclusive"],
                                   motif="Le lieu indiqué ne semble pas correct, à vérifier.")
