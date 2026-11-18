from rest_framework.permissions import SAFE_METHODS, BasePermission


def _is_admin(user):
    return bool(user and user.is_authenticated and (user.type == "ADMIN" or user.is_superuser))


class IsAdmin(BasePermission):
    message = "Réservé aux administrateurs."

    def has_permission(self, request, view):
        return _is_admin(request.user)


class IsAdminOrReadOnly(BasePermission):
    """Lecture publique, écriture réservée à l'admin (catégories, compétences)."""

    def has_permission(self, request, view):
        if request.method in SAFE_METHODS:
            return True
        return _is_admin(request.user)


class IsCitoyen(BasePermission):
    message = "Réservé aux citoyens disposant d'un profil."

    def has_permission(self, request, view):
        user = request.user
        return bool(user and user.is_authenticated and user.type == "CITOYEN" and hasattr(user, "citoyen_profile"))


class IsAssociation(BasePermission):
    message = "Réservé aux associations disposant d'un profil."

    def has_permission(self, request, view):
        user = request.user
        return bool(
            user and user.is_authenticated and user.type == "ASSOCIATION" and hasattr(user, "association_profile")
        )


class AnnoncePermission(BasePermission):
    """
    - Lecture : publique.
    - Création : association **vérifiée** (tous types) ou citoyen avec profil (activités uniquement,
      contrôlé dans le serializer).
    - Modification : organisateur (association ou citoyen).
    - Suppression : organisateur ou admin.
    """

    message = "Action non autorisée sur cette annonce."

    def has_permission(self, request, view):
        if request.method in SAFE_METHODS:
            return True
        user = request.user
        if not user or not user.is_authenticated:
            return False
        if _is_admin(user):
            return request.method == "DELETE"
        if user.type == "ASSOCIATION" and hasattr(user, "association_profile"):
            if request.method == "POST" and not user.association_profile.est_verifiee:
                self.message = "Votre association doit être vérifiée par un administrateur avant de publier."
                return False
            return True
        if user.type == "CITOYEN" and hasattr(user, "citoyen_profile"):
            return True
        return False

    def has_object_permission(self, request, view, obj):
        if request.method in SAFE_METHODS:
            return True
        user = request.user
        if _is_admin(user):
            return request.method == "DELETE"
        return obj.organisateur_user.id == user.id
