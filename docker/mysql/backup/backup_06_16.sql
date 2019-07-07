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
  `insert_dt` datetime NOT NULL COMMENT 'Факт оплаты ',
  `payed_dt` datetime DEFAULT NULL COMMENT 'Дата фактической оплаты билета на сеанс кино, NULL - не оплаченный билет',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
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
-- Table structure for table `company`
--

DROP TABLE IF EXISTS `company`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `company` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '4 бит в качестве не естественно ключа будет достаточно, unsigned исключит использование отрицательных значений и добавит в интервал положительных значение',
  `name` varchar(100) NOT NULL COMMENT 'Для названия компании вполне достаточно 100 символов в локальной кодировке, что сэкономят место и не будут избыточными',
  `active` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Флаг активности, должен позволять периодически деактивировать компанию в афише и все его события. Одного символа 0 или 1 хватит для фильтрации',
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
CREATE TABLE `feature` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '4 бит в качестве не естественно ключа будет достаточно, unsigned исключит использование отрицательных значений и добавит в интервал положительных значение',
  `name` varchar(100) NOT NULL COMMENT '100 символов в локальной кодировке сэкономят место и не будут избыточными',
  `type` enum('int','boolean','string','date') NOT NULL DEFAULT 'string' COMMENT 'Тип данных который будет сохранен в значении характеристики зала, набор этих данных жестко ограничены, т.к. от них будет зависеть как будет выводиться значения характеристик',
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
CREATE TABLE `feature_hall` (
  `id_feature` int(11) unsigned NOT NULL COMMENT 'Внешний ключ в рамках составного индекса характеристики зала',
  `id_hall` int(10) unsigned NOT NULL COMMENT 'Внешний ключ в рамках составного индекса характеристики зала',
  `value` varchar(100) NOT NULL COMMENT '100 символов в локальной кодировке сэкономят место и не будут избыточными, здесь будут хранится значения характеристик, сами характеристики могут добавляться, значения зависят от конкретного зала',
  KEY `id_hall` (`id_hall`),
  KEY `id_feature` (`id_feature`)
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
CREATE TABLE `hall` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '4 бит в качестве не естественно ключа будет достаточно, unsigned исключит использование отрицательных значений и добавит в интервал положительных значение',
  `id_company` int(11) unsigned NOT NULL,
  `name` varchar(100) NOT NULL COMMENT 'Для названия зала кинотеатра вполне достаточно 100 символов в локальной кодировке, что сэкономят место и не будут избыточными',
  PRIMARY KEY (`id`)
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
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT 'Цена за сеанс, DECIMAL сохранит корректный формат данных специально для цен',
  `finished` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Факт окончания сеанса, сеансы с этим флагом не используются в паблике ',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
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

-- Dump completed on 2019-06-16 20:48:14
