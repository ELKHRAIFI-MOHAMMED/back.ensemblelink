"""Tests de non-régression des correctifs de sécurité et des nouvelles fonctionnalités."""

from datetime import timedelta

from asgiref.sync import async_to_sync
from channels.testing import WebsocketCommunicator
from django.test import TransactionTestCase, override_settings
from django.utils import timezone
from rest_framework.test import APITestCase
from rest_framework_simplejwt.tokens import AccessToken

from .models import Annonce, AssociationProfile, Avis, Candidature, CitoyenProfile, Message, Notification, User

PWD = "Motdepasse-solide-42"


def creer_citoyen(username="cit"):
    u = User.objects.create_user(username, f"{username}@ex.fr", PWD, type="CITOYEN")
    CitoyenProfile.objects.create(user=u, prenom="Jean", nom=username)
    return u


def creer_association(username="asso", verifiee=True):
    u = User.objects.create_user(username, f"{username}@ex.fr", PWD, type="ASSOCIATION")
    AssociationProfile.objects.create(
        user=u, nom=f"Asso {username}", statut_verification="VERIFIEE" if verifiee else "EN_ATTENTE"
    )
    return u


def creer_annonce(asso_user, jours=3, places=None, duree=3):
    debut = timezone.now() + timedelta(days=jours)
    return Annonce.objects.create(
        association=asso_user.association_profile, titre="Mission", description="d", type="APPEL_BENEVOLAT",
        lieu="Lyon", date_debut=debut, date_fin=debut + timedelta(hours=duree), nombre_places=places,
    )


class SecuriteAuthTests(APITestCase):
    def test_inscription_admin_interdite(self):
        r = self.client.post("/api/signup/", {"username": "pirate", "email": "p@ex.fr", "password": PWD, "type": "ADMIN"})
        self.assertEqual(r.status_code, 400)
        self.assertFalse(User.objects.filter(username="pirate").exists())

    def test_compte_inactif_ne_peut_pas_se_connecter(self):
        u = creer_citoyen()
        u.is_active = False
        u.save()
        for ident in ("cit", "cit@ex.fr"):
            r = self.client.post("/api/login/", {"username_email": ident, "password": PWD})
            self.assertEqual(r.status_code, 401, ident)

    def test_connexion_email_ou_username(self):
        creer_citoyen()
        for ident in ("cit", "CIT@ex.fr"):
            r = self.client.post("/api/login/", {"username_email": ident, "password": PWD})
            self.assertEqual(r.status_code, 200, ident)
            self.assertIn("access", r.data)

    def test_seul_admin_peut_desactiver_un_compte(self):
        attaquant, victime = creer_citoyen("a"), creer_citoyen("v")
        self.client.force_authenticate(attaquant)
        self.assertEqual(self.client.post(f"/api/activate/{victime.id}/").status_code, 403)
        victime.refresh_from_db()
        self.assertTrue(victime.is_active)

        admin = User.objects.create_user("adm", "adm@ex.fr", PWD, type="ADMIN")
        self.client.force_authenticate(admin)
        self.assertEqual(self.client.post(f"/api/activate/{victime.id}/").status_code, 200)
        victime.refresh_from_db()
        self.assertFalse(victime.is_active)

    def test_liste_utilisateurs_reservee_admin(self):
        self.client.force_authenticate(creer_citoyen())
        self.assertEqual(self.client.get("/api/admin/users/").status_code, 403)

    def test_me_ne_plante_plus(self):
        self.client.force_authenticate(creer_citoyen())
        r = self.client.get("/api/me/")
        self.assertEqual(r.status_code, 200)
        self.assertIn("badges", r.data["stats"])

    def test_edition_profil_citoyen(self):
        self.client.force_authenticate(creer_citoyen())
        r = self.client.patch("/api/citoyen/edit/", {"bio": "Nouvelle bio"}, format="json")
        self.assertEqual(r.status_code, 200)
        self.assertEqual(r.data["bio"], "Nouvelle bio")


class AnnonceTests(APITestCase):
    def setUp(self):
        self.asso = creer_association()
        self.payload = {
            "titre": "Maraude", "description": "d", "type": "APPEL_BENEVOLAT", "lieu": "Lille",
            "date_debut": (timezone.now() + timedelta(days=2)).strftime("%Y-%m-%dT%H:%M"),
            "date_fin": (timezone.now() + timedelta(days=2, hours=3)).strftime("%Y-%m-%dT%H:%M"),
        }

    def test_lecture_publique(self):
        creer_annonce(self.asso)
        self.assertEqual(self.client.get("/api/annonces/").status_code, 200)

    def test_association_non_verifiee_ne_publie_pas(self):
        self.client.force_authenticate(creer_association("nv", verifiee=False))
        self.assertEqual(self.client.post("/api/annonces/", self.payload).status_code, 403)

    def test_dates_incoherentes_refusees(self):
        self.client.force_authenticate(self.asso)
        bad = dict(self.payload, date_fin=self.payload["date_debut"])
        self.assertEqual(self.client.post("/api/annonces/", bad).status_code, 400)

    def test_autre_association_ne_modifie_pas(self):
        annonce = creer_annonce(self.asso)
        self.client.force_authenticate(creer_association("autre"))
        self.assertEqual(self.client.patch(f"/api/annonces/{annonce.id}/", {"titre": "X"}).status_code, 403)


class CandidatureTests(APITestCase):
    def setUp(self):
        self.asso = creer_association()
        self.cit = creer_citoyen()
        self.annonce = creer_annonce(self.asso, places=1)

    def postuler(self, user=None, annonce=None):
        self.client.force_authenticate(user or self.cit)
        return self.client.post("/api/candidatures/", {"annonce": (annonce or self.annonce).id, "message": "Dispo"})

    def test_double_candidature_refusee(self):
        self.assertEqual(self.postuler().status_code, 201)
        self.assertEqual(self.postuler().status_code, 400)

    def test_annonce_terminee_refusee(self):
        passee = creer_annonce(self.asso, jours=-3)
        self.assertEqual(self.postuler(annonce=passee).status_code, 400)

    def test_citoyen_ne_peut_pas_reattribuer_ni_changer_statut(self):
        cid = self.postuler().data["id"]
        autre = creer_citoyen("autre")
        r = self.client.patch(
            f"/api/candidatures/mes/{cid}/",
            {"statut": "ACCEPTEE", "citoyen": autre.citoyen_profile.id, "message": "maj"},
            format="json",
        )
        self.assertEqual(r.status_code, 200)
        cand = Candidature.objects.get(id=cid)
        self.assertEqual(cand.statut, "EN_ATTENTE")
        self.assertEqual(cand.citoyen.user, self.cit)
        self.assertEqual(cand.message, "maj")

    def test_citoyen_peut_retirer_sa_candidature(self):
        cid = self.postuler().data["id"]
        self.assertEqual(self.client.delete(f"/api/candidatures/mes/{cid}/").status_code, 204)

    def test_capacite_respectee(self):
        c1 = self.postuler().data["id"]
        autre = creer_citoyen("c2")
        c2 = self.postuler(user=autre).data["id"]
        self.client.force_authenticate(self.asso)
        self.assertEqual(self.client.patch(f"/api/candidatures/mes/{c1}/", {"statut": "ACCEPTEE"}).status_code, 200)
        self.assertEqual(self.client.patch(f"/api/candidatures/mes/{c2}/", {"statut": "ACCEPTEE"}).status_code, 400)
        # notification envoyée au citoyen accepté
        self.assertTrue(Notification.objects.filter(destinataire=self.cit, titre__icontains="acceptée").exists())

    def test_pointage_qr_et_attestation(self):
        cid = self.postuler().data["id"]
        self.client.force_authenticate(self.asso)
        self.client.patch(f"/api/candidatures/mes/{cid}/", {"statut": "ACCEPTEE"})
        code = str(Candidature.objects.get(id=cid).code_presence)

        # le code n'est visible que du citoyen
        self.assertIsNone(self.client.get(f"/api/candidatures/mes/{cid}/").data["code_presence"])
        self.client.force_authenticate(self.cit)
        self.assertEqual(self.client.get(f"/api/candidatures/mes/{cid}/").data["code_presence"], code)
        self.assertEqual(self.client.get(f"/api/candidatures/{cid}/attestation/").status_code, 400)

        self.client.force_authenticate(self.asso)
        self.assertEqual(self.client.post("/api/candidatures/pointage/", {"code": code}).status_code, 200)
        cand = Candidature.objects.get(id=cid)
        self.assertTrue(cand.presence_confirmee)
        self.assertEqual(float(cand.heures_effectuees), 3.0)

        self.client.force_authenticate(self.cit)
        r = self.client.get(f"/api/candidatures/{cid}/attestation/")
        self.assertEqual(r.status_code, 200)
        self.assertEqual(r["Content-Type"], "application/pdf")


class AvisTests(APITestCase):
    def test_avis_seulement_apres_mission_partagee(self):
        asso, cit, intrus = creer_association(), creer_citoyen(), creer_citoyen("intrus")
        annonce = creer_annonce(asso, jours=-2)
        Candidature.objects.create(citoyen=cit.citoyen_profile, annonce=annonce, statut="ACCEPTEE")
        data = {"cible": asso.id, "annonce": annonce.id, "note": 5}

        self.client.force_authenticate(intrus)
        self.assertEqual(self.client.post("/api/avis/", data).status_code, 400)
        self.client.force_authenticate(cit)
        self.assertEqual(self.client.post("/api/avis/", data).status_code, 201)
        self.assertEqual(self.client.post("/api/avis/", data).status_code, 400)  # doublon
        self.assertEqual(Avis.objects.count(), 1)


@override_settings(CHANNEL_LAYERS={"default": {"BACKEND": "channels.layers.InMemoryChannelLayer"}})
class WebSocketTests(TransactionTestCase):
    def _connect(self, path):
        from PFE_BackEnd.asgi import application

        comm = WebsocketCommunicator(application, path, headers=[(b"origin", b"http://localhost:3000")])
        return comm

    def test_connexion_refusee_sans_token(self):
        b = creer_citoyen("b")

        async def scenario():
            comm = self._connect(f"/ws/chat/{b.id}/")
            connected, _ = await comm.connect()
            await comm.disconnect()
            return connected

        self.assertFalse(async_to_sync(scenario)())

    def test_expediteur_impose_par_le_token(self):
        a, b, c = creer_citoyen("a"), creer_citoyen("b"), creer_citoyen("c")
        token = str(AccessToken.for_user(a))

        async def scenario():
            comm = self._connect(f"/ws/chat/{b.id}/?token={token}")
            connected, _ = await comm.connect()
            assert connected
            # tentative d'usurpation : sender_id d'un autre utilisateur
            await comm.send_json_to({"message": "salut", "sender_id": c.id})
            reponse = await comm.receive_json_from()
            await comm.disconnect()
            return reponse

        reponse = async_to_sync(scenario)()
        self.assertEqual(reponse["sender_id"], a.id)
        msg = Message.objects.get()
        self.assertEqual((msg.sender, msg.receiver), (a, b))
