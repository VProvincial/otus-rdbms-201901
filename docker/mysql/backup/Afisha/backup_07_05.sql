CREATE DATABASE  IF NOT EXISTS `afisha` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `afisha`;
-- MySQL dump 10.13  Distrib 8.0.16, for macos10.14 (x86_64)
--
-- Host: localhost    Database: afisha
-- ------------------------------------------------------
-- Server version	5.7.25

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
 SET NAMES utf8 ;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `booking`
--

DROP TABLE IF EXISTS `booking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `booking` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '4 бит в качестве не естественно ключа будет достаточно, unsigned исключит использование отрицательных значений и добавит в интервал положительных значение',
  `id_seans` int(10) unsigned NOT NULL,
  `insert_at` datetime NOT NULL COMMENT 'Факт оплаты ',
  `payed_at` datetime DEFAULT NULL COMMENT 'Дата фактической оплаты билета на сеанс кино, NULL - не оплаченный билет',
  `id_status` int(10) unsigned NOT NULL,
  `ticket` varchar(10) NOT NULL COMMENT 'Номер билета',
  `id_client` int(10) unsigned NOT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `seans_fk` (`id_seans`),
  KEY `client_fk` (`id_client`),
  KEY `status_fk` (`id_status`),
  CONSTRAINT `client_fk` FOREIGN KEY (`id_client`) REFERENCES `client` (`id`),
  CONSTRAINT `seans_fk` FOREIGN KEY (`id_seans`) REFERENCES `seans` (`id`),
  CONSTRAINT `status_fk` FOREIGN KEY (`id_status`) REFERENCES `booking_status` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking`
--

LOCK TABLES `booking` WRITE;
/*!40000 ALTER TABLE `booking` DISABLE KEYS */;
/*!40000 ALTER TABLE `booking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `booking_status`
--

DROP TABLE IF EXISTS `booking_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `booking_status` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL COMMENT 'Краткое название статуса брони билета',
  `description` varchar(255) DEFAULT NULL COMMENT 'Подробное описание статуса брони билета',
  `sort` int(2) unsigned NOT NULL DEFAULT '50' COMMENT 'Сортировка статуса в соответствии с логическим порядком прохождения этапов покупки билета',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking_status`
--

LOCK TABLES `booking_status` WRITE;
/*!40000 ALTER TABLE `booking_status` DISABLE KEYS */;
/*!40000 ALTER TABLE `booking_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `client`
--

DROP TABLE IF EXISTS `client`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `client` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL COMMENT 'Название клиента',
  `balance` decimal(10,2) unsigned NOT NULL DEFAULT '0.00' COMMENT 'Баланс клиента в системе',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `client`
--

LOCK TABLES `client` WRITE;
/*!40000 ALTER TABLE `client` DISABLE KEYS */;
/*!40000 ALTER TABLE `client` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `company`
--

DROP TABLE IF EXISTS `company`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `company`(
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '4 бит в качестве не естественно ключа будет достаточно, unsigned исключит использование отрицательных значений и добавит в интервал положительных значение',
  `name` varchar(100) NOT NULL COMMENT 'Для названия компании вполне достаточно 100 символов в локальной кодировке, что сэкономят место и не будут избыточными',
  `active` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Флаг активности, должен позволять периодически деактивировать компанию в афише и все его события. Одного символа 0 или 1 хватит для фильтрации',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company`
--

LOCK TABLES `company` WRITE;
/*!40000 ALTER TABLE `company` DISABLE KEYS */;
/*!40000 ALTER TABLE `company` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feature`
--

DROP TABLE IF EXISTS `feature`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `feature`(
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '4 бит в качестве не естественно ключа будет достаточно, unsigned исключит использование отрицательных значений и добавит в интервал положительных значение',
  `name` varchar(100) NOT NULL COMMENT '100 символов в локальной кодировке сэкономят место и не будут избыточными',
  `type` enum('int','boolean','string','date') NOT NULL DEFAULT 'string' COMMENT 'Тип данных который будет сохранен в значении характеристики зала, набор этих данных жестко ограничены, т.к. от них будет зависеть как будет выводиться значения характеристик.\nВозможны варианты:\nInt - число, например: Кол-во мест - 200\nboolean - Да/нет, например: Наличие в зале кресел «D-Box» - Да\nstring - строка, например: Доп. информация: современая система управления цвета от компании …\ndate - дата',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feature`
--

LOCK TABLES `feature` WRITE;
/*!40000 ALTER TABLE `feature` DISABLE KEYS */;
/*!40000 ALTER TABLE `feature` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feature_hall`
--

DROP TABLE IF EXISTS `feature_hall`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `feature_hall`(
  `id_feature` int(11) unsigned NOT NULL COMMENT 'Внешний ключ в рамках составного индекса характеристики зала',
  `id_hall` int(10) unsigned NOT NULL COMMENT 'Внешний ключ в рамках составного индекса характеристики зала',
  `value` varchar(255) NOT NULL COMMENT '100 символов в локальной кодировке сэкономят место и не будут избыточными, здесь будут хранится значения характеристик, сами характеристики могут добавляться, значения зависят от конкретного зала',
  PRIMARY KEY (`id_feature`,`id_hall`),
  KEY `id_feature` (`id_feature`),
  KEY `hall_fk` (`id_hall`),
  CONSTRAINT `feature_fk` FOREIGN KEY (`id_feature`) REFERENCES `feature` (`id`),
  CONSTRAINT `hall_fk` FOREIGN KEY (`id_hall`) REFERENCES `hall` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feature_hall`
--

LOCK TABLES `feature_hall` WRITE;
/*!40000 ALTER TABLE `feature_hall` DISABLE KEYS */;
/*!40000 ALTER TABLE `feature_hall` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `film`
--

DROP TABLE IF EXISTS `film`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `film` (
  `id` int(4) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Естественных ключей для фильм нет в рамках наших атрибутов, простого int в 4 байта будет достаточно на ближайшие несколько десятков лет. В значения 4 байта с включеным unsigned входит числа  от 0 до 4294967295',
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL COMMENT 'хранение названия фильма достаточно для локальной кодировки, отсутствие utf позволит сэкономить занимаемое место',
  `year` year(4) DEFAULT '0000' COMMENT 'Нужно хранить только год, YEAR займет только 1 байт, этого достаточно для вывода информации, сортировки и фильтрации.\nКак альтернативу можно рассмотреть SMALLINT (2 байта), он дает диапазон, достаточный в большинстве ситуаций для хранения года, но. в нашем случае возможно избыточен, т.к. До 2155 года(макс число для YEAR) еще нужно дожить',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `film`
--

LOCK TABLES `film` WRITE;
/*!40000 ALTER TABLE `film` DISABLE KEYS */;
/*!40000 ALTER TABLE `film` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hall`
--

DROP TABLE IF EXISTS `hall`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `hall`(
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '4 бит в качестве не естественно ключа будет достаточно, unsigned исключит использование отрицательных значений и добавит в интервал положительных значение',
  `id_company` int(11) unsigned NOT NULL,
  `name` varchar(100) NOT NULL COMMENT 'Для названия зала кинотеатра вполне достаточно 100 символов в локальной кодировке, что сэкономят место и не будут избыточными',
  PRIMARY KEY (`id`),
  KEY `company_fk` (`id_company`),
  CONSTRAINT `company_fk` FOREIGN KEY (`id_company`) REFERENCES `company` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hall`
--

LOCK TABLES `hall` WRITE;
/*!40000 ALTER TABLE `hall` DISABLE KEYS */;
/*!40000 ALTER TABLE `hall` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seans`
--

DROP TABLE IF EXISTS `seans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `seans` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '4 бит в качестве не естественно ключа будет достаточно идентификации сеансов, unsigned исключит использование отрицательных значений и добавит в интервал положительных значение',
  `id_film` int(11) unsigned NOT NULL COMMENT 'Внешний ключ в рамках составного индекса',
  `id_hall` int(10) unsigned NOT NULL COMMENT 'Внешний ключ в рамках составного индекса',
  `start_at` datetime NOT NULL COMMENT 'Начало сеанса',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT 'Цена за сеанс, DECIMAL сохранит корректный формат данных специально для цен',
  `finished` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Факт окончания сеанса, сеансы с этим флагом не используются в паблике',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `film_fk` (`id_film`),
  KEY `hall_fk2` (`id_hall`),
  CONSTRAINT `film_fk` FOREIGN KEY (`id_film`) REFERENCES `film` (`id`),
  CONSTRAINT `hall_fk2` FOREIGN KEY (`id_hall`) REFERENCES `hall` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seans`
--

LOCK TABLES `seans` WRITE;
/*!40000 ALTER TABLE `seans` DISABLE KEYS */;
/*!40000 ALTER TABLE `seans` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-07-05 19:05:13