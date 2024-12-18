-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: localhost    Database: cs157ateam5
-- ------------------------------------------------------
-- Server version	9.0.1

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
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `studentID` int NOT NULL,
  `name` varchar(45) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  `password` varchar(45) DEFAULT NULL,
  `major_id` varchar(45) DEFAULT 'CS',
  PRIMARY KEY (`studentID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`studentID`, `name`, `email`, `password`, `major_id`) VALUES
(12, 'ss', 'ss@gmail.com', '012', 'CS'),
(777, 'Dazai', 'dazai@email.com', '120', 'CS'),
(5555, 'Chuuya', 'hat@pm.jp', 'Dazai!!!', 'CS'),
(6666, 'Akugatawa', 'chops@pm.jp', 'Dazai#1Fan!', 'CS'),
(8888, 'Mori', 'elisefan@pm.jp', 'Elise#1Fan', 'CS'),
(12345, 'user1', 'user1@gmail.com', '12345', 'CS'),
(23456, 'user2', 'user2@gmail.com', '23456', 'CS'),
(34567, 'user3', 'user3@gmail.com', '34567', 'CS'),
(45678, 'user4', 'user4@gmail.com', '45678', 'CS'),
(54321, 'user7', 'user7@gmail.com', '54321', 'CS'),
(56789, 'user5', 'user5@gmail.com', '56789', 'CS'),
(65432, 'user8', 'user8@gmail.com', '65432', 'CS'),
(67890, 'user6', 'user6@gmail.com', '67890', 'CS'),
(76543, 'user9', 'user9@gmail.com', '76543', 'CS'),
(15258126, 'Yongjun', 'abc@gmail.com', '123456', 'CS');

/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-12-05 22:09:43
