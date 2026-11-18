"""Sécurisation de la base Supabase.

Supabase publie automatiquement les tables du schéma `public` via son API REST (PostgREST), accessible
avec la clé « anon » qui, elle, est publique. Les tables créées par Django y seraient donc lisibles par
n'importe qui (utilisateurs, emails, hachages de mots de passe…).

On ferme cet accès : RLS activé sur toutes les tables (aucune politique = aucun accès pour anon /
authenticated) et révocation des droits de ces rôles. Django se connecte avec le rôle `postgres`,
propriétaire des tables, qui n'est pas concerné par RLS : l'application fonctionne normalement.
"""

import logging

from django.conf import settings
from django.db import connections

logger = logging.getLogger(__name__)

ROLES_PUBLICS = ("anon", "authenticated")


def est_supabase(using="default"):
    conn = connections[using]
    return conn.vendor == "postgresql" and bool(getattr(settings, "SUPABASE_URL", ""))


def securiser_tables(using="default"):
    """Active RLS et retire les droits des rôles publics sur toutes les tables du schéma public."""
    conn = connections[using]
    with conn.cursor() as c:
        c.execute("SELECT rolname FROM pg_roles WHERE rolname = ANY(%s)", [list(ROLES_PUBLICS)])
        roles = [r[0] for r in c.fetchall()]
        c.execute("SELECT tablename FROM pg_tables WHERE schemaname = 'public'")
        tables = [r[0] for r in c.fetchall()]
        for t in tables:
            c.execute(f'ALTER TABLE public."{t}" ENABLE ROW LEVEL SECURITY')
        if roles:
            liste = ", ".join(roles)
            c.execute(f"REVOKE ALL ON ALL TABLES IN SCHEMA public FROM {liste}")
            c.execute(f"REVOKE ALL ON ALL SEQUENCES IN SCHEMA public FROM {liste}")
            # Tables créées plus tard par de futures migrations : pas de droits par défaut non plus
            c.execute(f"ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE ALL ON TABLES FROM {liste}")
            c.execute(f"ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE ALL ON SEQUENCES FROM {liste}")
    return len(tables), roles


def securiser_apres_migration(sender, using="default", **kwargs):
    """Signal post_migrate : sécurise automatiquement après chaque `migrate` sur Supabase."""
    if not est_supabase(using):
        return
    nb, roles = securiser_tables(using)
    logger.info("Supabase : %s tables protégées (RLS + droits retirés à %s)", nb, ", ".join(roles) or "—")
