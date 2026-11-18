"""Pays pris en charge : code ISO 3166-1 alpha-2, libellé, fuseaux horaires (le premier est celui par défaut)."""

PAYS = {
    "MA": {"nom": "Maroc", "fuseaux": ["Africa/Casablanca"]},
    "FR": {"nom": "France", "fuseaux": ["Europe/Paris"]},
    "GB": {"nom": "Royaume-Uni", "fuseaux": ["Europe/London"]},
    "US": {
        "nom": "États-Unis",
        "fuseaux": ["America/New_York", "America/Chicago", "America/Denver", "America/Los_Angeles"],
    },
    "CA": {
        "nom": "Canada",
        "fuseaux": ["America/Toronto", "America/Vancouver", "America/Edmonton", "America/Halifax"],
    },
    "BE": {"nom": "Belgique", "fuseaux": ["Europe/Brussels"]},
    "CH": {"nom": "Suisse", "fuseaux": ["Europe/Zurich"]},
    "ES": {"nom": "Espagne", "fuseaux": ["Europe/Madrid"]},
    "DE": {"nom": "Allemagne", "fuseaux": ["Europe/Berlin"]},
    "IT": {"nom": "Italie", "fuseaux": ["Europe/Rome"]},
    "SN": {"nom": "Sénégal", "fuseaux": ["Africa/Dakar"]},
    "TN": {"nom": "Tunisie", "fuseaux": ["Africa/Tunis"]},
    "DZ": {"nom": "Algérie", "fuseaux": ["Africa/Algiers"]},
}

CHOIX_PAYS = [(code, info["nom"]) for code, info in PAYS.items()]
TOUS_FUSEAUX = sorted({tz for info in PAYS.values() for tz in info["fuseaux"]})


def fuseau_par_defaut(code_pays: str) -> str:
    return PAYS.get(code_pays, PAYS["FR"])["fuseaux"][0]
