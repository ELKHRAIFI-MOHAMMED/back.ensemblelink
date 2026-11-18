"""Tâche planifiée quotidienne de la bêta (Vercel Cron → vercel.json)."""

import hmac

from django.conf import settings
from django.core.management import call_command
from django.http import JsonResponse
from django.views.decorators.http import require_GET

from login_app.services import fermer_groupes_expires


@require_GET
def tache_quotidienne(request):
    """Vercel appelle cette URL chaque jour avec l'en-tête « Authorization: Bearer <CRON_SECRET> »."""
    attendu = f"Bearer {settings.CRON_SECRET}"
    if not settings.CRON_SECRET or not hmac.compare_digest(request.headers.get("Authorization", ""), attendu):
        return JsonResponse({"detail": "Non autorisé."}, status=401)
    fermes = fermer_groupes_expires()
    call_command("demo_jour_j", journee=True)
    return JsonResponse({"groupes_fermes": fermes, "demo_jour_j": "recréée"})
