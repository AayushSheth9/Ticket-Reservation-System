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
-- Table structure for table `ticket`
--

DROP TABLE IF EXISTS `ticket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ticket` (
  `Ticket_id` int NOT NULL,
  `Passenger_id` int NOT NULL,
  `Train_id` int DEFAULT NULL,
  `PNR` varchar(20) DEFAULT NULL,
  `Class_id` int DEFAULT NULL,
  `Seat_id` int DEFAULT NULL,
  `Boarding_station` int DEFAULT NULL,
  `Arrival_station` int DEFAULT NULL,
  `Ticket_status` enum('Confirmed','Cancelled','RAC','Waiting') DEFAULT NULL,
  `Payment_id` int DEFAULT NULL,
  `Travel_date` date DEFAULT NULL,
  PRIMARY KEY (`Ticket_id`,`Passenger_id`),
  KEY `Class_id` (`Class_id`),
  KEY `Passenger_id` (`Passenger_id`),
  KEY `Train_id` (`Train_id`),
  KEY `Boarding_station` (`Boarding_station`),
  KEY `Arrival_station` (`Arrival_station`),
  KEY `Seat_id` (`Seat_id`),
  KEY `Payment_id` (`Payment_id`),
  CONSTRAINT `ticket_ibfk_1` FOREIGN KEY (`Class_id`) REFERENCES `class` (`Class_id`),
  CONSTRAINT `ticket_ibfk_2` FOREIGN KEY (`Passenger_id`) REFERENCES `passengers` (`Passenger_id`),
  CONSTRAINT `ticket_ibfk_3` FOREIGN KEY (`Train_id`) REFERENCES `trains` (`Train_no`),
  CONSTRAINT `ticket_ibfk_4` FOREIGN KEY (`Boarding_station`) REFERENCES `stations` (`Station_id`),
  CONSTRAINT `ticket_ibfk_5` FOREIGN KEY (`Arrival_station`) REFERENCES `stations` (`Station_id`),
  CONSTRAINT `ticket_ibfk_6` FOREIGN KEY (`Seat_id`) REFERENCES `seat` (`Seat_id`),
  CONSTRAINT `ticket_ibfk_7` FOREIGN KEY (`Payment_id`) REFERENCES `payment` (`Payment_id`),
  CONSTRAINT `ticket_ibfk_8` FOREIGN KEY (`Payment_id`) REFERENCES `payment` (`Payment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket`
--

LOCK TABLES `ticket` WRITE;
/*!40000 ALTER TABLE `ticket` DISABLE KEYS */;
INSERT INTO `ticket` VALUES (1,1001,12001,'PNR952016',4,416,1,8,'Confirmed',1,'2025-04-14'),(1,1002,12001,'PNR952016',4,417,1,8,'Confirmed',1,'2025-04-14'),(1,1003,12001,'PNR952016',4,418,1,8,'Confirmed',1,'2025-04-14'),(1,1004,12001,'PNR952016',4,419,1,8,'Confirmed',1,'2025-04-14'),(1,1005,12001,'PNR952016',4,420,1,8,'Confirmed',1,'2025-04-14'),(1,1006,12001,'PNR952016',4,416,1,8,'RAC',1,'2025-04-14'),(2,1007,12001,'PNR462381',4,417,1,8,'RAC',2,'2025-04-14'),(2,1008,12001,'PNR462381',4,418,1,8,'RAC',2,'2025-04-14'),(2,1009,12001,'PNR462381',4,419,1,8,'RAC',2,'2025-04-14'),(2,1010,12001,'PNR462381',4,420,1,8,'RAC',2,'2025-04-14'),(2,1011,12001,'PNR462381',4,NULL,1,8,'Waiting',2,'2025-04-14'),(2,1012,12001,'PNR462381',4,NULL,1,8,'Waiting',2,'2025-04-14'),(3,1001,12002,'PNR455856',4,866,1,19,'Confirmed',3,'2025-04-15'),(3,1002,12002,'PNR455856',4,867,1,19,'Confirmed',3,'2025-04-15'),(3,1004,12002,'PNR455856',4,868,1,19,'Confirmed',3,'2025-04-15'),(4,1001,12001,'PNR892138',4,1191,12,8,'Confirmed',4,'2025-04-16'),(4,1002,12001,'PNR892138',4,1192,12,8,'Confirmed',4,'2025-04-16'),(4,1003,12001,'PNR892138',4,1193,12,8,'Confirmed',4,'2025-04-16'),(4,1004,12001,'PNR892138',4,1194,12,8,'Confirmed',4,'2025-04-16'),(4,1005,12001,'PNR892138',4,1195,12,8,'Confirmed',4,'2025-04-16'),(4,1006,12001,'PNR892138',4,1191,12,8,'RAC',4,'2025-04-16'),(4,1007,12001,'PNR892138',4,1192,12,8,'RAC',4,'2025-04-16'),(4,1008,12001,'PNR892138',4,1193,12,8,'RAC',4,'2025-04-16'),(4,1009,12001,'PNR892138',4,1194,12,8,'RAC',4,'2025-04-16'),(4,1010,12001,'PNR892138',4,1195,12,8,'RAC',4,'2025-04-16'),(4,1011,12001,'PNR892138',4,NULL,12,8,'Waiting',4,'2025-04-16'),(4,1012,12001,'PNR892138',4,NULL,12,8,'Waiting',4,'2025-04-16'),(5,1030,12019,'PNR093125',1,801,10,4,'Confirmed',5,'2025-04-14'),(5,1031,12019,'PNR093125',1,802,10,4,'Confirmed',5,'2025-04-14'),(5,1032,12019,'PNR093125',1,803,10,4,'Confirmed',5,'2025-04-14');
/*!40000 ALTER TABLE `ticket` ENABLE KEYS */;
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
