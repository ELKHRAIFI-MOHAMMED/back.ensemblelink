"""Synchronisation automatique des groupes de discussion avec les candidatures acceptées."""

from django.db.models.signals import post_delete, post_save
from django.dispatch import receiver

from .models import Candidature, GroupeDiscussion


def _groupe(candidature):
    try:
        return candidature.annonce.groupe
    except GroupeDiscussion.DoesNotExist:
        return None


@receiver(post_save, sender=Candidature)
def synchroniser_groupe(sender, instance, **kwargs):
    from .services import ajouter_membre, retirer_membre

    groupe = _groupe(instance)
    if groupe is None:
        return
    user = instance.citoyen.user
    if instance.statut == Candidature.Statut.ACCEPTEE:
        ajouter_membre(groupe, user)
    else:
        retirer_membre(groupe, user)


@receiver(post_delete, sender=Candidature)
def retirer_du_groupe(sender, instance, **kwargs):
    from .services import retirer_membre

    groupe = _groupe(instance)
    if groupe is not None:
        retirer_membre(groupe, instance.citoyen.user)
