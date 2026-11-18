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


# ============================================================== v3 : activités citoyennes, groupes, pays

from datetime import timezone as dt_timezone  # noqa: E402

from .models import GroupeDiscussion, MembreGroupe, MessageGroupe  # noqa: E402


def creer_activite(citoyen_user, jours=3, places=None, auto=True, duree=2):
    debut = timezone.now() + timedelta(days=jours)
    return Annonce.objects.create(
        createur=citoyen_user.citoyen_profile, titre="Match de foot", description="d", type="ACTIVITE",
        lieu="Parc", ville="Casablanca", pays="MA", fuseau_horaire="Africa/Casablanca",
        date_debut=debut, date_fin=debut + timedelta(hours=duree), nombre_places=places, inscription_automatique=auto,
    )


class ActiviteCitoyenneTests(APITestCase):
    def setUp(self):
        self.orga = creer_citoyen("orga")
        self.payload = {
            "titre": "Club de lecture", "description": "d", "type": "ACTIVITE", "lieu": "Café", "ville": "New York",
            "pays": "US", "fuseau_horaire": "America/New_York", "date_debut": "2030-06-01T10:00",
            "date_fin": "2030-06-01T12:00", "inscription_automatique": True,
        }

    def test_citoyen_publie_une_activite_dans_son_fuseau(self):
        self.client.force_authenticate(self.orga)
        r = self.client.post("/api/annonces/", self.payload)
        self.assertEqual(r.status_code, 201, r.data)
        a = Annonce.objects.get(id=r.data["id"])
        self.assertEqual(a.createur.user, self.orga)
        # 10:00 à New York (UTC-4 en juin) = 14:00 UTC
        self.assertEqual(a.date_debut.astimezone(dt_timezone.utc).hour, 14)
        self.assertTrue(r.data["date_debut"].startswith("2030-06-01T10:00"))
        self.assertEqual(r.data["organisateur"]["type"], "CITOYEN")

    def test_citoyen_ne_publie_pas_de_benevolat(self):
        self.client.force_authenticate(self.orga)
        r = self.client.post("/api/annonces/", dict(self.payload, type="APPEL_BENEVOLAT"))
        self.assertEqual(r.status_code, 400)

    def test_inscription_automatique_et_organisateur_gere(self):
        activite = creer_activite(self.orga, places=1)
        joueur, autre = creer_citoyen("joueur"), creer_citoyen("autre")
        self.client.force_authenticate(joueur)
        r = self.client.post("/api/candidatures/", {"annonce": activite.id})
        self.assertEqual(r.data["statut"], "ACCEPTEE")
        self.client.force_authenticate(autre)
        self.assertEqual(self.client.post("/api/candidatures/", {"annonce": activite.id}).status_code, 400)  # complet
        # L'organisateur ne peut pas rejoindre sa propre activité
        self.client.force_authenticate(self.orga)
        self.assertEqual(self.client.post("/api/candidatures/", {"annonce": activite.id}).status_code, 400)
        # ... mais voit les participants et gère les inscriptions
        r = self.client.get("/api/candidatures/mes/?role=organisateur")
        self.assertEqual(r.data["count"], 1)
        self.assertEqual(self.client.get(f"/api/annonces/{activite.id}/participants/").status_code, 200)

    def test_autre_citoyen_ne_modifie_pas_l_activite(self):
        activite = creer_activite(self.orga)
        self.client.force_authenticate(creer_citoyen("intrus"))
        self.assertEqual(self.client.patch(f"/api/annonces/{activite.id}/", {"titre": "X"}).status_code, 403)


class GroupeTests(APITestCase):
    def setUp(self):
        self.orga = creer_citoyen("orga")
        self.activite = creer_activite(self.orga, auto=False)
        self.p1 = creer_citoyen("p1")

    def creer_groupe(self):
        self.client.force_authenticate(self.orga)
        r = self.client.post(f"/api/annonces/{self.activite.id}/groupe/", {"nom": "Les footeux"})
        self.assertEqual(r.status_code, 201, r.data)
        return GroupeDiscussion.objects.get(id=r.data["id"])

    def test_seul_l_organisateur_cree_le_groupe(self):
        self.client.force_authenticate(self.p1)
        self.assertEqual(self.client.post(f"/api/annonces/{self.activite.id}/groupe/").status_code, 403)

    def test_participants_acceptes_rejoignent_et_quittent_automatiquement(self):
        cand = Candidature.objects.create(citoyen=self.p1.citoyen_profile, annonce=self.activite)
        groupe = self.creer_groupe()
        self.assertFalse(MembreGroupe.objects.filter(groupe=groupe, user=self.p1).exists())  # en attente

        # acceptation : ajout automatique + notification
        self.client.force_authenticate(self.orga)
        self.client.patch(f"/api/candidatures/mes/{cand.id}/", {"statut": "ACCEPTEE"})
        self.assertTrue(MembreGroupe.objects.filter(groupe=groupe, user=self.p1).exists())
        self.assertTrue(Notification.objects.filter(destinataire=self.p1, lien=f"/messages?groupe={groupe.id}").exists())

        # le membre écrit dans le groupe
        self.client.force_authenticate(self.p1)
        self.assertEqual(self.client.post(f"/api/groupes/{groupe.id}/messages/", {"contenu": "Salut !"}).status_code, 201)
        self.assertEqual(len(self.client.get("/api/groupes/").data), 1)

        # désistement : retrait automatique
        self.client.post(f"/api/candidatures/{cand.id}/annuler/")
        self.assertFalse(MembreGroupe.objects.filter(groupe=groupe, user=self.p1).exists())
        self.assertEqual(self.client.get(f"/api/groupes/{groupe.id}/messages/").status_code, 404)

    def test_non_membre_n_accede_pas(self):
        groupe = self.creer_groupe()
        self.client.force_authenticate(creer_citoyen("curieux"))
        self.assertEqual(self.client.get(f"/api/groupes/{groupe.id}/messages/").status_code, 404)

    def test_groupe_ferme_automatiquement_a_la_fin(self):
        groupe = self.creer_groupe()
        Annonce.objects.filter(id=self.activite.id).update(
            date_debut=timezone.now() - timedelta(hours=3), date_fin=timezone.now() - timedelta(hours=1)
        )
        r = self.client.get("/api/groupes/")
        self.assertTrue(r.data[0]["est_ferme"])
        groupe.refresh_from_db()
        self.assertTrue(groupe.ferme)
        self.assertTrue(MessageGroupe.objects.filter(groupe=groupe, systeme=True, contenu__startswith="🔒").exists())
        self.assertEqual(self.client.post(f"/api/groupes/{groupe.id}/messages/", {"contenu": "Encore ?"}).status_code, 400)


@override_settings(CHANNEL_LAYERS={"default": {"BACKEND": "channels.layers.InMemoryChannelLayer"}})
class GroupeWebSocketTests(TransactionTestCase):
    def test_seuls_les_membres_se_connectent_et_recoivent_les_messages(self):
        from .services import creer_groupe

        orga, intrus = creer_citoyen("orga"), creer_citoyen("intrus")
        groupe = creer_groupe(creer_activite(orga))

        async def connecter(user):
            from PFE_BackEnd.asgi import application

            comm = WebsocketCommunicator(
                application, f"/ws/groupe/{groupe.id}/?token={AccessToken.for_user(user)}",
                headers=[(b"origin", b"http://localhost:3000")],
            )
            ok, _ = await comm.connect()
            return comm, ok

        async def scenario():
            comm_intrus, ok_intrus = await connecter(intrus)
            if ok_intrus:
                await comm_intrus.disconnect()
            comm, ok = await connecter(orga)
            assert ok
            await comm.send_json_to({"message": "Rendez-vous à 17h"})
            recu = await comm.receive_json_from()
            await comm.disconnect()
            return ok_intrus, recu

        ok_intrus, recu = async_to_sync(scenario)()
        self.assertFalse(ok_intrus)
        self.assertEqual(recu["type"], "groupe_message")
        self.assertEqual(recu["message"]["contenu"], "Rendez-vous à 17h")


class HistoriqueTests(APITestCase):
    def test_historique_regroupe_organisation_participations_benevolat_et_avis(self):
        moi, orga_citoyen, asso = creer_citoyen("moi"), creer_citoyen("orga2"), creer_association("asso_h")
        mon_activite = creer_activite(moi)
        Candidature.objects.create(citoyen=orga_citoyen.citoyen_profile, annonce=mon_activite, statut="ACCEPTEE")
        activite_rejointe = creer_activite(orga_citoyen)
        Candidature.objects.create(citoyen=moi.citoyen_profile, annonce=activite_rejointe, statut="ACCEPTEE")
        mission = creer_annonce(asso, jours=-2)
        Candidature.objects.create(
            citoyen=moi.citoyen_profile, annonce=mission, statut="ACCEPTEE", presence_confirmee=True, heures_effectuees=3
        )
        Avis.objects.create(auteur=asso, cible=moi, annonce=mission, note=5)

        self.client.force_authenticate(moi)
        r = self.client.get("/api/historique/")
        self.assertEqual(r.status_code, 200)
        cats = sorted(e["categorie"] for e in r.data["evenements"])
        self.assertEqual(cats, ["AVIS_RECU", "BENEVOLAT", "ORGANISEE", "PARTICIPATION"])
        resume = r.data["resume"]
        self.assertEqual((resume["organisees"], resume["participations"], resume["benevolat"]), (1, 1, 1))
        self.assertEqual(resume["heures"], 3.0)
        organisee = next(e for e in r.data["evenements"] if e["categorie"] == "ORGANISEE")
        self.assertEqual(organisee["details"]["participants"], 1)
        benevolat = next(e for e in r.data["evenements"] if e["categorie"] == "BENEVOLAT")
        self.assertTrue(benevolat["details"]["attestation"])

    def test_historique_personnel(self):
        autre = creer_citoyen("autre_h")
        creer_activite(autre)
        self.client.force_authenticate(creer_citoyen("vide"))
        r = self.client.get("/api/historique/")
        self.assertEqual(r.data["evenements"], [])
        self.client.force_authenticate(None)
        self.assertEqual(self.client.get("/api/historique/").status_code, 401)


class JourJTests(APITestCase):
    def setUp(self):
        self.orga, self.moi = creer_citoyen("orga_j"), creer_citoyen("moi_j")
        now = timezone.now()
        # Activité en cours (commencée il y a 30 min) : toujours « jour J », quel que soit le fuseau
        self.en_cours = creer_activite(self.orga)
        Annonce.objects.filter(id=self.en_cours.id).update(date_debut=now - timedelta(minutes=30), date_fin=now + timedelta(hours=2))
        Candidature.objects.create(citoyen=self.moi.citoyen_profile, annonce=self.en_cours, statut="ACCEPTEE")
        # Activité dans 3 jours : pas aujourd'hui
        plus_tard = creer_activite(self.orga, jours=3)
        Candidature.objects.create(citoyen=self.moi.citoyen_profile, annonce=plus_tard, statut="ACCEPTEE")

    def test_participant_voit_son_jour_j_et_recoit_une_seule_notification(self):
        self.client.force_authenticate(self.moi)
        r = self.client.get("/api/aujourdhui/")
        self.assertEqual(r.status_code, 200)
        self.assertEqual([e["annonce"]["id"] for e in r.data["evenements"]], [self.en_cours.id])
        e = r.data["evenements"][0]
        self.assertEqual((e["role"], e["en_cours"], e["participants"]), ("PARTICIPANT", True, 1))
        self.client.get("/api/aujourdhui/")  # deuxième visite : pas de doublon
        self.assertEqual(Notification.objects.filter(destinataire=self.moi, titre__startswith="📅").count(), 1)

    def test_organisateur_voit_aussi_son_activite(self):
        self.client.force_authenticate(self.orga)
        r = self.client.get("/api/aujourdhui/")
        self.assertEqual(r.data["evenements"][0]["role"], "ORGANISATEUR")

    def test_candidature_en_attente_ou_terminee_exclue(self):
        attente = creer_citoyen("attente_j")
        Candidature.objects.create(citoyen=attente.citoyen_profile, annonce=self.en_cours, statut="EN_ATTENTE")
        self.client.force_authenticate(attente)
        self.assertEqual(self.client.get("/api/aujourdhui/").data["evenements"], [])
        Annonce.objects.filter(id=self.en_cours.id).update(date_fin=timezone.now() - timedelta(minutes=1))
        self.client.force_authenticate(self.moi)
        self.assertEqual(self.client.get("/api/aujourdhui/").data["evenements"], [])
