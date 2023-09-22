-- MariaDB dump 10.19  Distrib 10.5.21-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: system
-- ------------------------------------------------------
-- Server version	10.5.21-MariaDB-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `binary_file`
--

DROP TABLE IF EXISTS `binary_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `binary_file` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `os_id` int(10) unsigned NOT NULL,
  `at_least_versions` int(10) unsigned NOT NULL DEFAULT 32,
  `type` enum('program','config','security','data','other') NOT NULL DEFAULT 'data',
  `unit` varchar(255) DEFAULT NULL,
  `path` varchar(511) NOT NULL,
  `data` mediumblob NOT NULL,
  `mime_type` varchar(63) NOT NULL,
  `mime_encoding` varchar(63) NOT NULL,
  `mime_value` varchar(255) NOT NULL,
  `file_owner` varchar(63) NOT NULL,
  `file_group` varchar(63) NOT NULL,
  `file_mode` int(10) unsigned NOT NULL,
  `is_complessed` tinyint(1) NOT NULL DEFAULT 1,
  `last_modify` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `os_id` (`os_id`,`path`),
  KEY `unit` (`unit`),
  CONSTRAINT `binary_file_ibfk_1` FOREIGN KEY (`os_id`) REFERENCES `os` (`id`),
  CONSTRAINT `binary_file_ibfk_2` FOREIGN KEY (`unit`) REFERENCES `package` (`unit_name`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `command`
--

DROP TABLE IF EXISTS `command`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `command` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `command` varchar(255) NOT NULL,
  `os_id` int(10) unsigned NOT NULL,
  `has_argument` tinyint(1) NOT NULL DEFAULT 0,
  `argument_count` int(10) unsigned NOT NULL DEFAULT 0,
  `type` enum('package_install','package_remove','package_enable','package_disable','package_start','package_stop','package_restart','package_reload','sql','sql_file','sync','selinux','ssh','scp','initialize','security','security-install','rsync_trigger','other') NOT NULL DEFAULT 'other',
  `on_time` enum('anytime','initialize','pre_install','after_install','pre_start','after_start','finalize') NOT NULL DEFAULT 'anytime',
  `use_expect` tinyint(1) NOT NULL DEFAULT 0,
  `maxsplit` int(11) NOT NULL DEFAULT -1,
  `is_shell_subprocess` tinyint(1) NOT NULL DEFAULT 0,
  `allow_error` tinyint(1) NOT NULL DEFAULT 0,
  `unit` varchar(255) DEFAULT NULL,
  `priority` int(11) NOT NULL DEFAULT 1000,
  PRIMARY KEY (`id`),
  UNIQUE KEY `os_id_2` (`os_id`,`command`),
  KEY `os_id` (`os_id`),
  KEY `unit` (`unit`),
  CONSTRAINT `command_ibfk_1` FOREIGN KEY (`os_id`) REFERENCES `os` (`id`),
  CONSTRAINT `command_ibfk_2` FOREIGN KEY (`unit`) REFERENCES `package` (`unit_name`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `domain`
--

DROP TABLE IF EXISTS `domain`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `domain` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `type` enum('local','global','both') NOT NULL DEFAULT 'local',
  `ipv4_address` char(15) NOT NULL,
  `ipv4_mask` char(15) NOT NULL,
  `ipv6_address` varchar(127) DEFAULT NULL,
  `ipv6_mask` varchar(127) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `initialize`
--

DROP TABLE IF EXISTS `initialize`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `initialize` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `machine_id` int(10) unsigned NOT NULL,
  `package_installed` tinyint(1) NOT NULL DEFAULT 0,
  `rsync_done` tinyint(1) NOT NULL DEFAULT 0,
  `script_done` tinyint(1) NOT NULL DEFAULT 0,
  `security_done` tinyint(1) NOT NULL DEFAULT 0,
  `database_done` tinyint(1) NOT NULL DEFAULT 0,
  `command_done` tinyint(1) NOT NULL DEFAULT 0,
  `system_config_done` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `machine_id` (`machine_id`),
  CONSTRAINT `initialize_ibfk_1` FOREIGN KEY (`machine_id`) REFERENCES `machine` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `machine`
--

DROP TABLE IF EXISTS `machine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `machine` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `os_id` int(10) unsigned NOT NULL,
  `domain_id` int(10) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `type` enum('master','slave','other') NOT NULL DEFAULT 'other',
  `initialized` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `os_id` (`os_id`),
  KEY `domain_id` (`domain_id`),
  CONSTRAINT `machine_ibfk_1` FOREIGN KEY (`os_id`) REFERENCES `os` (`id`),
  CONSTRAINT `machine_ibfk_2` FOREIGN KEY (`domain_id`) REFERENCES `domain` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger insert_machine after insert on machine for each row insert into initialize ( machine_id ) values ( NEW.id ) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `os`
--

DROP TABLE IF EXISTS `os`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `os` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT 'Ferora',
  `edition` varchar(255) NOT NULL DEFAULT 'Workstation',
  `vendor` varchar(255) NOT NULL DEFAULT 'Red Hat',
  `version` varchar(255) NOT NULL,
  `sub_version` varchar(255) NOT NULL,
  `type` enum('Linux','UNIX','Windows') NOT NULL DEFAULT 'Linux',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `package`
--

DROP TABLE IF EXISTS `package`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `package` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `unit_name` varchar(255) DEFAULT NULL,
  `need_enable` tinyint(1) NOT NULL DEFAULT 0,
  `need_start` tinyint(1) DEFAULT 0,
  `dpend_on_unit` tinyint(1) NOT NULL DEFAULT 0,
  `os_id` int(10) unsigned NOT NULL,
  `install_type` enum('master','slave','all') NOT NULL DEFAULT 'all',
  `priority` int(11) NOT NULL DEFAULT 1000,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`,`os_id`),
  KEY `os_id` (`os_id`),
  KEY `unit_name` (`unit_name`),
  CONSTRAINT `package_ibfk_1` FOREIGN KEY (`os_id`) REFERENCES `os` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `package_initialize`
--

DROP TABLE IF EXISTS `package_initialize`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `package_initialize` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `package_id` int(10) unsigned NOT NULL,
  `machine_id` int(10) unsigned NOT NULL,
  `initialized` tinyint(1) NOT NULL DEFAULT 0,
  `initialize_date` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `package_id_key` (`package_id`,`machine_id`),
  KEY `machine_id` (`machine_id`),
  CONSTRAINT `package_initialize_ibfk_1` FOREIGN KEY (`package_id`) REFERENCES `package` (`id`),
  CONSTRAINT `package_initialize_ibfk_2` FOREIGN KEY (`machine_id`) REFERENCES `machine` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1386 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rsync`
--

DROP TABLE IF EXISTS `rsync`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rsync` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `os_id` int(10) unsigned NOT NULL,
  `directory` varchar(255) NOT NULL,
  `unit` varchar(255) DEFAULT NULL,
  `priority` int(11) NOT NULL DEFAULT 1000,
  `update_term_seconds` int(10) unsigned NOT NULL DEFAULT 86400,
  `has_trigger` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `os_id_2` (`os_id`,`directory`),
  KEY `os_id` (`os_id`),
  KEY `unit` (`unit`),
  CONSTRAINT `rsync_ibfk_1` FOREIGN KEY (`os_id`) REFERENCES `os` (`id`),
  CONSTRAINT `rsync_ibfk_2` FOREIGN KEY (`unit`) REFERENCES `package` (`unit_name`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rsync_date`
--

DROP TABLE IF EXISTS `rsync_date`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rsync_date` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `rsync_id` int(10) unsigned NOT NULL,
  `machine_id` int(10) unsigned NOT NULL,
  `unit_name` varchar(255) DEFAULT NULL,
  `rsync_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `update_term_seconds` int(10) unsigned NOT NULL DEFAULT 86400,
  `is_done` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `rsync_id_key` (`rsync_id`,`machine_id`),
  KEY `machine_id` (`machine_id`),
  KEY `unit_name` (`unit_name`),
  CONSTRAINT `rsync_date_ibfk_1` FOREIGN KEY (`rsync_id`) REFERENCES `rsync` (`id`),
  CONSTRAINT `rsync_date_ibfk_2` FOREIGN KEY (`machine_id`) REFERENCES `machine` (`id`),
  CONSTRAINT `rsync_date_ibfk_3` FOREIGN KEY (`unit_name`) REFERENCES `package` (`unit_name`)
) ENGINE=InnoDB AUTO_INCREMENT=1767 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `text_file`
--

DROP TABLE IF EXISTS `text_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `text_file` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `os_id` int(10) unsigned NOT NULL,
  `at_least_versions` int(10) unsigned NOT NULL DEFAULT 31,
  `type` enum('script','config','sql','other') NOT NULL DEFAULT 'other',
  `unit` varchar(255) DEFAULT NULL,
  `path` varchar(511) NOT NULL,
  `data` blob NOT NULL,
  `mime_type` varchar(63) NOT NULL,
  `mime_encoding` varchar(63) NOT NULL,
  `mime_value` varchar(255) NOT NULL,
  `file_owner` varchar(63) NOT NULL,
  `file_group` varchar(63) NOT NULL,
  `file_mode` int(10) unsigned NOT NULL,
  `is_complessed` tinyint(1) NOT NULL DEFAULT 1,
  `is_database_config` tinyint(1) NOT NULL DEFAULT 0,
  `is_initialize_database` tinyint(1) NOT NULL DEFAULT 0,
  `last_modify` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `os_id` (`os_id`,`path`),
  KEY `unit` (`unit`),
  CONSTRAINT `text_file_ibfk_1` FOREIGN KEY (`os_id`) REFERENCES `os` (`id`),
  CONSTRAINT `text_file_ibfk_2` FOREIGN KEY (`unit`) REFERENCES `package` (`unit_name`)
) ENGINE=InnoDB AUTO_INCREMENT=597 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-09-23  3:22:53
