# EnsembleLink — Backend (v4 bêta)

API Django REST d'**EnsembleLink** : associations, bénévoles, activités entre citoyens, dons, groupes de discussion,
avis, historique et alerte « Jour J ». Frontend : dépôt
[solidarlink-frontend](https://github.com/ELKHRAIFI-MOHAMMED/solidarlink-frontend).

## Trois façons de lancer le projet

| Mode | Base | Commande |
|---|---|---|
| Local classique | MySQL (XAMPP) via `.env` | `python manage.py runserver` |
| Local sur la base de la bêta | Supabase via `.env.supabase` | `ENV_FILE=.env.supabase python manage.py …` |
| Bêta en ligne | Supabase, sur **Vercel** | import du dépôt dans Vercel (voir plus bas) |

Les fichiers `.env*` (sauf `.env.example`) sont ignorés par Git : **ne jamais y committer de secrets**.

### Local (MySQL)

```bash
pip install -r requirements-local.txt      # inclut MySQL + Daphne (WebSockets temps réel)
cp .env.example .env                       # renseigner SECRET_KEY et DB_*
python manage.py migrate
python manage.py seed_demo                 # données de démo (--reset pour recréer)
python manage.py runserver                 # http://127.0.0.1:8000
python manage.py test login_app            # 34 tests
```

## Déploiement sur Vercel + Supabase (bêta)

Vercel détecte Django automatiquement (`manage.py`, `WSGI_APPLICATION`) et lance `collectstatic` tout seul.
Configuration fournie dans le dépôt : `vercel.json` (région **Londres `lhr1`**, à côté de la base Supabase
`eu-west-2`, et tâche planifiée quotidienne), `.python-version` (3.12), `requirements.txt`, `.vercelignore`.

### 1. Préparer la base Supabase (une seule fois, depuis votre PC)

Créer `backPfe/.env.supabase` (ignoré par Git) :

```ini
SECRET_KEY=<clé longue et aléatoire>
DATABASE_URL=<POSTGRES_URL_NON_POOLING de Supabase>   # port 5432
SUPABASE_URL=<SUPABASE_URL>
SUPABASE_SERVICE_ROLE_KEY=<SUPABASE_SERVICE_ROLE_KEY>
```

Puis :

```bash
ENV_FILE=.env.supabase python manage.py migrate            # crée les tables
ENV_FILE=.env.supabase python manage.py preparer_supabase  # sécurité RLS + bucket « media »
ENV_FILE=.env.supabase python manage.py seed_demo --reset  # données de démo
```

> **Sécurité Supabase :** les tables du schéma `public` sont normalement lisibles par l'API publique de Supabase
> avec la clé « anon ». Après chaque `migrate`, l'application active RLS sur toutes les tables et retire les droits
> des rôles `anon` / `authenticated` (voir `login_app/supabase_securite.py`). Django, propriétaire des tables,
> fonctionne normalement.

### 2. Importer le projet dans Vercel

**Vercel → Add New → Project → importer `backPfe`**, puis **Settings → Environment Variables** :

| Variable | Valeur |
|---|---|
| `SECRET_KEY` | clé longue et aléatoire (différente du local) |
| `POSTGRES_URL` | fournie par l'intégration Supabase de Vercel (pooler, port 6543) |
| `SUPABASE_URL` | fournie par l'intégration Supabase |
| `SUPABASE_SERVICE_ROLE_KEY` | fournie par l'intégration Supabase (**jamais côté frontend**) |
| `CORS_ALLOWED_ORIGINS` | URL du frontend, ex. `https://ensemblelink.vercel.app` |
| `CORS_ORIGIN_REGEX` | *(optionnel)* URL de prévisualisation, ex. `^https://ensemblelink-[a-z0-9-]+\.vercel\.app$` |
| `CRON_SECRET` | secret aléatoire : protège la tâche quotidienne `/api/cron/quotidien/` |
| `DEBUG` | `False` |

Si l'intégration Supabase est reliée au projet backend, les variables `POSTGRES_*` et `SUPABASE_*` sont déjà là.

### Ce qui change sur Vercel par rapport au local

| Fonction | Local | Vercel (bêta) |
|---|---|---|
| Serveur | Daphne (ASGI) | WSGI, une Vercel Function à Londres |
| Messagerie / notifications | WebSockets temps réel | rafraîchissement automatique (4 s / 30 s) côté frontend |
| Fichiers envoyés (logos, photos) | disque `media/` | **Supabase Storage**, bucket public `media` |
| Tâche quotidienne | `python manage.py fermer_groupes` | Vercel Cron, 5 h UTC : ferme les groupes terminés et recrée les activités « Jour J » de la démo |

Le temps réel par WebSocket reste possible plus tard sur Vercel (Django Channels en ASGI) avec un Redis externe
(`REDIS_URL`) pour relier les instances.

## Comptes de démo

Mot de passe commun : `Demo1234!` — `admin@ensemblelink.demo`, `emma.martin@mail.ensemblelink.demo`,
`yassine.elamrani@mail.ensemblelink.demo`, `oliver.smith@mail.ensemblelink.demo`,
`panier_solidaire@asso.ensemblelink.demo` (46 comptes dans 5 pays au total).
