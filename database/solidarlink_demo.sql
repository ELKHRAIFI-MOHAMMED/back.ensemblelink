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
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
(68,'Can view signalement',16,'view_signalement'),
(69,'Can add groupe discussion',18,'add_groupediscussion'),
(70,'Can change groupe discussion',18,'change_groupediscussion'),
(71,'Can delete groupe discussion',18,'delete_groupediscussion'),
(72,'Can view groupe discussion',18,'view_groupediscussion'),
(73,'Can add membre groupe',19,'add_membregroupe'),
(74,'Can change membre groupe',19,'change_membregroupe'),
(75,'Can delete membre groupe',19,'delete_membregroupe'),
(76,'Can view membre groupe',19,'view_membregroupe'),
(77,'Can add message groupe',20,'add_messagegroupe'),
(78,'Can change message groupe',20,'change_messagegroupe'),
(79,'Can delete message groupe',20,'delete_messagegroupe'),
(80,'Can view message groupe',20,'view_messagegroupe');
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
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
(18,'login_app','groupediscussion'),
(19,'login_app','membregroupe'),
(13,'login_app','message'),
(20,'login_app','messagegroupe'),
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
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
(32,'sessions','0001_initial','2026-11-17 23:00:53.886657'),
(33,'login_app','0015_v3_activites_groupes_pays','2026-11-18 14:23:45.074594');
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
  `association_id` bigint(20) DEFAULT NULL,
  `est_active` tinyint(1) NOT NULL,
  `image` varchar(100) DEFAULT NULL,
  `latitude` decimal(9,6) DEFAULT NULL,
  `longitude` decimal(9,6) DEFAULT NULL,
  `nombre_places` int(10) unsigned DEFAULT NULL CHECK (`nombre_places` >= 0),
  `objectif_don` decimal(12,2) DEFAULT NULL,
  `unite_don` varchar(40) NOT NULL,
  `ville` varchar(120) NOT NULL,
  `createur_id` bigint(20) DEFAULT NULL,
  `fuseau_horaire` varchar(64) NOT NULL,
  `inscription_automatique` tinyint(1) NOT NULL,
  `pays` varchar(2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `login_app_annonce_categorie_id_9966509e_fk_login_app` (`categorie_id`),
  KEY `login_app_annonce_createur_id_329b1518_fk_login_app` (`createur_id`),
  KEY `login_app_annonce_association_id_2c93d0ed_fk_login_app` (`association_id`),
  CONSTRAINT `login_app_annonce_association_id_2c93d0ed_fk_login_app` FOREIGN KEY (`association_id`) REFERENCES `login_app_associationprofile` (`id`),
  CONSTRAINT `login_app_annonce_categorie_id_9966509e_fk_login_app` FOREIGN KEY (`categorie_id`) REFERENCES `login_app_categorie` (`id`),
  CONSTRAINT `login_app_annonce_createur_id_329b1518_fk_login_app` FOREIGN KEY (`createur_id`) REFERENCES `login_app_citoyenprofile` (`id`),
  CONSTRAINT `annonce_un_seul_organisateur` CHECK (`association_id` is not null and `createur_id` is null or `association_id` is null and `createur_id` is not null)
) ENGINE=InnoDB AUTO_INCREMENT=117 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_app_annonce`
--

LOCK TABLES `login_app_annonce` WRITE;
/*!40000 ALTER TABLE `login_app_annonce` DISABLE KEYS */;
INSERT INTO `login_app_annonce` VALUES
(69,'Distribution de colis alimentaires','Préparation et distribution de 200 colis pour les familles inscrites.','Maison de quartier — Lyon','APPEL_BENEVOLAT','2026-10-28 08:00:00.000000','2026-10-28 12:00:00.000000','2026-11-18 14:45:59.277674',22,26,1,'',45.764321,4.797823,8,NULL,'','Lyon',NULL,'Europe/Paris',0,'FR'),
(70,'Grand nettoyage des berges de la Loire','Matinée de ramassage des déchets, gants et sacs fournis. Pique-nique offert !','Maison de quartier — Nantes','EVENEMENT','2026-11-04 08:00:00.000000','2026-11-04 11:00:00.000000','2026-11-18 14:45:59.292898',23,27,1,'',47.231361,-1.537494,30,NULL,'','Nantes',NULL,'Europe/Paris',0,'FR'),
(71,'Stage de révisions du brevet','Accompagner des collégiens de 3e en maths et français pendant une journée.','Local associatif — Paris','APPEL_BENEVOLAT','2026-11-08 08:00:00.000000','2026-11-08 14:00:00.000000','2026-11-18 14:45:59.303850',24,28,1,'',48.839826,2.359341,5,NULL,'','Paris',NULL,'Europe/Paris',0,'FR'),
(72,'Après-midi jeux en EHPAD','Belote, scrabble et goûter partagé avec les résidents de la résidence Les Tilleuls.','Parc — Bordeaux','EVENEMENT','2026-11-11 13:00:00.000000','2026-11-11 16:00:00.000000','2026-11-18 14:45:59.313464',26,30,1,'',44.853328,-0.606427,6,NULL,'','Bordeaux',NULL,'Europe/Paris',0,'FR'),
(73,'Tournoi de basket fauteuil','Accueil du public, arbitrage de table et buvette.','Local associatif — Toulouse','EVENEMENT','2026-11-13 09:00:00.000000','2026-11-13 14:00:00.000000','2026-11-18 14:45:59.323302',27,31,1,'',43.595115,1.416638,12,NULL,'','Toulouse',NULL,'Europe/Paris',0,'FR'),
(74,'Cuisine solidaire du samedi','Préparer 150 repas chauds avec notre cheffe bénévole. Tablier fourni.','Centre-ville — Lyon','APPEL_BENEVOLAT','2026-11-22 08:00:00.000000','2026-11-22 12:00:00.000000','2026-11-18 14:45:59.332862',22,26,1,'',45.740133,4.826094,6,NULL,'','Lyon',NULL,'Europe/Paris',0,'FR'),
(75,'Collecte de denrées pour l\'hiver','Pâtes, riz, conserves, produits d\'hygiène : chaque kilo compte.','Centre-ville — Lyon','DON','2026-11-20 07:00:00.000000','2026-11-23 07:00:00.000000','2026-11-18 14:45:59.342435',22,26,1,'',45.784850,4.843998,NULL,500.00,'kg','Lyon',NULL,'Europe/Paris',0,'FR'),
(76,'Plantation d\'une forêt urbaine','Plantation de 600 arbres selon la méthode Miyawaki à Rezé.','Parc — Nantes','EVENEMENT','2026-11-29 08:00:00.000000','2026-11-29 13:00:00.000000','2026-11-18 14:45:59.349311',23,27,1,'',47.232184,-1.550702,40,NULL,'','Nantes',NULL,'Europe/Paris',0,'FR'),
(77,'Atelier réparation de vélos','Aider les habitants à réparer eux-mêmes leur vélo. Outils fournis.','Local associatif — Nantes','APPEL_BENEVOLAT','2026-11-24 13:00:00.000000','2026-11-24 16:00:00.000000','2026-11-18 14:45:59.361695',23,27,1,'',47.193128,-1.570146,4,NULL,'','Nantes',NULL,'Europe/Paris',0,'FR'),
(78,'Aide aux devoirs hebdomadaire','Tous les mardis de 17h à 19h, niveau primaire et collège.','Centre-ville — Paris','APPEL_BENEVOLAT','2026-11-21 16:00:00.000000','2026-11-21 18:00:00.000000','2026-11-18 14:45:59.373819',24,28,1,'',48.861241,2.368566,10,NULL,'','Paris',NULL,'Europe/Paris',0,'FR'),
(79,'Dons de livres jeunesse','Albums, romans jeunesse et BD en bon état pour notre bibliothèque.','Parc — Paris','DON','2026-11-19 07:00:00.000000','2026-11-29 07:00:00.000000','2026-11-18 14:45:59.386277',24,28,1,'',48.866276,2.374045,NULL,300.00,'livres','Paris',NULL,'Europe/Paris',0,'FR'),
(80,'Promenade des chiens du refuge','Sortir nos pensionnaires pour une balade au parc Borély.','Parc — Marseille','APPEL_BENEVOLAT','2026-11-20 09:00:00.000000','2026-11-20 11:00:00.000000','2026-11-18 14:45:59.393898',25,29,1,'',43.317819,5.399119,8,NULL,'','Marseille',NULL,'Europe/Paris',0,'FR'),
(81,'Collecte de couvertures et croquettes','L\'hiver arrive : couvertures, paniers et croquettes sont les bienvenus.','Local associatif — Marseille','DON','2026-11-19 07:00:00.000000','2026-12-03 07:00:00.000000','2026-11-18 14:45:59.401394',25,29,1,'',43.283178,5.380655,NULL,120.00,'couvertures','Marseille',NULL,'Europe/Paris',0,'FR'),
(82,'Initiation tablette pour seniors','Apprendre aux aînés à appeler leurs proches en visio.','Centre-ville — Bordeaux','APPEL_BENEVOLAT','2026-11-26 13:00:00.000000','2026-11-26 15:00:00.000000','2026-11-18 14:45:59.409193',26,30,1,'',44.817559,-0.590778,4,NULL,'','Bordeaux',NULL,'Europe/Paris',0,'FR'),
(83,'Repas de Noël partagé','Préparer et partager un repas festif avec 60 personnes âgées isolées.','Centre-ville — Bordeaux','EVENEMENT','2026-12-24 11:00:00.000000','2026-12-24 15:00:00.000000','2026-11-18 14:45:59.418906',26,30,1,'',44.849909,-0.564516,15,NULL,'','Bordeaux',NULL,'Europe/Paris',0,'FR'),
(84,'Accompagnateurs course inclusive','Guider des coureurs malvoyants sur le parcours de 5 km.','Parc — Toulouse','APPEL_BENEVOLAT','2026-12-01 08:00:00.000000','2026-12-01 12:00:00.000000','2026-11-18 14:45:59.427513',27,31,1,'',43.611248,1.417891,20,NULL,'','Toulouse',NULL,'Europe/Paris',0,'FR'),
(85,'Distribution de paniers dans le Haut Atlas','Départ en minibus depuis Marrakech pour distribuer 150 paniers dans trois douars.','Maison de quartier — Marrakech','APPEL_BENEVOLAT','2026-11-24 07:00:00.000000','2026-11-24 15:00:00.000000','2026-11-18 14:45:59.444739',22,34,1,'',31.609304,-7.990744,10,NULL,'','Marrakech',NULL,'Africa/Casablanca',0,'MA'),
(86,'Collecte de couvertures pour les villages','Les nuits sont glaciales en montagne : couvertures et vêtements chauds bienvenus.','Maison de quartier — Marrakech','DON','2026-11-19 07:00:00.000000','2026-11-29 07:00:00.000000','2026-11-18 14:45:59.456289',22,34,1,'',31.640577,-7.953672,NULL,200.00,'couvertures','Marrakech',NULL,'Africa/Casablanca',0,'MA'),
(87,'Soutien scolaire du mercredi','Aide aux devoirs en français, arabe et maths pour des collégiens de Hay Mohammadi.','Parc — Casablanca','APPEL_BENEVOLAT','2026-11-20 14:00:00.000000','2026-11-20 16:00:00.000000','2026-11-18 14:45:59.463023',24,35,1,'',33.556843,-7.627232,8,NULL,'','Casablanca',NULL,'Africa/Casablanca',0,'MA'),
(88,'Inauguration de la bibliothèque de quartier','Lectures contées, ateliers dessin et rangement des 2 000 livres donnés.','Centre-ville — Casablanca','EVENEMENT','2026-11-09 09:00:00.000000','2026-11-09 13:00:00.000000','2026-11-18 14:45:59.473503',24,35,1,'',33.567170,-7.624505,15,NULL,'','Casablanca',NULL,'Africa/Casablanca',0,'MA'),
(89,'Saturday food sorting','Sort and pack surplus food for 20 community kitchens. Tea and biscuits provided!','Downtown — London','APPEL_BENEVOLAT','2026-11-21 10:00:00.000000','2026-11-21 14:00:00.000000','2026-11-18 14:45:59.486719',22,37,1,'',51.489958,-0.127661,12,NULL,'','London',NULL,'Europe/London',0,'GB'),
(90,'Community kitchen night','Cook and serve a three-course dinner for 80 guests in Hackney.','Main hall — London','EVENEMENT','2026-11-12 18:00:00.000000','2026-11-12 21:00:00.000000','2026-11-18 14:45:59.497594',22,37,1,'',51.485772,-0.156430,10,NULL,'','London',NULL,'Europe/London',0,'GB'),
(91,'Reading buddies for kids','Read one-to-one with primary school children at Ancoats library.','Downtown — Manchester','APPEL_BENEVOLAT','2026-11-23 16:00:00.000000','2026-11-23 18:00:00.000000','2026-11-18 14:45:59.509381',24,38,1,'',53.495621,-2.248325,6,NULL,'','Manchester',NULL,'Europe/London',0,'GB'),
(92,'Prospect Park clean-up','Join us to clean the lakeside trails. Gloves, bags and coffee provided.','Main hall — New York','EVENEMENT','2026-11-22 14:00:00.000000','2026-11-22 17:00:00.000000','2026-11-18 14:45:59.526173',23,39,1,'',40.704520,-73.966214,30,NULL,'','New York',NULL,'America/New_York',0,'US'),
(93,'Community garden planting','Spring planting at the Bed-Stuy community garden.','Community centre — New York','EVENEMENT','2026-11-10 14:00:00.000000','2026-11-10 18:00:00.000000','2026-11-18 14:45:59.538496',23,39,1,'',40.713372,-74.038727,20,NULL,'','New York',NULL,'America/New_York',0,'US'),
(94,'Dog walking volunteers','Walk our rescue dogs around the Presidio. Short training on arrival.','Park — San Francisco','APPEL_BENEVOLAT','2026-11-20 18:00:00.000000','2026-11-20 20:00:00.000000','2026-11-18 14:45:59.552097',25,40,1,'',37.796566,-122.447173,8,NULL,'','San Francisco',NULL,'America/Los_Angeles',0,'US'),
(95,'Pet food drive','Dry and canned food for 60 rescue dogs and cats.','Community centre — San Francisco','DON','2026-11-19 16:00:00.000000','2026-12-03 16:00:00.000000','2026-11-18 14:45:59.560164',25,40,1,'',37.792425,-122.425627,NULL,400.00,'lbs','San Francisco',NULL,'America/Los_Angeles',0,'US'),
(96,'Après-midi jeux avec les aînés','Bingo, cartes et chocolat chaud au centre communautaire du Plateau.','Parc — Montréal','EVENEMENT','2026-11-25 19:00:00.000000','2026-11-25 22:00:00.000000','2026-11-18 14:45:59.572189',26,41,1,'',45.494986,-73.559729,8,NULL,'','Montréal',NULL,'America/Toronto',0,'CA'),
(97,'Winter coat drive','Warm coats, hats and gloves for shelters across downtown Toronto.','Main hall — Toronto','DON','2026-11-19 13:00:00.000000','2026-12-09 13:00:00.000000','2026-11-18 14:45:59.580030',30,42,1,'',43.654947,-79.345514,NULL,300.00,'coats','Toronto',NULL,'America/Toronto',0,'CA'),
(98,'Shelter breakfast team','Prepare and serve breakfast for 120 guests at the Queen Street shelter.','Park — Toronto','APPEL_BENEVOLAT','2026-11-21 12:00:00.000000','2026-11-21 15:00:00.000000','2026-11-18 14:45:59.587748',30,42,1,'',43.664017,-79.414036,6,NULL,'','Toronto',NULL,'America/Toronto',0,'CA'),
(99,'Match de foot du dimanche à Aïn Diab','On cherche des joueurs pour un 7 contre 7 amical sur le terrain synthétique. Tous niveaux, ramenez de l\'eau !','Centre-ville — Casablanca','ACTIVITE','2026-11-22 16:00:00.000000','2026-11-22 18:00:00.000000','2026-11-18 14:45:59.596753',31,NULL,1,'',33.589216,-7.602586,14,NULL,'','Casablanca',49,'Africa/Casablanca',1,'MA'),
(100,'Club de lecture : L\'Alchimiste','On discute du roman de Paulo Coelho autour d\'un thé à la menthe, au café du jardin d\'essais.','Centre-ville — Rabat','ACTIVITE','2026-11-24 17:00:00.000000','2026-11-24 19:00:00.000000','2026-11-18 14:45:59.604366',32,NULL,1,'',34.016986,-6.845302,10,NULL,'','Rabat',51,'Africa/Casablanca',1,'MA'),
(101,'Atelier cuisine marocaine : tajine et msemen','Je vous apprends les recettes de ma grand-mère. Ingrédients partagés, inscription validée par mes soins.','Centre-ville — Marrakech','ACTIVITE','2026-11-27 09:00:00.000000','2026-11-27 12:00:00.000000','2026-11-18 14:45:59.610211',33,NULL,1,'',31.657813,-7.960143,8,NULL,'','Marrakech',52,'Africa/Casablanca',0,'MA'),
(102,'Pique-nique au parc de la Ligue arabe','Chacun apporte un plat, on s\'occupe des jeux pour les enfants.','Parc — Casablanca','ACTIVITE','2026-11-15 11:00:00.000000','2026-11-15 14:00:00.000000','2026-11-18 14:45:59.617014',33,NULL,1,'',33.595331,-7.605924,20,NULL,'','Casablanca',50,'Africa/Casablanca',1,'MA'),
(103,'Sunday 5-a-side football in Hyde Park','Friendly 5-a-side near the Serpentine. All levels welcome, bring a dark and a light t-shirt.','Community centre — London','ACTIVITE','2026-11-22 10:00:00.000000','2026-11-22 12:00:00.000000','2026-11-18 14:45:59.622416',31,NULL,1,'',51.486370,-0.106599,10,NULL,'','London',55,'Europe/London',1,'GB'),
(104,'Book club: The Midnight Library','Monthly book club at a cosy café in Islington. New faces always welcome!','Park — London','ACTIVITE','2026-11-26 19:00:00.000000','2026-11-26 21:00:00.000000','2026-11-18 14:45:59.627179',32,NULL,1,'',51.513137,-0.128512,12,NULL,'','London',57,'Europe/London',1,'GB'),
(105,'Picnic at Heaton Park','Bring a blanket and something to share. Frisbee and rounders afterwards.','Park — Manchester','ACTIVITE','2026-11-14 12:00:00.000000','2026-11-14 15:00:00.000000','2026-11-18 14:45:59.631842',33,NULL,1,'',53.506546,-2.212302,25,NULL,'','Manchester',58,'Europe/London',1,'GB'),
(106,'Central Park morning run','Easy 8 km loop around the reservoir, conversational pace. Coffee after!','Downtown — New York','ACTIVITE','2026-11-20 12:00:00.000000','2026-11-20 13:30:00.000000','2026-11-18 14:45:59.639790',31,NULL,1,'',40.697167,-74.026730,NULL,NULL,'','New York',59,'America/New_York',1,'US'),
(107,'Board game night','Catan, Ticket to Ride and Codenames in my Brooklyn apartment. Limited seats, I\'ll confirm by message.','Park — New York','ACTIVITE','2026-11-25 00:00:00.000000','2026-11-25 03:00:00.000000','2026-11-18 14:45:59.645153',33,NULL,1,'',40.687939,-74.007121,8,NULL,'','New York',60,'America/New_York',0,'US'),
(108,'Picnic at Dolores Park','Sunny afternoon picnic with a view of the city. Potluck style!','Park — San Francisco','ACTIVITE','2026-11-23 20:00:00.000000','2026-11-23 23:00:00.000000','2026-11-18 14:45:59.653269',33,NULL,1,'',37.803579,-122.416784,30,NULL,'','San Francisco',61,'America/Los_Angeles',1,'US'),
(109,'Pique-nique au parc La Fontaine','Pique-nique partagé près de l\'étang, guitare bienvenue !','Maison de quartier — Montréal','ACTIVITE','2026-11-23 17:00:00.000000','2026-11-23 20:00:00.000000','2026-11-18 14:45:59.662170',33,NULL,1,'',45.479603,-73.569377,25,NULL,'','Montréal',63,'America/Toronto',1,'CA'),
(110,'Randonnée au mont Royal','Montée jusqu\'au belvédère Kondiaronk par les sentiers, rythme tranquille.','Maison de quartier — Montréal','ACTIVITE','2026-11-21 14:00:00.000000','2026-11-21 16:30:00.000000','2026-11-18 14:45:59.672492',31,NULL,1,'',45.487803,-73.537605,15,NULL,'','Montréal',64,'America/Toronto',1,'CA'),
(111,'Pickup basketball at Christie Pits','Casual 3-on-3 and 5-on-5 games. All skill levels.','Main hall — Toronto','ACTIVITE','2026-11-22 23:00:00.000000','2026-11-23 01:00:00.000000','2026-11-18 14:45:59.682273',31,NULL,1,'',43.681062,-79.348887,10,NULL,'','Toronto',65,'America/Toronto',1,'CA'),
(112,'Sunrise yoga in Stanley Park','Gentle flow by the seawall. Bring your own mat.','Community centre — Vancouver','ACTIVITE','2026-11-24 14:00:00.000000','2026-11-24 15:00:00.000000','2026-11-18 14:45:59.696893',31,NULL,1,'',49.295477,-123.128781,20,NULL,'','Vancouver',66,'America/Vancouver',1,'CA'),
(113,'Pique-nique au parc de la Tête d\'Or','Grand pique-nique partagé près de la roseraie. Chacun apporte un plat ou une boisson !','Centre-ville — Lyon','ACTIVITE','2026-11-23 11:00:00.000000','2026-11-23 14:00:00.000000','2026-11-18 14:45:59.710735',33,NULL,1,'',45.760286,4.837106,20,NULL,'','Lyon',39,'Europe/Paris',1,'FR'),
(114,'Soirée jeux de société','Soirée jeux dans un bar à jeux du 11e. Places limitées : je valide les inscriptions.','Parc — Paris','ACTIVITE','2026-11-21 18:00:00.000000','2026-11-21 21:00:00.000000','2026-11-18 14:45:59.724403',33,NULL,1,'',48.841474,2.317322,8,NULL,'','Paris',40,'Europe/Paris',0,'FR'),
(115,'Partie de pétanque sur la Corniche','Pétanque détente face à la mer, boules prêtées si besoin.','Parc — Marseille','ACTIVITE','2026-11-20 16:00:00.000000','2026-11-20 18:00:00.000000','2026-11-18 14:45:59.737736',31,NULL,1,'',43.301799,5.348209,12,NULL,'','Marseille',41,'Europe/Paris',1,'FR'),
(116,'Balade à vélo le long de la Loire','Boucle de 30 km entre Nantes et Trentemoult, pause goûter à mi-parcours.','Maison de quartier — Nantes','ACTIVITE','2026-11-16 09:00:00.000000','2026-11-16 12:00:00.000000','2026-11-18 14:45:59.749006',31,NULL,1,'',47.188831,-1.536973,15,NULL,'','Nantes',42,'Europe/Paris',1,'FR');
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
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_app_annonce_competences_requises`
--

LOCK TABLES `login_app_annonce_competences_requises` WRITE;
/*!40000 ALTER TABLE `login_app_annonce_competences_requises` DISABLE KEYS */;
INSERT INTO `login_app_annonce_competences_requises` VALUES
(45,69,26),
(46,70,35),
(47,71,28),
(48,72,27),
(50,73,27),
(49,73,34),
(51,74,25),
(52,76,35),
(53,77,31),
(54,78,28),
(55,82,29),
(56,83,25),
(57,83,27),
(58,84,34),
(60,85,26),
(59,85,32),
(62,87,28),
(61,87,33),
(63,88,27),
(64,89,26),
(65,90,25),
(66,91,28),
(67,92,35),
(68,93,35),
(69,96,27),
(70,98,25);
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
  `pays` varchar(2) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `login_app_associatio_user_id_3a4787c6_fk_login_app` FOREIGN KEY (`user_id`) REFERENCES `login_app_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_app_associationprofile`
--

LOCK TABLES `login_app_associationprofile` WRITE;
/*!40000 ALTER TABLE `login_app_associationprofile` DISABLE KEYS */;
INSERT INTO `login_app_associationprofile` VALUES
(26,'Le Panier Solidaire','Épicerie solidaire et distributions de repas pour les familles en difficulté du 7e arrondissement.','contact@paniersolidaire.org','','{\"instagram\": \"https://instagram.com/panier_solidaire\"}',67,'12 rue de la Solidarité, Lyon','2025-11-26 14:44:26.129507','','','https://panier-solidaire.example.org','VERIFIEE','01 23 45 67 89','Lyon','FR'),
(27,'Vert Demain','Nettoyage des berges, jardins partagés et ateliers zéro déchet le long de la Loire.','contact@vertdemain.org','','{\"instagram\": \"https://instagram.com/vert_demain\"}',68,'12 rue de la Solidarité, Nantes','2026-08-23 14:44:28.823124','','','https://vert-demain.example.org','VERIFIEE','01 23 45 67 89','Nantes','FR'),
(28,'Lire Ensemble','Soutien scolaire gratuit et ateliers lecture pour les enfants de 6 à 15 ans.','contact@lireensemble.org','','{\"instagram\": \"https://instagram.com/lire_ensemble\"}',69,'12 rue de la Solidarité, Paris','2026-10-07 14:44:31.123083','','','https://lire-ensemble.example.org','VERIFIEE','01 23 45 67 89','Paris','FR'),
(29,'Pattes & Cœurs','Refuge associatif : soins, promenades et adoptions responsables de chiens et chats.','contact@pattescoeurs.org','','{\"instagram\": \"https://instagram.com/pattes_coeurs\"}',70,'12 rue de la Solidarité, Marseille','2026-06-01 14:44:32.840568','','','https://pattes-coeurs.example.org','VERIFIEE','01 23 45 67 89','Marseille','FR'),
(30,'Les Aînés Connectés','Lutte contre l\'isolement des personnes âgées : visites, appels et initiation au numérique.','contact@ainesconnectes.org','','{\"instagram\": \"https://instagram.com/aines_connectes\"}',71,'12 rue de la Solidarité, Bordeaux','2026-06-16 14:44:34.311440','','','https://aines-connectes.example.org','VERIFIEE','01 23 45 67 89','Bordeaux','FR'),
(31,'Sport Pour Tous 31','Rendre le sport accessible à tous, en particulier aux personnes en situation de handicap.','contact@sportpourtous.org','','{\"instagram\": \"https://instagram.com/sport_pour_tous\"}',72,'12 rue de la Solidarité, Toulouse','2026-06-27 14:44:35.759350','','','https://sport-pour-tous.example.org','VERIFIEE','01 23 45 67 89','Toulouse','FR'),
(32,'Toit d\'Abord','Maraudes et accompagnement vers le logement des personnes sans-abri.','contact@toitdabord.org','','{\"instagram\": \"https://instagram.com/toit_dabord\"}',73,'12 rue de la Solidarité, Lille','2026-08-09 14:44:38.596911','','','https://toit-dabord.example.org','EN_ATTENTE','01 23 45 67 89','Lille','FR'),
(33,'Collectif Récup\'Art','Ateliers artistiques à partir de matériaux recyclés, ouverts à tous les quartiers.','contact@recupart.org','','{\"instagram\": \"https://instagram.com/recup_art\"}',74,'12 rue de la Solidarité, Paris','2026-08-28 14:44:42.046679','','','https://recup-art.example.org','EN_ATTENTE','01 23 45 67 89','Paris','FR'),
(34,'Atlas Solidaire','Paniers solidaires, soutien aux villages du Haut Atlas et chantiers bénévoles.','contact@atlassolidaire.org','','{\"instagram\": \"https://instagram.com/atlas_solidaire\"}',75,'12 rue de la Solidarité, Marrakech','2025-11-07 14:44:44.762447','','','https://atlas-solidaire.example.org','VERIFIEE','+212 5 22 00 00 00','Marrakech','MA'),
(35,'Casa Entraide','Soutien scolaire et bibliothèques de quartier pour les enfants de Casablanca.','contact@casaentraide.org','','{\"instagram\": \"https://instagram.com/casa_entraide\"}',76,'12 rue de la Solidarité, Casablanca','2026-01-13 14:44:46.700043','','','https://casa-entraide.example.org','VERIFIEE','+212 5 22 00 00 00','Casablanca','MA'),
(36,'Tanja Verte','Nettoyage des plages et sensibilisation à l\'environnement sur le détroit.','contact@tanjaverte.org','','{\"instagram\": \"https://instagram.com/tanja_verte\"}',77,'12 rue de la Solidarité, Tanger','2026-09-05 14:44:48.912709','','','https://tanja-verte.example.org','EN_ATTENTE','+212 5 22 00 00 00','Tanger','MA'),
(37,'London Food Share','Redistributing surplus food to community kitchens across London.','contact@londonfoodshare.org','','{\"instagram\": \"https://instagram.com/london_food_share\"}',78,'12 Community Street, London','2025-12-21 14:44:51.004027','','','https://london-food-share.example.org','VERIFIEE','+44 20 7946 0000','London','GB'),
(38,'Manchester Reads','Free reading sessions and literacy support for children and adults.','contact@manchesterreads.org','','{\"instagram\": \"https://instagram.com/manchester_reads\"}',79,'12 Community Street, Manchester','2026-03-17 14:44:53.071681','','','https://manchester-reads.example.org','VERIFIEE','+44 20 7946 0000','Manchester','GB'),
(39,'Brooklyn Green Hands','Community gardens, tree planting and park clean-ups in Brooklyn.','contact@brooklyngreen.org','','{\"instagram\": \"https://instagram.com/brooklyn_green\"}',80,'12 Community Street, New York','2026-10-03 14:44:55.189895','','','https://brooklyn-green.example.org','VERIFIEE','+1 212 555 0100','New York','US'),
(40,'Bay Area Paws','Volunteer-run animal rescue: walks, fostering and adoption days.','contact@bayareapaws.org','','{\"instagram\": \"https://instagram.com/bay_area_paws\"}',81,'12 Community Street, San Francisco','2026-10-04 14:44:57.189474','','','https://bay-area-paws.example.org','VERIFIEE','+1 212 555 0100','San Francisco','US'),
(41,'Montréal Cœur Ouvert','Visites, appels et sorties pour les aînés isolés de Montréal.','contact@montrealcoeur.org','','{\"instagram\": \"https://instagram.com/montreal_coeur\"}',82,'12 rue de la Solidarité, Montréal','2026-09-02 14:44:59.169048','','','https://montreal-coeur.example.org','VERIFIEE','+1 514 555 0100','Montréal','CA'),
(42,'Toronto Warm Hearts','Winter coat drives, shelter breakfasts and support for unhoused neighbours.','contact@torontowarm.org','','{\"instagram\": \"https://instagram.com/toronto_warm\"}',83,'12 Community Street, Toronto','2026-06-30 14:45:01.174967','','','https://toronto-warm.example.org','VERIFIEE','+1 514 555 0100','Toronto','CA');
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
) ENGINE=InnoDB AUTO_INCREMENT=138 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_app_avis`
--

LOCK TABLES `login_app_avis` WRITE;
/*!40000 ALTER TABLE `login_app_avis` DISABLE KEYS */;
INSERT INTO `login_app_avis` VALUES
(81,5,'Très fiable, un vrai plaisir.','2026-11-18 14:46:00.938290',69,67,85),
(82,4,'Très fiable, un vrai plaisir.','2026-11-18 14:46:00.947393',69,67,91),
(83,4,'Belle expérience, je recommande !','2026-11-18 14:46:00.950446',69,91,67),
(84,5,'Super énergie, à refaire !','2026-11-18 14:46:00.958624',69,67,84),
(85,5,'Très fiable, un vrai plaisir.','2026-11-18 14:46:00.972382',70,68,92),
(86,5,'Très fiable, un vrai plaisir.','2026-11-18 14:46:00.981691',70,68,93),
(87,5,'Participant·e très sympa et ponctuel·le, merci !','2026-11-18 14:46:00.991204',70,68,87),
(88,5,'Organisation au top, ambiance géniale.','2026-11-18 14:46:00.993344',70,87,68),
(89,5,'Super énergie, à refaire !','2026-11-18 14:46:01.005900',71,69,93),
(90,5,'Très bien encadré, j\'y retourne.','2026-11-18 14:46:01.007631',71,93,69),
(91,4,'Super énergie, à refaire !','2026-11-18 14:46:01.013302',71,69,90),
(92,5,'Très fiable, un vrai plaisir.','2026-11-18 14:46:01.020531',71,69,85),
(93,5,'Très bien encadré, j\'y retourne.','2026-11-18 14:46:01.022130',71,85,69),
(94,5,'Très fiable, un vrai plaisir.','2026-11-18 14:46:01.031327',72,71,91),
(95,5,'Organisation au top, ambiance géniale.','2026-11-18 14:46:01.033319',72,91,71),
(96,5,'Participant·e très sympa et ponctuel·le, merci !','2026-11-18 14:46:01.039537',72,71,88),
(97,5,'Belle expérience, je recommande !','2026-11-18 14:46:01.041794',72,88,71),
(98,4,'Super énergie, à refaire !','2026-11-18 14:46:01.051400',73,72,85),
(99,5,'Belle expérience, je recommande !','2026-11-18 14:46:01.053761',73,85,72),
(100,5,'Super énergie, à refaire !','2026-11-18 14:46:01.060373',73,72,89),
(101,5,'Participant·e très sympa et ponctuel·le, merci !','2026-11-18 14:46:01.072077',88,76,97),
(102,4,'Super énergie, à refaire !','2026-11-18 14:46:01.080434',88,76,95),
(103,4,'Très bien encadré, j\'y retourne.','2026-11-18 14:46:01.083167',88,95,76),
(104,4,'Participant·e très sympa et ponctuel·le, merci !','2026-11-18 14:46:01.090413',88,76,94),
(105,4,'Great energy and always on time, thank you!','2026-11-18 14:46:01.101176',90,78,102),
(106,5,'Brilliantly organised, great vibe.','2026-11-18 14:46:01.103261',90,102,78),
(107,5,'Super reliable, hope to see you again.','2026-11-18 14:46:01.110952',90,78,101),
(108,5,'Wonderful experience, highly recommend!','2026-11-18 14:46:01.112929',90,101,78),
(109,5,'Lovely person to have on the team.','2026-11-18 14:46:01.122476',90,78,100),
(110,4,'Super reliable, hope to see you again.','2026-11-18 14:46:01.135729',93,80,106),
(111,4,'Brilliantly organised, great vibe.','2026-11-18 14:46:01.137637',93,106,80),
(112,5,'Great energy and always on time, thank you!','2026-11-18 14:46:01.146229',93,80,105),
(113,5,'Really well run, will join again.','2026-11-18 14:46:01.148775',93,105,80),
(114,5,'Lovely person to have on the team.','2026-11-18 14:46:01.157158',93,80,104),
(115,5,'Brilliantly organised, great vibe.','2026-11-18 14:46:01.159140',93,104,80),
(116,5,'Très fiable, un vrai plaisir.','2026-11-18 14:46:01.176472',102,95,96),
(117,4,'Participant·e très sympa et ponctuel·le, merci !','2026-11-18 14:46:01.187097',102,95,99),
(118,5,'Très bien encadré, j\'y retourne.','2026-11-18 14:46:01.189070',102,99,95),
(119,5,'Participant·e très sympa et ponctuel·le, merci !','2026-11-18 14:46:01.197384',102,95,97),
(120,5,'Participant·e très sympa et ponctuel·le, merci !','2026-11-18 14:46:01.207381',102,95,98),
(121,5,'Très bien encadré, j\'y retourne.','2026-11-18 14:46:01.209159',102,98,95),
(122,5,'Participant·e très sympa et ponctuel·le, merci !','2026-11-18 14:46:01.216194',102,95,94),
(123,5,'Organisation au top, ambiance géniale.','2026-11-18 14:46:01.218222',102,94,95),
(124,5,'Lovely person to have on the team.','2026-11-18 14:46:01.228965',105,103,100),
(125,5,'Really well run, will join again.','2026-11-18 14:46:01.230546',105,100,103),
(126,5,'Super reliable, hope to see you again.','2026-11-18 14:46:01.237775',105,103,101),
(127,5,'Really well run, will join again.','2026-11-18 14:46:01.239307',105,101,103),
(128,5,'Super reliable, hope to see you again.','2026-11-18 14:46:01.244548',105,103,102),
(129,5,'Wonderful experience, highly recommend!','2026-11-18 14:46:01.246024',105,102,103),
(130,5,'Très fiable, un vrai plaisir.','2026-11-18 14:46:01.255785',116,87,86),
(131,5,'Organisation au top, ambiance géniale.','2026-11-18 14:46:01.257082',116,86,87),
(132,4,'Super énergie, à refaire !','2026-11-18 14:46:01.262725',116,87,91),
(133,4,'Super énergie, à refaire !','2026-11-18 14:46:01.271984',116,87,88),
(134,5,'Belle expérience, je recommande !','2026-11-18 14:46:01.273956',116,88,87),
(135,4,'Super énergie, à refaire !','2026-11-18 14:46:01.279824',116,87,85),
(136,4,'Super énergie, à refaire !','2026-11-18 14:46:01.288585',116,87,93),
(137,5,'Belle expérience, je recommande !','2026-11-18 14:46:01.291964',116,93,87);
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
) ENGINE=InnoDB AUTO_INCREMENT=424 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_app_candidature`
--

LOCK TABLES `login_app_candidature` WRITE;
/*!40000 ALTER TABLE `login_app_candidature` DISABLE KEYS */;
INSERT INTO `login_app_candidature` VALUES
(248,'ACCEPTEE','Je suis partant·e !','2026-11-18 14:45:59.772982',4,69,39,'2e4458b5-5725-4966-9829-a38a3a0622d9','2026-10-26 08:00:00.000000',4.00,1,NULL),
(249,'ACCEPTEE','Disponible et motivé·e, à bientôt.','2026-11-18 14:45:59.788983',4,69,46,'a627bcf8-0d1b-4e74-b502-1afbafeff8ab','2026-10-26 08:00:00.000000',4.00,1,NULL),
(250,'ACCEPTEE','Première fois, j\'ai hâte !','2026-11-18 14:45:59.798309',4,69,40,'25adc2de-9339-40bf-89e0-f4a2df472032','2026-10-26 08:00:00.000000',4.00,1,NULL),
(251,'REFUSEE','Disponible et motivé·e, à bientôt.','2026-11-18 14:45:59.805357',NULL,69,41,'c678e63e-1c5f-430a-89a0-3a3580d8727d','2026-10-26 08:00:00.000000',0.00,0,NULL),
(252,'ACCEPTEE','Première fois, j\'ai hâte !','2026-11-18 14:45:59.813924',4,70,42,'4b49947d-0385-45dc-bcb8-45c1c3b2f2ca','2026-11-02 08:00:00.000000',3.00,1,NULL),
(253,'ACCEPTEE','Première fois, j\'ai hâte !','2026-11-18 14:45:59.827975',5,70,48,'161f3654-65b0-4c5f-9390-a110703c07d0','2026-11-02 08:00:00.000000',3.00,1,NULL),
(254,'ACCEPTEE','Première fois, j\'ai hâte !','2026-11-18 14:45:59.836678',5,70,47,'1f6d2cf8-ece1-408e-bbe1-e4860ff61131','2026-11-02 08:00:00.000000',3.00,1,NULL),
(255,'REFUSEE','Je suis partant·e !','2026-11-18 14:45:59.839720',NULL,70,40,'e6cbbc33-df08-4495-92ad-e0cf217922c3','2026-11-02 08:00:00.000000',0.00,0,NULL),
(256,'ACCEPTEE','Disponible et motivé·e, à bientôt.','2026-11-18 14:45:59.845592',4,71,40,'265faf63-c76d-4c44-9658-e926fb70f22f','2026-11-06 08:00:00.000000',6.00,1,NULL),
(257,'ACCEPTEE','Je suis partant·e !','2026-11-18 14:45:59.861380',4,71,45,'fd5aadd0-bc71-498a-a933-4c792cad1c19','2026-11-06 08:00:00.000000',6.00,1,NULL),
(258,'ACCEPTEE','Première fois, j\'ai hâte !','2026-11-18 14:45:59.874409',5,71,48,'49b1fa61-b79f-49f5-a2cd-abf22d515edf','2026-11-06 08:00:00.000000',6.00,1,NULL),
(259,'REFUSEE','Disponible et motivé·e, à bientôt.','2026-11-18 14:45:59.876628',NULL,71,47,'39bc8908-588e-43c6-aec9-a3ac1915037e','2026-11-06 08:00:00.000000',0.00,0,NULL),
(260,'ACCEPTEE','Disponible et motivé·e, à bientôt.','2026-11-18 14:45:59.884305',5,72,43,'2d6c2903-171e-419e-bfa0-f52bbc6215c6','2026-11-09 13:00:00.000000',3.00,1,NULL),
(261,'ACCEPTEE','Je suis partant·e !','2026-11-18 14:45:59.896688',5,72,46,'e7a7dde4-0ce7-4a98-8166-6bfe689d1af5','2026-11-09 13:00:00.000000',3.00,1,NULL),
(262,'REFUSEE','Première fois, j\'ai hâte !','2026-11-18 14:45:59.903178',NULL,72,48,'c8c137df-c268-46b9-a2c2-4184f9fd4415','2026-11-09 13:00:00.000000',0.00,0,NULL),
(263,'ACCEPTEE','Disponible et motivé·e, à bientôt.','2026-11-18 14:45:59.914877',5,73,44,'61bb4019-2885-4d9c-8103-551e5a6cd316','2026-11-11 09:00:00.000000',5.00,1,NULL),
(264,'ACCEPTEE','Disponible et motivé·e, à bientôt.','2026-11-18 14:45:59.932105',4,73,40,'d35a592e-69be-4b02-925e-22e138ad2454','2026-11-11 09:00:00.000000',5.00,1,NULL),
(265,'REFUSEE','Je suis partant·e !','2026-11-18 14:45:59.936600',NULL,73,39,'fc07cf69-2337-472c-a570-9661356fb910','2026-11-11 09:00:00.000000',0.00,0,NULL),
(266,'ACCEPTEE','Disponible et motivé·e, à bientôt.','2026-11-18 14:45:59.945096',NULL,74,39,'728d1057-a9e6-4c51-bd94-3d2b17beb039','2026-11-20 08:00:00.000000',0.00,0,NULL),
(267,'EN_ATTENTE','Disponible et motivé·e, à bientôt.','2026-11-18 14:45:59.952891',NULL,74,46,'ede83c17-15d0-4da9-a201-cd6b220bb12f',NULL,0.00,0,NULL),
(268,'EN_ATTENTE','Disponible et motivé·e, à bientôt.','2026-11-18 14:45:59.956399',NULL,74,43,'aeabaa38-12fc-4c42-838d-9dec7ccf4d1c',NULL,0.00,0,NULL),
(269,'EN_ATTENTE','Je suis partant·e !','2026-11-18 14:45:59.960834',NULL,74,41,'bdd408a2-fa7f-4984-b050-1e8feb4a7c6e',NULL,0.00,0,NULL),
(270,'ACCEPTEE','Première fois, j\'ai hâte !','2026-11-18 14:45:59.965069',NULL,75,39,'1958c915-14ba-41f6-b81c-ef5d6819a7c8','2026-11-18 07:00:00.000000',0.00,0,5.00),
(271,'ACCEPTEE','Je suis partant·e !','2026-11-18 14:45:59.975117',NULL,75,46,'c356e0f0-28b4-4216-aeff-098d73acadef','2026-11-18 07:00:00.000000',0.00,0,30.00),
(272,'ACCEPTEE','Je suis partant·e !','2026-11-18 14:45:59.979921',NULL,75,41,'2a504e34-8d25-4a6f-99e7-e496abc26553','2026-11-18 07:00:00.000000',0.00,0,5.00),
(273,'ACCEPTEE','Je suis partant·e !','2026-11-18 14:45:59.985980',NULL,75,43,'b120b418-ee90-42d7-8fa5-c0f43007732c','2026-11-18 07:00:00.000000',0.00,0,10.00),
(274,'EN_ATTENTE','Je suis partant·e !','2026-11-18 14:45:59.989674',NULL,76,42,'cd082621-852d-4142-ae0d-a92304f9b8af',NULL,0.00,0,NULL),
(275,'EN_ATTENTE','Je suis partant·e !','2026-11-18 14:45:59.995096',NULL,76,48,'540774d1-060a-4b44-af2e-a05bac7a1954',NULL,0.00,0,NULL),
(276,'EN_ATTENTE','Disponible et motivé·e, à bientôt.','2026-11-18 14:45:59.996769',NULL,76,46,'3e1c9cd0-130f-4b7d-9927-326b0a15b0c7',NULL,0.00,0,NULL),
(277,'EN_ATTENTE','Disponible et motivé·e, à bientôt.','2026-11-18 14:45:59.999001',NULL,76,43,'1770c707-361c-4596-85e2-e528c59b4c01',NULL,0.00,0,NULL),
(278,'EN_ATTENTE','Disponible et motivé·e, à bientôt.','2026-11-18 14:46:00.004992',NULL,77,42,'3c188497-e249-4adf-b22b-de9a311bc3d1',NULL,0.00,0,NULL),
(279,'EN_ATTENTE','Première fois, j\'ai hâte !','2026-11-18 14:46:00.009957',NULL,77,48,'867325b5-0afa-425f-9090-8c7be52576c1',NULL,0.00,0,NULL),
(280,'ACCEPTEE','Première fois, j\'ai hâte !','2026-11-18 14:46:00.023656',NULL,77,44,'f275f0ca-8ba2-4bc3-a780-0bff90a76ab7','2026-11-22 13:00:00.000000',0.00,0,NULL),
(281,'ACCEPTEE','Première fois, j\'ai hâte !','2026-11-18 14:46:00.037294',NULL,77,46,'297f2e5b-cab7-4187-8a0d-039e51054e79','2026-11-22 13:00:00.000000',0.00,0,NULL),
(282,'EN_ATTENTE','Disponible et motivé·e, à bientôt.','2026-11-18 14:46:00.043233',NULL,78,40,'a04978ea-0ec0-47fb-b144-412b7f833706',NULL,0.00,0,NULL),
(283,'EN_ATTENTE','Je suis partant·e !','2026-11-18 14:46:00.054705',NULL,78,45,'e94c452d-8f05-481e-be35-fe390e63a6f2',NULL,0.00,0,NULL),
(284,'ACCEPTEE','Première fois, j\'ai hâte !','2026-11-18 14:46:00.063474',NULL,78,48,'e94bcfc8-9682-4933-8b99-848054c2f30f','2026-11-19 16:00:00.000000',0.00,0,NULL),
(285,'ACCEPTEE','Je suis partant·e !','2026-11-18 14:46:00.072386',NULL,78,41,'93eded89-623f-422b-8d73-cfb0dc0c1840','2026-11-19 16:00:00.000000',0.00,0,NULL),
(286,'ACCEPTEE','Je suis partant·e !','2026-11-18 14:46:00.075856',NULL,79,40,'8de4af9c-98a9-4f75-8b03-895a84803582','2026-11-17 07:00:00.000000',0.00,0,30.00),
(287,'ACCEPTEE','Disponible et motivé·e, à bientôt.','2026-11-18 14:46:00.081880',NULL,79,45,'6f7f9a98-5c64-4376-8fe0-37aaedf1c04f','2026-11-17 07:00:00.000000',0.00,0,30.00),
(288,'ACCEPTEE','Première fois, j\'ai hâte !','2026-11-18 14:46:00.086989',NULL,79,46,'52a6af26-ac31-4ccf-9faf-7e6fa368f79e','2026-11-17 07:00:00.000000',0.00,0,10.00),
(289,'ACCEPTEE','Je suis partant·e !','2026-11-18 14:46:00.091578',NULL,79,39,'628d06a0-0c30-4515-8ffd-c9a306f84a34','2026-11-17 07:00:00.000000',0.00,0,30.00),
(290,'EN_ATTENTE','Première fois, j\'ai hâte !','2026-11-18 14:46:00.097278',NULL,80,41,'69cbde03-4caf-4a0c-8d4a-473db051fb75',NULL,0.00,0,NULL),
(291,'EN_ATTENTE','Première fois, j\'ai hâte !','2026-11-18 14:46:00.108738',NULL,80,40,'03e1e7c2-63fe-470e-8e40-2da4b33b2171',NULL,0.00,0,NULL),
(292,'EN_ATTENTE','Disponible et motivé·e, à bientôt.','2026-11-18 14:46:00.113163',NULL,80,42,'0ab296b4-281e-4d55-a81f-e34271148671',NULL,0.00,0,NULL),
(293,'ACCEPTEE','Première fois, j\'ai hâte !','2026-11-18 14:46:00.119894',NULL,81,41,'60f3ef85-e093-416b-bcb4-c5bee750c1a9','2026-11-17 07:00:00.000000',0.00,0,30.00),
(294,'ACCEPTEE','Je suis partant·e !','2026-11-18 14:46:00.129946',NULL,81,40,'a6d9c827-3488-4296-b4c7-a2dea43c00db','2026-11-17 07:00:00.000000',0.00,0,30.00),
(295,'ACCEPTEE','Je suis partant·e !','2026-11-18 14:46:00.136068',NULL,81,43,'dd7bc87a-562f-4ac0-93f0-8d7180497235','2026-11-17 07:00:00.000000',0.00,0,20.00),
(296,'EN_ATTENTE','Je suis partant·e !','2026-11-18 14:46:00.141175',NULL,82,43,'1c425cc6-7eee-45c6-9909-f0b75ee08dda',NULL,0.00,0,NULL),
(297,'ACCEPTEE','Première fois, j\'ai hâte !','2026-11-18 14:46:00.156011',NULL,82,48,'4ed997b7-06ae-4e08-a690-90eae0977300','2026-11-24 13:00:00.000000',0.00,0,NULL),
(298,'EN_ATTENTE','Je suis partant·e !','2026-11-18 14:46:00.160029',NULL,82,45,'d3ec00b9-bdfb-4635-bc2a-bbce46c98c12',NULL,0.00,0,NULL),
(299,'EN_ATTENTE','Première fois, j\'ai hâte !','2026-11-18 14:46:00.164752',NULL,83,43,'46a46467-7aae-4450-bfd2-2f20320d7ad5',NULL,0.00,0,NULL),
(300,'ACCEPTEE','Disponible et motivé·e, à bientôt.','2026-11-18 14:46:00.184254',NULL,83,44,'272f81f4-e786-43d0-a894-a327ebed310c','2026-12-22 11:00:00.000000',0.00,0,NULL),
(301,'EN_ATTENTE','Disponible et motivé·e, à bientôt.','2026-11-18 14:46:00.189602',NULL,83,46,'9e579e2f-3f7a-4886-98c2-13c0fb79f466',NULL,0.00,0,NULL),
(302,'EN_ATTENTE','Première fois, j\'ai hâte !','2026-11-18 14:46:00.193496',NULL,84,44,'5ac8b19b-adc0-4c06-910b-c9974f6ea781',NULL,0.00,0,NULL),
(303,'ACCEPTEE','Je suis partant·e !','2026-11-18 14:46:00.209301',NULL,84,40,'6b381f4e-9c02-40fc-bbc5-fd13198db11a','2026-11-29 08:00:00.000000',0.00,0,NULL),
(304,'EN_ATTENTE','Première fois, j\'ai hâte !','2026-11-18 14:46:00.214100',NULL,84,39,'fe309a0b-d859-42c9-ac85-b2e220681b2a',NULL,0.00,0,NULL),
(305,'EN_ATTENTE','Je suis partant·e !','2026-11-18 14:46:00.219964',NULL,85,52,'7dcd3828-33c7-496c-b945-d480eb6f1ce3',NULL,0.00,0,NULL),
(306,'EN_ATTENTE','Je suis partant·e !','2026-11-18 14:46:00.226736',NULL,85,54,'1c19f218-7030-4f58-ae59-f876eddeba59',NULL,0.00,0,NULL),
(307,'EN_ATTENTE','Disponible et motivé·e, à bientôt.','2026-11-18 14:46:00.230035',NULL,85,50,'c8249f0e-b97b-4f3c-97d9-2bac423ef843',NULL,0.00,0,NULL),
(308,'EN_ATTENTE','Je suis partant·e !','2026-11-18 14:46:00.235722',NULL,85,51,'ef1b7259-7ab8-42e3-8b2b-fed57ec52298',NULL,0.00,0,NULL),
(309,'ACCEPTEE','Première fois, j\'ai hâte !','2026-11-18 14:46:00.239365',NULL,86,52,'9581aff3-ac45-4904-9380-51daf89678e1','2026-11-17 07:00:00.000000',0.00,0,15.00),
(310,'ACCEPTEE','Première fois, j\'ai hâte !','2026-11-18 14:46:00.246079',NULL,86,54,'c4f31ddd-7f3e-47dd-907a-56fbf98ba89e','2026-11-17 07:00:00.000000',0.00,0,30.00),
(311,'ACCEPTEE','Je suis partant·e !','2026-11-18 14:46:00.250737',NULL,86,53,'43e699dd-dce0-4ea6-bc19-81b7ba80a329','2026-11-17 07:00:00.000000',0.00,0,30.00),
(312,'ACCEPTEE','Disponible et motivé·e, à bientôt.','2026-11-18 14:46:00.255326',NULL,86,51,'bfc9f503-2418-40a9-961e-93e4871c8983','2026-11-17 07:00:00.000000',0.00,0,5.00),
(313,'EN_ATTENTE','Je suis partant·e !','2026-11-18 14:46:00.258278',NULL,87,49,'06ab81d4-23f0-4deb-9c3c-919a8ca46747',NULL,0.00,0,NULL),
(314,'ACCEPTEE','Première fois, j\'ai hâte !','2026-11-18 14:46:00.268965',NULL,87,50,'11246fcb-f7cd-4d6d-86ed-1203e562b9c7','2026-11-18 14:00:00.000000',0.00,0,NULL),
(315,'EN_ATTENTE','Disponible et motivé·e, à bientôt.','2026-11-18 14:46:00.271149',NULL,87,52,'a0b411a4-2bcf-469d-9319-5c689992fc7f',NULL,0.00,0,NULL),
(316,'EN_ATTENTE','Première fois, j\'ai hâte !','2026-11-18 14:46:00.275100',NULL,87,54,'8a295b46-aed5-4623-a834-4fde3943ee1f',NULL,0.00,0,NULL),
(317,'ACCEPTEE','Disponible et motivé·e, à bientôt.','2026-11-18 14:46:00.281387',4,88,49,'575f688a-f149-45a0-9f05-03ed40f204df','2026-11-07 09:00:00.000000',4.00,1,NULL),
(318,'ACCEPTEE','Première fois, j\'ai hâte !','2026-11-18 14:46:00.292348',5,88,50,'9f78028f-4c53-4411-969b-59bc92afd14d','2026-11-07 09:00:00.000000',4.00,1,NULL),
(319,'ACCEPTEE','Disponible et motivé·e, à bientôt.','2026-11-18 14:46:00.299450',5,88,52,'b60e742b-d52f-48a5-9753-3693ee79c42e','2026-11-07 09:00:00.000000',4.00,1,NULL),
(320,'REFUSEE','Disponible et motivé·e, à bientôt.','2026-11-18 14:46:00.303433',NULL,88,53,'57e624de-dfce-450d-b123-8f324b4007ab','2026-11-07 09:00:00.000000',0.00,0,NULL),
(321,'EN_ATTENTE','Count me in!','2026-11-18 14:46:00.307086',NULL,89,55,'43181c47-be83-4361-8cfa-95b070c95410',NULL,0.00,0,NULL),
(322,'ACCEPTEE','Happy to help, see you there.','2026-11-18 14:46:00.317191',NULL,89,56,'364738ad-c79b-4cd8-a275-21af5de33f78','2026-11-19 10:00:00.000000',0.00,0,NULL),
(323,'EN_ATTENTE','Count me in!','2026-11-18 14:46:00.320851',NULL,89,57,'540d0915-5e9a-41d8-b917-a22be0cdef45',NULL,0.00,0,NULL),
(324,'EN_ATTENTE','Happy to help, see you there.','2026-11-18 14:46:00.323949',NULL,89,58,'99294afc-06fc-4ea5-bea1-b1bdba2142af',NULL,0.00,0,NULL),
(325,'ACCEPTEE','First time joining, can\'t wait!','2026-11-18 14:46:00.330665',5,90,55,'5202644d-2c15-4ded-916d-8685bef25bf4','2026-11-10 18:00:00.000000',3.00,1,NULL),
(326,'ACCEPTEE','Count me in!','2026-11-18 14:46:00.342279',5,90,56,'0f2f4673-1cec-41e1-9d8b-c25b36ae0f3a','2026-11-10 18:00:00.000000',3.00,1,NULL),
(327,'ACCEPTEE','Happy to help, see you there.','2026-11-18 14:46:00.347912',5,90,57,'50fdff8a-6fb4-4b4f-96e6-084675a191bc','2026-11-10 18:00:00.000000',3.00,1,NULL),
(328,'REFUSEE','First time joining, can\'t wait!','2026-11-18 14:46:00.351352',NULL,90,58,'65085138-796d-4eb0-b7d3-0b21bff7ac21','2026-11-10 18:00:00.000000',0.00,0,NULL),
(329,'EN_ATTENTE','Count me in!','2026-11-18 14:46:00.354076',NULL,91,58,'9155266e-0298-42e6-9932-883fb68d05d3',NULL,0.00,0,NULL),
(330,'ACCEPTEE','Count me in!','2026-11-18 14:46:00.363265',NULL,91,56,'20d30bd2-e98d-4ec9-a9eb-0b26c3063ebd','2026-11-21 16:00:00.000000',0.00,0,NULL),
(331,'ACCEPTEE','Count me in!','2026-11-18 14:46:00.370664',NULL,91,55,'baee7d79-92f1-4db4-97ba-77187543ed2b','2026-11-21 16:00:00.000000',0.00,0,NULL),
(332,'EN_ATTENTE','Count me in!','2026-11-18 14:46:00.373401',NULL,92,59,'4d938ab4-a9c7-4928-b168-725401ced8cb',NULL,0.00,0,NULL),
(333,'EN_ATTENTE','Happy to help, see you there.','2026-11-18 14:46:00.378817',NULL,92,60,'98020ee9-c0aa-49a7-91d1-c39df4f4782f',NULL,0.00,0,NULL),
(334,'EN_ATTENTE','Count me in!','2026-11-18 14:46:00.381671',NULL,92,62,'f1b11ad6-1211-4bca-a047-aeadc22d9b17',NULL,0.00,0,NULL),
(335,'EN_ATTENTE','Count me in!','2026-11-18 14:46:00.385555',NULL,92,61,'77a2137f-5e70-4af1-a006-f49b5512f701',NULL,0.00,0,NULL),
(336,'ACCEPTEE','Happy to help, see you there.','2026-11-18 14:46:00.392265',5,93,59,'a2c339d5-21bf-43aa-9cc7-05b6884ff0fa','2026-11-08 14:00:00.000000',4.00,1,NULL),
(337,'ACCEPTEE','Happy to help, see you there.','2026-11-18 14:46:00.401692',5,93,60,'8d0fe488-859f-48da-971c-b2f28fcd6a5e','2026-11-08 14:00:00.000000',4.00,1,NULL),
(338,'ACCEPTEE','First time joining, can\'t wait!','2026-11-18 14:46:00.407988',4,93,61,'8506eabf-22b6-4ea9-be7e-9767243dbdbb','2026-11-08 14:00:00.000000',4.00,1,NULL),
(339,'REFUSEE','Count me in!','2026-11-18 14:46:00.410221',NULL,93,62,'01650d70-23a0-4b68-87b3-d596e607a811','2026-11-08 14:00:00.000000',0.00,0,NULL),
(340,'EN_ATTENTE','Count me in!','2026-11-18 14:46:00.412894',NULL,94,61,'a6f8d087-2ac0-47c3-a556-5bfdfc155689',NULL,0.00,0,NULL),
(341,'EN_ATTENTE','First time joining, can\'t wait!','2026-11-18 14:46:00.418689',NULL,94,59,'04f1ba51-1f1d-4807-a259-9ae4f064b3ad',NULL,0.00,0,NULL),
(342,'EN_ATTENTE','Happy to help, see you there.','2026-11-18 14:46:00.421358',NULL,94,62,'21d99a4a-98ed-40cb-bb17-007d7258f0b6',NULL,0.00,0,NULL),
(343,'ACCEPTEE','Happy to help, see you there.','2026-11-18 14:46:00.424157',NULL,95,61,'e214a853-fc27-4052-aea5-fe9e49930bbd','2026-11-17 16:00:00.000000',0.00,0,10.00),
(344,'ACCEPTEE','First time joining, can\'t wait!','2026-11-18 14:46:00.431343',NULL,95,62,'84ecd8a7-0f7d-41c8-bff9-b55e562cb485','2026-11-17 16:00:00.000000',0.00,0,5.00),
(345,'ACCEPTEE','Happy to help, see you there.','2026-11-18 14:46:00.434636',NULL,95,59,'09af1218-3549-45e1-b9f0-50f77603e1f0','2026-11-17 16:00:00.000000',0.00,0,5.00),
(346,'EN_ATTENTE','Disponible et motivé·e, à bientôt.','2026-11-18 14:46:00.437723',NULL,96,63,'6eb08655-2fda-47b4-ab00-6de8ba0d1cba',NULL,0.00,0,NULL),
(347,'EN_ATTENTE','Disponible et motivé·e, à bientôt.','2026-11-18 14:46:00.444301',NULL,96,64,'a65b5ace-1e39-4ffc-9f7e-6263b4979b01',NULL,0.00,0,NULL),
(348,'EN_ATTENTE','Je suis partant·e !','2026-11-18 14:46:00.446890',NULL,96,66,'87247769-586a-44ac-b04e-ad064855efcb',NULL,0.00,0,NULL),
(349,'EN_ATTENTE','Première fois, j\'ai hâte !','2026-11-18 14:46:00.450502',NULL,96,65,'89408b3c-8b1c-4583-b38d-ea744ded4d20',NULL,0.00,0,NULL),
(350,'ACCEPTEE','Happy to help, see you there.','2026-11-18 14:46:00.453618',NULL,97,65,'6b7f25a1-6ff2-4824-9de0-80edd01c4f65','2026-11-17 13:00:00.000000',0.00,0,15.00),
(351,'ACCEPTEE','Count me in!','2026-11-18 14:46:00.459228',NULL,97,63,'43f46da6-d61a-47ce-8def-696064bc40f8','2026-11-17 13:00:00.000000',0.00,0,15.00),
(352,'ACCEPTEE','Happy to help, see you there.','2026-11-18 14:46:00.461791',NULL,97,64,'a71e6884-32cd-4ee0-9f6a-33151782f176','2026-11-17 13:00:00.000000',0.00,0,30.00),
(353,'EN_ATTENTE','Count me in!','2026-11-18 14:46:00.465128',NULL,98,65,'7b37907d-9082-46a0-9ddf-23591a45ee63',NULL,0.00,0,NULL),
(354,'EN_ATTENTE','Count me in!','2026-11-18 14:46:00.470887',NULL,98,64,'766d5cd9-c9cc-478a-96a2-de92ea51b715',NULL,0.00,0,NULL),
(355,'ACCEPTEE','Happy to help, see you there.','2026-11-18 14:46:00.477361',NULL,98,66,'0755cb49-63ca-4714-b34b-b20b0fbd1772','2026-11-19 12:00:00.000000',0.00,0,NULL),
(356,'ACCEPTEE','Disponible et motivé·e, à bientôt.','2026-11-18 14:46:00.484402',NULL,99,50,'d64bae9c-db1f-4604-9019-892b0b721178','2026-11-20 16:00:00.000000',0.00,0,NULL),
(357,'ACCEPTEE','Première fois, j\'ai hâte !','2026-11-18 14:46:00.492901',NULL,99,51,'e06e4bcd-9c27-4dc9-a56a-9676d637a793','2026-11-20 16:00:00.000000',0.00,0,NULL),
(358,'ACCEPTEE','Première fois, j\'ai hâte !','2026-11-18 14:46:00.499117',NULL,99,54,'71a20c4b-0e23-450f-81e3-d5c78ee37a9c','2026-11-20 16:00:00.000000',0.00,0,NULL),
(359,'ACCEPTEE','Je suis partant·e !','2026-11-18 14:46:00.506776',NULL,99,52,'6054d4f6-b6ae-430d-973f-496f49a9c019','2026-11-20 16:00:00.000000',0.00,0,NULL),
(360,'ACCEPTEE','Disponible et motivé·e, à bientôt.','2026-11-18 14:46:00.513067',NULL,99,53,'a678be3a-4f49-4bbb-808b-94479eeb94dd','2026-11-20 16:00:00.000000',0.00,0,NULL),
(361,'ACCEPTEE','Je suis partant·e !','2026-11-18 14:46:00.519950',NULL,100,54,'d5e3c294-1324-41ec-8edd-6def9579ac08','2026-11-22 17:00:00.000000',0.00,0,NULL),
(362,'ACCEPTEE','Première fois, j\'ai hâte !','2026-11-18 14:46:00.527324',NULL,100,50,'653125cf-b52b-4dcb-be57-279e0fe9eb94','2026-11-22 17:00:00.000000',0.00,0,NULL),
(363,'ACCEPTEE','Première fois, j\'ai hâte !','2026-11-18 14:46:00.533656',NULL,100,53,'74af700a-e027-431a-8717-024ec02a99ac','2026-11-22 17:00:00.000000',0.00,0,NULL),
(364,'ACCEPTEE','Première fois, j\'ai hâte !','2026-11-18 14:46:00.539560',NULL,100,49,'ea4d1813-776a-4ad5-a3b5-c96554d080d4','2026-11-22 17:00:00.000000',0.00,0,NULL),
(365,'ACCEPTEE','Disponible et motivé·e, à bientôt.','2026-11-18 14:46:00.545383',NULL,101,54,'e396aab1-c602-43e6-9d4d-93e845cf1ff2','2026-11-25 09:00:00.000000',0.00,0,NULL),
(366,'ACCEPTEE','Je suis partant·e !','2026-11-18 14:46:00.557347',NULL,101,50,'9b3048ee-0960-4ef3-9fec-2aca9b0ded92','2026-11-25 09:00:00.000000',0.00,0,NULL),
(367,'ACCEPTEE','Disponible et motivé·e, à bientôt.','2026-11-18 14:46:00.563956',NULL,101,53,'777882a6-d452-4b07-b8a7-c706cc89e958','2026-11-25 09:00:00.000000',0.00,0,NULL),
(368,'ACCEPTEE','Disponible et motivé·e, à bientôt.','2026-11-18 14:46:00.571579',NULL,101,51,'f3fd9f96-919f-4a07-88b5-6bcd3c179996','2026-11-25 09:00:00.000000',0.00,0,NULL),
(369,'ACCEPTEE','Disponible et motivé·e, à bientôt.','2026-11-18 14:46:00.578196',NULL,101,49,'562643b2-1976-471f-97cf-2a5c57f08dce','2026-11-25 09:00:00.000000',0.00,0,NULL),
(370,'ACCEPTEE','Disponible et motivé·e, à bientôt.','2026-11-18 14:46:00.586195',NULL,102,49,'a869c456-4bd4-4f92-9bf3-cf42c1d9e484','2026-11-13 11:00:00.000000',0.00,1,NULL),
(371,'ACCEPTEE','Première fois, j\'ai hâte !','2026-11-18 14:46:00.595001',NULL,102,53,'718e80e8-77fa-4ddc-b07f-fe757740936f','2026-11-13 11:00:00.000000',0.00,1,NULL),
(372,'ACCEPTEE','Disponible et motivé·e, à bientôt.','2026-11-18 14:46:00.602818',NULL,102,52,'e5f5b640-855d-4e81-8cba-e053dfe1b83e','2026-11-13 11:00:00.000000',0.00,1,NULL),
(373,'ACCEPTEE','Première fois, j\'ai hâte !','2026-11-18 14:46:00.609299',NULL,102,54,'f432ffe5-85f4-481a-801e-ba1997ab5684','2026-11-13 11:00:00.000000',0.00,1,NULL),
(374,'ACCEPTEE','Première fois, j\'ai hâte !','2026-11-18 14:46:00.616059',NULL,102,51,'9d0345a5-be06-4ff8-873d-9d26f6ef16ff','2026-11-13 11:00:00.000000',0.00,1,NULL),
(375,'ACCEPTEE','First time joining, can\'t wait!','2026-11-18 14:46:00.622211',NULL,103,56,'f95e6c74-935e-488e-b57f-e5a9d8e3230a','2026-11-20 10:00:00.000000',0.00,0,NULL),
(376,'ACCEPTEE','Happy to help, see you there.','2026-11-18 14:46:00.631760',NULL,103,57,'29311cd6-1f07-4de4-9d16-ddab1fe46963','2026-11-20 10:00:00.000000',0.00,0,NULL),
(377,'ACCEPTEE','Happy to help, see you there.','2026-11-18 14:46:00.639578',NULL,103,58,'1cbf0631-df49-4516-bfcb-10b1d93468d1','2026-11-20 10:00:00.000000',0.00,0,NULL),
(378,'ACCEPTEE','Happy to help, see you there.','2026-11-18 14:46:00.645672',NULL,104,55,'b878364b-671a-4e95-8a2c-2656f1d3e561','2026-11-24 19:00:00.000000',0.00,0,NULL),
(379,'ACCEPTEE','Count me in!','2026-11-18 14:46:00.655870',NULL,104,56,'d188814a-bdbb-4ed3-9e24-c178f305475c','2026-11-24 19:00:00.000000',0.00,0,NULL),
(380,'ACCEPTEE','Happy to help, see you there.','2026-11-18 14:46:00.661360',NULL,104,58,'4eaeab01-0a56-478f-bd98-8d33a975761d','2026-11-24 19:00:00.000000',0.00,0,NULL),
(381,'ACCEPTEE','Happy to help, see you there.','2026-11-18 14:46:00.667913',NULL,105,57,'e4a2c492-3652-4bca-bd1f-d31d91d9c813','2026-11-12 12:00:00.000000',0.00,1,NULL),
(382,'ACCEPTEE','First time joining, can\'t wait!','2026-11-18 14:46:00.677329',NULL,105,56,'2c5e82d7-d54c-4be3-bc4b-a04764c52bf8','2026-11-12 12:00:00.000000',0.00,1,NULL),
(383,'ACCEPTEE','Count me in!','2026-11-18 14:46:00.683937',NULL,105,55,'20b0aa0e-9db2-4b87-a597-c10e6121438f','2026-11-12 12:00:00.000000',0.00,1,NULL),
(384,'ACCEPTEE','Happy to help, see you there.','2026-11-18 14:46:00.686392',NULL,106,60,'d3b1eeb4-b054-4aaa-b940-be5dfdd30070','2026-11-18 12:00:00.000000',0.00,0,NULL),
(385,'ACCEPTEE','First time joining, can\'t wait!','2026-11-18 14:46:00.691578',NULL,106,62,'f82aaf60-ef83-4aed-870e-73a1b683741e','2026-11-18 12:00:00.000000',0.00,0,NULL),
(386,'ACCEPTEE','First time joining, can\'t wait!','2026-11-18 14:46:00.693736',NULL,106,61,'b2e0f175-9430-4061-a1fe-141c294ee83c','2026-11-18 12:00:00.000000',0.00,0,NULL),
(387,'ACCEPTEE','Happy to help, see you there.','2026-11-18 14:46:00.699924',NULL,107,59,'3edcf732-71e6-4e48-ac98-b8c0e2769e8a','2026-11-23 00:00:00.000000',0.00,0,NULL),
(388,'EN_ATTENTE','Count me in!','2026-11-18 14:46:00.705398',NULL,107,62,'505e5638-fedb-4eb5-85cf-cdbd85afded1',NULL,0.00,0,NULL),
(389,'EN_ATTENTE','Count me in!','2026-11-18 14:46:00.707964',NULL,107,61,'f68e23e4-bb4d-40e7-9eb5-49f4c3c40452',NULL,0.00,0,NULL),
(390,'ACCEPTEE','Count me in!','2026-11-18 14:46:00.713826',NULL,108,59,'96e5547c-4cf1-4dd6-9753-1122226293b6','2026-11-21 20:00:00.000000',0.00,0,NULL),
(391,'ACCEPTEE','Happy to help, see you there.','2026-11-18 14:46:00.723833',NULL,108,62,'0848ac48-c39f-49db-a7ee-fc1b0d37b924','2026-11-21 20:00:00.000000',0.00,0,NULL),
(392,'ACCEPTEE','Happy to help, see you there.','2026-11-18 14:46:00.730232',NULL,108,60,'fdcf4cd6-8e27-4d0c-9fa1-be0d4263005c','2026-11-21 20:00:00.000000',0.00,0,NULL),
(393,'ACCEPTEE','Disponible et motivé·e, à bientôt.','2026-11-18 14:46:00.738427',NULL,109,64,'4e1d0637-93a0-4bc2-9250-eb952c5bdba4','2026-11-21 17:00:00.000000',0.00,0,NULL),
(394,'ACCEPTEE','Je suis partant·e !','2026-11-18 14:46:00.748233',NULL,109,65,'cb0ee67c-09aa-439b-a583-d85cd5cda721','2026-11-21 17:00:00.000000',0.00,0,NULL),
(395,'ACCEPTEE','Je suis partant·e !','2026-11-18 14:46:00.755818',NULL,109,66,'58be0ca8-8399-40a1-8570-4492ef51c36a','2026-11-21 17:00:00.000000',0.00,0,NULL),
(396,'ACCEPTEE','Je suis partant·e !','2026-11-18 14:46:00.761846',NULL,110,63,'d7be5cdf-53db-4c44-ac00-2d4f500367da','2026-11-19 14:00:00.000000',0.00,0,NULL),
(397,'ACCEPTEE','Je suis partant·e !','2026-11-18 14:46:00.771399',NULL,110,65,'8f02d798-1e05-4b89-857a-402fd0859de2','2026-11-19 14:00:00.000000',0.00,0,NULL),
(398,'ACCEPTEE','Première fois, j\'ai hâte !','2026-11-18 14:46:00.777145',NULL,110,66,'3f0f56bb-46d2-4ce7-9bd5-7a804b7e1269','2026-11-19 14:00:00.000000',0.00,0,NULL),
(399,'ACCEPTEE','Count me in!','2026-11-18 14:46:00.783019',NULL,111,66,'c2e6adf8-ec39-4839-b137-78b4418b2903','2026-11-20 23:00:00.000000',0.00,0,NULL),
(400,'ACCEPTEE','Count me in!','2026-11-18 14:46:00.790505',NULL,111,64,'1d96b8bf-1bdd-4c6a-a9a9-4e4b914c2afc','2026-11-20 23:00:00.000000',0.00,0,NULL),
(401,'ACCEPTEE','Happy to help, see you there.','2026-11-18 14:46:00.796003',NULL,111,63,'a9bd1613-fdbf-423e-bb8d-88bfa0bec313','2026-11-20 23:00:00.000000',0.00,0,NULL),
(402,'ACCEPTEE','First time joining, can\'t wait!','2026-11-18 14:46:00.802887',NULL,112,63,'a671c273-bd54-493e-b8f1-6959320b940b','2026-11-22 14:00:00.000000',0.00,0,NULL),
(403,'ACCEPTEE','First time joining, can\'t wait!','2026-11-18 14:46:00.811163',NULL,112,64,'29665f2c-abfd-42fc-bd24-b64bff5671f2','2026-11-22 14:00:00.000000',0.00,0,NULL),
(404,'ACCEPTEE','First time joining, can\'t wait!','2026-11-18 14:46:00.817047',NULL,112,65,'8a631be4-8b20-4447-b000-33e6171d408d','2026-11-22 14:00:00.000000',0.00,0,NULL),
(405,'ACCEPTEE','Première fois, j\'ai hâte !','2026-11-18 14:46:00.822833',NULL,113,46,'86a0035f-0276-42c9-9e22-2e276042ee20','2026-11-21 11:00:00.000000',0.00,0,NULL),
(406,'ACCEPTEE','Disponible et motivé·e, à bientôt.','2026-11-18 14:46:00.830159',NULL,113,47,'2ec87cb5-e1c7-4ede-9e56-3d8f8c9a54fa','2026-11-21 11:00:00.000000',0.00,0,NULL),
(407,'ACCEPTEE','Disponible et motivé·e, à bientôt.','2026-11-18 14:46:00.836557',NULL,113,48,'757e1111-15a6-4db4-a3ec-0798021a2a7f','2026-11-21 11:00:00.000000',0.00,0,NULL),
(408,'ACCEPTEE','Disponible et motivé·e, à bientôt.','2026-11-18 14:46:00.841561',NULL,113,44,'e4b5d236-1950-4bca-968e-3dc854285bcf','2026-11-21 11:00:00.000000',0.00,0,NULL),
(409,'ACCEPTEE','Je suis partant·e !','2026-11-18 14:46:00.846903',NULL,113,43,'c53d8220-bb4c-4ce1-abef-62cc69b174bc','2026-11-21 11:00:00.000000',0.00,0,NULL),
(410,'EN_ATTENTE','Disponible et motivé·e, à bientôt.','2026-11-18 14:46:00.851163',NULL,114,45,'94ee192d-bb25-4ec5-9011-05ddb60f3704',NULL,0.00,0,NULL),
(411,'EN_ATTENTE','Première fois, j\'ai hâte !','2026-11-18 14:46:00.856908',NULL,114,44,'5b56023d-0bf1-48de-8157-f8fb77dda1f0',NULL,0.00,0,NULL),
(412,'EN_ATTENTE','Je suis partant·e !','2026-11-18 14:46:00.858994',NULL,114,47,'c4ee0149-a086-4828-89f8-29a7d9061a4b',NULL,0.00,0,NULL),
(413,'EN_ATTENTE','Disponible et motivé·e, à bientôt.','2026-11-18 14:46:00.860665',NULL,114,48,'d256de05-eb97-4ad0-b818-406f0e908c94',NULL,0.00,0,NULL),
(414,'EN_ATTENTE','Première fois, j\'ai hâte !','2026-11-18 14:46:00.862250',NULL,114,43,'d864d253-5106-4492-96a1-d14417106e72',NULL,0.00,0,NULL),
(415,'ACCEPTEE','Première fois, j\'ai hâte !','2026-11-18 14:46:00.867942',NULL,115,40,'56d73237-46cc-4407-995f-12596c48b552','2026-11-18 16:00:00.000000',0.00,0,NULL),
(416,'ACCEPTEE','Je suis partant·e !','2026-11-18 14:46:00.874959',NULL,115,42,'18a8dcb5-25cc-4ccf-84ea-aff927c4461d','2026-11-18 16:00:00.000000',0.00,0,NULL),
(417,'ACCEPTEE','Première fois, j\'ai hâte !','2026-11-18 14:46:00.881387',NULL,115,48,'f945ace2-1db8-4842-8e16-f6aa044ae458','2026-11-18 16:00:00.000000',0.00,0,NULL),
(418,'ACCEPTEE','Je suis partant·e !','2026-11-18 14:46:00.888022',NULL,115,46,'3121af1e-dba6-44a9-8690-fc62a3d1e137','2026-11-18 16:00:00.000000',0.00,0,NULL),
(419,'ACCEPTEE','Disponible et motivé·e, à bientôt.','2026-11-18 14:46:00.893261',NULL,116,48,'cd81d917-6e47-4bfa-ba92-f23b6106c559','2026-11-14 09:00:00.000000',0.00,1,NULL),
(420,'ACCEPTEE','Disponible et motivé·e, à bientôt.','2026-11-18 14:46:00.902186',NULL,116,40,'764ef7b3-58f1-4bbf-83f4-f22890fbc701','2026-11-14 09:00:00.000000',0.00,1,NULL),
(421,'ACCEPTEE','Je suis partant·e !','2026-11-18 14:46:00.907322',NULL,116,43,'052359b1-3b3d-46e5-97ca-35560b88d7da','2026-11-14 09:00:00.000000',0.00,1,NULL),
(422,'ACCEPTEE','Je suis partant·e !','2026-11-18 14:46:00.913336',NULL,116,46,'2cc532ac-e3ab-4618-af1e-6cc18a00c318','2026-11-14 09:00:00.000000',0.00,1,NULL),
(423,'ACCEPTEE','Disponible et motivé·e, à bientôt.','2026-11-18 14:46:00.921757',NULL,116,41,'606f6ac4-ffdd-4239-bbfb-d230aa222b75','2026-11-14 09:00:00.000000',0.00,1,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_app_categorie`
--

LOCK TABLES `login_app_categorie` WRITE;
/*!40000 ALTER TABLE `login_app_categorie` DISABLE KEYS */;
INSERT INTO `login_app_categorie` VALUES
(22,'Solidarité alimentaire','#F26B3A','🥕'),
(23,'Environnement','#2E9E6A','🌿'),
(24,'Éducation','#3D6FD8','📚'),
(25,'Animaux','#B5651D','🐾'),
(26,'Seniors','#C2477A','🫶'),
(27,'Sport & handicap','#0E9AA7','🏅'),
(28,'Santé','#D64545','🩺'),
(29,'Culture','#8A5CF6','🎨'),
(30,'Logement','#6B7B3A','🏠'),
(31,'Sport entre amis','#E4572E','⚽'),
(32,'Lecture','#5B8C5A','📖'),
(33,'Loisirs & sorties','#D98E04','🧺');
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
  `pays` varchar(2) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `login_app_citoyenprofile_user_id_b1a2d76a_fk_login_app_user_id` FOREIGN KEY (`user_id`) REFERENCES `login_app_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_app_citoyenprofile`
--

LOCK TABLES `login_app_citoyenprofile` WRITE;
/*!40000 ALTER TABLE `login_app_citoyenprofile` DISABLE KEYS */;
INSERT INTO `login_app_citoyenprofile` VALUES
(39,'Emma','Martin','Emma, de Lyon. J\'aime me rendre utile et rencontrer du monde près de chez moi.','Bénévolat associatif depuis 2 ans.',84,'','Lyon','FR'),
(40,'Lucas','Bernard','Lucas, de Paris. J\'aime me rendre utile et rencontrer du monde près de chez moi.','Bénévolat associatif depuis 2 ans.',85,'','Paris','FR'),
(41,'Inès','Haddad','Inès, de Marseille. J\'aime me rendre utile et rencontrer du monde près de chez moi.','Bénévolat associatif depuis 2 ans.',86,'','Marseille','FR'),
(42,'Hugo','Petit','Hugo, de Nantes. J\'aime me rendre utile et rencontrer du monde près de chez moi.','Bénévolat associatif depuis 2 ans.',87,'','Nantes','FR'),
(43,'Chloé','Dubois','Chloé, de Bordeaux. J\'aime me rendre utile et rencontrer du monde près de chez moi.','Bénévolat associatif depuis 2 ans.',88,'','Bordeaux','FR'),
(44,'Yanis','Moreau','Yanis, de Toulouse. J\'aime me rendre utile et rencontrer du monde près de chez moi.','Bénévolat associatif depuis 2 ans.',89,'','Toulouse','FR'),
(45,'Léa','Laurent','Léa, de Paris. J\'aime me rendre utile et rencontrer du monde près de chez moi.','Bénévolat associatif depuis 2 ans.',90,'','Paris','FR'),
(46,'Adam','Benali','Adam, de Lyon. J\'aime me rendre utile et rencontrer du monde près de chez moi.','Bénévolat associatif depuis 2 ans.',91,'','Lyon','FR'),
(47,'Manon','Girard','Manon, de Lille. J\'aime me rendre utile et rencontrer du monde près de chez moi.','Bénévolat associatif depuis 2 ans.',92,'','Lille','FR'),
(48,'Nathan','Roux','Nathan, de Nantes. J\'aime me rendre utile et rencontrer du monde près de chez moi.','Bénévolat associatif depuis 2 ans.',93,'','Nantes','FR'),
(49,'Yassine','El Amrani','Yassine, de Casablanca. J\'aime me rendre utile et rencontrer du monde près de chez moi.','Bénévolat associatif depuis 2 ans.',94,'','Casablanca','MA'),
(50,'Imane','Alaoui','Imane, de Casablanca. J\'aime me rendre utile et rencontrer du monde près de chez moi.','Bénévolat associatif depuis 2 ans.',95,'','Casablanca','MA'),
(51,'Salma','Benjelloun','Salma, de Rabat. J\'aime me rendre utile et rencontrer du monde près de chez moi.','Bénévolat associatif depuis 2 ans.',96,'','Rabat','MA'),
(52,'Omar','Tazi','Omar, de Marrakech. J\'aime me rendre utile et rencontrer du monde près de chez moi.','Bénévolat associatif depuis 2 ans.',97,'','Marrakech','MA'),
(53,'Karim','Berrada','Karim, de Tanger. J\'aime me rendre utile et rencontrer du monde près de chez moi.','Bénévolat associatif depuis 2 ans.',98,'','Tanger','MA'),
(54,'Nora','Chraibi','Nora, de Marrakech. J\'aime me rendre utile et rencontrer du monde près de chez moi.','Bénévolat associatif depuis 2 ans.',99,'','Marrakech','MA'),
(55,'Oliver','Smith','Oliver from London. I love meeting people and helping out locally.','Volunteering for 2 years.',100,'','London','GB'),
(56,'Amelia','Jones','Amelia from London. I love meeting people and helping out locally.','Volunteering for 2 years.',101,'','London','GB'),
(57,'Priya','Patel','Priya from London. I love meeting people and helping out locally.','Volunteering for 2 years.',102,'','London','GB'),
(58,'Harry','Wilson','Harry from Manchester. I love meeting people and helping out locally.','Volunteering for 2 years.',103,'','Manchester','GB'),
(59,'James','Miller','James from New York. I love meeting people and helping out locally.','Volunteering for 2 years.',104,'','New York','US'),
(60,'Emily','Davis','Emily from New York. I love meeting people and helping out locally.','Volunteering for 2 years.',105,'','New York','US'),
(61,'Sofia','Garcia','Sofia from San Francisco. I love meeting people and helping out locally.','Volunteering for 2 years.',106,'','San Francisco','US'),
(62,'Michael','Brown','Michael from Chicago. I love meeting people and helping out locally.','Volunteering for 2 years.',107,'','Chicago','US'),
(63,'Liam','Tremblay','Liam, de Montréal. J\'aime me rendre utile et rencontrer du monde près de chez moi.','Bénévolat associatif depuis 2 ans.',108,'','Montréal','CA'),
(64,'Chloé','Gagnon','Chloé, de Montréal. J\'aime me rendre utile et rencontrer du monde près de chez moi.','Bénévolat associatif depuis 2 ans.',109,'','Montréal','CA'),
(65,'Noah','Wong','Noah from Toronto. I love meeting people and helping out locally.','Volunteering for 2 years.',110,'','Toronto','CA'),
(66,'Olivia','Martin','Olivia from Vancouver. I love meeting people and helping out locally.','Volunteering for 2 years.',111,'','Vancouver','CA');
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
) ENGINE=InnoDB AUTO_INCREMENT=139 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_app_citoyenprofile_centres_interet`
--

LOCK TABLES `login_app_citoyenprofile_centres_interet` WRITE;
/*!40000 ALTER TABLE `login_app_citoyenprofile_centres_interet` DISABLE KEYS */;
INSERT INTO `login_app_citoyenprofile_centres_interet` VALUES
(81,39,22),
(80,39,26),
(79,39,33),
(82,40,24),
(84,40,29),
(83,40,32),
(85,41,25),
(86,41,28),
(87,41,31),
(89,42,23),
(88,42,31),
(90,43,24),
(91,43,26),
(92,44,27),
(93,44,31),
(96,45,23),
(95,45,29),
(94,45,33),
(97,46,22),
(98,46,30),
(99,47,24),
(100,47,30),
(102,48,23),
(101,48,31),
(103,49,24),
(104,49,31),
(105,50,24),
(106,50,33),
(108,51,29),
(107,51,32),
(110,52,22),
(109,52,33),
(112,53,23),
(111,53,31),
(114,54,22),
(113,54,33),
(115,55,22),
(116,55,31),
(118,56,22),
(117,56,32),
(120,57,24),
(119,57,32),
(122,58,31),
(121,58,33),
(123,59,23),
(124,59,31),
(126,60,23),
(125,60,33),
(127,61,25),
(128,61,33),
(129,62,24),
(130,62,31),
(132,63,26),
(131,63,33),
(133,64,26),
(134,64,31),
(135,65,30),
(136,65,31),
(137,66,23),
(138,66,31);
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
) ENGINE=InnoDB AUTO_INCREMENT=133 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_app_citoyenprofile_competences`
--

LOCK TABLES `login_app_citoyenprofile_competences` WRITE;
/*!40000 ALTER TABLE `login_app_citoyenprofile_competences` DISABLE KEYS */;
INSERT INTO `login_app_citoyenprofile_competences` VALUES
(77,39,25),
(78,39,26),
(79,40,28),
(80,40,29),
(82,41,30),
(81,41,34),
(84,42,31),
(83,42,35),
(85,43,27),
(86,43,29),
(88,44,27),
(87,44,34),
(90,45,30),
(89,45,36),
(92,46,26),
(91,46,32),
(94,47,28),
(93,47,33),
(96,48,31),
(95,48,32),
(98,49,27),
(97,49,34),
(99,50,25),
(100,50,30),
(102,51,28),
(101,51,33),
(103,52,25),
(104,52,26),
(105,53,32),
(106,53,35),
(107,54,27),
(108,54,36),
(109,55,26),
(110,55,27),
(111,56,25),
(112,56,30),
(113,57,28),
(114,57,29),
(116,58,31),
(115,58,34),
(118,59,26),
(117,59,34),
(119,60,35),
(120,60,36),
(122,61,30),
(121,61,33),
(123,62,27),
(124,62,29),
(125,63,25),
(126,63,27),
(127,64,34),
(128,64,36),
(129,65,26),
(130,65,29),
(132,66,27),
(131,66,35);
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
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_app_competence`
--

LOCK TABLES `login_app_competence` WRITE;
/*!40000 ALTER TABLE `login_app_competence` DISABLE KEYS */;
INSERT INTO `login_app_competence` VALUES
(27,'Animation'),
(31,'Bricolage'),
(30,'Communication'),
(25,'Cuisine'),
(29,'Informatique'),
(35,'Jardinage'),
(33,'Langues étrangères'),
(26,'Logistique'),
(32,'Permis B'),
(36,'Photographie'),
(34,'Premiers secours'),
(28,'Soutien scolaire');
/*!40000 ALTER TABLE `login_app_competence` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_app_groupediscussion`
--

DROP TABLE IF EXISTS `login_app_groupediscussion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `login_app_groupediscussion` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `nom` varchar(255) NOT NULL,
  `ferme` tinyint(1) NOT NULL,
  `date_fermeture` datetime(6) DEFAULT NULL,
  `date_creation` datetime(6) NOT NULL,
  `annonce_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `annonce_id` (`annonce_id`),
  CONSTRAINT `login_app_groupedisc_annonce_id_622327d7_fk_login_app` FOREIGN KEY (`annonce_id`) REFERENCES `login_app_annonce` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_app_groupediscussion`
--

LOCK TABLES `login_app_groupediscussion` WRITE;
/*!40000 ALTER TABLE `login_app_groupediscussion` DISABLE KEYS */;
INSERT INTO `login_app_groupediscussion` VALUES
(19,'Match de foot du dimanche à Aïn Diab',0,NULL,'2026-11-18 14:46:01.294005',99),
(20,'Club de lecture : L\'Alchimiste',0,NULL,'2026-11-18 14:46:01.559350',100),
(21,'Pique-nique au parc de la Ligue arabe',1,'2026-11-15 14:00:00.000000','2026-11-18 14:46:01.744385',102),
(22,'Sunday 5-a-side football in Hyde Park',0,NULL,'2026-11-18 14:46:01.886872',103),
(23,'Book club: The Midnight Library',0,NULL,'2026-11-18 14:46:02.055940',104),
(24,'Picnic at Heaton Park',1,'2026-11-14 15:00:00.000000','2026-11-18 14:46:02.179942',105),
(25,'Central Park morning run',0,NULL,'2026-11-18 14:46:02.307596',106),
(26,'Picnic at Dolores Park',0,NULL,'2026-11-18 14:46:02.448152',108),
(27,'Pique-nique au parc La Fontaine',0,NULL,'2026-11-18 14:46:02.540139',109),
(28,'Randonnée au mont Royal',0,NULL,'2026-11-18 14:46:02.635526',110),
(29,'Pique-nique au parc de la Tête d\'Or',0,NULL,'2026-11-18 14:46:02.729477',113),
(30,'Partie de pétanque sur la Corniche',0,NULL,'2026-11-18 14:46:02.935500',115),
(31,'Balade à vélo le long de la Loire',1,'2026-11-16 12:00:00.000000','2026-11-18 14:46:03.107438',116),
(32,'Cuisine solidaire du samedi',0,NULL,'2026-11-18 14:46:03.237272',74),
(33,'Distribution de paniers dans le Haut Atlas',0,NULL,'2026-11-18 14:46:03.328358',85),
(34,'Saturday food sorting',0,NULL,'2026-11-18 14:46:03.372192',89),
(35,'Prospect Park clean-up',0,NULL,'2026-11-18 14:46:03.478550',92),
(36,'Community garden planting',1,'2026-11-10 18:00:00.000000','2026-11-18 14:46:03.531044',93);
/*!40000 ALTER TABLE `login_app_groupediscussion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_app_membregroupe`
--

DROP TABLE IF EXISTS `login_app_membregroupe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `login_app_membregroupe` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `role` varchar(15) NOT NULL,
  `date_ajout` datetime(6) NOT NULL,
  `dernier_lu` datetime(6) DEFAULT NULL,
  `groupe_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `membre_groupe_unique` (`groupe_id`,`user_id`),
  KEY `login_app_membregroupe_user_id_46b2fc43_fk_login_app_user_id` (`user_id`),
  CONSTRAINT `login_app_membregrou_groupe_id_fd39a460_fk_login_app` FOREIGN KEY (`groupe_id`) REFERENCES `login_app_groupediscussion` (`id`),
  CONSTRAINT `login_app_membregroupe_user_id_46b2fc43_fk_login_app_user_id` FOREIGN KEY (`user_id`) REFERENCES `login_app_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=145 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_app_membregroupe`
--

LOCK TABLES `login_app_membregroupe` WRITE;
/*!40000 ALTER TABLE `login_app_membregroupe` DISABLE KEYS */;
INSERT INTO `login_app_membregroupe` VALUES
(73,'ORGANISATEUR','2026-11-18 14:46:01.295913','2026-11-18 15:12:02.922745',19,94),
(74,'MEMBRE','2026-11-18 14:46:01.341058',NULL,19,98),
(75,'MEMBRE','2026-11-18 14:46:01.377752',NULL,19,97),
(76,'MEMBRE','2026-11-18 14:46:01.417551',NULL,19,99),
(77,'MEMBRE','2026-11-18 14:46:01.451158',NULL,19,96),
(78,'MEMBRE','2026-11-18 14:46:01.485744',NULL,19,95),
(79,'ORGANISATEUR','2026-11-18 14:46:01.562381',NULL,20,96),
(80,'MEMBRE','2026-11-18 14:46:01.590783',NULL,20,94),
(81,'MEMBRE','2026-11-18 14:46:01.621749',NULL,20,98),
(82,'MEMBRE','2026-11-18 14:46:01.652800',NULL,20,95),
(83,'MEMBRE','2026-11-18 14:46:01.681921',NULL,20,99),
(84,'ORGANISATEUR','2026-11-18 14:46:01.746897','2026-11-18 15:12:31.291992',21,95),
(85,'MEMBRE','2026-11-18 14:46:01.771136',NULL,21,96),
(86,'MEMBRE','2026-11-18 14:46:01.777268',NULL,21,99),
(87,'MEMBRE','2026-11-18 14:46:01.784072',NULL,21,97),
(88,'MEMBRE','2026-11-18 14:46:01.790613',NULL,21,98),
(89,'MEMBRE','2026-11-18 14:46:01.797195',NULL,21,94),
(90,'ORGANISATEUR','2026-11-18 14:46:01.889196',NULL,22,100),
(91,'MEMBRE','2026-11-18 14:46:01.910235',NULL,22,103),
(92,'MEMBRE','2026-11-18 14:46:01.944918',NULL,22,102),
(93,'MEMBRE','2026-11-18 14:46:01.999499',NULL,22,101),
(94,'ORGANISATEUR','2026-11-18 14:46:02.057614',NULL,23,102),
(95,'MEMBRE','2026-11-18 14:46:02.073318',NULL,23,103),
(96,'MEMBRE','2026-11-18 14:46:02.094017',NULL,23,101),
(97,'MEMBRE','2026-11-18 14:46:02.119351',NULL,23,100),
(98,'ORGANISATEUR','2026-11-18 14:46:02.184386',NULL,24,103),
(99,'MEMBRE','2026-11-18 14:46:02.210312',NULL,24,100),
(100,'MEMBRE','2026-11-18 14:46:02.219936',NULL,24,101),
(101,'MEMBRE','2026-11-18 14:46:02.229447',NULL,24,102),
(102,'ORGANISATEUR','2026-11-18 14:46:02.309806',NULL,25,104),
(103,'MEMBRE','2026-11-18 14:46:02.340305',NULL,25,106),
(104,'MEMBRE','2026-11-18 14:46:02.375712',NULL,25,107),
(105,'MEMBRE','2026-11-18 14:46:02.405121',NULL,25,105),
(106,'ORGANISATEUR','2026-11-18 14:46:02.450453',NULL,26,106),
(107,'MEMBRE','2026-11-18 14:46:02.466104',NULL,26,105),
(108,'MEMBRE','2026-11-18 14:46:02.487019',NULL,26,107),
(109,'MEMBRE','2026-11-18 14:46:02.506490',NULL,26,104),
(110,'ORGANISATEUR','2026-11-18 14:46:02.541525',NULL,27,108),
(111,'MEMBRE','2026-11-18 14:46:02.556143',NULL,27,111),
(112,'MEMBRE','2026-11-18 14:46:02.576418',NULL,27,110),
(113,'MEMBRE','2026-11-18 14:46:02.597759',NULL,27,109),
(114,'ORGANISATEUR','2026-11-18 14:46:02.637084',NULL,28,109),
(115,'MEMBRE','2026-11-18 14:46:02.652119',NULL,28,111),
(116,'MEMBRE','2026-11-18 14:46:02.671509',NULL,28,110),
(117,'MEMBRE','2026-11-18 14:46:02.691420',NULL,28,108),
(118,'ORGANISATEUR','2026-11-18 14:46:02.731341',NULL,29,84),
(119,'MEMBRE','2026-11-18 14:46:02.751889',NULL,29,88),
(120,'MEMBRE','2026-11-18 14:46:02.781544',NULL,29,89),
(121,'MEMBRE','2026-11-18 14:46:02.812567',NULL,29,93),
(122,'MEMBRE','2026-11-18 14:46:02.845662',NULL,29,92),
(123,'MEMBRE','2026-11-18 14:46:02.877603',NULL,29,91),
(124,'ORGANISATEUR','2026-11-18 14:46:02.937864',NULL,30,86),
(125,'MEMBRE','2026-11-18 14:46:02.959648',NULL,30,91),
(126,'MEMBRE','2026-11-18 14:46:02.988343',NULL,30,93),
(127,'MEMBRE','2026-11-18 14:46:03.016499',NULL,30,87),
(128,'MEMBRE','2026-11-18 14:46:03.046198',NULL,30,85),
(129,'ORGANISATEUR','2026-11-18 14:46:03.109821',NULL,31,87),
(130,'MEMBRE','2026-11-18 14:46:03.131675',NULL,31,86),
(131,'MEMBRE','2026-11-18 14:46:03.139265',NULL,31,91),
(132,'MEMBRE','2026-11-18 14:46:03.145952',NULL,31,88),
(133,'MEMBRE','2026-11-18 14:46:03.153931',NULL,31,85),
(134,'MEMBRE','2026-11-18 14:46:03.160362',NULL,31,93),
(135,'ORGANISATEUR','2026-11-18 14:46:03.239507',NULL,32,67),
(136,'MEMBRE','2026-11-18 14:46:03.260961',NULL,32,84),
(137,'ORGANISATEUR','2026-11-18 14:46:03.330974',NULL,33,75),
(138,'ORGANISATEUR','2026-11-18 14:46:03.374824',NULL,34,78),
(139,'MEMBRE','2026-11-18 14:46:03.398741',NULL,34,101),
(140,'ORGANISATEUR','2026-11-18 14:46:03.482674',NULL,35,80),
(141,'ORGANISATEUR','2026-11-18 14:46:03.535658',NULL,36,80),
(142,'MEMBRE','2026-11-18 14:46:03.553733',NULL,36,106),
(143,'MEMBRE','2026-11-18 14:46:03.559739',NULL,36,105),
(144,'MEMBRE','2026-11-18 14:46:03.565223',NULL,36,104);
/*!40000 ALTER TABLE `login_app_membregroupe` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_app_message`
--

LOCK TABLES `login_app_message` WRITE;
/*!40000 ALTER TABLE `login_app_message` DISABLE KEYS */;
INSERT INTO `login_app_message` VALUES
(16,'Bonjour ! Faut-il apporter quelque chose pour la cuisine solidaire ?','2026-11-18 14:46:03.628042',67,84,1),
(17,'Bonjour Emma, juste de bonnes chaussures fermées, on fournit le reste 🙂','2026-11-18 14:46:03.630580',84,67,1),
(18,'Parfait, à samedi !','2026-11-18 14:46:03.633662',67,84,0),
(19,'Je peux aussi aider pour l\'atelier code si besoin.','2026-11-18 14:46:03.636063',69,85,1),
(20,'Super, on vous ajoute à la liste. Merci Lucas !','2026-11-18 14:46:03.638069',85,69,0),
(21,'Hi! Is there parking near the warehouse?','2026-11-18 14:46:03.639924',78,100,1),
(22,'Hi Oliver, yes, free parking on Wick Lane on Saturdays.','2026-11-18 14:46:03.642239',100,78,0),
(23,'Salam ! Je peux venir aider pour le soutien scolaire en maths.','2026-11-18 14:46:03.644275',76,94,0);
/*!40000 ALTER TABLE `login_app_message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_app_messagegroupe`
--

DROP TABLE IF EXISTS `login_app_messagegroupe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `login_app_messagegroupe` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `contenu` longtext NOT NULL,
  `systeme` tinyint(1) NOT NULL,
  `date_envoi` datetime(6) NOT NULL,
  `auteur_id` bigint(20) DEFAULT NULL,
  `groupe_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `login_app_messagegroupe_auteur_id_adc45add_fk_login_app_user_id` (`auteur_id`),
  KEY `login_app_messagegro_groupe_id_e25e6cc8_fk_login_app` (`groupe_id`),
  CONSTRAINT `login_app_messagegro_groupe_id_e25e6cc8_fk_login_app` FOREIGN KEY (`groupe_id`) REFERENCES `login_app_groupediscussion` (`id`),
  CONSTRAINT `login_app_messagegroupe_auteur_id_adc45add_fk_login_app_user_id` FOREIGN KEY (`auteur_id`) REFERENCES `login_app_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=271 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_app_messagegroupe`
--

LOCK TABLES `login_app_messagegroupe` WRITE;
/*!40000 ALTER TABLE `login_app_messagegroupe` DISABLE KEYS */;
INSERT INTO `login_app_messagegroupe` VALUES
(136,'👋 Groupe créé par Yassine El Amrani. Les participants acceptés le rejoignent automatiquement ; il sera fermé à la fin de l\'activité.',1,'2026-11-18 08:46:01.293244',NULL,19),
(137,'Karim Berrada a rejoint le groupe.',1,'2026-11-18 08:46:01.293244',NULL,19),
(138,'Omar Tazi a rejoint le groupe.',1,'2026-11-18 08:46:01.293244',NULL,19),
(139,'Nora Chraibi a rejoint le groupe.',1,'2026-11-18 08:46:01.293244',NULL,19),
(140,'Salma Benjelloun a rejoint le groupe.',1,'2026-11-18 08:46:01.293244',NULL,19),
(141,'Imane Alaoui a rejoint le groupe.',1,'2026-11-18 08:46:01.293244',NULL,19),
(142,'Bonjour à tous, ravi·e de participer !',0,'2026-11-18 09:03:01.293244',98,19),
(143,'On se retrouve à l\'entrée principale ?',0,'2026-11-18 09:20:01.293244',97,19),
(144,'Oui, 10 minutes avant le début, ce sera parfait.',0,'2026-11-18 09:37:01.293244',99,19),
(145,'J\'apporte de l\'eau et des gobelets pour tout le monde 🙂',0,'2026-11-18 09:54:01.293244',96,19),
(146,'👋 Groupe créé par Salma Benjelloun. Les participants acceptés le rejoignent automatiquement ; il sera fermé à la fin de l\'activité.',1,'2026-11-18 08:46:01.293244',NULL,20),
(147,'Yassine El Amrani a rejoint le groupe.',1,'2026-11-18 08:46:01.293244',NULL,20),
(148,'Karim Berrada a rejoint le groupe.',1,'2026-11-18 08:46:01.293244',NULL,20),
(149,'Imane Alaoui a rejoint le groupe.',1,'2026-11-18 08:46:01.293244',NULL,20),
(150,'Nora Chraibi a rejoint le groupe.',1,'2026-11-18 08:46:01.293244',NULL,20),
(151,'Bonjour à tous, ravi·e de participer !',0,'2026-11-18 09:03:01.293244',94,20),
(152,'On se retrouve à l\'entrée principale ?',0,'2026-11-18 09:20:01.293244',98,20),
(153,'Oui, 10 minutes avant le début, ce sera parfait.',0,'2026-11-18 09:37:01.293244',95,20),
(154,'J\'apporte de l\'eau et des gobelets pour tout le monde 🙂',0,'2026-11-18 09:54:01.293244',99,20),
(155,'Super, merci ! Pensez à la crème solaire.',0,'2026-11-18 10:11:01.293244',96,20),
(156,'👋 Groupe créé par Imane Alaoui. Les participants acceptés le rejoignent automatiquement ; il sera fermé à la fin de l\'activité.',1,'2026-11-13 11:00:00.000000',NULL,21),
(157,'Bonjour à tous, ravi·e de participer !',0,'2026-11-13 11:17:00.000000',96,21),
(158,'On se retrouve à l\'entrée principale ?',0,'2026-11-13 11:34:00.000000',99,21),
(159,'Oui, 10 minutes avant le début, ce sera parfait.',0,'2026-11-13 11:51:00.000000',97,21),
(160,'J\'apporte de l\'eau et des gobelets pour tout le monde 🙂',0,'2026-11-13 12:08:00.000000',98,21),
(161,'Super, merci ! Pensez à la crème solaire.',0,'2026-11-13 12:25:00.000000',94,21),
(162,'🔒 L\'activité est terminée : le groupe est maintenant fermé (lecture seule).',1,'2026-11-15 14:00:00.000000',NULL,21),
(163,'👋 Groupe créé par Oliver Smith. Les participants acceptés le rejoignent automatiquement ; il sera fermé à la fin de l\'activité.',1,'2026-11-18 08:46:01.293244',NULL,22),
(164,'Harry Wilson a rejoint le groupe.',1,'2026-11-18 08:46:01.293244',NULL,22),
(165,'Priya Patel a rejoint le groupe.',1,'2026-11-18 08:46:01.293244',NULL,22),
(166,'Amelia Jones a rejoint le groupe.',1,'2026-11-18 08:46:01.293244',NULL,22),
(167,'Hi everyone, looking forward to it!',0,'2026-11-18 09:03:01.293244',103,22),
(168,'Shall we meet at the main entrance?',0,'2026-11-18 09:20:01.293244',102,22),
(169,'Sounds good, 10 minutes before the start.',0,'2026-11-18 09:37:01.293244',101,22),
(170,'I\'ll bring some water and snacks for the group 🙂',0,'2026-11-18 09:54:01.293244',100,22),
(171,'👋 Groupe créé par Priya Patel. Les participants acceptés le rejoignent automatiquement ; il sera fermé à la fin de l\'activité.',1,'2026-11-18 08:46:01.293244',NULL,23),
(172,'Harry Wilson a rejoint le groupe.',1,'2026-11-18 08:46:01.293244',NULL,23),
(173,'Amelia Jones a rejoint le groupe.',1,'2026-11-18 08:46:01.293244',NULL,23),
(174,'Oliver Smith a rejoint le groupe.',1,'2026-11-18 08:46:01.293244',NULL,23),
(175,'Hi everyone, looking forward to it!',0,'2026-11-18 09:03:01.293244',103,23),
(176,'Shall we meet at the main entrance?',0,'2026-11-18 09:20:01.293244',101,23),
(177,'Sounds good, 10 minutes before the start.',0,'2026-11-18 09:37:01.293244',100,23),
(178,'I\'ll bring some water and snacks for the group 🙂',0,'2026-11-18 09:54:01.293244',102,23),
(179,'Amazing, thanks! See you all there.',0,'2026-11-18 10:11:01.293244',103,23),
(180,'👋 Groupe créé par Harry Wilson. Les participants acceptés le rejoignent automatiquement ; il sera fermé à la fin de l\'activité.',1,'2026-11-12 12:00:00.000000',NULL,24),
(181,'Hi everyone, looking forward to it!',0,'2026-11-12 12:17:00.000000',100,24),
(182,'Shall we meet at the main entrance?',0,'2026-11-12 12:34:00.000000',101,24),
(183,'Sounds good, 10 minutes before the start.',0,'2026-11-12 12:51:00.000000',102,24),
(184,'🔒 L\'activité est terminée : le groupe est maintenant fermé (lecture seule).',1,'2026-11-14 15:00:00.000000',NULL,24),
(185,'👋 Groupe créé par James Miller. Les participants acceptés le rejoignent automatiquement ; il sera fermé à la fin de l\'activité.',1,'2026-11-18 08:46:01.293244',NULL,25),
(186,'Sofia Garcia a rejoint le groupe.',1,'2026-11-18 08:46:01.293244',NULL,25),
(187,'Michael Brown a rejoint le groupe.',1,'2026-11-18 08:46:01.293244',NULL,25),
(188,'Emily Davis a rejoint le groupe.',1,'2026-11-18 08:46:01.293244',NULL,25),
(189,'Hi everyone, looking forward to it!',0,'2026-11-18 09:03:01.293244',106,25),
(190,'Shall we meet at the main entrance?',0,'2026-11-18 09:20:01.293244',107,25),
(191,'Sounds good, 10 minutes before the start.',0,'2026-11-18 09:37:01.293244',105,25),
(192,'I\'ll bring some water and snacks for the group 🙂',0,'2026-11-18 09:54:01.293244',104,25),
(193,'Amazing, thanks! See you all there.',0,'2026-11-18 10:11:01.293244',106,25),
(194,'👋 Groupe créé par Sofia Garcia. Les participants acceptés le rejoignent automatiquement ; il sera fermé à la fin de l\'activité.',1,'2026-11-18 08:46:01.293244',NULL,26),
(195,'Emily Davis a rejoint le groupe.',1,'2026-11-18 08:46:01.293244',NULL,26),
(196,'Michael Brown a rejoint le groupe.',1,'2026-11-18 08:46:01.293244',NULL,26),
(197,'James Miller a rejoint le groupe.',1,'2026-11-18 08:46:01.293244',NULL,26),
(198,'Hi everyone, looking forward to it!',0,'2026-11-18 09:03:01.293244',105,26),
(199,'Shall we meet at the main entrance?',0,'2026-11-18 09:20:01.293244',107,26),
(200,'Sounds good, 10 minutes before the start.',0,'2026-11-18 09:37:01.293244',104,26),
(201,'👋 Groupe créé par Liam Tremblay. Les participants acceptés le rejoignent automatiquement ; il sera fermé à la fin de l\'activité.',1,'2026-11-18 08:46:01.293244',NULL,27),
(202,'Olivia Martin a rejoint le groupe.',1,'2026-11-18 08:46:01.293244',NULL,27),
(203,'Noah Wong a rejoint le groupe.',1,'2026-11-18 08:46:01.293244',NULL,27),
(204,'Chloé Gagnon a rejoint le groupe.',1,'2026-11-18 08:46:01.293244',NULL,27),
(205,'Bonjour à tous, ravi·e de participer !',0,'2026-11-18 09:03:01.293244',111,27),
(206,'On se retrouve à l\'entrée principale ?',0,'2026-11-18 09:20:01.293244',110,27),
(207,'Oui, 10 minutes avant le début, ce sera parfait.',0,'2026-11-18 09:37:01.293244',109,27),
(208,'👋 Groupe créé par Chloé Gagnon. Les participants acceptés le rejoignent automatiquement ; il sera fermé à la fin de l\'activité.',1,'2026-11-18 08:46:01.293244',NULL,28),
(209,'Olivia Martin a rejoint le groupe.',1,'2026-11-18 08:46:01.293244',NULL,28),
(210,'Noah Wong a rejoint le groupe.',1,'2026-11-18 08:46:01.293244',NULL,28),
(211,'Liam Tremblay a rejoint le groupe.',1,'2026-11-18 08:46:01.293244',NULL,28),
(212,'Bonjour à tous, ravi·e de participer !',0,'2026-11-18 09:03:01.293244',111,28),
(213,'On se retrouve à l\'entrée principale ?',0,'2026-11-18 09:20:01.293244',110,28),
(214,'Oui, 10 minutes avant le début, ce sera parfait.',0,'2026-11-18 09:37:01.293244',108,28),
(215,'👋 Groupe créé par Emma Martin. Les participants acceptés le rejoignent automatiquement ; il sera fermé à la fin de l\'activité.',1,'2026-11-18 08:46:01.293244',NULL,29),
(216,'Chloé Dubois a rejoint le groupe.',1,'2026-11-18 08:46:01.293244',NULL,29),
(217,'Yanis Moreau a rejoint le groupe.',1,'2026-11-18 08:46:01.293244',NULL,29),
(218,'Nathan Roux a rejoint le groupe.',1,'2026-11-18 08:46:01.293244',NULL,29),
(219,'Manon Girard a rejoint le groupe.',1,'2026-11-18 08:46:01.293244',NULL,29),
(220,'Adam Benali a rejoint le groupe.',1,'2026-11-18 08:46:01.293244',NULL,29),
(221,'Bonjour à tous, ravi·e de participer !',0,'2026-11-18 09:03:01.293244',88,29),
(222,'On se retrouve à l\'entrée principale ?',0,'2026-11-18 09:20:01.293244',89,29),
(223,'Oui, 10 minutes avant le début, ce sera parfait.',0,'2026-11-18 09:37:01.293244',93,29),
(224,'J\'apporte de l\'eau et des gobelets pour tout le monde 🙂',0,'2026-11-18 09:54:01.293244',92,29),
(225,'Super, merci ! Pensez à la crème solaire.',0,'2026-11-18 10:11:01.293244',91,29),
(226,'👋 Groupe créé par Inès Haddad. Les participants acceptés le rejoignent automatiquement ; il sera fermé à la fin de l\'activité.',1,'2026-11-18 08:46:01.293244',NULL,30),
(227,'Adam Benali a rejoint le groupe.',1,'2026-11-18 08:46:01.293244',NULL,30),
(228,'Nathan Roux a rejoint le groupe.',1,'2026-11-18 08:46:01.293244',NULL,30),
(229,'Hugo Petit a rejoint le groupe.',1,'2026-11-18 08:46:01.293244',NULL,30),
(230,'Lucas Bernard a rejoint le groupe.',1,'2026-11-18 08:46:01.293244',NULL,30),
(231,'Bonjour à tous, ravi·e de participer !',0,'2026-11-18 09:03:01.293244',91,30),
(232,'On se retrouve à l\'entrée principale ?',0,'2026-11-18 09:20:01.293244',93,30),
(233,'Oui, 10 minutes avant le début, ce sera parfait.',0,'2026-11-18 09:37:01.293244',87,30),
(234,'J\'apporte de l\'eau et des gobelets pour tout le monde 🙂',0,'2026-11-18 09:54:01.293244',85,30),
(235,'👋 Groupe créé par Hugo Petit. Les participants acceptés le rejoignent automatiquement ; il sera fermé à la fin de l\'activité.',1,'2026-11-14 09:00:00.000000',NULL,31),
(236,'Bonjour à tous, ravi·e de participer !',0,'2026-11-14 09:17:00.000000',86,31),
(237,'On se retrouve à l\'entrée principale ?',0,'2026-11-14 09:34:00.000000',91,31),
(238,'Oui, 10 minutes avant le début, ce sera parfait.',0,'2026-11-14 09:51:00.000000',88,31),
(239,'J\'apporte de l\'eau et des gobelets pour tout le monde 🙂',0,'2026-11-14 10:08:00.000000',85,31),
(240,'🔒 L\'activité est terminée : le groupe est maintenant fermé (lecture seule).',1,'2026-11-16 12:00:00.000000',NULL,31),
(241,'👋 Groupe créé par Le Panier Solidaire. Les participants acceptés le rejoignent automatiquement ; il sera fermé à la fin de l\'activité.',1,'2026-11-18 08:46:01.293244',NULL,32),
(242,'Emma Martin a rejoint le groupe.',1,'2026-11-18 08:46:01.293244',NULL,32),
(243,'Bonjour à tous, ravi·e de participer !',0,'2026-11-18 09:03:01.293244',84,32),
(244,'On se retrouve à l\'entrée principale ?',0,'2026-11-18 09:20:01.293244',67,32),
(245,'Oui, 10 minutes avant le début, ce sera parfait.',0,'2026-11-18 09:37:01.293244',84,32),
(246,'J\'apporte de l\'eau et des gobelets pour tout le monde 🙂',0,'2026-11-18 09:54:01.293244',67,32),
(247,'Super, merci ! Pensez à la crème solaire.',0,'2026-11-18 10:11:01.293244',84,32),
(248,'👋 Groupe créé par Atlas Solidaire. Les participants acceptés le rejoignent automatiquement ; il sera fermé à la fin de l\'activité.',1,'2026-11-18 08:46:01.293244',NULL,33),
(249,'Bonjour à tous, ravi·e de participer !',0,'2026-11-18 09:03:01.293244',75,33),
(250,'On se retrouve à l\'entrée principale ?',0,'2026-11-18 09:20:01.293244',75,33),
(251,'Oui, 10 minutes avant le début, ce sera parfait.',0,'2026-11-18 09:37:01.293244',75,33),
(252,'👋 Groupe créé par London Food Share. Les participants acceptés le rejoignent automatiquement ; il sera fermé à la fin de l\'activité.',1,'2026-11-18 08:46:01.293244',NULL,34),
(253,'Amelia Jones a rejoint le groupe.',1,'2026-11-18 08:46:01.293244',NULL,34),
(254,'Hi everyone, looking forward to it!',0,'2026-11-18 09:03:01.293244',101,34),
(255,'Shall we meet at the main entrance?',0,'2026-11-18 09:20:01.293244',78,34),
(256,'Sounds good, 10 minutes before the start.',0,'2026-11-18 09:37:01.293244',101,34),
(257,'I\'ll bring some water and snacks for the group 🙂',0,'2026-11-18 09:54:01.293244',78,34),
(258,'Amazing, thanks! See you all there.',0,'2026-11-18 10:11:01.293244',101,34),
(259,'👋 Groupe créé par Brooklyn Green Hands. Les participants acceptés le rejoignent automatiquement ; il sera fermé à la fin de l\'activité.',1,'2026-11-18 08:46:01.293244',NULL,35),
(260,'Hi everyone, looking forward to it!',0,'2026-11-18 09:03:01.293244',80,35),
(261,'Shall we meet at the main entrance?',0,'2026-11-18 09:20:01.293244',80,35),
(262,'Sounds good, 10 minutes before the start.',0,'2026-11-18 09:37:01.293244',80,35),
(263,'I\'ll bring some water and snacks for the group 🙂',0,'2026-11-18 09:54:01.293244',80,35),
(264,'👋 Groupe créé par Brooklyn Green Hands. Les participants acceptés le rejoignent automatiquement ; il sera fermé à la fin de l\'activité.',1,'2026-11-08 14:00:00.000000',NULL,36),
(265,'Hi everyone, looking forward to it!',0,'2026-11-08 14:17:00.000000',106,36),
(266,'Shall we meet at the main entrance?',0,'2026-11-08 14:34:00.000000',105,36),
(267,'Sounds good, 10 minutes before the start.',0,'2026-11-08 14:51:00.000000',104,36),
(268,'I\'ll bring some water and snacks for the group 🙂',0,'2026-11-08 15:08:00.000000',80,36),
(269,'Amazing, thanks! See you all there.',0,'2026-11-08 15:25:00.000000',106,36),
(270,'🔒 L\'activité est terminée : le groupe est maintenant fermé (lecture seule).',1,'2026-11-10 18:00:00.000000',NULL,36);
/*!40000 ALTER TABLE `login_app_messagegroupe` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_app_notification`
--

LOCK TABLES `login_app_notification` WRITE;
/*!40000 ALTER TABLE `login_app_notification` DISABLE KEYS */;
INSERT INTO `login_app_notification` VALUES
(48,'Vous avez rejoint un groupe 💬','« Match de foot du dimanche à Aïn Diab »','/messages?groupe=19',0,'2026-11-18 14:46:01.359756',98),
(49,'Vous avez rejoint un groupe 💬','« Match de foot du dimanche à Aïn Diab »','/messages?groupe=19',0,'2026-11-18 14:46:01.399108',97),
(50,'Vous avez rejoint un groupe 💬','« Match de foot du dimanche à Aïn Diab »','/messages?groupe=19',0,'2026-11-18 14:46:01.434529',99),
(51,'Vous avez rejoint un groupe 💬','« Match de foot du dimanche à Aïn Diab »','/messages?groupe=19',0,'2026-11-18 14:46:01.470643',96),
(52,'Vous avez rejoint un groupe 💬','« Match de foot du dimanche à Aïn Diab »','/messages?groupe=19',0,'2026-11-18 14:46:01.502301',95),
(53,'Vous avez rejoint un groupe 💬','« Club de lecture : L\'Alchimiste »','/messages?groupe=20',0,'2026-11-18 14:46:01.608854',94),
(54,'Vous avez rejoint un groupe 💬','« Club de lecture : L\'Alchimiste »','/messages?groupe=20',0,'2026-11-18 14:46:01.637792',98),
(55,'Vous avez rejoint un groupe 💬','« Club de lecture : L\'Alchimiste »','/messages?groupe=20',0,'2026-11-18 14:46:01.668718',95),
(56,'Vous avez rejoint un groupe 💬','« Club de lecture : L\'Alchimiste »','/messages?groupe=20',0,'2026-11-18 14:46:01.697593',99),
(57,'Vous avez rejoint un groupe 💬','« Sunday 5-a-side football in Hyde Park »','/messages?groupe=22',0,'2026-11-18 14:46:01.927795',103),
(58,'Vous avez rejoint un groupe 💬','« Sunday 5-a-side football in Hyde Park »','/messages?groupe=22',0,'2026-11-18 14:46:01.977314',102),
(59,'Vous avez rejoint un groupe 💬','« Sunday 5-a-side football in Hyde Park »','/messages?groupe=22',0,'2026-11-18 14:46:02.020261',101),
(60,'Vous avez rejoint un groupe 💬','« Book club: The Midnight Library »','/messages?groupe=23',0,'2026-11-18 14:46:02.083517',103),
(61,'Vous avez rejoint un groupe 💬','« Book club: The Midnight Library »','/messages?groupe=23',0,'2026-11-18 14:46:02.107323',101),
(62,'Vous avez rejoint un groupe 💬','« Book club: The Midnight Library »','/messages?groupe=23',0,'2026-11-18 14:46:02.134171',100),
(63,'Vous avez rejoint un groupe 💬','« Central Park morning run »','/messages?groupe=25',0,'2026-11-18 14:46:02.357530',106),
(64,'Vous avez rejoint un groupe 💬','« Central Park morning run »','/messages?groupe=25',0,'2026-11-18 14:46:02.393880',107),
(65,'Vous avez rejoint un groupe 💬','« Central Park morning run »','/messages?groupe=25',0,'2026-11-18 14:46:02.415503',105),
(66,'Vous avez rejoint un groupe 💬','« Picnic at Dolores Park »','/messages?groupe=26',0,'2026-11-18 14:46:02.477478',105),
(67,'Vous avez rejoint un groupe 💬','« Picnic at Dolores Park »','/messages?groupe=26',0,'2026-11-18 14:46:02.497048',107),
(68,'Vous avez rejoint un groupe 💬','« Picnic at Dolores Park »','/messages?groupe=26',0,'2026-11-18 14:46:02.516605',104),
(69,'Vous avez rejoint un groupe 💬','« Pique-nique au parc La Fontaine »','/messages?groupe=27',0,'2026-11-18 14:46:02.566727',111),
(70,'Vous avez rejoint un groupe 💬','« Pique-nique au parc La Fontaine »','/messages?groupe=27',0,'2026-11-18 14:46:02.588141',110),
(71,'Vous avez rejoint un groupe 💬','« Pique-nique au parc La Fontaine »','/messages?groupe=27',0,'2026-11-18 14:46:02.609213',109),
(72,'Vous avez rejoint un groupe 💬','« Randonnée au mont Royal »','/messages?groupe=28',0,'2026-11-18 14:46:02.662174',111),
(73,'Vous avez rejoint un groupe 💬','« Randonnée au mont Royal »','/messages?groupe=28',0,'2026-11-18 14:46:02.681601',110),
(74,'Vous avez rejoint un groupe 💬','« Randonnée au mont Royal »','/messages?groupe=28',0,'2026-11-18 14:46:02.701700',108),
(75,'Vous avez rejoint un groupe 💬','« Pique-nique au parc de la Tête d\'Or »','/messages?groupe=29',0,'2026-11-18 14:46:02.767863',88),
(76,'Vous avez rejoint un groupe 💬','« Pique-nique au parc de la Tête d\'Or »','/messages?groupe=29',0,'2026-11-18 14:46:02.797972',89),
(77,'Vous avez rejoint un groupe 💬','« Pique-nique au parc de la Tête d\'Or »','/messages?groupe=29',0,'2026-11-18 14:46:02.831140',93),
(78,'Vous avez rejoint un groupe 💬','« Pique-nique au parc de la Tête d\'Or »','/messages?groupe=29',0,'2026-11-18 14:46:02.863410',92),
(79,'Vous avez rejoint un groupe 💬','« Pique-nique au parc de la Tête d\'Or »','/messages?groupe=29',0,'2026-11-18 14:46:02.890239',91),
(80,'Vous avez rejoint un groupe 💬','« Partie de pétanque sur la Corniche »','/messages?groupe=30',0,'2026-11-18 14:46:02.975869',91),
(81,'Vous avez rejoint un groupe 💬','« Partie de pétanque sur la Corniche »','/messages?groupe=30',0,'2026-11-18 14:46:03.004099',93),
(82,'Vous avez rejoint un groupe 💬','« Partie de pétanque sur la Corniche »','/messages?groupe=30',0,'2026-11-18 14:46:03.033305',87),
(83,'Vous avez rejoint un groupe 💬','« Partie de pétanque sur la Corniche »','/messages?groupe=30',0,'2026-11-18 14:46:03.061428',85),
(84,'Vous avez rejoint un groupe 💬','« Cuisine solidaire du samedi »','/messages?groupe=32',0,'2026-11-18 14:46:03.276951',84),
(85,'Vous avez rejoint un groupe 💬','« Saturday food sorting »','/messages?groupe=34',0,'2026-11-18 14:46:03.420270',101),
(86,'Nouvelle association à vérifier','Toit d\'Abord attend une vérification.','/espace/admin',0,'2026-11-18 14:46:03.646246',66),
(87,'Nouvelle association à vérifier','Collectif Récup\'Art attend une vérification.','/espace/admin',0,'2026-11-18 14:46:03.648418',66),
(88,'Nouvelle association à vérifier','Tanja Verte attend une vérification.','/espace/admin',0,'2026-11-18 14:46:03.651867',66);
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_app_signalement`
--

LOCK TABLES `login_app_signalement` WRITE;
/*!40000 ALTER TABLE `login_app_signalement` DISABLE KEYS */;
INSERT INTO `login_app_signalement` VALUES
(3,'Le lieu indiqué ne semble pas correct, à vérifier.','OUVERT','2026-11-18 14:46:03.654999',84,90,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=112 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_app_user`
--

LOCK TABLES `login_app_user` WRITE;
/*!40000 ALTER TABLE `login_app_user` DISABLE KEYS */;
INSERT INTO `login_app_user` VALUES
(66,'pbkdf2_sha256$1500000$nHKS1aXZILa5ER3I0vA4oq$EoqvK0ef7prGowiAQYOh+VLZtVyJNdhz+kM/4vM2sBw=',NULL,1,'admin','','','admin@solidarlink.local',1,1,'2026-11-18 14:44:21.276754','ADMIN'),
(67,'pbkdf2_sha256$1500000$8TbeqHVdB629DolF3WpPku$WVSD15lL+dA92HC3XApVTvWSIeSp+RX+HRD3MlkzZtw=',NULL,0,'panier_solidaire','','','panier_solidaire@asso.solidarlink.local',0,1,'2026-11-18 14:44:23.404803','ASSOCIATION'),
(68,'pbkdf2_sha256$1500000$ASKplVzDHtAnGNIDXgUmoo$O39o/PeV1eMWvuIvuXKZt922tMLTGLvLQpNy4ypkkqg=',NULL,0,'vert_demain','','','vert_demain@asso.solidarlink.local',0,1,'2026-11-18 14:44:26.140815','ASSOCIATION'),
(69,'pbkdf2_sha256$1500000$IJ4zNmzx5egZhd53mbiVHw$xiCsegtrWE0C9m/58tbrtnggzPPLzyeX51rrD7BD0Nk=',NULL,0,'lire_ensemble','','','lire_ensemble@asso.solidarlink.local',0,1,'2026-11-18 14:44:28.827200','ASSOCIATION'),
(70,'pbkdf2_sha256$1500000$h13RyZr0JZOXiaDSurGpjl$gUQzNPErGKwtNRRbJyW6uvDwvRWW/Y31ZCshlpM2uAA=',NULL,0,'pattes_coeurs','','','pattes_coeurs@asso.solidarlink.local',0,1,'2026-11-18 14:44:31.125243','ASSOCIATION'),
(71,'pbkdf2_sha256$1500000$XEibO5S0LuqYxpZj7zJE0x$sE6YZQPq9/UaywqkS+rrwuYNkgO7hYmP0qlk0U+076g=',NULL,0,'aines_connectes','','','aines_connectes@asso.solidarlink.local',0,1,'2026-11-18 14:44:32.843236','ASSOCIATION'),
(72,'pbkdf2_sha256$1500000$kWfzKYJAR4u5WIq9HPlcvc$RfgueFi0PiZKHLFcBzzQUwtoiOJmNAnAAEvrcN/E7O4=',NULL,0,'sport_pour_tous','','','sport_pour_tous@asso.solidarlink.local',0,1,'2026-11-18 14:44:34.314369','ASSOCIATION'),
(73,'pbkdf2_sha256$1500000$RK6YUYlbkQQQp5fFoDdV1X$jOlzjF1XzR2JQN5y5yDPC5wAXku+cIEdqdjEB2tnSyg=',NULL,0,'toit_dabord','','','toit_dabord@asso.solidarlink.local',0,1,'2026-11-18 14:44:35.761741','ASSOCIATION'),
(74,'pbkdf2_sha256$1500000$JfeMoqALOybalJ896ENUuS$hLy7s+4I/EINQyViwfQNsaICB3sbifEaKvhRin0fIKY=',NULL,0,'recup_art','','','recup_art@asso.solidarlink.local',0,1,'2026-11-18 14:44:38.798203','ASSOCIATION'),
(75,'pbkdf2_sha256$1500000$tVERlvcvHIf4bPtLgN99lc$YYqGSY7e8MUMosgLHJY3ddzJg88vKlAiWmDtMSDCQh4=',NULL,0,'atlas_solidaire','','','atlas_solidaire@asso.solidarlink.local',0,1,'2026-11-18 14:44:42.052102','ASSOCIATION'),
(76,'pbkdf2_sha256$1500000$LJJk49qNeen7oaSFksZvcc$qORrVPh0P9JCacnZUAUK5354/zADn5pN9eheirFRtYU=',NULL,0,'casa_entraide','','','casa_entraide@asso.solidarlink.local',0,1,'2026-11-18 14:44:44.767890','ASSOCIATION'),
(77,'pbkdf2_sha256$1500000$JoGx2la6vyyoe0SpwbFAIo$iDb/AZmn8q9a/mqA1fhNGut1deJ2RxKgj3zMO2+y5cM=',NULL,0,'tanja_verte','','','tanja_verte@asso.solidarlink.local',0,1,'2026-11-18 14:44:46.703562','ASSOCIATION'),
(78,'pbkdf2_sha256$1500000$1FyvYe40L2TM23ts6xObEQ$dAoecLdXhyL+Z+ku5qvYQTNIdUSjRc46UPlrASpTVn0=',NULL,0,'london_food_share','','','london_food_share@asso.solidarlink.local',0,1,'2026-11-18 14:44:48.918259','ASSOCIATION'),
(79,'pbkdf2_sha256$1500000$MgGwc3SCJCUv8AJAiHTkzF$xpM505r/Ao0yrQk/XvOSlNM1PqmeavsOtmALAPip8OQ=',NULL,0,'manchester_reads','','','manchester_reads@asso.solidarlink.local',0,1,'2026-11-18 14:44:51.007594','ASSOCIATION'),
(80,'pbkdf2_sha256$1500000$gMvmYq2wjXMXDGff5XMnTo$AJ+Gg2HkqIPJi+FK5CQXiQv8211rnbVx92qW/eN88Hw=',NULL,0,'brooklyn_green','','','brooklyn_green@asso.solidarlink.local',0,1,'2026-11-18 14:44:53.074598','ASSOCIATION'),
(81,'pbkdf2_sha256$1500000$oayxU7BUZukf5txpIcW29u$wxlRs2s1JIlqb68BIfh7p0bcWqG5zZRZurR8gja8vgA=',NULL,0,'bay_area_paws','','','bay_area_paws@asso.solidarlink.local',0,1,'2026-11-18 14:44:55.192877','ASSOCIATION'),
(82,'pbkdf2_sha256$1500000$khI5saHnLB75UWEuC1ujuR$wBF7Sxr5dMKvpaFXrQ3csNSUbqpelXRt/FgJAcdwnFs=',NULL,0,'montreal_coeur','','','montreal_coeur@asso.solidarlink.local',0,1,'2026-11-18 14:44:57.192213','ASSOCIATION'),
(83,'pbkdf2_sha256$1500000$E1dioPoYnAcBpcqPpEcRQN$56c0eSYkEW0RXvAaawKyFjMKttRKnvY8Y1j5uAziEh8=',NULL,0,'toronto_warm','','','toronto_warm@asso.solidarlink.local',0,1,'2026-11-18 14:44:59.172521','ASSOCIATION'),
(84,'pbkdf2_sha256$1500000$k7HcaFQPVkp9IKgomeVM2l$H7b3rUxL5sSB75xNl6JCnjIUIidAUj2NoR2fG0mQvkY=',NULL,0,'emma.martin','Emma','Martin','emma.martin@mail.solidarlink.local',0,1,'2026-11-18 14:45:01.178952','CITOYEN'),
(85,'pbkdf2_sha256$1500000$g9TBJ7JMVWCkZde8q1MH2B$4GxdiqF6REpO2rsilH+/Ki5Y9hxzVJNQzT8kxWPgT4M=',NULL,0,'lucas.bernard','Lucas','Bernard','lucas.bernard@mail.solidarlink.local',0,1,'2026-11-18 14:45:03.374305','CITOYEN'),
(86,'pbkdf2_sha256$1500000$YEdSWxaW5lTxWFKHD0wKX5$1V5UnvOr12DuDnV8GB8bwP2th7ZCBAAJj4LzO6I5WGo=',NULL,0,'ines.haddad','Inès','Haddad','ines.haddad@mail.solidarlink.local',0,1,'2026-11-18 14:45:05.455138','CITOYEN'),
(87,'pbkdf2_sha256$1500000$erS42dZ6qGwqP84dMb77vK$5aDWbehN8j0bcznhZt9mW6MvxYA0cst5+yLj6x9Ca4A=',NULL,0,'hugo.petit','Hugo','Petit','hugo.petit@mail.solidarlink.local',0,1,'2026-11-18 14:45:07.480404','CITOYEN'),
(88,'pbkdf2_sha256$1500000$HbxavgQcu0sG7D1YHAJ5Ax$7WzYfVrgTJ7GmWaKiiv1NwyxcD4wO/c4yQXqgSe/DR0=',NULL,0,'chloe.dubois','Chloé','Dubois','chloe.dubois@mail.solidarlink.local',0,1,'2026-11-18 14:45:09.583877','CITOYEN'),
(89,'pbkdf2_sha256$1500000$Z9w1OIc7d7fzmwDqDH8llh$Cettage8MOA7fZKsRaZxVXlr8jj04lrNZjVajWdeufQ=',NULL,0,'yanis.moreau','Yanis','Moreau','yanis.moreau@mail.solidarlink.local',0,1,'2026-11-18 14:45:11.538121','CITOYEN'),
(90,'pbkdf2_sha256$1500000$m1Vs6G6IDDOJbXiNVqdPNZ$9MPveX40AlEL6bNOdKHEUBe/VaRPabIG+7Ll5QplVjg=',NULL,0,'lea.laurent','Léa','Laurent','lea.laurent@mail.solidarlink.local',0,1,'2026-11-18 14:45:13.664937','CITOYEN'),
(91,'pbkdf2_sha256$1500000$ujbMalLJIgxwRbSMSyXemG$wWRd0KpT4AMkBCdSgWZ0oF9b8OHAjAe48Su46PXivSg=',NULL,0,'adam.benali','Adam','Benali','adam.benali@mail.solidarlink.local',0,1,'2026-11-18 14:45:15.743637','CITOYEN'),
(92,'pbkdf2_sha256$1500000$5TUmIAEIMCLErhb4C3agup$Uca4XuHYrBBBJQ8opsCk+V7e9ExAwTxo9nNgvTn6GL0=',NULL,0,'manon.girard','Manon','Girard','manon.girard@mail.solidarlink.local',0,1,'2026-11-18 14:45:17.771533','CITOYEN'),
(93,'pbkdf2_sha256$1500000$PLCvdQj0saWLThsZp7LOn3$g99lDOXE4rq+SSgeYNRiz+10sbzkOGTTpJD1xIf4L2w=',NULL,0,'nathan.roux','Nathan','Roux','nathan.roux@mail.solidarlink.local',0,1,'2026-11-18 14:45:19.860409','CITOYEN'),
(94,'pbkdf2_sha256$1500000$gWUHWYgYZZqZHmmiZZfqfR$svzliV6/f8e8Lb5EEYyPjL2TUw1QpmU5nOSSl87KzuY=',NULL,0,'yassine.elamrani','Yassine','El Amrani','yassine.elamrani@mail.solidarlink.local',0,1,'2026-11-18 14:45:21.889122','CITOYEN'),
(95,'pbkdf2_sha256$1500000$uEsHqKGmUlwoPqBj2u0VH9$SfzeSbPXvmsosJIe447n7BQPpbJZpX7S9DvzXr1oAo8=',NULL,0,'imane.alaoui','Imane','Alaoui','imane.alaoui@mail.solidarlink.local',0,1,'2026-11-18 14:45:23.952155','CITOYEN'),
(96,'pbkdf2_sha256$1500000$YNhRdhb0E5sWamSwsh245b$zyLJxbj4qSFK40iWwvCwxuO7+WxQ8cUMkScqSypWPMk=',NULL,0,'salma.benjelloun','Salma','Benjelloun','salma.benjelloun@mail.solidarlink.local',0,1,'2026-11-18 14:45:25.998044','CITOYEN'),
(97,'pbkdf2_sha256$1500000$Nk0dybb0f2xhPnPPKOaXlc$RNgG+fqcn0x7eVI9bqxbbwo37D2umRlYczsOP6n33tM=',NULL,0,'omar.tazi','Omar','Tazi','omar.tazi@mail.solidarlink.local',0,1,'2026-11-18 14:45:27.992613','CITOYEN'),
(98,'pbkdf2_sha256$1500000$AWYZNdKnCGOLfE8gh3kyHj$uz8hzyCOeNzjLyR4NEVR2QEPakJ2tavO3RkRpGpYYOI=',NULL,0,'karim.berrada','Karim','Berrada','karim.berrada@mail.solidarlink.local',0,1,'2026-11-18 14:45:29.968748','CITOYEN'),
(99,'pbkdf2_sha256$1500000$UbUJx2F4K704dUi5iMViV1$nVK9k24uMFnHDsOMxT+rgu73F3dfSq0ZqeXSHU1FHr0=',NULL,0,'nora.chraibi','Nora','Chraibi','nora.chraibi@mail.solidarlink.local',0,1,'2026-11-18 14:45:31.974893','CITOYEN'),
(100,'pbkdf2_sha256$1500000$TA2ggCczzlsZTwwcDPjONN$keQcIKDJnXzRqx1cjIuQbrLdfUJzk6CDU4DMnHFWZY4=',NULL,0,'oliver.smith','Oliver','Smith','oliver.smith@mail.solidarlink.local',0,1,'2026-11-18 14:45:34.179752','CITOYEN'),
(101,'pbkdf2_sha256$1500000$nji0pjuO1uT5R9sg6AgO1R$kwP4n8EzDyToXrHKPQ9zaIxKTIXWpYGOx7H7hTyZOcs=',NULL,0,'amelia.jones','Amelia','Jones','amelia.jones@mail.solidarlink.local',0,1,'2026-11-18 14:45:36.289150','CITOYEN'),
(102,'pbkdf2_sha256$1500000$CutklAdBbrE9GSyjZ4bKrD$noFU5bhU4okwwTmxwEwF7N8lMuSWegglozFAeTKomkM=',NULL,0,'priya.patel','Priya','Patel','priya.patel@mail.solidarlink.local',0,1,'2026-11-18 14:45:38.489458','CITOYEN'),
(103,'pbkdf2_sha256$1500000$bMBZZj2NgUgh3CMPEz8qwm$f/h7w4MhgUARpVfX5IKw0r1r4idDjDNgHyCO3oZBiyg=',NULL,0,'harry.wilson','Harry','Wilson','harry.wilson@mail.solidarlink.local',0,1,'2026-11-18 14:45:40.476398','CITOYEN'),
(104,'pbkdf2_sha256$1500000$trMf0Sk39jWML8eOclPfPj$aq5xBZh/UImAzdMeY8Y1fM5hfTLGzvJ7P2OYXwzC7Os=',NULL,0,'james.miller','James','Miller','james.miller@mail.solidarlink.local',0,1,'2026-11-18 14:45:42.473665','CITOYEN'),
(105,'pbkdf2_sha256$1500000$FLKDfj05PTpbFP8ld3Ki7g$LjarWod584nVwDuh13eSefbbzoNrLHkYH3HJbQ5z0rA=',NULL,0,'emily.davis','Emily','Davis','emily.davis@mail.solidarlink.local',0,1,'2026-11-18 14:45:44.495171','CITOYEN'),
(106,'pbkdf2_sha256$1500000$ThHTzILzjgK3PrcANiCnZp$HIT/x4g6kpiUfNLLu4laYTIkur+IclC28JuWcYkqlBE=',NULL,0,'sofia.garcia','Sofia','Garcia','sofia.garcia@mail.solidarlink.local',0,1,'2026-11-18 14:45:46.567226','CITOYEN'),
(107,'pbkdf2_sha256$1500000$38LK0LrpMBpUQ2Oakuq1v2$C1e+rcres9Fc1OQ6W1+FHVWfWHE95LWD9Z/+b7ziYrU=',NULL,0,'michael.brown','Michael','Brown','michael.brown@mail.solidarlink.local',0,1,'2026-11-18 14:45:48.714779','CITOYEN'),
(108,'pbkdf2_sha256$1500000$bPN756pRXCZKcapFOz83yk$PC4sX+Npo3hUgr2nAsl3TtP5AjFzM3a66jCCQeHrzpM=',NULL,0,'liam.tremblay','Liam','Tremblay','liam.tremblay@mail.solidarlink.local',0,1,'2026-11-18 14:45:50.763563','CITOYEN'),
(109,'pbkdf2_sha256$1500000$mpOryvoZJj0za9j8g68VyW$nbbOexJln0X8vcR8Vtzg1UsG9AjKMYSyi8DSvVPHm+Q=',NULL,0,'chloe.gagnon','Chloé','Gagnon','chloe.gagnon@mail.solidarlink.local',0,1,'2026-11-18 14:45:52.818370','CITOYEN'),
(110,'pbkdf2_sha256$1500000$GTVK0XRfRzE9LaLrCmLyNs$BtHDePmdtuldFZsURRfjjCV1XReSfo4aGwWQeMZQAgQ=',NULL,0,'noah.wong','Noah','Wong','noah.wong@mail.solidarlink.local',0,1,'2026-11-18 14:45:54.866765','CITOYEN'),
(111,'pbkdf2_sha256$1500000$KTVTI3PsVuV0d08aZ8lMAV$iHF0sxpcQ4rXbZk0qhpzL8IEtCmP78ubmji7BZTu6XI=',NULL,0,'olivia.martin','Olivia','Martin','olivia.martin@mail.solidarlink.local',0,1,'2026-11-18 14:45:56.946149','CITOYEN');
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

-- Dump completed on 2026-11-18 15:13:20
