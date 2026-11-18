"""
Django settings — EnsembleLink (backend PFE_BackEnd).

Trois façons de lancer le projet :
  1. En local avec MySQL (XAMPP)      → fichier `.env`              (voir `.env.example`)
  2. En local sur la base Supabase    → `ENV_FILE=.env.supabase python manage.py ...`
  3. Sur Vercel (bêta)                → variables d'environnement du projet Vercel
                                         (Vercel définit automatiquement VERCEL=1)

Ne jamais committer de fichier `.env*` contenant des secrets.
"""

import os
from datetime import timedelta
from pathlib import Path
from urllib.parse import parse_qs, unquote, urlparse

import environ

BASE_DIR = Path(__file__).resolve().parent.parent

env = environ.Env(
    DEBUG=(bool, False),
    ALLOWED_HOSTS=(list, ["localhost", "127.0.0.1"]),
    CORS_ALLOWED_ORIGINS=(list, ["http://localhost:3000", "http://127.0.0.1:3000"]),
    CORS_ORIGIN_REGEX=(str, ""),
    DB_HOST=(str, "127.0.0.1"),
    DB_PORT=(str, "3306"),
    REDIS_URL=(str, ""),
    JWT_ACCESS_MINUTES=(int, 60),
    JWT_REFRESH_DAYS=(int, 7),
    SUPABASE_URL=(str, ""),
    SUPABASE_SERVICE_ROLE_KEY=(str, ""),
    SUPABASE_STORAGE_BUCKET=(str, "media"),
    CRON_SECRET=(str, ""),
)
_fichier_env = BASE_DIR / os.environ.get("ENV_FILE", ".env")
if _fichier_env.exists():
    environ.Env.read_env(_fichier_env)

# Vercel définit VERCEL=1 pendant le build et à l'exécution
SUR_VERCEL = bool(os.environ.get("VERCEL"))

SECRET_KEY = env("SECRET_KEY")
DEBUG = env("DEBUG")
ALLOWED_HOSTS = env("ALLOWED_HOSTS")
if SUR_VERCEL:
    ALLOWED_HOSTS += [".vercel.app"]
    if os.environ.get("VERCEL_URL"):
        ALLOWED_HOSTS.append(os.environ["VERCEL_URL"])

AUTH_USER_MODEL = "login_app.User"

# Un seul backend : il gère email OU username et refuse les comptes inactifs.
AUTHENTICATION_BACKENDS = ["login_app.backends.EmailOrUsernameModelBackend"]

INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    "rest_framework",
    "rest_framework_simplejwt",
    "django_filters",
    "corsheaders",
    "channels",
    "login_app",
]
# Daphne (serveur ASGI + WebSockets) uniquement en local : Vercel exécute l'app en WSGI.
if not SUR_VERCEL:
    try:
        import daphne  # noqa: F401

        INSTALLED_APPS.insert(0, "daphne")
    except ImportError:
        pass

MIDDLEWARE = [
    "corsheaders.middleware.CorsMiddleware",  # doit être placé le plus haut possible
    "django.middleware.security.SecurityMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
]

# CORS : uniquement les origines déclarées (+ éventuellement les URL de prévisualisation Vercel du frontend)
CORS_ALLOWED_ORIGINS = env("CORS_ALLOWED_ORIGINS")
CORS_ALLOWED_ORIGIN_REGEXES = [env("CORS_ORIGIN_REGEX")] if env("CORS_ORIGIN_REGEX") else []
if SUR_VERCEL:
    # Projets frontend EnsembleLink sur Vercel (production + prévisualisations), acceptés même sans variable :
    #   ensemblelink.vercel.app, ensemblelink-xxxx.vercel.app, solidarlink-frontend-xxxx.vercel.app
    CORS_ALLOWED_ORIGIN_REGEXES.append(r"^https://(ensemblelink|solidarlink-frontend)(-[a-z0-9-]+)?\.vercel\.app$")
CORS_ALLOW_CREDENTIALS = True
CSRF_TRUSTED_ORIGINS = [o for o in CORS_ALLOWED_ORIGINS if o.startswith("https://")]
if SUR_VERCEL:
    CSRF_TRUSTED_ORIGINS.append("https://*.vercel.app")  # connexion à /admin/ sur Vercel
    SECURE_PROXY_SSL_HEADER = ("HTTP_X_FORWARDED_PROTO", "https")

REST_FRAMEWORK = {
    "DEFAULT_AUTHENTICATION_CLASSES": (
        "rest_framework_simplejwt.authentication.JWTAuthentication",
    ),
    "DEFAULT_PERMISSION_CLASSES": ("rest_framework.permissions.IsAuthenticated",),
    "DEFAULT_FILTER_BACKENDS": (
        "django_filters.rest_framework.DjangoFilterBackend",
        "rest_framework.filters.SearchFilter",
        "rest_framework.filters.OrderingFilter",
    ),
    "DEFAULT_PAGINATION_CLASS": "login_app.pagination.StandardPagination",
    "PAGE_SIZE": 12,
    "DEFAULT_THROTTLE_CLASSES": (
        "rest_framework.throttling.AnonRateThrottle",
        "rest_framework.throttling.UserRateThrottle",
    ),
    "DEFAULT_THROTTLE_RATES": {
        "anon": "3000/hour",
        "user": "10000/hour",
        "login": "10/minute",
    },
}

SIMPLE_JWT = {
    "ACCESS_TOKEN_LIFETIME": timedelta(minutes=env("JWT_ACCESS_MINUTES")),
    "REFRESH_TOKEN_LIFETIME": timedelta(days=env("JWT_REFRESH_DAYS")),
    "UPDATE_LAST_LOGIN": True,
}

ROOT_URLCONF = "PFE_BackEnd.urls"

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [],
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
            ],
        },
    },
]

WSGI_APPLICATION = "PFE_BackEnd.wsgi.application"
# Si ASGI_APPLICATION est défini, Vercel utilise l'entrée ASGI : on le réserve au local (Daphne + WebSockets).
if not SUR_VERCEL:
    ASGI_APPLICATION = "PFE_BackEnd.asgi.application"

# Channels : Redis si REDIS_URL est défini, sinon mémoire (local / bêta sans WebSockets)
if env("REDIS_URL"):
    CHANNEL_LAYERS = {
        "default": {
            "BACKEND": "channels_redis.core.RedisChannelLayer",
            "CONFIG": {"hosts": [env("REDIS_URL")]},
        }
    }
else:
    CHANNEL_LAYERS = {"default": {"BACKEND": "channels.layers.InMemoryChannelLayer"}}


# --------------------------------------------------------------------- base de données
def _postgres_depuis_url(url):
    """Configuration PostgreSQL à partir d'une URL (Supabase / Vercel). Les paramètres propres au
    pooler Supabase (pgbouncer=true, supa=…) sont ignorés : seul sslmode est transmis."""
    u = urlparse(url)
    query = parse_qs(u.query)
    pooler_transaction = u.port == 6543 or "pgbouncer" in query
    options = {"sslmode": query.get("sslmode", ["require"])[0]}
    if pooler_transaction:
        # Le pooler en mode transaction ne supporte pas les requêtes préparées côté serveur
        options["prepare_threshold"] = None
    return {
        "ENGINE": "django.db.backends.postgresql",
        "NAME": u.path.lstrip("/") or "postgres",
        "USER": unquote(u.username or ""),
        "PASSWORD": unquote(u.password or ""),
        "HOST": u.hostname,
        "PORT": str(u.port or 5432),
        "OPTIONS": options,
        "CONN_MAX_AGE": 0,
        "DISABLE_SERVER_SIDE_CURSORS": pooler_transaction,
    }


_url_bdd = os.environ.get("DATABASE_URL") or env.str("DATABASE_URL", "") or os.environ.get("POSTGRES_URL", "")
if _url_bdd:
    DATABASES = {"default": _postgres_depuis_url(_url_bdd)}
else:
    DATABASES = {
        "default": {
            "ENGINE": "django.db.backends.mysql",
            "NAME": env("DB_NAME"),
            "USER": env("DB_USER"),
            "PASSWORD": env("DB_PASSWORD"),
            "HOST": env("DB_HOST"),
            "PORT": env("DB_PORT"),
            "OPTIONS": {"charset": "utf8mb4", "init_command": "SET sql_mode='STRICT_TRANS_TABLES'"},
        }
    }

AUTH_PASSWORD_VALIDATORS = [
    {"NAME": "django.contrib.auth.password_validation.UserAttributeSimilarityValidator"},
    {"NAME": "django.contrib.auth.password_validation.MinimumLengthValidator"},
    {"NAME": "django.contrib.auth.password_validation.CommonPasswordValidator"},
    {"NAME": "django.contrib.auth.password_validation.NumericPasswordValidator"},
]

LANGUAGE_CODE = "fr-fr"
TIME_ZONE = "Europe/Paris"
USE_I18N = True
USE_TZ = True

# --------------------------------------------------------------------- fichiers
# Statiques : Vercel lance collectstatic automatiquement (STATIC_ROOT) et les sert via son CDN.
STATIC_URL = "static/"
STATIC_ROOT = BASE_DIR / "staticfiles"

# Médias (logos, photos, images d'annonces) : Supabase Storage si configuré (indispensable sur Vercel,
# dont le disque n'est pas persistant), sinon disque local.
SUPABASE_URL = env("SUPABASE_URL").rstrip("/")
SUPABASE_SERVICE_ROLE_KEY = env("SUPABASE_SERVICE_ROLE_KEY")
SUPABASE_STORAGE_BUCKET = env("SUPABASE_STORAGE_BUCKET")
MEDIA_URL = "/media/"
MEDIA_ROOT = BASE_DIR / "media"
STORAGES = {
    "default": {"BACKEND": "django.core.files.storage.FileSystemStorage"},
    "staticfiles": {"BACKEND": "django.contrib.staticfiles.storage.StaticFilesStorage"},
}
if SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY:
    STORAGES["default"] = {"BACKEND": "login_app.storage.SupabaseStorage"}

# Limite de taille des uploads (4 Mo : les requêtes Vercel sont limitées à 4,5 Mo)
DATA_UPLOAD_MAX_MEMORY_SIZE = 4 * 1024 * 1024
FILE_UPLOAD_MAX_MEMORY_SIZE = 4 * 1024 * 1024

DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"

# Tâche planifiée Vercel (vercel.json → crons) : protégée par ce secret
CRON_SECRET = env("CRON_SECRET")

LOGGING = {
    "version": 1,
    "disable_existing_loggers": False,
    "handlers": {"console": {"class": "logging.StreamHandler"}},
    "root": {"handlers": ["console"], "level": "INFO" if SUR_VERCEL else "WARNING"},
}

if not DEBUG:
    SECURE_CONTENT_TYPE_NOSNIFF = True
    SESSION_COOKIE_SECURE = True
    CSRF_COOKIE_SECURE = True
    X_FRAME_OPTIONS = "DENY"
