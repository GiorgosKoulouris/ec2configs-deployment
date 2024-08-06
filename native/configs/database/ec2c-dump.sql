-- MariaDB dump 10.19  Distrib 10.6.16-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: ec2c
-- ------------------------------------------------------
-- Server version	10.6.16-MariaDB-0ubuntu0.22.04.1

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
-- Current Database: `ec2c`
--

/*!40000 DROP DATABASE IF EXISTS `ec2c`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `ec2c` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;

USE `ec2c`;

--
-- Table structure for table `aws_access_list`
--

DROP TABLE IF EXISTS `aws_access_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aws_access_list` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `target_type` varchar(10) DEFAULT NULL,
  `target_id` varchar(45) NOT NULL,
  `account` varchar(45) NOT NULL,
  `access_level` varchar(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aws_access_list`
--

LOCK TABLES `aws_access_list` WRITE;
/*!40000 ALTER TABLE `aws_access_list` DISABLE KEYS */;
/*!40000 ALTER TABLE `aws_access_list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `aws_accounts`
--

DROP TABLE IF EXISTS `aws_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aws_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_name` varchar(45) NOT NULL,
  `aws_id` varchar(45) NOT NULL,
  `fa_access_key` varchar(45) NOT NULL,
  `fa_secret` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `aws_azs`
--

DROP TABLE IF EXISTS `aws_azs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aws_azs` (
  `id` int(11) NOT NULL COMMENT 'Primary Key',
  `az` varchar(40) DEFAULT NULL COMMENT 'Create Time',
  `region` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aws_azs`
--

LOCK TABLES `aws_azs` WRITE;
/*!40000 ALTER TABLE `aws_azs` DISABLE KEYS */;
INSERT INTO `aws_azs` VALUES (0,'af-south-1a','af-south-1'),(1,'af-south-1b','af-south-1'),(2,'af-south-1c','af-south-1'),(3,'ap-east-1a','ap-east-1'),(4,'ap-east-1b','ap-east-1'),(5,'ap-east-1c','ap-east-1'),(6,'ap-northeast-1a','ap-northeast-1'),(7,'ap-northeast-1b','ap-northeast-1'),(8,'ap-northeast-1c','ap-northeast-1'),(9,'ap-northeast-1d','ap-northeast-1'),(10,'ap-northeast-2a','ap-northeast-2'),(11,'ap-northeast-2b','ap-northeast-2'),(12,'ap-northeast-2c','ap-northeast-2'),(13,'ap-northeast-2d','ap-northeast-2'),(14,'ap-northeast-3a','ap-northeast-3'),(15,'ap-northeast-3b','ap-northeast-3'),(16,'ap-northeast-3c','ap-northeast-3'),(17,'ap-south-1a','ap-south-1'),(18,'ap-south-1b','ap-south-1'),(19,'ap-south-1c','ap-south-1'),(20,'ap-south-2a','ap-south-2'),(21,'ap-south-2b','ap-south-2'),(22,'ap-south-2c','ap-south-2'),(23,'ap-southeast-1a','ap-southeast-1'),(24,'ap-southeast-1b','ap-southeast-1'),(25,'ap-southeast-1c','ap-southeast-1'),(26,'ap-southeast-2a','ap-southeast-2'),(27,'ap-southeast-2b','ap-southeast-2'),(28,'ap-southeast-2c','ap-southeast-2'),(29,'ap-southeast-3a','ap-southeast-3'),(30,'ap-southeast-3b','ap-southeast-3'),(31,'ap-southeast-3c','ap-southeast-3'),(32,'ap-southeast-4a','ap-southeast-4'),(33,'ap-southeast-4b','ap-southeast-4'),(34,'ap-southeast-4c','ap-southeast-4'),(35,'ca-central-1a','ca-central-1'),(36,'ca-central-1b','ca-central-1'),(37,'ca-central-1c','ca-central-1'),(38,'cn-north-1a','cn-north-1'),(39,'cn-north-1b','cn-north-1'),(40,'cn-north-1c','cn-north-1'),(41,'cn-northwest-1a','cn-northwest-1'),(42,'cn-northwest-1b','cn-northwest-1'),(43,'cn-northwest-1c','cn-northwest-1'),(44,'eu-central-1a','eu-central-1'),(45,'eu-central-1b','eu-central-1'),(46,'eu-central-1c','eu-central-1'),(47,'eu-central-2a','eu-central-2'),(48,'eu-central-2b','eu-central-2'),(49,'eu-central-2c','eu-central-2'),(50,'eu-north-1a','eu-north-1'),(51,'eu-north-1b','eu-north-1'),(52,'eu-north-1c','eu-north-1'),(53,'eu-south-1a','eu-south-1'),(54,'eu-south-1b','eu-south-1'),(55,'eu-south-1c','eu-south-1'),(56,'eu-south-2a','eu-south-2'),(57,'eu-south-2b','eu-south-2'),(58,'eu-south-2c','eu-south-2'),(59,'eu-west-1a','eu-west-1'),(60,'eu-west-1b','eu-west-1'),(61,'eu-west-1c','eu-west-1'),(62,'eu-west-2a','eu-west-2'),(63,'eu-west-2b','eu-west-2'),(64,'eu-west-2c','eu-west-2'),(65,'eu-west-3a','eu-west-3'),(66,'eu-west-3b','eu-west-3'),(67,'eu-west-3c','eu-west-3'),(68,'il-central-1a','il-central-1'),(69,'il-central-1b','il-central-1'),(70,'il-central-1c','il-central-1'),(71,'me-central-1a','me-central-1'),(72,'me-central-1b','me-central-1'),(73,'me-central-1c','me-central-1'),(74,'me-south-1a','me-south-1'),(75,'me-south-1b','me-south-1'),(76,'me-south-1c','me-south-1'),(77,'sa-east-1a','sa-east-1'),(78,'sa-east-1b','sa-east-1'),(79,'sa-east-1c','sa-east-1'),(80,'us-east-1a','us-east-1'),(81,'us-east-1b','us-east-1'),(82,'us-east-1c','us-east-1'),(83,'us-east-1d','us-east-1'),(84,'us-east-1e','us-east-1'),(85,'us-east-1f','us-east-1'),(86,'us-east-2a','us-east-2'),(87,'us-east-2b','us-east-2'),(88,'us-east-2c','us-east-2'),(89,'us-gov-east-1a','us-gov-east-1'),(90,'us-gov-east-1b','us-gov-east-1'),(91,'us-gov-east-1c','us-gov-east-1'),(92,'us-gov-west-1a','us-gov-west-1'),(93,'us-gov-west-1b','us-gov-west-1'),(94,'us-gov-west-1c','us-gov-west-1'),(95,'us-west-1a','us-west-1'),(96,'us-west-1b','us-west-1'),(97,'us-west-1c','us-west-1'),(98,'us-west-2a','us-west-2'),(99,'us-west-2b','us-west-2'),(100,'us-west-2c','us-west-2'),(101,'us-west-2d','us-west-2');
/*!40000 ALTER TABLE `aws_azs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `aws_regions`
--

DROP TABLE IF EXISTS `aws_regions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aws_regions` (
  `id` int(11) NOT NULL,
  `friendly_name` varchar(45) DEFAULT NULL,
  `aws_name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aws_regions`
--

LOCK TABLES `aws_regions` WRITE;
/*!40000 ALTER TABLE `aws_regions` DISABLE KEYS */;
INSERT INTO `aws_regions` VALUES (1,'ap-east-1 - Asia Pacific (Hong Kong)','ap-east-1'),(2,'ap-northeast-1 - Asia Pacific (Tokyo)','ap-northeast-1'),(3,'ap-northeast-2 - Asia Pacific (Seoul)','ap-northeast-2'),(4,'ap-northeast-3 - Asia Pacific (Osaka)','ap-northeast-3'),(5,'ap-south-1 - Asia Pacific (Mumbai)','ap-south-1'),(6,'ap-south-2 - Asia Pacific (Hyderabad)','ap-south-2'),(7,'ap-southeast-1 - Asia Pacific (Singapore)','ap-southeast-1'),(8,'ap-southeast-2 - Asia Pacific (Sydney)','ap-southeast-2'),(9,'ap-southeast-3 - Asia Pacific (Jakarta)','ap-southeast-3'),(10,'ca-central-1 - Canada (Central)','ca-central-1'),(11,'eu-central-1 - Europe (Frankfurt)','eu-central-1'),(12,'eu-central-2 - Europe (Zurich)','eu-central-2'),(13,'eu-north-1 - Europe (Stockholm)','eu-north-1'),(14,'eu-south-1 - Europe (Milan)','eu-south-1'),(15,'eu-south-2 - Europe (Spain)','eu-south-2'),(16,'eu-west-1 - Europe (Ireland)','eu-west-1'),(17,'eu-west-2 - Europe (London)','eu-west-2'),(18,'eu-west-3 - Europe (Paris)','eu-west-3'),(19,'il-central-1 - Israel (Tel Aviv)','il-central-1'),(20,'ap-southeast-4 - Asia Pacific (Melbourne)','ap-southeast-4'),(21,'me-central-1 - Middle East (UAE)','me-central-1'),(22,'me-south-1 - Middle East (Bahrain)','me-south-1'),(23,'sa-east-1 - South America (São Paulo)','sa-east-1'),(24,'us-east-1 - US East (N. Virginia)','us-east-1'),(25,'us-east-2 - US East (Ohio)','us-east-2'),(26,'us-gov-east-1 - AWS GovCloud (US-East)','us-gov-east-1'),(27,'us-gov-west-1 - AWS GovCloud (US-West)','us-gov-west-1'),(28,'us-west-1 - US West (N. California)','us-west-1'),(29,'us-west-2 - US West (Oregon)','us-west-2');
/*!40000 ALTER TABLE `aws_regions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_azs`
--

DROP TABLE IF EXISTS `az_azs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_azs` (
  `id` int(11) NOT NULL COMMENT 'Primary Key',
  `az` varchar(40) DEFAULT NULL COMMENT 'Create Time',
  `region` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_azs`
--

LOCK TABLES `az_azs` WRITE;
/*!40000 ALTER TABLE `az_azs` DISABLE KEYS */;
INSERT INTO `az_azs` VALUES (0,'af-south-1a','af-south-1'),(1,'af-south-1b','af-south-1'),(2,'af-south-1c','af-south-1'),(3,'ap-east-1a','ap-east-1'),(4,'ap-east-1b','ap-east-1'),(5,'ap-east-1c','ap-east-1'),(6,'ap-northeast-1a','ap-northeast-1'),(7,'ap-northeast-1b','ap-northeast-1'),(8,'ap-northeast-1c','ap-northeast-1'),(9,'ap-northeast-1d','ap-northeast-1'),(10,'ap-northeast-2a','ap-northeast-2'),(11,'ap-northeast-2b','ap-northeast-2'),(12,'ap-northeast-2c','ap-northeast-2'),(13,'ap-northeast-2d','ap-northeast-2'),(14,'ap-northeast-3a','ap-northeast-3'),(15,'ap-northeast-3b','ap-northeast-3'),(16,'ap-northeast-3c','ap-northeast-3'),(17,'ap-south-1a','ap-south-1'),(18,'ap-south-1b','ap-south-1'),(19,'ap-south-1c','ap-south-1'),(20,'ap-south-2a','ap-south-2'),(21,'ap-south-2b','ap-south-2'),(22,'ap-south-2c','ap-south-2'),(23,'ap-southeast-1a','ap-southeast-1'),(24,'ap-southeast-1b','ap-southeast-1'),(25,'ap-southeast-1c','ap-southeast-1'),(26,'ap-southeast-2a','ap-southeast-2'),(27,'ap-southeast-2b','ap-southeast-2'),(28,'ap-southeast-2c','ap-southeast-2'),(29,'ap-southeast-3a','ap-southeast-3'),(30,'ap-southeast-3b','ap-southeast-3'),(31,'ap-southeast-3c','ap-southeast-3'),(32,'ap-southeast-4a','ap-southeast-4'),(33,'ap-southeast-4b','ap-southeast-4'),(34,'ap-southeast-4c','ap-southeast-4'),(35,'ca-central-1a','ca-central-1'),(36,'ca-central-1b','ca-central-1'),(37,'ca-central-1c','ca-central-1'),(38,'cn-north-1a','cn-north-1'),(39,'cn-north-1b','cn-north-1'),(40,'cn-north-1c','cn-north-1'),(41,'cn-northwest-1a','cn-northwest-1'),(42,'cn-northwest-1b','cn-northwest-1'),(43,'cn-northwest-1c','cn-northwest-1'),(44,'eu-central-1a','eu-central-1'),(45,'eu-central-1b','eu-central-1'),(46,'eu-central-1c','eu-central-1'),(47,'eu-central-2a','eu-central-2'),(48,'eu-central-2b','eu-central-2'),(49,'eu-central-2c','eu-central-2'),(50,'eu-north-1a','eu-north-1'),(51,'eu-north-1b','eu-north-1'),(52,'eu-north-1c','eu-north-1'),(53,'eu-south-1a','eu-south-1'),(54,'eu-south-1b','eu-south-1'),(55,'eu-south-1c','eu-south-1'),(56,'eu-south-2a','eu-south-2'),(57,'eu-south-2b','eu-south-2'),(58,'eu-south-2c','eu-south-2'),(59,'eu-west-1a','eu-west-1'),(60,'eu-west-1b','eu-west-1'),(61,'eu-west-1c','eu-west-1'),(62,'eu-west-2a','eu-west-2'),(63,'eu-west-2b','eu-west-2'),(64,'eu-west-2c','eu-west-2'),(65,'eu-west-3a','eu-west-3'),(66,'eu-west-3b','eu-west-3'),(67,'eu-west-3c','eu-west-3'),(68,'il-central-1a','il-central-1'),(69,'il-central-1b','il-central-1'),(70,'il-central-1c','il-central-1'),(71,'me-central-1a','me-central-1'),(72,'me-central-1b','me-central-1'),(73,'me-central-1c','me-central-1'),(74,'me-south-1a','me-south-1'),(75,'me-south-1b','me-south-1'),(76,'me-south-1c','me-south-1'),(77,'sa-east-1a','sa-east-1'),(78,'sa-east-1b','sa-east-1'),(79,'sa-east-1c','sa-east-1'),(80,'us-east-1a','us-east-1'),(81,'us-east-1b','us-east-1'),(82,'us-east-1c','us-east-1'),(83,'us-east-1d','us-east-1'),(84,'us-east-1e','us-east-1'),(85,'us-east-1f','us-east-1'),(86,'us-east-2a','us-east-2'),(87,'us-east-2b','us-east-2'),(88,'us-east-2c','us-east-2'),(89,'us-gov-east-1a','us-gov-east-1'),(90,'us-gov-east-1b','us-gov-east-1'),(91,'us-gov-east-1c','us-gov-east-1'),(92,'us-gov-west-1a','us-gov-west-1'),(93,'us-gov-west-1b','us-gov-west-1'),(94,'us-gov-west-1c','us-gov-west-1'),(95,'us-west-1a','us-west-1'),(96,'us-west-1b','us-west-1'),(97,'us-west-1c','us-west-1'),(98,'us-west-2a','us-west-2'),(99,'us-west-2b','us-west-2'),(100,'us-west-2c','us-west-2'),(101,'us-west-2d','us-west-2');
/*!40000 ALTER TABLE `az_azs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_regions`
--

DROP TABLE IF EXISTS `az_regions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_regions` (
  `id` int(11) NOT NULL,
  `az_name` varchar(45) DEFAULT NULL,
  `display_name` varchar(45) DEFAULT NULL,
  `reg_display_name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `az_regions`
--

LOCK TABLES `az_regions` WRITE;
/*!40000 ALTER TABLE `az_regions` DISABLE KEYS */;
INSERT INTO `az_regions` VALUES (1,'eastus','East US','(US) East US'),(2,'eastus2','East US 2','(US) East US 2'),(3,'southcentralus','South Central US','(US) South Central US'),(4,'westus2','West US 2','(US) West US 2'),(5,'westus3','West US 3','(US) West US 3'),(6,'australiaeast','Australia East','(Asia Pacific) Australia East'),(7,'southeastasia','Southeast Asia','(Asia Pacific) Southeast Asia'),(8,'northeurope','North Europe','(Europe) North Europe'),(9,'swedencentral','Sweden Central','(Europe) Sweden Central'),(10,'uksouth','UK South','(Europe) UK South'),(11,'westeurope','West Europe','(Europe) West Europe'),(12,'centralus','Central US','(US) Central US'),(13,'southafricanorth','South Africa North','(Africa) South Africa North'),(14,'centralindia','Central India','(Asia Pacific) Central India'),(15,'eastasia','East Asia','(Asia Pacific) East Asia'),(16,'japaneast','Japan East','(Asia Pacific) Japan East'),(17,'koreacentral','Korea Central','(Asia Pacific) Korea Central'),(18,'canadacentral','Canada Central','(Canada) Canada Central'),(19,'francecentral','France Central','(Europe) France Central'),(20,'germanywestcentral','Germany West Central','(Europe) Germany West Central'),(21,'italynorth','Italy North','(Europe) Italy North'),(22,'norwayeast','Norway East','(Europe) Norway East'),(23,'polandcentral','Poland Central','(Europe) Poland Central'),(24,'switzerlandnorth','Switzerland North','(Europe) Switzerland North'),(25,'uaenorth','UAE North','(Middle East) UAE North'),(26,'brazilsouth','Brazil South','(South America) Brazil South'),(27,'centraluseuap','Central US EUAP','(US) Central US EUAP'),(28,'israelcentral','Israel Central','(Middle East) Israel Central'),(29,'qatarcentral','Qatar Central','(Middle East) Qatar Central'),(30,'centralusstage','Central US (Stage)','(US) Central US (Stage)'),(31,'eastusstage','East US (Stage)','(US) East US (Stage)'),(32,'eastus2stage','East US 2 (Stage)','(US) East US 2 (Stage)'),(33,'northcentralusstage','North Central US (Stage)','(US) North Central US (Stage)'),(34,'southcentralusstage','South Central US (Stage)','(US) South Central US (Stage)'),(35,'westusstage','West US (Stage)','(US) West US (Stage)'),(36,'westus2stage','West US 2 (Stage)','(US) West US 2 (Stage)'),(37,'asia','Asia','Asia'),(38,'asiapacific','Asia Pacific','Asia Pacific'),(39,'australia','Australia','Australia'),(40,'brazil','Brazil','Brazil'),(41,'canada','Canada','Canada'),(42,'europe','Europe','Europe'),(43,'france','France','France'),(44,'germany','Germany','Germany'),(45,'global','Global','Global'),(46,'india','India','India'),(47,'japan','Japan','Japan'),(48,'korea','Korea','Korea'),(49,'norway','Norway','Norway'),(50,'singapore','Singapore','Singapore'),(51,'southafrica','South Africa','South Africa'),(52,'sweden','Sweden','Sweden'),(53,'switzerland','Switzerland','Switzerland'),(54,'uae','United Arab Emirates','United Arab Emirates'),(55,'uk','United Kingdom','United Kingdom'),(56,'unitedstates','United States','United States'),(57,'unitedstateseuap','United States EUAP','United States EUAP'),(58,'eastasiastage','East Asia (Stage)','(Asia Pacific) East Asia (Stage)'),(59,'southeastasiastage','Southeast Asia (Stage)','(Asia Pacific) Southeast Asia (Stage)'),(60,'brazilus','Brazil US','(South America) Brazil US'),(61,'eastusstg','East US STG','(US) East US STG'),(62,'northcentralus','North Central US','(US) North Central US'),(63,'westus','West US','(US) West US'),(64,'japanwest','Japan West','(Asia Pacific) Japan West'),(65,'jioindiawest','Jio India West','(Asia Pacific) Jio India West'),(66,'eastus2euap','East US 2 EUAP','(US) East US 2 EUAP'),(67,'westcentralus','West Central US','(US) West Central US'),(68,'southafricawest','South Africa West','(Africa) South Africa West'),(69,'australiacentral','Australia Central','(Asia Pacific) Australia Central'),(70,'australiacentral2','Australia Central 2','(Asia Pacific) Australia Central 2'),(71,'australiasoutheast','Australia Southeast','(Asia Pacific) Australia Southeast'),(72,'jioindiacentral','Jio India Central','(Asia Pacific) Jio India Central'),(73,'koreasouth','Korea South','(Asia Pacific) Korea South'),(74,'southindia','South India','(Asia Pacific) South India'),(75,'westindia','West India','(Asia Pacific) West India'),(76,'canadaeast','Canada East','(Canada) Canada East'),(77,'francesouth','France South','(Europe) France South'),(78,'germanynorth','Germany North','(Europe) Germany North'),(79,'norwaywest','Norway West','(Europe) Norway West'),(80,'switzerlandwest','Switzerland West','(Europe) Switzerland West'),(81,'ukwest','UK West','(Europe) UK West'),(82,'uaecentral','UAE Central','(Middle East) UAE Central'),(83,'brazilsoutheast','Brazil Southeast','(South America) Brazil Southeast');
/*!40000 ALTER TABLE `az_regions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `az_subscriptions`
--

DROP TABLE IF EXISTS `az_subscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `az_subscriptions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subscription_name` varchar(45) NOT NULL,
  `tenant_id` varchar(45) NOT NULL,
  `subscription_id` varchar(45) NOT NULL,
  `application_id` varchar(45) NOT NULL,
  `secret_value` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `config_shares`
--

DROP TABLE IF EXISTS `config_shares`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `config_shares` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `config_uuid` varchar(45) NOT NULL,
  `share_type` varchar(10) NOT NULL,
  `target_id` varchar(45) NOT NULL,
  `permissions` varchar(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `config_shares`
--

LOCK TABLES `config_shares` WRITE;
/*!40000 ALTER TABLE `config_shares` DISABLE KEYS */;
/*!40000 ALTER TABLE `config_shares` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `configs`
--

DROP TABLE IF EXISTS `configs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `configs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_email` varchar(45) NOT NULL,
  `config_name` varchar(25) NOT NULL,
  `config_uuid` varchar(45) NOT NULL,
  `account` varchar(45) DEFAULT NULL,
  `region` varchar(45) NOT NULL,
  `created_by` varchar(45) NOT NULL,
  `created_at` datetime NOT NULL,
  `modified_at` datetime DEFAULT NULL,
  `modified_by` varchar(45) DEFAULT NULL,
  `deleted` varchar(10) DEFAULT NULL,
  `status` varchar(40) NOT NULL,
  `cloud_provider` varchar(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `configs`
--

LOCK TABLES `configs` WRITE;
/*!40000 ALTER TABLE `configs` DISABLE KEYS */;
/*!40000 ALTER TABLE `configs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_group_assignments`
--

DROP TABLE IF EXISTS `user_group_assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_group_assignments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_email` varchar(45) NOT NULL,
  `group_name` varchar(45) NOT NULL,
  `added_by` varchar(45) NOT NULL,
  `added_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_group_assignments`
--

LOCK TABLES `user_group_assignments` WRITE;
/*!40000 ALTER TABLE `user_group_assignments` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_group_assignments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_groups`
--

DROP TABLE IF EXISTS `user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_name` varchar(45) NOT NULL,
  `owner_email` varchar(45) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_by` varchar(45) NOT NULL,
  `modified_at` datetime DEFAULT NULL,
  `modified_by` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`group_name`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_groups`
--

LOCK TABLES `user_groups` WRITE;
/*!40000 ALTER TABLE `user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(45) NOT NULL,
  `username` varchar(45) NOT NULL,
  `user_uuid` varchar(45) NOT NULL,
  `first_login` datetime DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  `is_admin` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-05-11 14:07:05
