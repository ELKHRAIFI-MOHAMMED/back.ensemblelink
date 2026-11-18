import uuid

from django.contrib.auth.models import AbstractUser
from django.core.exceptions import ValidationError
from django.core.validators import MaxValueValidator, MinValueValidator
from django.db import models
from django.utils import timezone
from django.utils.translation import gettext_lazy as _

from .pays import CHOIX_PAYS


class User(AbstractUser):
    class UserType(models.TextChoices):
        ADMIN = "ADMIN", _("Admin")
        ASSOCIATION = "ASSOCIATION", _("Association")
        CITOYEN = "CITOYEN", _("Citoyen")

    type = models.CharField(max_length=20, choices=UserType.choices, default=UserType.CITOYEN)
    email = models.EmailField(_("email"), unique=True)

    @property
    def is_admin(self):
        return self.type == self.UserType.ADMIN or self.is_superuser

    @property
    def is_association(self):
        return self.type == self.UserType.ASSOCIATION

    @property
    def is_citoyen(self):
        return self.type == self.UserType.CITOYEN

    def __str__(self):
        return self.username


class Categorie(models.Model):
    nom = models.CharField(max_length=100, unique=True)
    icone = models.CharField(max_length=10, blank=True, help_text="Emoji affiché dans l'interface")
    couleur = models.CharField(max_length=7, default="#F26B3A", help_text="Couleur hexadécimale")

    class Meta:
        ordering = ["nom"]

    def __str__(self):
        return self.nom


class Competence(models.Model):
    nom = models.CharField(max_length=100, unique=True)

    class Meta:
        ordering = ["nom"]

    def __str__(self):
        return self.nom


class AssociationProfile(models.Model):
    class StatutVerification(models.TextChoices):
        EN_ATTENTE = "EN_ATTENTE", _("En attente de vérification")
        VERIFIEE = "VERIFIEE", _("Vérifiée")
        REJETEE = "REJETEE", _("Rejetée")

    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name="association_profile")
    nom = models.CharField(max_length=255)
    description = models.TextField(blank=True)
    contact = models.CharField(max_length=255, blank=True)
    telephone = models.CharField(max_length=30, blank=True)
    site_web = models.URLField(blank=True)
    ville = models.CharField(max_length=120, blank=True)
    pays = models.CharField(max_length=2, choices=CHOIX_PAYS, default="FR")
    adresse = models.CharField(max_length=255, blank=True)
    logo = models.ImageField(upload_to="logos/", blank=True, null=True)
    reseaux_sociaux = models.JSONField(blank=True, default=dict)
    statut_verification = models.CharField(
        max_length=20, choices=StatutVerification.choices, default=StatutVerification.EN_ATTENTE
    )
    motif_rejet = models.TextField(blank=True)
    document_justificatif = models.FileField(upload_to="justificatifs/", blank=True, null=True)
    date_creation = models.DateTimeField(default=timezone.now)

    @property
    def est_verifiee(self):
        return self.statut_verification == self.StatutVerification.VERIFIEE

    def __str__(self):
        return self.nom


class CitoyenProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name="citoyen_profile")
    prenom = models.CharField(max_length=100)
    nom = models.CharField(max_length=100)
    bio = models.TextField(blank=True)
    experiences = models.TextField(blank=True)
    ville = models.CharField(max_length=120, blank=True)
    pays = models.CharField(max_length=2, choices=CHOIX_PAYS, default="FR")
    photo = models.ImageField(upload_to="avatars/", blank=True, null=True)
    competences = models.ManyToManyField(Competence, blank=True, related_name="citoyens")
    centres_interet = models.ManyToManyField(Categorie, blank=True, related_name="citoyens_interesses")

    def __str__(self):
        return f"{self.prenom} {self.nom}"


class PhotoAlbum(models.Model):
    citoyen = models.ForeignKey(CitoyenProfile, on_delete=models.CASCADE, related_name="album")
    image = models.ImageField(upload_to="album_photos/")
    legende = models.CharField(max_length=255, blank=True)
    date_ajout = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-date_ajout"]


class Annonce(models.Model):
    class AnnonceType(models.TextChoices):
        EVENEMENT = "EVENEMENT", _("Évènement")
        DON = "DON", _("Don")
        APPEL_BENEVOLAT = "APPEL_BENEVOLAT", _("Appel au bénévolat")
        ACTIVITE = "ACTIVITE", _("Activité entre citoyens")

    titre = models.CharField(max_length=255)
    description = models.TextField()
    type = models.CharField(max_length=20, choices=AnnonceType.choices)
    # Organisateur : une association OU un citoyen (activités : foot, club de lecture, pique-nique…)
    association = models.ForeignKey(
        AssociationProfile, on_delete=models.CASCADE, related_name="annonces", verbose_name=_("Association"),
        null=True, blank=True,
    )
    createur = models.ForeignKey(
        CitoyenProfile, on_delete=models.CASCADE, related_name="activites_organisees",
        null=True, blank=True, verbose_name=_("Citoyen organisateur"),
    )
    categorie = models.ForeignKey(
        Categorie, on_delete=models.SET_NULL, null=True, blank=True, related_name="annonces",
        verbose_name=_("Catégorie"),
    )
    competences_requises = models.ManyToManyField(Competence, blank=True, related_name="annonces")

    # Lieu & géolocalisation
    lieu = models.CharField(max_length=255)
    ville = models.CharField(max_length=120, blank=True)
    pays = models.CharField(max_length=2, choices=CHOIX_PAYS, default="FR")
    fuseau_horaire = models.CharField(max_length=64, default="Europe/Paris")
    latitude = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)
    longitude = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)

    date_debut = models.DateTimeField()
    date_fin = models.DateTimeField()

    # Capacité (null = illimité)
    nombre_places = models.PositiveIntegerField(null=True, blank=True)
    inscription_automatique = models.BooleanField(
        default=False, help_text="Participants acceptés sans validation (dans la limite des places)"
    )

    # Spécifique aux annonces de type DON
    objectif_don = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True)
    unite_don = models.CharField(max_length=40, blank=True, help_text="ex : €, kg, couvertures, repas")

    image = models.ImageField(upload_to="annonces/", blank=True, null=True)
    est_active = models.BooleanField(default=True, help_text="L'association peut clôturer l'annonce")
    date_creation = models.DateTimeField(auto_now_add=True)

    class Meta:
        verbose_name = _("Annonce")
        verbose_name_plural = _("Annonces")
        ordering = ["-date_creation"]
        constraints = [
            models.CheckConstraint(
                condition=(
                    models.Q(association__isnull=False, createur__isnull=True)
                    | models.Q(association__isnull=True, createur__isnull=False)
                ),
                name="annonce_un_seul_organisateur",
            ),
        ]

    def clean(self):
        if self.date_debut and self.date_fin and self.date_fin <= self.date_debut:
            raise ValidationError({"date_fin": "La date de fin doit être postérieure à la date de début."})
        if (self.latitude is None) != (self.longitude is None):
            raise ValidationError("Latitude et longitude doivent être renseignées ensemble.")

    @property
    def organisateur_user(self):
        return self.association.user if self.association_id else self.createur.user

    @property
    def organisateur_nom(self):
        return self.association.nom if self.association_id else str(self.createur)

    @property
    def est_terminee(self):
        return self.date_fin < timezone.now()

    @property
    def places_prises(self):
        return self.candidatures.filter(statut=Candidature.Statut.ACCEPTEE).count()

    @property
    def places_restantes(self):
        if self.nombre_places is None:
            return None
        return max(self.nombre_places - self.places_prises, 0)

    @property
    def est_complete(self):
        restantes = self.places_restantes
        return restantes is not None and restantes == 0

    @property
    def quantite_collectee(self):
        total = self.candidatures.filter(
            statut=Candidature.Statut.ACCEPTEE, quantite_don__isnull=False
        ).aggregate(total=models.Sum("quantite_don"))["total"]
        return total or 0

    @property
    def duree_heures(self):
        return round((self.date_fin - self.date_debut).total_seconds() / 3600, 2)

    def __str__(self):
        return f"{self.titre} - {self.organisateur_nom}"


class Candidature(models.Model):
    class Statut(models.TextChoices):
        EN_ATTENTE = "EN_ATTENTE", _("En attente")
        ACCEPTEE = "ACCEPTEE", _("Acceptée")
        REFUSEE = "REFUSEE", _("Refusée")
        ANNULEE = "ANNULEE", _("Annulée")

    citoyen = models.ForeignKey(CitoyenProfile, on_delete=models.CASCADE, related_name="candidatures")
    annonce = models.ForeignKey(Annonce, on_delete=models.CASCADE, related_name="candidatures")
    statut = models.CharField(max_length=20, choices=Statut.choices, default=Statut.EN_ATTENTE)
    message = models.TextField(blank=True)
    date_candidature = models.DateTimeField(auto_now_add=True)
    date_reponse = models.DateTimeField(null=True, blank=True)

    # Suivi de l'engagement
    note_engagement = models.PositiveSmallIntegerField(
        null=True, blank=True, validators=[MinValueValidator(1), MaxValueValidator(5)]
    )
    code_presence = models.UUIDField(default=uuid.uuid4, unique=True, editable=False)
    presence_confirmee = models.BooleanField(default=False)
    heures_effectuees = models.DecimalField(max_digits=6, decimal_places=2, default=0)

    # Promesse de don (annonces DON)
    quantite_don = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True)

    class Meta:
        ordering = ["-date_candidature"]
        constraints = [
            models.UniqueConstraint(fields=["citoyen", "annonce"], name="candidature_unique_par_annonce"),
        ]

    def __str__(self):
        return f"Candidature de {self.citoyen} pour {self.annonce.titre}"


class Avis(models.Model):
    """Avis bidirectionnel : citoyen → association ou association → citoyen, après une mission."""

    auteur = models.ForeignKey(User, on_delete=models.CASCADE, related_name="avis_donnes")
    cible = models.ForeignKey(User, on_delete=models.CASCADE, related_name="avis_recus")
    annonce = models.ForeignKey(Annonce, on_delete=models.CASCADE, related_name="avis")
    note = models.PositiveSmallIntegerField(validators=[MinValueValidator(1), MaxValueValidator(5)])
    commentaire = models.TextField(blank=True)
    date_creation = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-date_creation"]
        verbose_name_plural = "Avis"
        constraints = [
            models.UniqueConstraint(fields=["auteur", "cible", "annonce"], name="avis_unique"),
        ]

    def __str__(self):
        return f"{self.auteur} → {self.cible} ({self.note}/5)"


class Notification(models.Model):
    destinataire = models.ForeignKey(User, on_delete=models.CASCADE, related_name="notifications")
    titre = models.CharField(max_length=255)
    message = models.TextField(blank=True)
    lien = models.CharField(max_length=255, blank=True)
    lue = models.BooleanField(default=False)
    date_creation = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-date_creation"]

    def __str__(self):
        return f"{self.destinataire} : {self.titre}"


class Signalement(models.Model):
    class Statut(models.TextChoices):
        OUVERT = "OUVERT", _("Ouvert")
        TRAITE = "TRAITE", _("Traité")
        REJETE = "REJETE", _("Rejeté")

    auteur = models.ForeignKey(User, on_delete=models.CASCADE, related_name="signalements_faits")
    annonce = models.ForeignKey(Annonce, on_delete=models.CASCADE, null=True, blank=True, related_name="signalements")
    utilisateur_signale = models.ForeignKey(
        User, on_delete=models.CASCADE, null=True, blank=True, related_name="signalements_recus"
    )
    motif = models.TextField()
    statut = models.CharField(max_length=10, choices=Statut.choices, default=Statut.OUVERT)
    date_creation = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-date_creation"]

    def clean(self):
        if not self.annonce and not self.utilisateur_signale:
            raise ValidationError("Un signalement doit viser une annonce ou un utilisateur.")


class Message(models.Model):
    sender = models.ForeignKey(User, on_delete=models.CASCADE, related_name="messages_sent")
    receiver = models.ForeignKey(User, on_delete=models.CASCADE, related_name="messages_received")
    contenu = models.TextField()
    date_envoi = models.DateTimeField(auto_now_add=True)
    lu = models.BooleanField(default=False)

    class Meta:
        ordering = ["date_envoi"]

    def __str__(self):
        return f"Message de {self.sender} à {self.receiver} le {self.date_envoi}"


class GroupeDiscussion(models.Model):
    """Groupe de chat lié à une annonce. Les participants acceptés y entrent automatiquement ;
    il se ferme automatiquement à la fin de l'activité."""

    annonce = models.OneToOneField(Annonce, on_delete=models.CASCADE, related_name="groupe")
    nom = models.CharField(max_length=255)
    ferme = models.BooleanField(default=False)
    date_fermeture = models.DateTimeField(null=True, blank=True)
    date_creation = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-date_creation"]

    @property
    def est_ferme(self):
        return self.ferme or self.annonce.date_fin < timezone.now()

    def __str__(self):
        return self.nom


class MembreGroupe(models.Model):
    class Role(models.TextChoices):
        ORGANISATEUR = "ORGANISATEUR", _("Organisateur")
        MEMBRE = "MEMBRE", _("Membre")

    groupe = models.ForeignKey(GroupeDiscussion, on_delete=models.CASCADE, related_name="membres")
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="groupes")
    role = models.CharField(max_length=15, choices=Role.choices, default=Role.MEMBRE)
    date_ajout = models.DateTimeField(auto_now_add=True)
    dernier_lu = models.DateTimeField(null=True, blank=True)

    class Meta:
        constraints = [models.UniqueConstraint(fields=["groupe", "user"], name="membre_groupe_unique")]


class MessageGroupe(models.Model):
    groupe = models.ForeignKey(GroupeDiscussion, on_delete=models.CASCADE, related_name="messages")
    auteur = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True, related_name="messages_groupe")
    contenu = models.TextField()
    systeme = models.BooleanField(default=False, help_text="Message automatique (arrivée, départ, fermeture)")
    date_envoi = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["date_envoi"]
