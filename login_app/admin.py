from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin

from .models import (
    Annonce, AssociationProfile, Avis, Candidature, Categorie, CitoyenProfile, Competence, Message,
    Notification, PhotoAlbum, Signalement, User,
)


@admin.register(User)
class UserAdmin(BaseUserAdmin):
    list_display = ("username", "email", "type", "is_active", "date_joined")
    list_filter = ("type", "is_active")
    fieldsets = BaseUserAdmin.fieldsets + (("SolidarLink", {"fields": ("type",)}),)
    add_fieldsets = BaseUserAdmin.add_fieldsets + (("SolidarLink", {"fields": ("email", "type")}),)


@admin.register(AssociationProfile)
class AssociationAdmin(admin.ModelAdmin):
    list_display = ("nom", "ville", "statut_verification", "date_creation")
    list_filter = ("statut_verification", "ville")
    search_fields = ("nom", "user__email")


@admin.register(CitoyenProfile)
class CitoyenAdmin(admin.ModelAdmin):
    list_display = ("prenom", "nom", "ville")
    search_fields = ("prenom", "nom", "user__email")


@admin.register(Annonce)
class AnnonceAdmin(admin.ModelAdmin):
    list_display = ("titre", "type", "association", "ville", "date_debut", "est_active")
    list_filter = ("type", "categorie", "est_active")
    search_fields = ("titre", "association__nom")


@admin.register(Candidature)
class CandidatureAdmin(admin.ModelAdmin):
    list_display = ("citoyen", "annonce", "statut", "presence_confirmee", "heures_effectuees")
    list_filter = ("statut", "presence_confirmee")


admin.site.register([Categorie, Competence, PhotoAlbum, Avis, Notification, Signalement, Message])
