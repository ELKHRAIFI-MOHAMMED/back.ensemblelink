"""Stockage des médias (logos, photos, images d'annonces) dans Supabase Storage.

Sur Vercel le disque n'est pas persistant : les fichiers envoyés par les utilisateurs sont donc
stockés dans un bucket Supabase public. La clé `service_role` n'est utilisée QUE côté serveur.

Activé automatiquement quand SUPABASE_URL et SUPABASE_SERVICE_ROLE_KEY sont définis.
"""

import json
import mimetypes
import posixpath
import uuid
from urllib.error import HTTPError
from urllib.parse import quote
from urllib.request import Request, urlopen

from django.conf import settings
from django.core.files.base import ContentFile
from django.core.files.storage import Storage
from django.utils.deconstruct import deconstructible


@deconstructible
class SupabaseStorage(Storage):
    def __init__(self, bucket=None):
        self.base = settings.SUPABASE_URL
        self.cle = settings.SUPABASE_SERVICE_ROLE_KEY
        self.bucket = bucket or settings.SUPABASE_STORAGE_BUCKET

    # ------------------------------------------------------------ helpers HTTP
    def _requete(self, methode, chemin, data=None, entetes=None):
        h = {"Authorization": f"Bearer {self.cle}", "apikey": self.cle}
        h.update(entetes or {})
        req = Request(f"{self.base}/storage/v1/{chemin}", data=data, headers=h, method=methode)
        with urlopen(req, timeout=30) as r:
            return r.status, r.read()

    def _objet(self, name):
        return f"object/{self.bucket}/{quote(name)}"

    # ------------------------------------------------------------ API Storage de Django
    def _save(self, name, content):
        content.seek(0) if hasattr(content, "seek") else None
        data = content.read()
        type_mime = getattr(content, "content_type", None) or mimetypes.guess_type(name)[0] or "application/octet-stream"
        self._requete("POST", self._objet(name), data=data, entetes={"Content-Type": type_mime, "x-upsert": "false"})
        return name

    def get_available_name(self, name, max_length=None):
        # Nom unique (évite les collisions et les écrasements) : dossier/uuid-nom.ext
        dossier, fichier = posixpath.split(name.replace("\\", "/"))
        base, ext = posixpath.splitext(fichier)
        unique = f"{base[:40]}-{uuid.uuid4().hex[:10]}{ext.lower()}"
        return posixpath.join(dossier, unique) if dossier else unique

    def exists(self, name):
        try:
            statut, _ = self._requete("HEAD", self._objet(name))
            return statut == 200
        except HTTPError:
            return False

    def delete(self, name):
        try:
            self._requete(
                "DELETE", f"object/{self.bucket}", data=json.dumps({"prefixes": [name]}).encode(),
                entetes={"Content-Type": "application/json"},
            )
        except HTTPError:
            pass

    def url(self, name):
        return f"{self.base}/storage/v1/object/public/{self.bucket}/{quote(name)}"

    def _open(self, name, mode="rb"):
        with urlopen(self.url(name), timeout=30) as r:
            return ContentFile(r.read(), name=name)

    def size(self, name):
        with urlopen(Request(self.url(name), method="HEAD"), timeout=30) as r:
            return int(r.headers.get("Content-Length", 0))


def creer_bucket_public(bucket=None):
    """Crée le bucket public des médias s'il n'existe pas (appelé par `preparer_supabase`)."""
    s = SupabaseStorage(bucket)
    corps = json.dumps({"id": s.bucket, "name": s.bucket, "public": True, "file_size_limit": 5 * 1024 * 1024}).encode()
    try:
        s._requete("POST", "bucket", data=corps, entetes={"Content-Type": "application/json"})
        return "créé"
    except HTTPError as e:
        texte = e.read().decode(errors="ignore")
        if e.code in (400, 409) and ("exists" in texte.lower() or "duplicate" in texte.lower()):
            return "existe déjà"
        raise
