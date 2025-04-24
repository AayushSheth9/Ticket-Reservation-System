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
-- Table structure for table `passengers`
--

DROP TABLE IF EXISTS `passengers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `passengers` (
  `Passenger_id` int NOT NULL,
  `Name` varchar(30) DEFAULT NULL,
  `Age` int DEFAULT NULL,
  `Gender` enum('Male','Female','Other') DEFAULT NULL,
  `Email` varchar(50) DEFAULT NULL,
  `Phone` varchar(15) DEFAULT NULL,
  `Category` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`Passenger_id`),
  UNIQUE KEY `Email` (`Email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `passengers`
--

LOCK TABLES `passengers` WRITE;
/*!40000 ALTER TABLE `passengers` DISABLE KEYS */;
INSERT INTO `passengers` VALUES (1001,'Rajesh Kumar',35,'Male','rajesh.kumar@gmail.com','9876543210',NULL),(1002,'Priya Sharma',28,'Female','priya.sharma@gmail.com','9876543211',NULL),(1003,'Amit Singh',42,'Male','amit.singh@gmail.com','9876543212',NULL),(1004,'Neha Patel',19,'Female','neha.patel@gmail.com','9876543213','Student'),(1005,'Suresh Verma',45,'Male','suresh.verma@gmail.com','9876543214',NULL),(1006,'Anita Desai',38,'Female','anita.desai@gmail.com','9876543215',NULL),(1007,'Rahul Gupta',27,'Male','rahul.gupta@gmail.com','9876543216',NULL),(1008,'Sunita Agarwal',33,'Female','sunita.agarwal@gmail.com','9876543217',NULL),(1009,'Vijay Reddy',50,'Male','vijay.reddy@gmail.com','9876543218','Disabled'),(1010,'Meena Iyer',29,'Female','meena.iyer@gmail.com','9876543219',NULL),(1011,'Kiran Joshi',36,'Male','kiran.joshi@gmail.com','9876543220',NULL),(1012,'Ritu Malhotra',22,'Female','ritu.malhotra@gmail.com','9876543221',NULL),(1013,'Sanjay Mehta',48,'Male','sanjay.mehta@gmail.com','9876543222',NULL),(1014,'Pooja Bansal',30,'Female','pooja.bansal@gmail.com','9876543223',NULL),(1015,'Deepak Choudhary',21,'Male','deepak.choudhary@gmail.com','9876543224',NULL),(1016,'Kavita Nair',26,'Female','kavita.nair@gmail.com','9876543225',NULL),(1017,'Rakesh Mishra',82,'Male','rakesh.mishra@gmail.com','9876543226','Senior Citizen'),(1018,'Anjali Saxena',34,'Female','anjali.saxena@gmail.com','9876543227',NULL),(1019,'Dinesh Yadav',39,'Male','dinesh.yadav@gmail.com','9876543228',NULL),(1020,'Seema Khanna',72,'Female','seema.khanna@gmail.com','9876543229','Senior Citizen'),(1021,'Mohan Lal',55,'Other','mohan.lal@gmail.com','9876543230',NULL),(1022,'Arti Kapoor',27,'Female','arti.kapoor@gmail.com','9876543231',NULL),(1023,'Shankar Pillai',43,'Male','shankar.pillai@gmail.com','9876543232',NULL),(1024,'Geeta Sharma',29,'Female','geeta.sharma@gmail.com','9876543233',NULL),(1025,'Prakash Tiwari',37,'Male','prakash.tiwari@gmail.com','9876543234',NULL),(1026,'Mamta Sinha',46,'Female','mamta.sinha@gmail.com','9876543235',NULL),(1027,'Nitin Chauhan',33,'Male','nitin.chauhan@gmail.com','9876543236',NULL),(1028,'Shweta Bhatia',28,'Other','shweta.bhatia@gmail.com','9876543237',NULL),(1029,'Ramesh Venkat',71,'Male','ramesh.venkat@gmail.com','9876543238','Senior Citizen'),(1030,'Usha Trivedi',30,'Female','usha.trivedi@gmail.com','9876543239',NULL),(1031,'Aryan Phad',11,'Male','mclovin6@iitp.ac.in','8329077294','Student'),(1032,'Sakshi Jadhav',12,'Female','sakshi@pict.ac.in','6995956864','Student');
/*!40000 ALTER TABLE `passengers` ENABLE KEYS */;
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
