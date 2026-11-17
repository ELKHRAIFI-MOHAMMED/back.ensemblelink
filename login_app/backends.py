from django.contrib.auth import get_user_model
from django.contrib.auth.backends import ModelBackend

User = get_user_model()


class EmailOrUsernameModelBackend(ModelBackend):
    """Authentifie par email ou par username.

    Correctif sécurité : l'ancienne version ne vérifiait pas `is_active`,
    ce qui permettait à un compte désactivé de se connecter.
    """

    def authenticate(self, request, username=None, email=None, password=None, **kwargs):
        identifiant = email or username
        if not identifiant or not password:
            return None
        try:
            if "@" in identifiant:
                user = User.objects.get(email__iexact=identifiant)
            else:
                user = User.objects.get(username__iexact=identifiant)
        except User.DoesNotExist:
            # Exécute le hasher pour limiter les attaques par mesure de temps
            User().set_password(password)
            return None

        if user.check_password(password) and self.user_can_authenticate(user):
            return user
        return None
