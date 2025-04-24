CREATE DATABASE  IF NOT EXISTS `miniproject` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `miniproject`;
-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: miniproject
-- ------------------------------------------------------
-- Server version	8.0.41

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `trains`
--

DROP TABLE IF EXISTS `trains`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trains` (
  `Train_no` int NOT NULL,
  `Train_name` varchar(30) DEFAULT NULL,
  `Type` enum('Passenger','Express','Premium') DEFAULT NULL,
  `Source_id` int DEFAULT NULL,
  `Destination_id` int DEFAULT NULL,
  `Days_of_operation` char(7) DEFAULT NULL,
  PRIMARY KEY (`Train_no`),
  KEY `Source_id` (`Source_id`),
  KEY `Destination_id` (`Destination_id`),
  CONSTRAINT `trains_ibfk_1` FOREIGN KEY (`Source_id`) REFERENCES `stations` (`Station_id`),
  CONSTRAINT `trains_ibfk_2` FOREIGN KEY (`Destination_id`) REFERENCES `stations` (`Station_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trains`
--

LOCK TABLES `trains` WRITE;
/*!40000 ALTER TABLE `trains` DISABLE KEYS */;
INSERT INTO `trains` VALUES (12001,'Shatabdi Express','Premium',1,8,'YYNYNYN'),(12002,'Rajdhani Express','Premium',1,2,'YYYYYYY'),(12003,'Duronto Express','Premium',3,4,'YYNYYNN'),(12004,'Garib Rath','Express',5,6,'NYYNYYY'),(12005,'Chennai Mail','Express',3,1,'YYYYYYY'),(12006,'Mumbai Express','Express',2,5,'YYYYNYY'),(12007,'Konkan Kanya','Express',2,11,'YNYYNYN'),(12008,'Punjab Mail','Express',1,17,'YYNYYNY'),(12009,'Deccan Express','Express',9,6,'NYYNYYN'),(12010,'Varanasi Express','Express',1,20,'YYNYYYN'),(12011,'Lucknow Shatabdi','Premium',1,10,'YYNYYNN'),(12012,'Poorva Express','Express',4,1,'YYNYYNY'),(12013,'Kerala Express','Express',1,16,'YYYYYYY'),(12014,'Chandigarh Express','Passenger',1,12,'YYYYYYY'),(12015,'Bhopal Express','Express',1,13,'NYYNYYY'),(12016,'Patna Vadodara Express','Premium',14,21,'YYYYYYN'),(12017,'Ganga Express','Express',1,14,'YNYYNYY'),(12018,'Vishakha Express','Premium',6,18,'YYYYNNY'),(12019,'Himalayan Queen','Express',1,15,'NYYNYYY'),(12020,'Kaveri Express','Express',5,3,'YYNYYNY');
/*!40000 ALTER TABLE `trains` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-24  6:29:37
