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

-- Dump completed on 2025-04-16  0:37:39
