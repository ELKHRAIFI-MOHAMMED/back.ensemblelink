/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.11.16-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: solidarlink
-- ------------------------------------------------------
-- Server version	10.11.16-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `solidarlink`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `solidarlink` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

USE `solidarlink`;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES
(1,'Can add log entry',1,'add_logentry'),
(2,'Can change log entry',1,'change_logentry'),
(3,'Can delete log entry',1,'delete_logentry'),
(4,'Can view log entry',1,'view_logentry'),
(5,'Can add permission',3,'add_permission'),
(6,'Can change permission',3,'change_permission'),
(7,'Can delete permission',3,'delete_permission'),
(8,'Can view permission',3,'view_permission'),
(9,'Can add group',2,'add_group'),
(10,'Can change group',2,'change_group'),
(11,'Can delete group',2,'delete_group'),
(12,'Can view group',2,'view_group'),
(13,'Can add content type',4,'add_contenttype'),
(14,'Can change content type',4,'change_contenttype'),
(15,'Can delete content type',4,'delete_contenttype'),
(16,'Can view content type',4,'view_contenttype'),
(17,'Can add session',5,'add_session'),
(18,'Can change session',5,'change_session'),
(19,'Can delete session',5,'delete_session'),
(20,'Can view session',5,'view_session'),
(21,'Can add categorie',10,'add_categorie'),
(22,'Can change categorie',10,'change_categorie'),
(23,'Can delete categorie',10,'delete_categorie'),
(24,'Can view categorie',10,'view_categorie'),
(25,'Can add user',17,'add_user'),
(26,'Can change user',17,'change_user'),
(27,'Can delete user',17,'delete_user'),
(28,'Can view user',17,'view_user'),
(29,'Can add association profile',7,'add_associationprofile'),
(30,'Can change association profile',7,'change_associationprofile'),
(31,'Can delete association profile',7,'delete_associationprofile'),
(32,'Can view association profile',7,'view_associationprofile'),
(33,'Can add Annonce',6,'add_annonce'),
(34,'Can change Annonce',6,'change_annonce'),
(35,'Can delete Annonce',6,'delete_annonce'),
(36,'Can view Annonce',6,'view_annonce'),
(37,'Can add citoyen profile',11,'add_citoyenprofile'),
(38,'Can change citoyen profile',11,'change_citoyenprofile'),
(39,'Can delete citoyen profile',11,'delete_citoyenprofile'),
(40,'Can view citoyen profile',11,'view_citoyenprofile'),
(41,'Can add candidature',9,'add_candidature'),
(42,'Can change candidature',9,'change_candidature'),
(43,'Can delete candidature',9,'delete_candidature'),
(44,'Can view candidature',9,'view_candidature'),
(45,'Can add message',13,'add_message'),
(46,'Can change message',13,'change_message'),
(47,'Can delete message',13,'delete_message'),
(48,'Can view message',13,'view_message'),
(49,'Can add avis',8,'add_avis'),
(50,'Can change avis',8,'change_avis'),
(51,'Can delete avis',8,'delete_avis'),
(52,'Can view avis',8,'view_avis'),
(53,'Can add competence',12,'add_competence'),
(54,'Can change competence',12,'change_competence'),
(55,'Can delete competence',12,'delete_competence'),
(56,'Can view competence',12,'view_competence'),
(57,'Can add notification',14,'add_notification'),
(58,'Can change notification',14,'change_notification'),
(59,'Can delete notification',14,'delete_notification'),
(60,'Can view notification',14,'view_notification'),
(61,'Can add photo album',15,'add_photoalbum'),
(62,'Can change photo album',15,'change_photoalbum'),
(63,'Can delete photo album',15,'delete_photoalbum'),
(64,'Can view photo album',15,'view_photoalbum'),
(65,'Can add signalement',16,'add_signalement'),
(66,'Can change signalement',16,'change_signalement'),
(67,'Can delete signalement',16,'delete_signalement'),
(68,'Can view signalement',16,'view_signalement');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext DEFAULT NULL,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL CHECK (`action_flag` >= 0),
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_login_app_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_login_app_user_id` FOREIGN KEY (`user_id`) REFERENCES `login_app_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES
(1,'admin','logentry'),
(2,'auth','group'),
(3,'auth','permission'),
(4,'contenttypes','contenttype'),
(6,'login_app','annonce'),
(7,'login_app','associationprofile'),
(8,'login_app','avis'),
(9,'login_app','candidature'),
(10,'login_app','categorie'),
(11,'login_app','citoyenprofile'),
(12,'login_app','competence'),
(13,'login_app','message'),
(14,'login_app','notification'),
(15,'login_app','photoalbum'),
(16,'login_app','signalement'),
(17,'login_app','user'),
(5,'sessions','session');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES
(1,'contenttypes','0001_initial','2026-11-17 23:00:40.111321'),
(2,'contenttypes','0002_remove_content_type_name','2026-11-17 23:00:40.254105'),
(3,'auth','0001_initial','2026-11-17 23:00:40.565475'),
(4,'auth','0002_alter_permission_name_max_length','2026-11-17 23:00:40.632387'),
(5,'auth','0003_alter_user_email_max_length','2026-11-17 23:00:40.641604'),
(6,'auth','0004_alter_user_username_opts','2026-11-17 23:00:40.652026'),
(7,'auth','0005_alter_user_last_login_null','2026-11-17 23:00:40.662232'),
(8,'auth','0006_require_contenttypes_0002','2026-11-17 23:00:40.667733'),
(9,'auth','0007_alter_validators_add_error_messages','2026-11-17 23:00:40.676942'),
(10,'auth','0008_alter_user_username_max_length','2026-11-17 23:00:40.688850'),
(11,'auth','0009_alter_user_last_name_max_length','2026-11-17 23:00:40.699944'),
(12,'auth','0010_alter_group_name_max_length','2026-11-17 23:00:40.770902'),
(13,'auth','0011_update_proxy_permissions','2026-11-17 23:00:40.782316'),
(14,'auth','0012_alter_user_first_name_max_length','2026-11-17 23:00:40.792544'),
(15,'login_app','0001_initial','2026-11-17 23:00:41.996427'),
(16,'admin','0001_initial','2026-11-17 23:00:42.170864'),
(17,'admin','0002_logentry_remove_auto_add','2026-11-17 23:00:42.197503'),
(18,'admin','0003_logentry_add_action_flag_choices','2026-11-17 23:00:42.222418'),
(19,'login_app','0002_rename_prénom_citoyenprofile_prenom','2026-11-17 23:00:42.286523'),
(20,'login_app','0003_remove_associationprofile_feedback_and_more','2026-11-17 23:00:42.530125'),
(21,'login_app','0004_rename_fefeedback_associationprofile_feedback','2026-11-17 23:00:42.592130'),
(22,'login_app','0005_alter_associationprofile_feedback_and_more','2026-11-17 23:00:42.828323'),
(23,'login_app','0006_alter_associationprofile_logo','2026-11-17 23:00:42.928509'),
(24,'login_app','0007_remove_annonce_association_annonce_id_user','2026-11-17 23:00:43.415488'),
(25,'login_app','0008_alter_annonce_id_user','2026-11-17 23:00:43.788821'),
(26,'login_app','0009_rename_id_user_annonce_user_and_more','2026-11-17 23:00:44.524750'),
(27,'login_app','0010_alter_candidature_id','2026-11-17 23:00:44.608758'),
(28,'login_app','0011_alter_candidature_id','2026-11-17 23:00:44.687672'),
(29,'login_app','0012_candidature_id_user','2026-11-17 23:00:44.775451'),
(30,'login_app','0013_alter_annonce_options_remove_annonce_user_and_more','2026-11-17 23:00:46.251054'),
(31,'login_app','0014_solidarlink_v2','2026-11-17 23:00:53.795931'),
(32,'sessions','0001_initial','2026-11-17 23:00:53.886657');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_app_annonce`
--

DROP TABLE IF EXISTS `login_app_annonce`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `login_app_annonce` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `titre` varchar(255) NOT NULL,
  `description` longtext NOT NULL,
  `lieu` varchar(255) NOT NULL,
  `type` varchar(20) NOT NULL,
  `date_debut` datetime(6) NOT NULL,
  `date_fin` datetime(6) NOT NULL,
  `date_creation` datetime(6) NOT NULL,
  `categorie_id` bigint(20) DEFAULT NULL,
  `association_id` bigint(20) NOT NULL,
  `est_active` tinyint(1) NOT NULL,
  `image` varchar(100) DEFAULT NULL,
  `latitude` decimal(9,6) DEFAULT NULL,
  `longitude` decimal(9,6) DEFAULT NULL,
  `nombre_places` int(10) unsigned DEFAULT NULL CHECK (`nombre_places` >= 0),
  `objectif_don` decimal(12,2) DEFAULT NULL,
  `unite_don` varchar(40) NOT NULL,
  `ville` varchar(120) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `login_app_annonce_categorie_id_9966509e_fk_login_app` (`categorie_id`),
  KEY `login_app_annonce_association_id_2c93d0ed_fk` (`association_id`),
  CONSTRAINT `login_app_annonce_association_id_2c93d0ed_fk` FOREIGN KEY (`association_id`) REFERENCES `login_app_associationprofile` (`id`),
  CONSTRAINT `login_app_annonce_categorie_id_9966509e_fk_login_app` FOREIGN KEY (`categorie_id`) REFERENCES `login_app_categorie` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_app_annonce`
--

LOCK TABLES `login_app_annonce` WRITE;
/*!40000 ALTER TABLE `login_app_annonce` DISABLE KEYS */;
INSERT INTO `login_app_annonce` VALUES
(1,'Distribution de colis alimentaires','Préparation et distribution de 200 colis pour les familles inscrites.','Maison des associations — Lyon','APPEL_BENEVOLAT','2026-10-27 09:00:00.000000','2026-10-27 13:00:00.000000','2026-11-17 23:02:45.812869',1,1,1,'',45.769430,4.798243,8,NULL,'','Lyon'),
(2,'Grand nettoyage des berges de la Loire','Matinée de ramassage des déchets, gants et sacs fournis. Pique-nique offert !','Maison des associations — Nantes','EVENEMENT','2026-11-03 09:00:00.000000','2026-11-03 12:00:00.000000','2026-11-17 23:02:45.822807',2,2,1,'',47.201518,-1.553172,30,NULL,'','Nantes'),
(3,'Stage de révisions du brevet','Accompagner des collégiens de 3e en maths et français pendant une journée.','Maison des associations — Paris','APPEL_BENEVOLAT','2026-11-07 09:00:00.000000','2026-11-07 15:00:00.000000','2026-11-17 23:02:45.829104',3,3,1,'',48.860275,2.369482,5,NULL,'','Paris'),
(4,'Après-midi jeux en EHPAD','Belote, scrabble et goûter partagé avec les résidents de la résidence Les Tilleuls.','Local associatif — Bordeaux','EVENEMENT','2026-11-10 09:00:00.000000','2026-11-10 12:00:00.000000','2026-11-17 23:02:45.835085',5,5,1,'',44.821026,-0.572059,6,NULL,'','Bordeaux'),
(5,'Tournoi de basket fauteuil','Accueil du public, arbitrage de table et buvette.','Maison des associations — Toulouse','EVENEMENT','2026-11-12 09:00:00.000000','2026-11-12 14:00:00.000000','2026-11-17 23:02:45.840795',6,6,1,'',43.620228,1.416973,12,NULL,'','Toulouse'),
(6,'Cuisine solidaire du samedi','Préparer 150 repas chauds avec notre cheffe bénévole. Tablier fourni.','Local associatif — Lyon','APPEL_BENEVOLAT','2026-11-21 09:00:00.000000','2026-11-21 13:00:00.000000','2026-11-17 23:02:45.846640',1,1,1,'',45.754415,4.808138,6,NULL,'','Lyon'),
(7,'Collecte de denrées pour l\'hiver','Pâtes, riz, conserves, produits d\'hygiène : chaque kilo compte.','Parc — Lyon','DON','2026-11-19 08:00:00.000000','2026-11-22 08:00:00.000000','2026-11-17 23:02:45.853455',1,1,1,'',45.740133,4.826094,NULL,500.00,'kg','Lyon'),
(8,'Plantation d\'une forêt urbaine','Plantation de 600 arbres selon la méthode Miyawaki à Rezé.','Parc — Nantes','EVENEMENT','2026-11-28 09:00:00.000000','2026-11-28 14:00:00.000000','2026-11-17 23:02:45.858838',2,2,1,'',47.239250,-1.545302,40,NULL,'','Nantes'),
(9,'Atelier réparation de vélos','Aider les habitants à réparer eux-mêmes leur vélo. Outils fournis.','Maison des associations — Nantes','APPEL_BENEVOLAT','2026-11-23 09:00:00.000000','2026-11-23 12:00:00.000000','2026-11-17 23:02:45.864414',2,2,1,'',47.232184,-1.550702,4,NULL,'','Nantes'),
(10,'Aide aux devoirs hebdomadaire','Tous les mardis de 17h à 19h, niveau primaire et collège.','Local associatif — Paris','APPEL_BENEVOLAT','2026-11-20 09:00:00.000000','2026-11-20 11:00:00.000000','2026-11-17 23:02:45.871017',3,3,1,'',48.831328,2.335654,10,NULL,'','Paris'),
(11,'Dons de livres jeunesse','Albums, romans jeunesse et BD en bon état pour notre bibliothèque.','Parc — Paris','DON','2026-11-18 08:00:00.000000','2026-11-28 08:00:00.000000','2026-11-17 23:02:45.878477',3,3,1,'',48.861241,2.368566,NULL,300.00,'livres','Paris'),
(12,'Atelier initiation au code pour ados','Animer un atelier Scratch / Python pour 12 adolescents.','Maison des associations — Paris','APPEL_BENEVOLAT','2026-12-03 09:00:00.000000','2026-12-03 12:00:00.000000','2026-11-17 23:02:45.882884',3,3,1,'',48.866276,2.374045,3,NULL,'','Paris'),
(13,'Promenade des chiens du refuge','Sortir nos pensionnaires pour une balade au parc Borély.','Maison des associations — Marseille','APPEL_BENEVOLAT','2026-11-19 09:00:00.000000','2026-11-19 11:00:00.000000','2026-11-17 23:02:45.889986',4,4,1,'',43.317819,5.399119,8,NULL,'','Marseille'),
(14,'Collecte de couvertures et croquettes','L\'hiver arrive : couvertures, paniers et croquettes sont les bienvenus.','Local associatif — Marseille','DON','2026-11-18 08:00:00.000000','2026-12-02 08:00:00.000000','2026-11-17 23:02:45.895721',4,4,1,'',43.283178,5.380655,NULL,120.00,'couvertures','Marseille'),
(15,'Journée portes ouvertes adoption','Accueil des visiteurs, photos des animaux et stand d\'information.','Parc — Marseille','EVENEMENT','2026-12-06 09:00:00.000000','2026-12-06 15:00:00.000000','2026-11-17 23:02:45.900987',4,4,1,'',43.276259,5.358222,10,NULL,'','Marseille'),
(16,'Initiation tablette pour seniors','Apprendre aux aînés à appeler leurs proches en visio.','Parc — Bordeaux','APPEL_BENEVOLAT','2026-11-25 09:00:00.000000','2026-11-25 11:00:00.000000','2026-11-17 23:02:45.908430',5,5,1,'',44.849909,-0.564516,4,NULL,'','Bordeaux'),
(17,'Repas de Noël partagé','Préparer et partager un repas festif avec 60 personnes âgées isolées.','Maison des associations — Bordeaux','EVENEMENT','2026-12-23 09:00:00.000000','2026-12-23 13:00:00.000000','2026-11-17 23:02:45.914950',5,5,1,'',44.844348,-0.605509,15,NULL,'','Bordeaux'),
(18,'Accompagnateurs course inclusive','Guider des coureurs malvoyants sur le parcours de 5 km.','Salle municipale — Toulouse','APPEL_BENEVOLAT','2026-11-30 09:00:00.000000','2026-11-30 13:00:00.000000','2026-11-17 23:02:45.921843',6,6,1,'',43.584504,1.434556,20,NULL,'','Toulouse'),
(19,'Collecte d\'équipements sportifs','Ballons, raquettes, chaussures en bon état.','Salle municipale — Toulouse','DON','2026-11-20 08:00:00.000000','2026-12-10 08:00:00.000000','2026-11-17 23:02:45.928196',6,6,1,'',43.615777,1.471628,NULL,80.00,'équipements','Toulouse'),
(20,'Animation multisport en IME','Encadrer un après-midi multisport avec des jeunes de l\'institut médico-éducatif.','Maison des associations — Toulouse','APPEL_BENEVOLAT','2026-11-26 09:00:00.000000','2026-11-26 12:00:00.000000','2026-11-17 23:02:45.932874',6,6,1,'',43.588443,1.406768,2,NULL,'','Toulouse');
/*!40000 ALTER TABLE `login_app_annonce` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_app_annonce_competences_requises`
--

DROP TABLE IF EXISTS `login_app_annonce_competences_requises`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `login_app_annonce_competences_requises` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `annonce_id` bigint(20) NOT NULL,
  `competence_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `login_app_annonce_compet_annonce_id_competence_id_f0b8bcd8_uniq` (`annonce_id`,`competence_id`),
  KEY `login_app_annonce_co_competence_id_8b30ded6_fk_login_app` (`competence_id`),
  CONSTRAINT `login_app_annonce_co_annonce_id_52d8664f_fk_login_app` FOREIGN KEY (`annonce_id`) REFERENCES `login_app_annonce` (`id`),
  CONSTRAINT `login_app_annonce_co_competence_id_8b30ded6_fk_login_app` FOREIGN KEY (`competence_id`) REFERENCES `login_app_competence` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_app_annonce_competences_requises`
--

LOCK TABLES `login_app_annonce_competences_requises` WRITE;
/*!40000 ALTER TABLE `login_app_annonce_competences_requises` DISABLE KEYS */;
INSERT INTO `login_app_annonce_competences_requises` VALUES
(1,1,2),
(2,2,11),
(3,3,4),
(4,4,3),
(6,5,3),
(5,5,10),
(7,6,1),
(8,8,11),
(9,9,7),
(10,10,4),
(11,12,5),
(13,15,6),
(12,15,12),
(14,16,5),
(15,17,1),
(16,17,3),
(17,18,10),
(18,20,3);
/*!40000 ALTER TABLE `login_app_annonce_competences_requises` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_app_associationprofile`
--

DROP TABLE IF EXISTS `login_app_associationprofile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `login_app_associationprofile` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `nom` varchar(255) NOT NULL,
  `description` longtext NOT NULL,
  `contact` varchar(255) NOT NULL,
  `logo` varchar(100) DEFAULT NULL,
  `reseaux_sociaux` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`reseaux_sociaux`)),
  `user_id` bigint(20) NOT NULL,
  `adresse` varchar(255) NOT NULL,
  `date_creation` datetime(6) NOT NULL,
  `document_justificatif` varchar(100) DEFAULT NULL,
  `motif_rejet` longtext NOT NULL,
  `site_web` varchar(200) NOT NULL,
  `statut_verification` varchar(20) NOT NULL,
  `telephone` varchar(30) NOT NULL,
  `ville` varchar(120) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `login_app_associatio_user_id_3a4787c6_fk_login_app` FOREIGN KEY (`user_id`) REFERENCES `login_app_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_app_associationprofile`
--

LOCK TABLES `login_app_associationprofile` WRITE;
/*!40000 ALTER TABLE `login_app_associationprofile` DISABLE KEYS */;
INSERT INTO `login_app_associationprofile` VALUES
(1,'Le Panier Solidaire','Épicerie solidaire et distributions de repas pour les familles en difficulté du 7e arrondissement.','contact@paniersolidaire.org','','{\"instagram\": \"https://instagram.com/panier_solidaire\"}',2,'12 rue de la Solidarité, Lyon','2025-11-25 23:00:00.000000','','','https://panier-solidaire.example.org','VERIFIEE','01 23 45 67 89','Lyon'),
(2,'Vert Demain','Nettoyage des berges, jardins partagés et ateliers zéro déchet le long de la Loire.','contact@vertdemain.org','','{\"instagram\": \"https://instagram.com/vert_demain\"}',3,'12 rue de la Solidarité, Nantes','2026-08-22 23:00:00.000000','','','https://vert-demain.example.org','VERIFIEE','01 23 45 67 89','Nantes'),
(3,'Lire Ensemble','Soutien scolaire gratuit et ateliers lecture pour les enfants de 6 à 15 ans.','contact@lireensemble.org','','{\"instagram\": \"https://instagram.com/lire_ensemble\"}',4,'12 rue de la Solidarité, Paris','2026-10-06 23:00:00.000000','','','https://lire-ensemble.example.org','VERIFIEE','01 23 45 67 89','Paris'),
(4,'Pattes & Cœurs','Refuge associatif : soins, promenades et adoptions responsables de chiens et chats.','contact@pattescoeurs.org','','{\"instagram\": \"https://instagram.com/pattes_coeurs\"}',5,'12 rue de la Solidarité, Marseille','2026-05-31 23:00:00.000000','','','https://pattes-coeurs.example.org','VERIFIEE','01 23 45 67 89','Marseille'),
(5,'Les Aînés Connectés','Lutte contre l\'isolement des personnes âgées : visites, appels et initiation au numérique.','contact@ainesconnectes.org','','{\"instagram\": \"https://instagram.com/aines_connectes\"}',6,'12 rue de la Solidarité, Bordeaux','2026-06-15 23:00:00.000000','','','https://aines-connectes.example.org','VERIFIEE','01 23 45 67 89','Bordeaux'),
(6,'Sport Pour Tous 31','Rendre le sport accessible à tous, en particulier aux personnes en situation de handicap.','contact@sportpourtous.org','','{\"instagram\": \"https://instagram.com/sport_pour_tous\"}',7,'12 rue de la Solidarité, Toulouse','2026-06-26 23:00:00.000000','','','https://sport-pour-tous.example.org','VERIFIEE','01 23 45 67 89','Toulouse'),
(7,'Toit d\'Abord','Maraudes et accompagnement vers le logement des personnes sans-abri.','contact@toitdabord.org','','{\"instagram\": \"https://instagram.com/toit_dabord\"}',8,'12 rue de la Solidarité, Lille','2026-08-08 23:00:00.000000','','','https://toit-dabord.example.org','EN_ATTENTE','01 23 45 67 89','Lille'),
(8,'Collectif Récup\'Art','Ateliers artistiques à partir de matériaux recyclés, ouverts à tous les quartiers.','contact@recupart.org','','{\"instagram\": \"https://instagram.com/recup_art\"}',9,'12 rue de la Solidarité, Paris','2026-08-27 23:00:00.000000','','','https://recup-art.example.org','EN_ATTENTE','01 23 45 67 89','Paris');
/*!40000 ALTER TABLE `login_app_associationprofile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_app_avis`
--

DROP TABLE IF EXISTS `login_app_avis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `login_app_avis` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `note` smallint(5) unsigned NOT NULL CHECK (`note` >= 0),
  `commentaire` longtext NOT NULL,
  `date_creation` datetime(6) NOT NULL,
  `annonce_id` bigint(20) NOT NULL,
  `auteur_id` bigint(20) NOT NULL,
  `cible_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `avis_unique` (`auteur_id`,`cible_id`,`annonce_id`),
  KEY `login_app_avis_annonce_id_57b341e6_fk_login_app_annonce_id` (`annonce_id`),
  KEY `login_app_avis_cible_id_ce75e3f8_fk_login_app_user_id` (`cible_id`),
  CONSTRAINT `login_app_avis_annonce_id_57b341e6_fk_login_app_annonce_id` FOREIGN KEY (`annonce_id`) REFERENCES `login_app_annonce` (`id`),
  CONSTRAINT `login_app_avis_auteur_id_0b1d7831_fk_login_app_user_id` FOREIGN KEY (`auteur_id`) REFERENCES `login_app_user` (`id`),
  CONSTRAINT `login_app_avis_cible_id_ce75e3f8_fk_login_app_user_id` FOREIGN KEY (`cible_id`) REFERENCES `login_app_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_app_avis`
--

LOCK TABLES `login_app_avis` WRITE;
/*!40000 ALTER TABLE `login_app_avis` DISABLE KEYS */;
INSERT INTO `login_app_avis` VALUES
(1,5,'Super énergie, à refaire !','2026-11-17 23:02:46.181763',1,2,16),
(2,5,'Belle expérience, je recommande !','2026-11-17 23:02:46.189042',1,16,2),
(3,5,'Bénévole ponctuel·le et très investi·e, merci !','2026-11-17 23:02:46.195036',1,2,17),
(4,4,'Super énergie, à refaire !','2026-11-17 23:02:46.200242',1,2,10),
(5,5,'Bénévole ponctuel·le et très investi·e, merci !','2026-11-17 23:02:46.210377',2,3,18),
(6,4,'Équipe accueillante et mission bien organisée.','2026-11-17 23:02:46.212146',2,18,3),
(7,4,'Bénévole ponctuel·le et très investi·e, merci !','2026-11-17 23:02:46.218174',2,3,19),
(8,5,'Équipe accueillante et mission bien organisée.','2026-11-17 23:02:46.219880',2,19,3),
(9,5,'Bénévole ponctuel·le et très investi·e, merci !','2026-11-17 23:02:46.225448',2,3,13),
(10,4,'Belle expérience, je recommande !','2026-11-17 23:02:46.227042',2,13,3),
(11,5,'Super énergie, à refaire !','2026-11-17 23:02:46.240435',3,4,15),
(12,5,'Équipe accueillante et mission bien organisée.','2026-11-17 23:02:46.243155',3,15,4),
(13,4,'Super énergie, à refaire !','2026-11-17 23:02:46.251294',3,4,16),
(14,4,'Très bon encadrement, j\'y retourne.','2026-11-17 23:02:46.253530',3,16,4),
(15,5,'Très fiable, un vrai plaisir.','2026-11-17 23:02:46.261043',3,4,11),
(16,5,'Équipe accueillante et mission bien organisée.','2026-11-17 23:02:46.263320',3,11,4),
(17,4,'Très fiable, un vrai plaisir.','2026-11-17 23:02:46.274271',4,6,19),
(18,5,'Équipe accueillante et mission bien organisée.','2026-11-17 23:02:46.276246',4,19,6),
(19,5,'Bénévole ponctuel·le et très investi·e, merci !','2026-11-17 23:02:46.282672',4,6,14),
(20,4,'Très fiable, un vrai plaisir.','2026-11-17 23:02:46.292138',5,7,12),
(21,5,'Belle expérience, je recommande !','2026-11-17 23:02:46.293858',5,12,7),
(22,4,'Très fiable, un vrai plaisir.','2026-11-17 23:02:46.299332',5,7,15),
(23,4,'Très bon encadrement, j\'y retourne.','2026-11-17 23:02:46.301034',5,15,7);
/*!40000 ALTER TABLE `login_app_avis` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_app_candidature`
--

DROP TABLE IF EXISTS `login_app_candidature`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `login_app_candidature` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `statut` varchar(20) NOT NULL,
  `message` longtext NOT NULL,
  `date_candidature` datetime(6) NOT NULL,
  `note_engagement` smallint(5) unsigned DEFAULT NULL,
  `annonce_id` bigint(20) NOT NULL,
  `citoyen_id` bigint(20) NOT NULL,
  `code_presence` uuid NOT NULL,
  `date_reponse` datetime(6) DEFAULT NULL,
  `heures_effectuees` decimal(6,2) NOT NULL,
  `presence_confirmee` tinyint(1) NOT NULL,
  `quantite_don` decimal(12,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `login_app_candidature_code_presence_272fbbe2_uniq` (`code_presence`),
  UNIQUE KEY `candidature_unique_par_annonce` (`citoyen_id`,`annonce_id`),
  KEY `login_app_candidatur_annonce_id_bc362361_fk_login_app` (`annonce_id`),
  CONSTRAINT `login_app_candidatur_annonce_id_bc362361_fk_login_app` FOREIGN KEY (`annonce_id`) REFERENCES `login_app_annonce` (`id`),
  CONSTRAINT `login_app_candidature_citoyen_id_d86931de_fk` FOREIGN KEY (`citoyen_id`) REFERENCES `login_app_citoyenprofile` (`id`),
  CONSTRAINT `login_app_candidature_note_engagement_d84c1d3e_check` CHECK (`note_engagement` >= 0)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_app_candidature`
--

LOCK TABLES `login_app_candidature` WRITE;
/*!40000 ALTER TABLE `login_app_candidature` DISABLE KEYS */;
INSERT INTO `login_app_candidature` VALUES
(1,'ACCEPTEE','J\'ai déjà participé à ce type de mission, je serais ravi·e d\'aider.','2026-11-17 23:02:45.947727',4,1,1,'56652b29-a818-4e0b-98bf-eec7d74a5ccf','2026-10-25 09:00:00.000000',4.00,1,NULL),
(2,'ACCEPTEE','Bonjour, je suis disponible et motivé·e !','2026-11-17 23:02:45.955665',5,1,8,'abc0f0d8-b01d-4348-b8e1-64b423d0f184','2026-10-25 09:00:00.000000',4.00,1,NULL),
(3,'ACCEPTEE','Disponible toute la journée, n\'hésitez pas à me contacter.','2026-11-17 23:02:45.961551',5,1,7,'59526075-6f2a-4dfd-b4e5-fb2d34a3c005','2026-10-25 09:00:00.000000',4.00,1,NULL),
(4,'REFUSEE','Bonjour, je suis disponible et motivé·e !','2026-11-17 23:02:45.963784',NULL,1,5,'3c10e3bc-40de-4955-beea-1da7794588e9','2026-10-25 09:00:00.000000',0.00,0,NULL),
(5,'ACCEPTEE','Disponible toute la journée, n\'hésitez pas à me contacter.','2026-11-17 23:02:45.968853',5,2,4,'e5ec6d12-2af2-49b6-8f17-f5c1b295a4cf','2026-11-01 09:00:00.000000',3.00,1,NULL),
(6,'ACCEPTEE','Bonjour, je suis disponible et motivé·e !','2026-11-17 23:02:45.973695',5,2,10,'f4eb7a80-7c2f-4b2f-a63c-fd987a33d808','2026-11-01 09:00:00.000000',3.00,1,NULL),
(7,'ACCEPTEE','Bonjour, je suis disponible et motivé·e !','2026-11-17 23:02:45.979021',4,2,9,'ffc9d0cd-e620-443d-9459-0f75511b9b43','2026-11-01 09:00:00.000000',3.00,1,NULL),
(8,'REFUSEE','Disponible toute la journée, n\'hésitez pas à me contacter.','2026-11-17 23:02:45.981103',NULL,2,5,'0e3de280-f6bb-4402-9f70-825d1e39a74c','2026-11-01 09:00:00.000000',0.00,0,NULL),
(9,'ACCEPTEE','Disponible toute la journée, n\'hésitez pas à me contacter.','2026-11-17 23:02:45.987597',5,3,2,'27e98946-7ce4-4dba-a1f5-d8ca3d508409','2026-11-05 09:00:00.000000',6.00,1,NULL),
(10,'ACCEPTEE','Disponible toute la journée, n\'hésitez pas à me contacter.','2026-11-17 23:02:45.995266',5,3,7,'5091c4e1-51fb-46bd-93dc-43f0dbb6404d','2026-11-05 09:00:00.000000',6.00,1,NULL),
(11,'ACCEPTEE','J\'ai déjà participé à ce type de mission, je serais ravi·e d\'aider.','2026-11-17 23:02:46.000905',4,3,6,'c2dae172-822e-48a9-acfd-6b9fced06b7f','2026-11-05 09:00:00.000000',6.00,1,NULL),
(12,'REFUSEE','Bonjour, je suis disponible et motivé·e !','2026-11-17 23:02:46.003375',NULL,3,8,'26863720-cb6d-491b-a8ee-0e8176c0ee93','2026-11-05 09:00:00.000000',0.00,0,NULL),
(13,'ACCEPTEE','Bonjour, je suis disponible et motivé·e !','2026-11-17 23:02:46.008474',4,4,5,'5bac1ca6-ceac-4d8c-90e9-3bb1988f63d3','2026-11-08 09:00:00.000000',3.00,1,NULL),
(14,'ACCEPTEE','Bonjour, je suis disponible et motivé·e !','2026-11-17 23:02:46.013444',4,4,10,'5d821941-9530-4a78-94e9-69d4d180f1f9','2026-11-08 09:00:00.000000',3.00,1,NULL),
(15,'REFUSEE','Disponible toute la journée, n\'hésitez pas à me contacter.','2026-11-17 23:02:46.015431',NULL,4,9,'ec871129-fbec-4020-9438-c307bca514a4','2026-11-08 09:00:00.000000',0.00,0,NULL),
(16,'ACCEPTEE','Disponible toute la journée, n\'hésitez pas à me contacter.','2026-11-17 23:02:46.020626',4,5,6,'0abee0ec-f621-4766-b857-619084fee37f','2026-11-10 09:00:00.000000',5.00,1,NULL),
(17,'ACCEPTEE','J\'ai déjà participé à ce type de mission, je serais ravi·e d\'aider.','2026-11-17 23:02:46.025958',5,5,3,'86672ff8-b285-4f28-be3a-bca65d9aeede','2026-11-10 09:00:00.000000',5.00,1,NULL),
(18,'REFUSEE','Disponible toute la journée, n\'hésitez pas à me contacter.','2026-11-17 23:02:46.028355',NULL,5,8,'e7f0fd09-eea8-4dcb-a518-b74bb023f454','2026-11-10 09:00:00.000000',0.00,0,NULL),
(19,'EN_ATTENTE','Disponible toute la journée, n\'hésitez pas à me contacter.','2026-11-17 23:02:46.030783',NULL,6,1,'f9839ef4-526e-4ce7-aee9-a76b94510935',NULL,0.00,0,NULL),
(20,'EN_ATTENTE','Disponible toute la journée, n\'hésitez pas à me contacter.','2026-11-17 23:02:46.033000',NULL,6,8,'43865809-7692-4ab9-a44c-726ddd6aaa4e',NULL,0.00,0,NULL),
(21,'ACCEPTEE','Bonjour, je suis disponible et motivé·e !','2026-11-17 23:02:46.038524',NULL,6,10,'d53bd674-cfed-4959-9274-06f9a43656ff','2026-11-19 09:00:00.000000',0.00,0,NULL),
(22,'ACCEPTEE','Disponible toute la journée, n\'hésitez pas à me contacter.','2026-11-17 23:02:46.043806',NULL,6,6,'c45c122e-6c48-44d3-8c27-7be0e4328f73','2026-11-19 09:00:00.000000',0.00,0,NULL),
(23,'ACCEPTEE','Disponible toute la journée, n\'hésitez pas à me contacter.','2026-11-17 23:02:46.045866',NULL,7,1,'37dfb659-6f6b-4542-9004-422d532199d0','2026-11-17 08:00:00.000000',0.00,0,15.00),
(24,'ACCEPTEE','Bonjour, je suis disponible et motivé·e !','2026-11-17 23:02:46.047970',NULL,7,8,'062bc092-66cb-4c7e-b13e-87e8c08340c4','2026-11-17 08:00:00.000000',0.00,0,15.00),
(25,'ACCEPTEE','J\'ai déjà participé à ce type de mission, je serais ravi·e d\'aider.','2026-11-17 23:02:46.050063',NULL,7,6,'4ded031e-aa17-445b-9f1e-e5e9d83236e7','2026-11-17 08:00:00.000000',0.00,0,10.00),
(26,'ACCEPTEE','J\'ai déjà participé à ce type de mission, je serais ravi·e d\'aider.','2026-11-17 23:02:46.052192',NULL,7,9,'54c4920b-53ab-4005-a912-15ae89bca5b8','2026-11-17 08:00:00.000000',0.00,0,5.00),
(27,'EN_ATTENTE','Disponible toute la journée, n\'hésitez pas à me contacter.','2026-11-17 23:02:46.054291',NULL,8,4,'7118c82c-e8f2-4d7e-911c-979837f18fdc',NULL,0.00,0,NULL),
(28,'EN_ATTENTE','Disponible toute la journée, n\'hésitez pas à me contacter.','2026-11-17 23:02:46.056286',NULL,8,10,'9b41c56d-9945-44fc-a1af-3cdc9e1fbcbb',NULL,0.00,0,NULL),
(29,'EN_ATTENTE','Disponible toute la journée, n\'hésitez pas à me contacter.','2026-11-17 23:02:46.058262',NULL,8,6,'8887b3ab-08da-481c-9387-d18640ee0d6a',NULL,0.00,0,NULL),
(30,'ACCEPTEE','Disponible toute la journée, n\'hésitez pas à me contacter.','2026-11-17 23:02:46.062694',NULL,8,9,'84480f97-af2c-4e66-84d5-97f4d07d7b96','2026-11-26 09:00:00.000000',0.00,0,NULL),
(31,'EN_ATTENTE','Bonjour, je suis disponible et motivé·e !','2026-11-17 23:02:46.064566',NULL,9,4,'30fa7961-b001-4441-8b67-dc0a96fb0fd0',NULL,0.00,0,NULL),
(32,'ACCEPTEE','Disponible toute la journée, n\'hésitez pas à me contacter.','2026-11-17 23:02:46.069413',NULL,9,10,'352be143-9501-45c4-b65d-99db9e39869e','2026-11-21 09:00:00.000000',0.00,0,NULL),
(33,'EN_ATTENTE','Disponible toute la journée, n\'hésitez pas à me contacter.','2026-11-17 23:02:46.071344',NULL,9,5,'20ec3485-cf62-4d05-a636-99c99e09aa6e',NULL,0.00,0,NULL),
(34,'EN_ATTENTE','J\'ai déjà participé à ce type de mission, je serais ravi·e d\'aider.','2026-11-17 23:02:46.073113',NULL,9,2,'546c978e-0560-44fe-96e9-fd529f896402',NULL,0.00,0,NULL),
(35,'EN_ATTENTE','J\'ai déjà participé à ce type de mission, je serais ravi·e d\'aider.','2026-11-17 23:02:46.074933',NULL,10,2,'79964cbd-f2a1-472a-85a7-2fe05de3d851',NULL,0.00,0,NULL),
(36,'EN_ATTENTE','Bonjour, je suis disponible et motivé·e !','2026-11-17 23:02:46.076783',NULL,10,7,'a7c3e10e-092a-4880-a17c-a257edc26ccc',NULL,0.00,0,NULL),
(37,'EN_ATTENTE','Disponible toute la journée, n\'hésitez pas à me contacter.','2026-11-17 23:02:46.078528',NULL,10,1,'9d97cb6b-fe88-420c-acae-8492b2f811cf',NULL,0.00,0,NULL),
(38,'EN_ATTENTE','Bonjour, je suis disponible et motivé·e !','2026-11-17 23:02:46.080355',NULL,10,10,'06a052f6-7ae9-4f3c-8b44-ffd78f584003',NULL,0.00,0,NULL),
(39,'ACCEPTEE','Bonjour, je suis disponible et motivé·e !','2026-11-17 23:02:46.082068',NULL,11,2,'5c04ee4c-0baa-4dd7-ae01-16df008a5e33','2026-11-16 08:00:00.000000',0.00,0,30.00),
(40,'ACCEPTEE','Bonjour, je suis disponible et motivé·e !','2026-11-17 23:02:46.083752',NULL,11,7,'273dc9c2-247c-4c18-94e5-c23db814bc04','2026-11-16 08:00:00.000000',0.00,0,10.00),
(41,'ACCEPTEE','Disponible toute la journée, n\'hésitez pas à me contacter.','2026-11-17 23:02:46.085548',NULL,11,10,'700491e8-ff9b-4e30-bc96-ca052ad7a03a','2026-11-16 08:00:00.000000',0.00,0,20.00),
(42,'ACCEPTEE','Disponible toute la journée, n\'hésitez pas à me contacter.','2026-11-17 23:02:46.087438',NULL,11,9,'2dcc8176-110b-4e7b-8532-1465a15c871a','2026-11-16 08:00:00.000000',0.00,0,10.00),
(43,'ACCEPTEE','J\'ai déjà participé à ce type de mission, je serais ravi·e d\'aider.','2026-11-17 23:02:46.091617',NULL,12,2,'9e6cbddf-cc44-42c4-b758-7f7bbfa8b8a5','2026-12-01 09:00:00.000000',0.00,0,NULL),
(44,'EN_ATTENTE','Disponible toute la journée, n\'hésitez pas à me contacter.','2026-11-17 23:02:46.093541',NULL,12,7,'f0625944-d16b-4af2-9edc-6c90ea323627',NULL,0.00,0,NULL),
(45,'ACCEPTEE','Disponible toute la journée, n\'hésitez pas à me contacter.','2026-11-17 23:02:46.097681',NULL,12,6,'47137de8-6f16-48a3-8b60-c6c11655f631','2026-12-01 09:00:00.000000',0.00,0,NULL),
(46,'EN_ATTENTE','Disponible toute la journée, n\'hésitez pas à me contacter.','2026-11-17 23:02:46.099615',NULL,12,10,'ee9c61e4-98ba-4cbf-a787-e2a373769740',NULL,0.00,0,NULL),
(47,'ACCEPTEE','Disponible toute la journée, n\'hésitez pas à me contacter.','2026-11-17 23:02:46.105492',NULL,13,3,'9e77ec47-5aed-4a8f-928e-20a1da81a95f','2026-11-17 09:00:00.000000',0.00,0,NULL),
(48,'EN_ATTENTE','J\'ai déjà participé à ce type de mission, je serais ravi·e d\'aider.','2026-11-17 23:02:46.107526',NULL,13,6,'82bf1cd8-68d4-456f-9cdb-4082d8b60ec5',NULL,0.00,0,NULL),
(49,'ACCEPTEE','J\'ai déjà participé à ce type de mission, je serais ravi·e d\'aider.','2026-11-17 23:02:46.111740',NULL,13,8,'dea32a2b-d52d-420b-8a3b-78cf610845cc','2026-11-17 09:00:00.000000',0.00,0,NULL),
(50,'ACCEPTEE','Bonjour, je suis disponible et motivé·e !','2026-11-17 23:02:46.113540',NULL,14,3,'ca68e3c8-733c-47aa-81c5-ea238d37829e','2026-11-16 08:00:00.000000',0.00,0,5.00),
(51,'ACCEPTEE','J\'ai déjà participé à ce type de mission, je serais ravi·e d\'aider.','2026-11-17 23:02:46.115147',NULL,14,2,'204e5f83-8336-48ab-b560-e1016c76ec0f','2026-11-16 08:00:00.000000',0.00,0,5.00),
(52,'ACCEPTEE','Disponible toute la journée, n\'hésitez pas à me contacter.','2026-11-17 23:02:46.117000',NULL,14,5,'4ab7400b-9a89-402a-aa4c-aecee62d0e61','2026-11-16 08:00:00.000000',0.00,0,30.00),
(53,'EN_ATTENTE','Bonjour, je suis disponible et motivé·e !','2026-11-17 23:02:46.118971',NULL,15,3,'f3952b2c-c334-46f3-a86c-ad7a49a30e78',NULL,0.00,0,NULL),
(54,'ACCEPTEE','Disponible toute la journée, n\'hésitez pas à me contacter.','2026-11-17 23:02:46.123649',NULL,15,5,'f4682d99-cf07-421a-9d95-59708082d567','2026-12-04 09:00:00.000000',0.00,0,NULL),
(55,'EN_ATTENTE','Bonjour, je suis disponible et motivé·e !','2026-11-17 23:02:46.125641',NULL,15,10,'a087b9af-09be-478b-9499-c5b55f50e4c0',NULL,0.00,0,NULL),
(56,'EN_ATTENTE','Bonjour, je suis disponible et motivé·e !','2026-11-17 23:02:46.127712',NULL,16,5,'b7c50b6c-f692-4a64-ac1a-6cfbd384c6b0',NULL,0.00,0,NULL),
(57,'ACCEPTEE','Bonjour, je suis disponible et motivé·e !','2026-11-17 23:02:46.132741',NULL,16,2,'824280f7-9f14-4f2b-867e-cf6b99804cdb','2026-11-23 09:00:00.000000',0.00,0,NULL),
(58,'EN_ATTENTE','Disponible toute la journée, n\'hésitez pas à me contacter.','2026-11-17 23:02:46.134696',NULL,16,1,'fcabac9b-c6dd-48c0-ba4b-8f7b66b725b4',NULL,0.00,0,NULL),
(59,'ACCEPTEE','Bonjour, je suis disponible et motivé·e !','2026-11-17 23:02:46.139438',NULL,17,5,'76cd69da-052f-4fab-9971-336907035c90','2026-12-21 09:00:00.000000',0.00,0,NULL),
(60,'ACCEPTEE','Disponible toute la journée, n\'hésitez pas à me contacter.','2026-11-17 23:02:46.143859',NULL,17,9,'6404ef64-9a5d-4266-a735-9d2927fbe355','2026-12-21 09:00:00.000000',0.00,0,NULL),
(61,'ACCEPTEE','J\'ai déjà participé à ce type de mission, je serais ravi·e d\'aider.','2026-11-17 23:02:46.147845',NULL,17,4,'ead2d2f0-959e-4efe-99ad-0b69d50e473b','2026-12-21 09:00:00.000000',0.00,0,NULL),
(62,'EN_ATTENTE','Bonjour, je suis disponible et motivé·e !','2026-11-17 23:02:46.149644',NULL,18,6,'62b7ac31-8d40-4568-a06e-10fd88e07bb4',NULL,0.00,0,NULL),
(63,'EN_ATTENTE','Bonjour, je suis disponible et motivé·e !','2026-11-17 23:02:46.151642',NULL,18,4,'ddd3f9f5-6f4b-4291-8388-ecbdeedba253',NULL,0.00,0,NULL),
(64,'ACCEPTEE','J\'ai déjà participé à ce type de mission, je serais ravi·e d\'aider.','2026-11-17 23:02:46.156769',NULL,18,9,'6567c3be-8b29-4272-9739-c8a1e702c964','2026-11-28 09:00:00.000000',0.00,0,NULL),
(65,'ACCEPTEE','J\'ai déjà participé à ce type de mission, je serais ravi·e d\'aider.','2026-11-17 23:02:46.159100',NULL,19,6,'7726e1fa-26f8-4dcd-ad4b-1116ea84d2e2','2026-11-18 08:00:00.000000',0.00,0,20.00),
(66,'ACCEPTEE','Disponible toute la journée, n\'hésitez pas à me contacter.','2026-11-17 23:02:46.161040',NULL,19,7,'5e4608c1-1a9b-4d7b-83a1-5e1f9d091a64','2026-11-18 08:00:00.000000',0.00,0,5.00),
(67,'ACCEPTEE','Disponible toute la journée, n\'hésitez pas à me contacter.','2026-11-17 23:02:46.162969',NULL,19,8,'648e14a7-0017-4863-8f2a-d343a3378ecc','2026-11-18 08:00:00.000000',0.00,0,5.00),
(68,'ACCEPTEE','J\'ai déjà participé à ce type de mission, je serais ravi·e d\'aider.','2026-11-17 23:02:46.167387',NULL,20,6,'89ecd1cf-321a-41f1-80bf-44d8981e6fa5','2026-11-24 09:00:00.000000',0.00,0,NULL),
(69,'EN_ATTENTE','Bonjour, je suis disponible et motivé·e !','2026-11-17 23:02:46.169518',NULL,20,1,'644dfc24-0a39-49f3-8fff-7cb46945b2b3',NULL,0.00,0,NULL),
(70,'EN_ATTENTE','Bonjour, je suis disponible et motivé·e !','2026-11-17 23:02:46.171500',NULL,20,8,'3eafd1dd-00d1-43d7-b39a-12a8ed272b9d',NULL,0.00,0,NULL);
/*!40000 ALTER TABLE `login_app_candidature` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_app_categorie`
--

DROP TABLE IF EXISTS `login_app_categorie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `login_app_categorie` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) NOT NULL,
  `couleur` varchar(7) NOT NULL,
  `icone` varchar(10) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `login_app_categorie_nom_54f46a7b_uniq` (`nom`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_app_categorie`
--

LOCK TABLES `login_app_categorie` WRITE;
/*!40000 ALTER TABLE `login_app_categorie` DISABLE KEYS */;
INSERT INTO `login_app_categorie` VALUES
(1,'Solidarité alimentaire','#F26B3A','🥕'),
(2,'Environnement','#2E9E6A','🌿'),
(3,'Éducation','#3D6FD8','📚'),
(4,'Animaux','#B5651D','🐾'),
(5,'Seniors','#C2477A','🫶'),
(6,'Sport & handicap','#0E9AA7','⚽'),
(7,'Santé','#D64545','🩺'),
(8,'Culture','#8A5CF6','🎨'),
(9,'Logement','#6B7B3A','🏠');
/*!40000 ALTER TABLE `login_app_categorie` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_app_citoyenprofile`
--

DROP TABLE IF EXISTS `login_app_citoyenprofile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `login_app_citoyenprofile` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `prenom` varchar(100) NOT NULL,
  `nom` varchar(100) NOT NULL,
  `bio` longtext NOT NULL,
  `experiences` longtext NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `photo` varchar(100) DEFAULT NULL,
  `ville` varchar(120) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `login_app_citoyenprofile_user_id_b1a2d76a_fk_login_app_user_id` FOREIGN KEY (`user_id`) REFERENCES `login_app_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_app_citoyenprofile`
--

LOCK TABLES `login_app_citoyenprofile` WRITE;
/*!40000 ALTER TABLE `login_app_citoyenprofile` DISABLE KEYS */;
INSERT INTO `login_app_citoyenprofile` VALUES
(1,'Emma','Martin','Emma, bénévole à Lyon. J\'aime me rendre utile près de chez moi.','Bénévolat associatif depuis 2 ans.',10,'','Lyon'),
(2,'Lucas','Bernard','Lucas, bénévole à Paris. J\'aime me rendre utile près de chez moi.','Bénévolat associatif depuis 2 ans.',11,'','Paris'),
(3,'Inès','Haddad','Inès, bénévole à Marseille. J\'aime me rendre utile près de chez moi.','Bénévolat associatif depuis 2 ans.',12,'','Marseille'),
(4,'Hugo','Petit','Hugo, bénévole à Nantes. J\'aime me rendre utile près de chez moi.','Bénévolat associatif depuis 2 ans.',13,'','Nantes'),
(5,'Chloé','Dubois','Chloé, bénévole à Bordeaux. J\'aime me rendre utile près de chez moi.','Bénévolat associatif depuis 2 ans.',14,'','Bordeaux'),
(6,'Yanis','Moreau','Yanis, bénévole à Toulouse. J\'aime me rendre utile près de chez moi.','Bénévolat associatif depuis 2 ans.',15,'','Toulouse'),
(7,'Léa','Laurent','Léa, bénévole à Paris. J\'aime me rendre utile près de chez moi.','Bénévolat associatif depuis 2 ans.',16,'','Paris'),
(8,'Adam','Benali','Adam, bénévole à Lyon. J\'aime me rendre utile près de chez moi.','Bénévolat associatif depuis 2 ans.',17,'','Lyon'),
(9,'Manon','Girard','Manon, bénévole à Lille. J\'aime me rendre utile près de chez moi.','Bénévolat associatif depuis 2 ans.',18,'','Lille'),
(10,'Nathan','Roux','Nathan, bénévole à Nantes. J\'aime me rendre utile près de chez moi.','Bénévolat associatif depuis 2 ans.',19,'','Nantes');
/*!40000 ALTER TABLE `login_app_citoyenprofile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_app_citoyenprofile_centres_interet`
--

DROP TABLE IF EXISTS `login_app_citoyenprofile_centres_interet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `login_app_citoyenprofile_centres_interet` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `citoyenprofile_id` bigint(20) NOT NULL,
  `categorie_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `login_app_citoyenprofile_citoyenprofile_id_catego_b8032b80_uniq` (`citoyenprofile_id`,`categorie_id`),
  KEY `login_app_citoyenpro_categorie_id_8209d12c_fk_login_app` (`categorie_id`),
  CONSTRAINT `login_app_citoyenpro_categorie_id_8209d12c_fk_login_app` FOREIGN KEY (`categorie_id`) REFERENCES `login_app_categorie` (`id`),
  CONSTRAINT `login_app_citoyenpro_citoyenprofile_id_61d0bc83_fk_login_app` FOREIGN KEY (`citoyenprofile_id`) REFERENCES `login_app_citoyenprofile` (`id`),
  CONSTRAINT `login_app_citoyenprofile__citoyenprofile_id_61d0bc83_fk` FOREIGN KEY (`citoyenprofile_id`) REFERENCES `login_app_citoyenprofile` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_app_citoyenprofile_centres_interet`
--

LOCK TABLES `login_app_citoyenprofile_centres_interet` WRITE;
/*!40000 ALTER TABLE `login_app_citoyenprofile_centres_interet` DISABLE KEYS */;
INSERT INTO `login_app_citoyenprofile_centres_interet` VALUES
(1,1,1),
(2,1,5),
(4,2,3),
(3,2,8),
(5,3,4),
(6,3,7),
(7,4,2),
(8,5,3),
(9,5,5),
(10,6,6),
(12,7,2),
(11,7,8),
(13,8,1),
(14,8,9),
(16,9,3),
(15,9,9),
(17,10,2),
(18,10,6);
/*!40000 ALTER TABLE `login_app_citoyenprofile_centres_interet` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_app_citoyenprofile_competences`
--

DROP TABLE IF EXISTS `login_app_citoyenprofile_competences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `login_app_citoyenprofile_competences` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `citoyenprofile_id` bigint(20) NOT NULL,
  `competence_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `login_app_citoyenprofile_citoyenprofile_id_compet_baa01479_uniq` (`citoyenprofile_id`,`competence_id`),
  KEY `login_app_citoyenpro_competence_id_42153dd3_fk_login_app` (`competence_id`),
  CONSTRAINT `login_app_citoyenpro_citoyenprofile_id_9327ca38_fk_login_app` FOREIGN KEY (`citoyenprofile_id`) REFERENCES `login_app_citoyenprofile` (`id`),
  CONSTRAINT `login_app_citoyenpro_competence_id_42153dd3_fk_login_app` FOREIGN KEY (`competence_id`) REFERENCES `login_app_competence` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_app_citoyenprofile_competences`
--

LOCK TABLES `login_app_citoyenprofile_competences` WRITE;
/*!40000 ALTER TABLE `login_app_citoyenprofile_competences` DISABLE KEYS */;
INSERT INTO `login_app_citoyenprofile_competences` VALUES
(1,1,1),
(2,1,2),
(3,2,4),
(4,2,5),
(6,3,6),
(5,3,10),
(8,4,7),
(7,4,11),
(9,5,3),
(10,5,5),
(12,6,3),
(11,6,10),
(14,7,6),
(13,7,12),
(16,8,2),
(15,8,8),
(18,9,4),
(17,9,9),
(20,10,7),
(19,10,8);
/*!40000 ALTER TABLE `login_app_citoyenprofile_competences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_app_competence`
--

DROP TABLE IF EXISTS `login_app_competence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `login_app_competence` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nom` (`nom`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_app_competence`
--

LOCK TABLES `login_app_competence` WRITE;
/*!40000 ALTER TABLE `login_app_competence` DISABLE KEYS */;
INSERT INTO `login_app_competence` VALUES
(3,'Animation'),
(7,'Bricolage'),
(6,'Communication'),
(1,'Cuisine'),
(5,'Informatique'),
(11,'Jardinage'),
(9,'Langues étrangères'),
(2,'Logistique'),
(8,'Permis B'),
(12,'Photographie'),
(10,'Premiers secours'),
(4,'Soutien scolaire');
/*!40000 ALTER TABLE `login_app_competence` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_app_message`
--

DROP TABLE IF EXISTS `login_app_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `login_app_message` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `contenu` longtext NOT NULL,
  `date_envoi` datetime(6) NOT NULL,
  `receiver_id` bigint(20) NOT NULL,
  `sender_id` bigint(20) NOT NULL,
  `lu` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `login_app_message_receiver_id_6c9ddccc_fk_login_app_user_id` (`receiver_id`),
  KEY `login_app_message_sender_id_87313a7f_fk_login_app_user_id` (`sender_id`),
  CONSTRAINT `login_app_message_receiver_id_6c9ddccc_fk_login_app_user_id` FOREIGN KEY (`receiver_id`) REFERENCES `login_app_user` (`id`),
  CONSTRAINT `login_app_message_sender_id_87313a7f_fk_login_app_user_id` FOREIGN KEY (`sender_id`) REFERENCES `login_app_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_app_message`
--

LOCK TABLES `login_app_message` WRITE;
/*!40000 ALTER TABLE `login_app_message` DISABLE KEYS */;
INSERT INTO `login_app_message` VALUES
(1,'Bonjour ! Faut-il apporter quelque chose pour la cuisine solidaire ?','2026-11-17 23:02:46.302732',2,10,1),
(2,'Bonjour Emma, juste de bonnes chaussures fermées, on fournit le reste 🙂','2026-11-17 23:02:46.305758',10,2,1),
(3,'Parfait, à samedi !','2026-11-17 23:02:46.307500',2,10,0),
(4,'Je peux aussi aider pour l\'atelier code si besoin.','2026-11-17 23:02:46.309354',4,11,1),
(5,'Super, on vous ajoute à la liste. Merci Lucas !','2026-11-17 23:02:46.310807',11,4,0),
(6,'Est-ce que je peux venir avec ma sœur pour la promenade ?','2026-11-17 23:02:46.312256',5,12,0);
/*!40000 ALTER TABLE `login_app_message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_app_notification`
--

DROP TABLE IF EXISTS `login_app_notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `login_app_notification` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `titre` varchar(255) NOT NULL,
  `message` longtext NOT NULL,
  `lien` varchar(255) NOT NULL,
  `lue` tinyint(1) NOT NULL,
  `date_creation` datetime(6) NOT NULL,
  `destinataire_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `login_app_notificati_destinataire_id_9a193ef2_fk_login_app` (`destinataire_id`),
  CONSTRAINT `login_app_notificati_destinataire_id_9a193ef2_fk_login_app` FOREIGN KEY (`destinataire_id`) REFERENCES `login_app_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_app_notification`
--

LOCK TABLES `login_app_notification` WRITE;
/*!40000 ALTER TABLE `login_app_notification` DISABLE KEYS */;
INSERT INTO `login_app_notification` VALUES
(1,'Nouvelle association à vérifier','Toit d\'Abord attend une vérification.','/espace/admin',0,'2026-11-17 23:02:46.313843',1),
(2,'Nouvelle association à vérifier','Collectif Récup\'Art attend une vérification.','/espace/admin',0,'2026-11-17 23:02:46.316616',1),
(3,'Candidature acceptée 🎉','Votre candidature pour « Cuisine solidaire du samedi » a été examinée.','/espace',0,'2026-11-17 23:02:46.318311',10),
(4,'Nouvelle mission près de chez vous','« Collecte de denrées pour l\'hiver » à Lyon.','/missions',0,'2026-11-17 23:02:46.319845',10);
/*!40000 ALTER TABLE `login_app_notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_app_photoalbum`
--

DROP TABLE IF EXISTS `login_app_photoalbum`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `login_app_photoalbum` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `image` varchar(100) NOT NULL,
  `legende` varchar(255) NOT NULL,
  `date_ajout` datetime(6) NOT NULL,
  `citoyen_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `login_app_photoalbum_citoyen_id_654bf8e7_fk_login_app` (`citoyen_id`),
  CONSTRAINT `login_app_photoalbum_citoyen_id_654bf8e7_fk_login_app` FOREIGN KEY (`citoyen_id`) REFERENCES `login_app_citoyenprofile` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_app_photoalbum`
--

LOCK TABLES `login_app_photoalbum` WRITE;
/*!40000 ALTER TABLE `login_app_photoalbum` DISABLE KEYS */;
/*!40000 ALTER TABLE `login_app_photoalbum` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_app_signalement`
--

DROP TABLE IF EXISTS `login_app_signalement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `login_app_signalement` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `motif` longtext NOT NULL,
  `statut` varchar(10) NOT NULL,
  `date_creation` datetime(6) NOT NULL,
  `annonce_id` bigint(20) DEFAULT NULL,
  `auteur_id` bigint(20) NOT NULL,
  `utilisateur_signale_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `login_app_signalemen_annonce_id_426cff75_fk_login_app` (`annonce_id`),
  KEY `login_app_signalement_auteur_id_406816e2_fk_login_app_user_id` (`auteur_id`),
  KEY `login_app_signalemen_utilisateur_signale__7919142b_fk_login_app` (`utilisateur_signale_id`),
  CONSTRAINT `login_app_signalemen_annonce_id_426cff75_fk_login_app` FOREIGN KEY (`annonce_id`) REFERENCES `login_app_annonce` (`id`),
  CONSTRAINT `login_app_signalemen_utilisateur_signale__7919142b_fk_login_app` FOREIGN KEY (`utilisateur_signale_id`) REFERENCES `login_app_user` (`id`),
  CONSTRAINT `login_app_signalement_auteur_id_406816e2_fk_login_app_user_id` FOREIGN KEY (`auteur_id`) REFERENCES `login_app_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_app_signalement`
--

LOCK TABLES `login_app_signalement` WRITE;
/*!40000 ALTER TABLE `login_app_signalement` DISABLE KEYS */;
INSERT INTO `login_app_signalement` VALUES
(1,'Le lieu indiqué ne semble pas correct, à vérifier.','OUVERT','2026-11-17 23:02:46.321474',20,16,NULL);
/*!40000 ALTER TABLE `login_app_signalement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_app_user`
--

DROP TABLE IF EXISTS `login_app_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `login_app_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `type` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `login_app_user_email_847ff430_uniq` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_app_user`
--

LOCK TABLES `login_app_user` WRITE;
/*!40000 ALTER TABLE `login_app_user` DISABLE KEYS */;
INSERT INTO `login_app_user` VALUES
(1,'pbkdf2_sha256$1500000$vT9ZcC6OTON3ilOzozCdsi$Yw1P0nT/xbz5T+WOq6XKA8Oy4gMQ8ng1zydcwceRDN4=',NULL,1,'admin','','','admin@solidarlink.local',1,1,'2026-11-17 23:02:24.814495','ADMIN'),
(2,'pbkdf2_sha256$1500000$Kn6NPB4RDCjYYRq8hyzacT$z4WF3uqnhZ0SxFOrSHAclU3XgmQXDJH0G/zZiSVqevY=',NULL,0,'panier_solidaire','','','panier_solidaire@asso.solidarlink.local',0,1,'2026-11-17 23:02:25.873926','ASSOCIATION'),
(3,'pbkdf2_sha256$1500000$6CqKbnyGiFADKEVbVpbLaJ$2PVvm3tId59mIpXYb62tw/Zy6NHLB89rhOw2IMlwWZs=',NULL,0,'vert_demain','','','vert_demain@asso.solidarlink.local',0,1,'2026-11-17 23:02:26.775722','ASSOCIATION'),
(4,'pbkdf2_sha256$1500000$bibhLIihaqbnGTBmmUPFNL$M4UGHET8LefZmIELX4UWwCTP8v8eqn1udsHiczrlJtU=',NULL,0,'lire_ensemble','','','lire_ensemble@asso.solidarlink.local',0,1,'2026-11-17 23:02:27.721869','ASSOCIATION'),
(5,'pbkdf2_sha256$1500000$JocKZ6gBIOymBQoEZRouBm$9IuWLzdAeLAwdc1tOdIRZcHp6R3A9G4VOBxlr8X1yzo=',NULL,0,'pattes_coeurs','','','pattes_coeurs@asso.solidarlink.local',0,1,'2026-11-17 23:02:28.685552','ASSOCIATION'),
(6,'pbkdf2_sha256$1500000$OpZW2Pp8ILT1SHG0BC4qhH$G20oAjaRyvw38JZ+VsOI7XP0iOFJF6tw6nc2m2GVzF4=',NULL,0,'aines_connectes','','','aines_connectes@asso.solidarlink.local',0,1,'2026-11-17 23:02:29.555420','ASSOCIATION'),
(7,'pbkdf2_sha256$1500000$ck4wht9oQ8HGDSmSDs7Ra5$PeJ1XgoUfc9N6nlYYDg4KOCSgkKgume4FjD8p1N3KgU=',NULL,0,'sport_pour_tous','','','sport_pour_tous@asso.solidarlink.local',0,1,'2026-11-17 23:02:30.702278','ASSOCIATION'),
(8,'pbkdf2_sha256$1500000$0yZH8z0s2mbvKleT7bXQuB$zzYNJ9qTD1dEdBj2cGEJlwrRuEoA7tYrTLOtFKoLfso=',NULL,0,'toit_dabord','','','toit_dabord@asso.solidarlink.local',0,1,'2026-11-17 23:02:31.598000','ASSOCIATION'),
(9,'pbkdf2_sha256$1500000$IVHQGo9dITKmZccFjhtGPl$11wxkq7GbPOltiRYwdexJMLWVZi6rGQ1ngOkf14v9G8=',NULL,0,'recup_art','','','recup_art@asso.solidarlink.local',0,1,'2026-11-17 23:02:32.742544','ASSOCIATION'),
(10,'pbkdf2_sha256$1500000$LU1zUaS53qAJfGdF4YbILI$G/7wSD72ss2+Y0SuquzLB9/J0qKKVR73whqM+A+jrMc=',NULL,0,'emma.martin','Emma','Martin','emma.martin@mail.solidarlink.local',0,1,'2026-11-17 23:02:34.250141','CITOYEN'),
(11,'pbkdf2_sha256$1500000$QnkGVzc508V1W5P9kRJbM9$mxUrZLcNOFOYsoFEKG7ofx6zhSNdqs8mYrnvK/xNtbY=',NULL,0,'lucas.bernard','Lucas','Bernard','lucas.bernard@mail.solidarlink.local',0,1,'2026-11-17 23:02:36.025888','CITOYEN'),
(12,'pbkdf2_sha256$1500000$7RI0Gtn6QcOuJJSuLfq87Z$6XNwCMsraDA8fBwtFj4oJNqVf99irUkldwmeqBbU7OI=',NULL,0,'ines.haddad','Inès','Haddad','ines.haddad@mail.solidarlink.local',0,1,'2026-11-17 23:02:37.021850','CITOYEN'),
(13,'pbkdf2_sha256$1500000$jZmtiCB3DcXkP8IrWmemmY$Fm7YJnOVTOu0HPzqrJNwDyZ6XVm2+MSKN8F7MfYuTgM=',NULL,0,'hugo.petit','Hugo','Petit','hugo.petit@mail.solidarlink.local',0,1,'2026-11-17 23:02:38.005632','CITOYEN'),
(14,'pbkdf2_sha256$1500000$HNuw7o51vvVMAjY41oUHQr$wbQ3mx6xegFF1TFS5q7dtHhKn5rQcYUWVNJle5FTWVg=',NULL,0,'chloe.dubois','Chloé','Dubois','chloe.dubois@mail.solidarlink.local',0,1,'2026-11-17 23:02:38.916093','CITOYEN'),
(15,'pbkdf2_sha256$1500000$NAA43bw9lY7N5ZmOxuQnl1$KaTr9I1/Kv7POL352AMkqR/XJIESb5+Ezk7ak4rV/j8=',NULL,0,'yanis.moreau','Yanis','Moreau','yanis.moreau@mail.solidarlink.local',0,1,'2026-11-17 23:02:39.855644','CITOYEN'),
(16,'pbkdf2_sha256$1500000$sSTvQvqCeMOjwbSnvN8Gxt$v04Oa4uwj1DcR3dEkB9L+8f067skws4lCBIXICzNgSg=',NULL,0,'lea.laurent','Léa','Laurent','lea.laurent@mail.solidarlink.local',0,1,'2026-11-17 23:02:41.536446','CITOYEN'),
(17,'pbkdf2_sha256$1500000$MPksnmDkg4T9s3paHl9CXy$l6/8dJEcEjhUbIsE6JvCNbEHl0XLJLNzLG7AFY/PMek=',NULL,0,'adam.benali','Adam','Benali','adam.benali@mail.solidarlink.local',0,1,'2026-11-17 23:02:43.062698','CITOYEN'),
(18,'pbkdf2_sha256$1500000$3HZLRIq28oAaftsPYzUEmC$fNVwxFY/bQ5U/kBkFS2erURAYkv77YDaLBy93dQjAvs=',NULL,0,'manon.girard','Manon','Girard','manon.girard@mail.solidarlink.local',0,1,'2026-11-17 23:02:43.993528','CITOYEN'),
(19,'pbkdf2_sha256$1500000$851dCSJ7dFzVm3VprcBnEo$DTGpe3UskfmQNDUOjGu0M4WyO518DHyqqX8vkTUiegk=',NULL,0,'nathan.roux','Nathan','Roux','nathan.roux@mail.solidarlink.local',0,1,'2026-11-17 23:02:44.881283','CITOYEN');
/*!40000 ALTER TABLE `login_app_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_app_user_groups`
--

DROP TABLE IF EXISTS `login_app_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `login_app_user_groups` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `login_app_user_groups_user_id_group_id_bee0187b_uniq` (`user_id`,`group_id`),
  KEY `login_app_user_groups_group_id_24c5bf2e_fk_auth_group_id` (`group_id`),
  CONSTRAINT `login_app_user_groups_group_id_24c5bf2e_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `login_app_user_groups_user_id_02d45058_fk_login_app_user_id` FOREIGN KEY (`user_id`) REFERENCES `login_app_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_app_user_groups`
--

LOCK TABLES `login_app_user_groups` WRITE;
/*!40000 ALTER TABLE `login_app_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `login_app_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_app_user_user_permissions`
--

DROP TABLE IF EXISTS `login_app_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `login_app_user_user_permissions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `login_app_user_user_perm_user_id_permission_id_588783a2_uniq` (`user_id`,`permission_id`),
  KEY `login_app_user_user__permission_id_b1a035b0_fk_auth_perm` (`permission_id`),
  CONSTRAINT `login_app_user_user__permission_id_b1a035b0_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `login_app_user_user__user_id_e1babca2_fk_login_app` FOREIGN KEY (`user_id`) REFERENCES `login_app_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_app_user_user_permissions`
--

LOCK TABLES `login_app_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `login_app_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `login_app_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-17 23:05:10
