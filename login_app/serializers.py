from django.contrib.auth import get_user_model
from django.contrib.auth.password_validation import validate_password
from django.utils import timezone
from rest_framework import serializers

from .models import (
    Annonce,
    AssociationProfile,
    Avis,
    Candidature,
    Categorie,
    CitoyenProfile,
    Competence,
    Message,
    Notification,
    PhotoAlbum,
    Signalement,
)

User = get_user_model()


# ============================================================== utilisateurs

class UserSignUpSerializer(serializers.ModelSerializer):
    """Inscription. Correctif sécurité : le type ADMIN ne peut plus être choisi."""

    password = serializers.CharField(write_only=True, style={"input_type": "password"})
    type = serializers.ChoiceField(choices=[User.UserType.CITOYEN, User.UserType.ASSOCIATION])

    class Meta:
        model = User
        fields = ("id", "username", "email", "password", "type")

    def validate_email(self, value):
        if User.objects.filter(email__iexact=value).exists():
            raise serializers.ValidationError("Un compte existe déjà avec cet email.")
        return value.lower()

    def validate(self, attrs):
        validate_password(attrs["password"], user=User(username=attrs.get("username"), email=attrs.get("email")))
        return attrs

    def create(self, validated_data):
        return User.objects.create_user(**validated_data)


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ("id", "username", "email", "type", "is_active", "date_joined", "last_login")
        read_only_fields = fields


class UserMiniSerializer(serializers.ModelSerializer):
    """Représentation publique minimale (pas d'email)."""

    nom_affiche = serializers.SerializerMethodField()
    avatar = serializers.SerializerMethodField()
    profil_id = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = ("id", "username", "type", "nom_affiche", "avatar", "profil_id")

    def get_nom_affiche(self, obj):
        if hasattr(obj, "association_profile"):
            return obj.association_profile.nom
        if hasattr(obj, "citoyen_profile"):
            return f"{obj.citoyen_profile.prenom} {obj.citoyen_profile.nom}"
        return obj.username

    def _url(self, field):
        if not field:
            return None
        request = self.context.get("request")
        return request.build_absolute_uri(field.url) if request else field.url

    def get_avatar(self, obj):
        if hasattr(obj, "association_profile"):
            return self._url(obj.association_profile.logo)
        if hasattr(obj, "citoyen_profile"):
            return self._url(obj.citoyen_profile.photo)
        return None

    def get_profil_id(self, obj):
        if hasattr(obj, "association_profile"):
            return obj.association_profile.id
        if hasattr(obj, "citoyen_profile"):
            return obj.citoyen_profile.id
        return None


# ============================================================== référentiels

class CategorieSerializer(serializers.ModelSerializer):
    nombre_annonces = serializers.IntegerField(read_only=True, required=False)

    class Meta:
        model = Categorie
        fields = ("id", "nom", "icone", "couleur", "nombre_annonces")


class CompetenceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Competence
        fields = ("id", "nom")


# ============================================================== profils

class AssociationMiniSerializer(serializers.ModelSerializer):
    class Meta:
        model = AssociationProfile
        fields = ("id", "user", "nom", "logo", "ville", "statut_verification")


class AssociationProfileSerializer(serializers.ModelSerializer):
    reseaux_sociaux = serializers.JSONField(binary=True, required=False)
    note_moyenne = serializers.FloatField(read_only=True, required=False)
    nombre_avis = serializers.IntegerField(read_only=True, required=False)
    nombre_annonces = serializers.IntegerField(read_only=True, required=False)

    class Meta:
        model = AssociationProfile
        fields = (
            "id", "user", "nom", "description", "contact", "telephone", "site_web", "ville", "adresse",
            "logo", "reseaux_sociaux", "statut_verification", "motif_rejet", "document_justificatif",
            "date_creation", "note_moyenne", "nombre_avis", "nombre_annonces",
        )
        read_only_fields = ("id", "user", "statut_verification", "motif_rejet", "date_creation")
        extra_kwargs = {"document_justificatif": {"write_only": True}}

    def validate_logo(self, value):
        return _valider_image(value)

    def validate_reseaux_sociaux(self, value):
        if value in (None, ""):
            return {}
        if not isinstance(value, dict):
            raise serializers.ValidationError("Format attendu : objet {\"facebook\": \"url\", ...}.")
        return value


class AssociationAdminSerializer(AssociationProfileSerializer):
    """Vue admin : expose le justificatif et l'email du compte."""

    email = serializers.EmailField(source="user.email", read_only=True)
    compte_actif = serializers.BooleanField(source="user.is_active", read_only=True)

    class Meta(AssociationProfileSerializer.Meta):
        fields = AssociationProfileSerializer.Meta.fields + ("email", "compte_actif")
        extra_kwargs = {}


class PhotoAlbumSerializer(serializers.ModelSerializer):
    class Meta:
        model = PhotoAlbum
        fields = ("id", "image", "legende", "date_ajout")
        read_only_fields = ("id", "date_ajout")

    def validate_image(self, value):
        return _valider_image(value)


class CitoyenProfileSerializer(serializers.ModelSerializer):
    competences = serializers.PrimaryKeyRelatedField(many=True, queryset=Competence.objects.all(), required=False)
    centres_interet = serializers.PrimaryKeyRelatedField(
        many=True, queryset=Categorie.objects.all(), required=False
    )
    competences_detail = CompetenceSerializer(source="competences", many=True, read_only=True)
    centres_interet_detail = CategorieSerializer(source="centres_interet", many=True, read_only=True)
    album = PhotoAlbumSerializer(many=True, read_only=True)

    class Meta:
        model = CitoyenProfile
        fields = (
            "id", "user", "prenom", "nom", "bio", "experiences", "ville", "photo",
            "competences", "centres_interet", "competences_detail", "centres_interet_detail", "album",
        )
        read_only_fields = ("id", "user")

    def validate_photo(self, value):
        return _valider_image(value)


# ============================================================== annonces

class AnnonceSerializer(serializers.ModelSerializer):
    association = AssociationMiniSerializer(read_only=True)
    categorie_detail = CategorieSerializer(source="categorie", read_only=True)
    competences_requises = serializers.PrimaryKeyRelatedField(
        many=True, queryset=Competence.objects.all(), required=False
    )
    competences_detail = CompetenceSerializer(source="competences_requises", many=True, read_only=True)

    places_prises = serializers.SerializerMethodField()
    places_restantes = serializers.SerializerMethodField()
    est_complete = serializers.SerializerMethodField()
    est_terminee = serializers.BooleanField(read_only=True)
    quantite_collectee = serializers.SerializerMethodField()
    duree_heures = serializers.FloatField(read_only=True)
    ma_candidature = serializers.SerializerMethodField()

    class Meta:
        model = Annonce
        fields = (
            "id", "titre", "description", "type", "association", "categorie", "categorie_detail",
            "competences_requises", "competences_detail", "lieu", "ville", "latitude", "longitude",
            "date_debut", "date_fin", "nombre_places", "objectif_don", "unite_don", "image", "est_active",
            "date_creation", "places_prises", "places_restantes", "est_complete", "est_terminee",
            "quantite_collectee", "duree_heures", "ma_candidature",
        )
        read_only_fields = ("id", "association", "date_creation")

    # Les valeurs sont annotées dans le queryset (évite le N+1) avec repli sur la propriété du modèle.
    def get_places_prises(self, obj):
        return getattr(obj, "nb_acceptees", None) if hasattr(obj, "nb_acceptees") else obj.places_prises

    def get_places_restantes(self, obj):
        if obj.nombre_places is None:
            return None
        return max(obj.nombre_places - self.get_places_prises(obj), 0)

    def get_est_complete(self, obj):
        restantes = self.get_places_restantes(obj)
        return restantes is not None and restantes == 0

    def get_quantite_collectee(self, obj):
        val = getattr(obj, "total_dons", None) if hasattr(obj, "total_dons") else obj.quantite_collectee
        return float(val or 0)

    def get_ma_candidature(self, obj):
        """Statut de la candidature de l'utilisateur connecté (citoyen), sinon None."""
        request = self.context.get("request")
        user = getattr(request, "user", None)
        if not user or not user.is_authenticated or not hasattr(user, "citoyen_profile"):
            return None
        cand = obj.candidatures.filter(citoyen=user.citoyen_profile).only("id", "statut").first()
        return {"id": cand.id, "statut": cand.statut} if cand else None

    def validate_image(self, value):
        return _valider_image(value)

    def validate(self, attrs):
        inst = self.instance
        debut = attrs.get("date_debut", inst.date_debut if inst else None)
        fin = attrs.get("date_fin", inst.date_fin if inst else None)
        if debut and fin and fin <= debut:
            raise serializers.ValidationError({"date_fin": "La date de fin doit être postérieure à la date de début."})
        if inst is None and fin and fin < timezone.now():
            raise serializers.ValidationError({"date_fin": "Impossible de publier une annonce déjà terminée."})

        lat = attrs.get("latitude", inst.latitude if inst else None)
        lng = attrs.get("longitude", inst.longitude if inst else None)
        if (lat is None) != (lng is None):
            raise serializers.ValidationError("Latitude et longitude doivent être renseignées ensemble.")

        type_ = attrs.get("type", inst.type if inst else None)
        if type_ != Annonce.AnnonceType.DON and attrs.get("objectif_don"):
            raise serializers.ValidationError({"objectif_don": "Réservé aux annonces de type DON."})

        if inst is not None and "nombre_places" in attrs and attrs["nombre_places"] is not None:
            if attrs["nombre_places"] < inst.places_prises:
                raise serializers.ValidationError(
                    {"nombre_places": f"Déjà {inst.places_prises} bénévoles acceptés : impossible de réduire en dessous."}
                )
        return attrs

    def create(self, validated_data):
        competences = validated_data.pop("competences_requises", [])
        annonce = Annonce.objects.create(association=self.context["request"].user.association_profile, **validated_data)
        annonce.competences_requises.set(competences)
        return annonce


# ============================================================== candidatures

class CitoyenMiniSerializer(serializers.ModelSerializer):
    class Meta:
        model = CitoyenProfile
        fields = ("id", "user", "prenom", "nom", "ville", "photo")


class AnnonceMiniSerializer(serializers.ModelSerializer):
    association = AssociationMiniSerializer(read_only=True)

    class Meta:
        model = Annonce
        fields = ("id", "titre", "type", "lieu", "ville", "date_debut", "date_fin", "association", "unite_don")


class CandidatureSerializer(serializers.ModelSerializer):
    """Création par un citoyen + lecture. Les champs de suivi sont en lecture seule."""

    annonce = serializers.PrimaryKeyRelatedField(queryset=Annonce.objects.select_related("association"))
    annonce_detail = AnnonceMiniSerializer(source="annonce", read_only=True)
    citoyen = CitoyenMiniSerializer(read_only=True)
    code_presence = serializers.SerializerMethodField()
    peut_attestation = serializers.SerializerMethodField()

    class Meta:
        model = Candidature
        fields = (
            "id", "annonce", "annonce_detail", "citoyen", "statut", "message", "date_candidature",
            "date_reponse", "note_engagement", "presence_confirmee", "heures_effectuees", "quantite_don",
            "code_presence", "peut_attestation",
        )
        read_only_fields = (
            "id", "citoyen", "statut", "date_candidature", "date_reponse", "note_engagement",
            "presence_confirmee", "heures_effectuees",
        )

    def get_code_presence(self, obj):
        # Seul le citoyen voit son code (sinon l'association pourrait pointer sans scanner).
        request = self.context.get("request")
        if request and obj.citoyen.user_id == request.user.id and obj.statut == Candidature.Statut.ACCEPTEE:
            return str(obj.code_presence)
        return None

    def get_peut_attestation(self, obj):
        return obj.statut == Candidature.Statut.ACCEPTEE and obj.presence_confirmee

    def validate_quantite_don(self, value):
        if value is not None and value <= 0:
            raise serializers.ValidationError("La quantité doit être positive.")
        return value

    def validate(self, attrs):
        if self.instance is not None:
            if self.instance.statut != Candidature.Statut.EN_ATTENTE:
                raise serializers.ValidationError("Seule une candidature en attente peut être modifiée.")
            attrs.pop("annonce", None)  # l'annonce liée ne peut pas changer
            return attrs

        annonce = attrs["annonce"]
        citoyen = self.context["request"].user.citoyen_profile
        if not annonce.est_active:
            raise serializers.ValidationError("Cette annonce est clôturée.")
        if annonce.est_terminee:
            raise serializers.ValidationError("Cette annonce est terminée.")
        if annonce.est_complete:
            raise serializers.ValidationError("Il n'y a plus de place disponible pour cette annonce.")
        if Candidature.objects.filter(citoyen=citoyen, annonce=annonce).exists():
            raise serializers.ValidationError("Vous avez déjà postulé à cette annonce.")
        if attrs.get("quantite_don") and annonce.type != Annonce.AnnonceType.DON:
            raise serializers.ValidationError({"quantite_don": "Réservé aux annonces de type DON."})
        return attrs

    def create(self, validated_data):
        return Candidature.objects.create(citoyen=self.context["request"].user.citoyen_profile, **validated_data)


class CandidatureGestionSerializer(serializers.ModelSerializer):
    """Mise à jour par l'association propriétaire de l'annonce."""

    statut = serializers.ChoiceField(
        choices=[Candidature.Statut.ACCEPTEE, Candidature.Statut.REFUSEE], required=False
    )

    class Meta:
        model = Candidature
        fields = ("statut", "note_engagement", "presence_confirmee", "heures_effectuees")

    def validate_heures_effectuees(self, value):
        if value < 0 or value > 1000:
            raise serializers.ValidationError("Nombre d'heures invalide.")
        return value

    def validate(self, attrs):
        cand = self.instance
        nouveau_statut = attrs.get("statut", cand.statut)
        if cand.statut == Candidature.Statut.ANNULEE:
            raise serializers.ValidationError("Cette candidature a été annulée par le citoyen.")
        if (
            attrs.get("statut") == Candidature.Statut.ACCEPTEE
            and cand.statut != Candidature.Statut.ACCEPTEE
            and cand.annonce.est_complete
        ):
            raise serializers.ValidationError("L'annonce est complète : impossible d'accepter un bénévole de plus.")
        suivi = {"note_engagement", "presence_confirmee", "heures_effectuees"} & set(attrs)
        if suivi and nouveau_statut != Candidature.Statut.ACCEPTEE:
            raise serializers.ValidationError("Le suivi (présence, heures, note) n'est possible que pour un bénévole accepté.")
        return attrs


# ============================================================== avis, notifications, signalements

class AvisSerializer(serializers.ModelSerializer):
    auteur = UserMiniSerializer(read_only=True)
    cible_detail = UserMiniSerializer(source="cible", read_only=True)
    annonce_titre = serializers.CharField(source="annonce.titre", read_only=True)

    class Meta:
        model = Avis
        fields = ("id", "auteur", "cible", "cible_detail", "annonce", "annonce_titre", "note", "commentaire", "date_creation")
        read_only_fields = ("id", "auteur", "date_creation")

    def validate(self, attrs):
        auteur = self.context["request"].user
        cible, annonce = attrs["cible"], attrs["annonce"]
        if cible == auteur:
            raise serializers.ValidationError("Vous ne pouvez pas vous évaluer vous-même.")
        if not annonce.est_terminee:
            raise serializers.ValidationError("Un avis ne peut être laissé qu'après la fin de la mission.")

        acceptee = Candidature.Statut.ACCEPTEE
        if auteur.type == "CITOYEN":
            ok = (
                hasattr(auteur, "citoyen_profile")
                and annonce.association.user_id == cible.id
                and annonce.candidatures.filter(citoyen=auteur.citoyen_profile, statut=acceptee).exists()
            )
        elif auteur.type == "ASSOCIATION":
            ok = (
                annonce.association.user_id == auteur.id
                and hasattr(cible, "citoyen_profile")
                and annonce.candidatures.filter(citoyen=cible.citoyen_profile, statut=acceptee).exists()
            )
        else:
            ok = False
        if not ok:
            raise serializers.ValidationError("Vous n'avez pas participé à cette mission avec cette personne.")
        if Avis.objects.filter(auteur=auteur, cible=cible, annonce=annonce).exists():
            raise serializers.ValidationError("Vous avez déjà laissé un avis pour cette mission.")
        return attrs


class NotificationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Notification
        fields = ("id", "titre", "message", "lien", "lue", "date_creation")
        read_only_fields = fields


class SignalementSerializer(serializers.ModelSerializer):
    auteur = UserMiniSerializer(read_only=True)
    annonce_titre = serializers.CharField(source="annonce.titre", read_only=True, default=None)
    utilisateur_signale_detail = UserMiniSerializer(source="utilisateur_signale", read_only=True)

    class Meta:
        model = Signalement
        fields = (
            "id", "auteur", "annonce", "annonce_titre", "utilisateur_signale", "utilisateur_signale_detail",
            "motif", "statut", "date_creation",
        )
        read_only_fields = ("id", "auteur", "statut", "date_creation")

    def validate(self, attrs):
        if not attrs.get("annonce") and not attrs.get("utilisateur_signale"):
            raise serializers.ValidationError("Indiquez une annonce ou un utilisateur à signaler.")
        if attrs.get("utilisateur_signale") == self.context["request"].user:
            raise serializers.ValidationError("Vous ne pouvez pas vous signaler vous-même.")
        return attrs


# ============================================================== messagerie

class MessageSerializer(serializers.ModelSerializer):
    sender = UserMiniSerializer(read_only=True)
    receiver = UserMiniSerializer(read_only=True)
    is_own = serializers.SerializerMethodField()

    class Meta:
        model = Message
        fields = ("id", "sender", "receiver", "contenu", "date_envoi", "lu", "is_own")
        read_only_fields = ("id", "sender", "receiver", "date_envoi", "lu", "is_own")

    def get_is_own(self, obj):
        request = self.context.get("request")
        return bool(request and obj.sender_id == request.user.id)

    def validate_contenu(self, value):
        value = value.strip()
        if not value:
            raise serializers.ValidationError("Le message est vide.")
        if len(value) > 5000:
            raise serializers.ValidationError("Message trop long (5000 caractères max).")
        return value


# ============================================================== utilitaires

EXTENSIONS_IMAGES = {".jpg", ".jpeg", ".png", ".webp", ".gif"}
TAILLE_MAX_IMAGE = 5 * 1024 * 1024


def _valider_image(fichier):
    if not fichier:
        return fichier
    import os

    ext = os.path.splitext(fichier.name)[1].lower()
    if ext not in EXTENSIONS_IMAGES:
        raise serializers.ValidationError("Format d'image non supporté (jpg, png, webp, gif).")
    if fichier.size > TAILLE_MAX_IMAGE:
        raise serializers.ValidationError("Image trop volumineuse (5 Mo maximum).")
    return fichier
