"""
Données de démonstration SolidarLink.

    python manage.py seed_demo            # remplit une base vide
    python manage.py seed_demo --reset    # vide les données de l'app puis remplit

Tous les comptes de démo utilisent le mot de passe : Demo1234!
"""

import random
from datetime import timedelta
from decimal import Decimal

from django.core.management.base import BaseCommand, CommandError
from django.db import transaction
from django.utils import timezone

from login_app.models import (
    Annonce, AssociationProfile, Avis, Candidature, Categorie, CitoyenProfile, Competence, Message,
    Notification, Signalement, User,
)

MOT_DE_PASSE = "Demo1234!"

VILLES = {
    "Paris": (48.8566, 2.3522),
    "Lyon": (45.7640, 4.8357),
    "Marseille": (43.2965, 5.3698),
    "Nantes": (47.2184, -1.5536),
    "Bordeaux": (44.8378, -0.5792),
    "Toulouse": (43.6047, 1.4442),
    "Lille": (50.6292, 3.0573),
}

CATEGORIES = [
    ("Solidarité alimentaire", "🥕", "#F26B3A"),
    ("Environnement", "🌿", "#2E9E6A"),
    ("Éducation", "📚", "#3D6FD8"),
    ("Animaux", "🐾", "#B5651D"),
    ("Seniors", "🫶", "#C2477A"),
    ("Sport & handicap", "⚽", "#0E9AA7"),
    ("Santé", "🩺", "#D64545"),
    ("Culture", "🎨", "#8A5CF6"),
    ("Logement", "🏠", "#6B7B3A"),
]

COMPETENCES = [
    "Cuisine", "Logistique", "Animation", "Soutien scolaire", "Informatique", "Communication",
    "Bricolage", "Permis B", "Langues étrangères", "Premiers secours", "Jardinage", "Photographie",
]

ASSOCIATIONS = [
    # username, nom, ville, catégorie principale, statut, description
    ("panier_solidaire", "Le Panier Solidaire", "Lyon", "Solidarité alimentaire", "VERIFIEE",
     "Épicerie solidaire et distributions de repas pour les familles en difficulté du 7e arrondissement."),
    ("vert_demain", "Vert Demain", "Nantes", "Environnement", "VERIFIEE",
     "Nettoyage des berges, jardins partagés et ateliers zéro déchet le long de la Loire."),
    ("lire_ensemble", "Lire Ensemble", "Paris", "Éducation", "VERIFIEE",
     "Soutien scolaire gratuit et ateliers lecture pour les enfants de 6 à 15 ans."),
    ("pattes_coeurs", "Pattes & Cœurs", "Marseille", "Animaux", "VERIFIEE",
     "Refuge associatif : soins, promenades et adoptions responsables de chiens et chats."),
    ("aines_connectes", "Les Aînés Connectés", "Bordeaux", "Seniors", "VERIFIEE",
     "Lutte contre l'isolement des personnes âgées : visites, appels et initiation au numérique."),
    ("sport_pour_tous", "Sport Pour Tous 31", "Toulouse", "Sport & handicap", "VERIFIEE",
     "Rendre le sport accessible à tous, en particulier aux personnes en situation de handicap."),
    ("toit_dabord", "Toit d'Abord", "Lille", "Logement", "EN_ATTENTE",
     "Maraudes et accompagnement vers le logement des personnes sans-abri."),
    ("recup_art", "Collectif Récup'Art", "Paris", "Culture", "EN_ATTENTE",
     "Ateliers artistiques à partir de matériaux recyclés, ouverts à tous les quartiers."),
]

CITOYENS = [
    ("emma.martin", "Emma", "Martin", "Lyon", ["Cuisine", "Logistique"], ["Solidarité alimentaire", "Seniors"]),
    ("lucas.bernard", "Lucas", "Bernard", "Paris", ["Soutien scolaire", "Informatique"], ["Éducation", "Culture"]),
    ("ines.haddad", "Inès", "Haddad", "Marseille", ["Premiers secours", "Communication"], ["Animaux", "Santé"]),
    ("hugo.petit", "Hugo", "Petit", "Nantes", ["Jardinage", "Bricolage"], ["Environnement"]),
    ("chloe.dubois", "Chloé", "Dubois", "Bordeaux", ["Animation", "Informatique"], ["Seniors", "Éducation"]),
    ("yanis.moreau", "Yanis", "Moreau", "Toulouse", ["Animation", "Premiers secours"], ["Sport & handicap"]),
    ("lea.laurent", "Léa", "Laurent", "Paris", ["Photographie", "Communication"], ["Culture", "Environnement"]),
    ("adam.benali", "Adam", "Benali", "Lyon", ["Permis B", "Logistique"], ["Solidarité alimentaire", "Logement"]),
    ("manon.girard", "Manon", "Girard", "Lille", ["Langues étrangères", "Soutien scolaire"], ["Éducation", "Logement"]),
    ("nathan.roux", "Nathan", "Roux", "Nantes", ["Bricolage", "Permis B"], ["Environnement", "Sport & handicap"]),
]

# (asso, titre, type, catégorie, jours depuis aujourd'hui, durée h, places, compétences, objectif_don, unité, description)
ANNONCES = [
    # --- missions passées (pour heures, avis et attestations)
    ("panier_solidaire", "Distribution de colis alimentaires", "APPEL_BENEVOLAT", "Solidarité alimentaire", -21, 4, 8,
     ["Logistique"], None, "", "Préparation et distribution de 200 colis pour les familles inscrites."),
    ("vert_demain", "Grand nettoyage des berges de la Loire", "EVENEMENT", "Environnement", -14, 3, 30,
     ["Jardinage"], None, "", "Matinée de ramassage des déchets, gants et sacs fournis. Pique-nique offert !"),
    ("lire_ensemble", "Stage de révisions du brevet", "APPEL_BENEVOLAT", "Éducation", -10, 6, 5,
     ["Soutien scolaire"], None, "", "Accompagner des collégiens de 3e en maths et français pendant une journée."),
    ("aines_connectes", "Après-midi jeux en EHPAD", "EVENEMENT", "Seniors", -7, 3, 6,
     ["Animation"], None, "", "Belote, scrabble et goûter partagé avec les résidents de la résidence Les Tilleuls."),
    ("sport_pour_tous", "Tournoi de basket fauteuil", "EVENEMENT", "Sport & handicap", -5, 5, 12,
     ["Animation", "Premiers secours"], None, "", "Accueil du public, arbitrage de table et buvette."),
    # --- missions à venir
    ("panier_solidaire", "Cuisine solidaire du samedi", "APPEL_BENEVOLAT", "Solidarité alimentaire", 4, 4, 6,
     ["Cuisine"], None, "", "Préparer 150 repas chauds avec notre cheffe bénévole. Tablier fourni."),
    ("panier_solidaire", "Collecte de denrées pour l'hiver", "DON", "Solidarité alimentaire", 2, 72, None,
     [], Decimal("500"), "kg", "Pâtes, riz, conserves, produits d'hygiène : chaque kilo compte."),
    ("vert_demain", "Plantation d'une forêt urbaine", "EVENEMENT", "Environnement", 11, 5, 40,
     ["Jardinage"], None, "", "Plantation de 600 arbres selon la méthode Miyawaki à Rezé."),
    ("vert_demain", "Atelier réparation de vélos", "APPEL_BENEVOLAT", "Environnement", 6, 3, 4,
     ["Bricolage"], None, "", "Aider les habitants à réparer eux-mêmes leur vélo. Outils fournis."),
    ("lire_ensemble", "Aide aux devoirs hebdomadaire", "APPEL_BENEVOLAT", "Éducation", 3, 2, 10,
     ["Soutien scolaire"], None, "", "Tous les mardis de 17h à 19h, niveau primaire et collège."),
    ("lire_ensemble", "Dons de livres jeunesse", "DON", "Éducation", 1, 240, None,
     [], Decimal("300"), "livres", "Albums, romans jeunesse et BD en bon état pour notre bibliothèque."),
    ("lire_ensemble", "Atelier initiation au code pour ados", "APPEL_BENEVOLAT", "Éducation", 16, 3, 3,
     ["Informatique"], None, "", "Animer un atelier Scratch / Python pour 12 adolescents."),
    ("pattes_coeurs", "Promenade des chiens du refuge", "APPEL_BENEVOLAT", "Animaux", 2, 2, 8,
     [], None, "", "Sortir nos pensionnaires pour une balade au parc Borély."),
    ("pattes_coeurs", "Collecte de couvertures et croquettes", "DON", "Animaux", 1, 336, None,
     [], Decimal("120"), "couvertures", "L'hiver arrive : couvertures, paniers et croquettes sont les bienvenus."),
    ("pattes_coeurs", "Journée portes ouvertes adoption", "EVENEMENT", "Animaux", 19, 6, 10,
     ["Communication", "Photographie"], None, "", "Accueil des visiteurs, photos des animaux et stand d'information."),
    ("aines_connectes", "Initiation tablette pour seniors", "APPEL_BENEVOLAT", "Seniors", 8, 2, 4,
     ["Informatique"], None, "", "Apprendre aux aînés à appeler leurs proches en visio."),
    ("aines_connectes", "Repas de Noël partagé", "EVENEMENT", "Seniors", 36, 4, 15,
     ["Cuisine", "Animation"], None, "", "Préparer et partager un repas festif avec 60 personnes âgées isolées."),
    ("sport_pour_tous", "Accompagnateurs course inclusive", "APPEL_BENEVOLAT", "Sport & handicap", 13, 4, 20,
     ["Premiers secours"], None, "", "Guider des coureurs malvoyants sur le parcours de 5 km."),
    ("sport_pour_tous", "Collecte d'équipements sportifs", "DON", "Sport & handicap", 3, 480, None,
     [], Decimal("80"), "équipements", "Ballons, raquettes, chaussures en bon état."),
    ("sport_pour_tous", "Animation multisport en IME", "APPEL_BENEVOLAT", "Sport & handicap", 9, 3, 2,
     ["Animation"], None, "", "Encadrer un après-midi multisport avec des jeunes de l'institut médico-éducatif."),
]

MESSAGES = [
    ("emma.martin", "panier_solidaire", [
        "Bonjour ! Faut-il apporter quelque chose pour la cuisine solidaire ?",
        "Bonjour Emma, juste de bonnes chaussures fermées, on fournit le reste 🙂",
        "Parfait, à samedi !",
    ]),
    ("lucas.bernard", "lire_ensemble", [
        "Je peux aussi aider pour l'atelier code si besoin.",
        "Super, on vous ajoute à la liste. Merci Lucas !",
    ]),
    ("ines.haddad", "pattes_coeurs", [
        "Est-ce que je peux venir avec ma sœur pour la promenade ?",
    ]),
]


class Command(BaseCommand):
    help = "Insère des données de démonstration (comptes, annonces, candidatures, avis, messages)."

    def add_arguments(self, parser):
        parser.add_argument("--reset", action="store_true", help="Supprime les données existantes avant l'insertion.")

    @transaction.atomic
    def handle(self, *args, **options):
        random.seed(42)
        if options["reset"]:
            self._reset()
        elif User.objects.filter(username="admin").exists():
            raise CommandError("Les données de démo existent déjà. Utilisez --reset pour les recréer.")

        now = timezone.now().replace(minute=0, second=0, microsecond=0)

        admin = User.objects.create_superuser("admin", "admin@solidarlink.local", MOT_DE_PASSE, type=User.UserType.ADMIN)

        cats = {nom: Categorie.objects.create(nom=nom, icone=ic, couleur=col) for nom, ic, col in CATEGORIES}
        comps = {nom: Competence.objects.create(nom=nom) for nom in COMPETENCES}

        assos = {}
        for username, nom, ville, cat, statut, desc in ASSOCIATIONS:
            u = User.objects.create_user(username, f"{username}@asso.solidarlink.local", MOT_DE_PASSE, type=User.UserType.ASSOCIATION)
            assos[username] = AssociationProfile.objects.create(
                user=u, nom=nom, ville=ville, description=desc, statut_verification=statut,
                contact=f"contact@{username.replace('_', '')}.org", telephone="01 23 45 67 89",
                site_web=f"https://{username.replace('_', '-')}.example.org",
                adresse=f"12 rue de la Solidarité, {ville}",
                reseaux_sociaux={"instagram": f"https://instagram.com/{username}"},
                date_creation=now - timedelta(days=random.randint(30, 400)),
            )

        citoyens = {}
        for username, prenom, nom, ville, cmp, interets in CITOYENS:
            u = User.objects.create_user(username, f"{username}@mail.solidarlink.local", MOT_DE_PASSE,
                                         type=User.UserType.CITOYEN, first_name=prenom, last_name=nom)
            c = CitoyenProfile.objects.create(
                user=u, prenom=prenom, nom=nom, ville=ville,
                bio=f"{prenom}, bénévole à {ville}. J'aime me rendre utile près de chez moi.",
                experiences="Bénévolat associatif depuis 2 ans.",
            )
            c.competences.set([comps[x] for x in cmp])
            c.centres_interet.set([cats[x] for x in interets])
            citoyens[username] = c

        annonces = []
        for (asso, titre, type_, cat, jours, duree, places, cmp, objectif, unite, desc) in ANNONCES:
            a = assos[asso]
            lat, lng = VILLES[a.ville]
            debut = (now + timedelta(days=jours)).replace(hour=9 if duree < 24 else 8)
            annonce = Annonce.objects.create(
                association=a, titre=titre, type=type_, categorie=cats[cat], description=desc,
                lieu=f"{random.choice(['Maison des associations', 'Salle municipale', 'Parc', 'Local associatif'])} — {a.ville}",
                ville=a.ville,
                latitude=Decimal(str(round(lat + random.uniform(-0.03, 0.03), 6))),
                longitude=Decimal(str(round(lng + random.uniform(-0.04, 0.04), 6))),
                date_debut=debut, date_fin=debut + timedelta(hours=duree), nombre_places=places,
                objectif_don=objectif, unite_don=unite,
            )
            annonce.competences_requises.set([comps[x] for x in cmp])
            annonces.append(annonce)

        self._candidatures(annonces, citoyens, now)
        self._avis(annonces)
        self._messages(citoyens, assos)
        self._divers(admin, citoyens, assos, annonces)

        self.stdout.write(self.style.SUCCESS(
            f"Démo prête : {User.objects.count()} comptes, {Annonce.objects.count()} annonces, "
            f"{Candidature.objects.count()} candidatures, {Avis.objects.count()} avis. Mot de passe : {MOT_DE_PASSE}"
        ))

    # ------------------------------------------------------------------
    def _reset(self):
        for model in (Message, Notification, Signalement, Avis, Candidature, Annonce, CitoyenProfile,
                      AssociationProfile, Competence, Categorie):
            model.objects.all().delete()
        User.objects.all().delete()
        self.stdout.write("Données existantes supprimées.")

    def _candidatures(self, annonces, citoyens, now):
        tous = list(citoyens.values())
        for annonce in annonces:
            passee = annonce.date_fin < now
            # Bénévoles de la même ville en priorité
            locaux = [c for c in tous if c.ville == annonce.ville]
            autres = [c for c in tous if c.ville != annonce.ville]
            nb = min(len(locaux) + 2, (annonce.nombre_places or 4) + 1)
            candidats = (locaux + random.sample(autres, 2))[:nb]
            for i, cit in enumerate(candidats):
                if passee:
                    statut = Candidature.Statut.ACCEPTEE if i < max(len(candidats) - 1, 1) else Candidature.Statut.REFUSEE
                elif annonce.type == Annonce.AnnonceType.DON:
                    statut = Candidature.Statut.ACCEPTEE
                else:
                    statut = random.choice([Candidature.Statut.EN_ATTENTE, Candidature.Statut.EN_ATTENTE, Candidature.Statut.ACCEPTEE])
                if annonce.nombre_places and statut == Candidature.Statut.ACCEPTEE and annonce.places_prises >= annonce.nombre_places:
                    statut = Candidature.Statut.EN_ATTENTE
                cand = Candidature(
                    citoyen=cit, annonce=annonce, statut=statut,
                    message=random.choice([
                        "Bonjour, je suis disponible et motivé·e !",
                        "J'ai déjà participé à ce type de mission, je serais ravi·e d'aider.",
                        "Disponible toute la journée, n'hésitez pas à me contacter.",
                    ]),
                )
                if statut != Candidature.Statut.EN_ATTENTE:
                    cand.date_reponse = annonce.date_debut - timedelta(days=2)
                if annonce.type == Annonce.AnnonceType.DON:
                    cand.quantite_don = Decimal(random.choice([5, 10, 15, 20, 30]))
                if passee and statut == Candidature.Statut.ACCEPTEE:
                    cand.presence_confirmee = True
                    cand.heures_effectuees = Decimal(str(annonce.duree_heures))
                    cand.note_engagement = random.choice([4, 5, 5])
                cand.save()

    def _avis(self, annonces):
        commentaires_asso = ["Bénévole ponctuel·le et très investi·e, merci !", "Super énergie, à refaire !", "Très fiable, un vrai plaisir."]
        commentaires_cit = ["Équipe accueillante et mission bien organisée.", "Belle expérience, je recommande !", "Très bon encadrement, j'y retourne."]
        for annonce in annonces:
            if not annonce.est_terminee:
                continue
            asso_user = annonce.association.user
            for cand in annonce.candidatures.filter(statut=Candidature.Statut.ACCEPTEE):
                Avis.objects.create(auteur=asso_user, cible=cand.citoyen.user, annonce=annonce,
                                    note=random.choice([4, 5, 5]), commentaire=random.choice(commentaires_asso))
                if random.random() < 0.7:
                    Avis.objects.create(auteur=cand.citoyen.user, cible=asso_user, annonce=annonce,
                                        note=random.choice([4, 5, 5, 5]), commentaire=random.choice(commentaires_cit))

    def _messages(self, citoyens, assos):
        for cit_name, asso_name, lignes in MESSAGES:
            cit, asso = citoyens[cit_name].user, assos[asso_name].user
            for i, txt in enumerate(lignes):
                sender, receiver = (cit, asso) if i % 2 == 0 else (asso, cit)
                Message.objects.create(sender=sender, receiver=receiver, contenu=txt, lu=i < len(lignes) - 1)

    def _divers(self, admin, citoyens, assos, annonces):
        for asso in assos.values():
            if asso.statut_verification == AssociationProfile.StatutVerification.EN_ATTENTE:
                Notification.objects.create(destinataire=admin, titre="Nouvelle association à vérifier",
                                            message=f"{asso.nom} attend une vérification.", lien="/espace/admin")
        emma = citoyens["emma.martin"].user
        Notification.objects.create(destinataire=emma, titre="Candidature acceptée 🎉",
                                    message="Votre candidature pour « Cuisine solidaire du samedi » a été examinée.", lien="/espace")
        Notification.objects.create(destinataire=emma, titre="Nouvelle mission près de chez vous",
                                    message="« Collecte de denrées pour l'hiver » à Lyon.", lien="/missions")
        Signalement.objects.create(auteur=citoyens["lea.laurent"].user, annonce=annonces[-1],
                                   motif="Le lieu indiqué ne semble pas correct, à vérifier.")
