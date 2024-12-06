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
-- Table structure for table `ge`
--

DROP TABLE IF EXISTS `ge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ge` (
  `courseID` varchar(15) NOT NULL,
  `courseName` varchar(200) DEFAULT NULL,
  `credits` int DEFAULT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `geArea` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`courseID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ge`
--

LOCK TABLES `ge` WRITE;
/*!40000 ALTER TABLE `ge` DISABLE KEYS */;
INSERT INTO `ge` VALUES ('AAS1','Introduction to Asian American Studies',3,'Introductory examination of Asian Pacific Islander Desi/Americans (APID/A) through U.S.-national and transnational frameworks, concerned with contests over the production of racial knowledge, power, and citizenship and belonging. Develops an account of racialization beyond the black-white binary in the context of US war and empire in Asia and the Pacific Islands, settler colonialism, globalization, migration, and popular culture. ','F'),('BIOL10','The Living World',3,'Provides students with an understanding of the most fundamental concepts of modern biology including ecology (the interaction between organisms and their environment), human inheritance, the structure and function of living organisms, evolution, strategies for survival and reproduction, and biotechnology.','B2'),('CCS30','Race and Ethnicity in Public Space',3,'This course focuses on race and ethnicity. Using readings, field trips, media images, and course discussion students learn about racialization in American society. We explore uses of racial and ethnic categories and their institutionalization in everyday life.','F'),('COMM20','Public Speaking',3,'Principles of rhetoric applied to oral communication; selecting, analyzing, adapting, organizing and delivering ideas effectively.','A1'),('COMM21','Performing Culture and Society',3,'Live performance is used as a method for exploring human behavior as it occurs within contemporary cultures and societies. Performance assignments will draw from among the following: performance of texts, street performance, personal narrative, oral history, everyday life, and social justice.','D'),('ENGL2','Critical Thinking and Writing',3,'Focuses on the relationship between language and logic in composing arguments. Students learn various methods of effective reasoning and appropriate rhetorical strategies to help them invent, demonstrate, and express arguments clearly, logically, and persuasively. ','A3'),('GEOL5','Sustainability, Human Development, and the Earth',3,'Introductory course examining the role and interaction of the natural world on the physiological, social, and psychological development of human beings within the context of the environmental, social, and academic community system.','E'),('LING21','Critical Thinking and Language',3,'Exploring systems of language and logic in oral and written discourse, with a focus on the role of shared cultural assumptions, language style and the media of presentation in shaping the form and content of argumentation.','A3'),('LSTP10','Chronicles of Education',3,'This course uses chronicles, or narratives, to expand traditional views about the sites where education takes place and to articulate the educational forces that shape individuals and societies.','C2'),('MATH12','Number Systems',3,'Structure of the real number system, numeration systems, elementary number theory, and problem-solving techniques; technology integrated throughout the course.  ','B4'),('MATH31','Calculus II',4,'Definite and indefinite integration with applications. Sequences and series. Graphical, algebraic and numerical methods of solving problems. ','B4'),('MUSC10A','Music Appreciation',3,'General survey of Western music focusing on recorded and live performances.','C1'),('MUSC10C','Pop and Rock in the U.S.',3,'Examines the musical attributes, structures, and stylistic choices in American popular music, as well as the historical and cultural underpinnings of the originating forces and influences and how they affect or are affected by social/cultural norms and political and economic developments.','C1'),('PHIL12','Human Nature and the Meaning of Life',3,'Survey of philosophical discussions of various topics related to the definition and understanding of human nature and the meaning of life, including questions such as: In what ways or to what degree (if any) are human beings unique among other forms of life? What is the role of desire in human nature? What is the nature of and/or limitations on human freedom? In what ways are freedom and moral responsibility linked? What is the Meaning of Life? ','E'),('PHYS1','Elementary Physics',3,'Mechanics, energy, electricity, magnetism, optics, atomic and nuclear physics, properties of matter; emphasizes practical applications of physics principles to contemporary problems. ','B1'),('PSYC1','Introduction to Psychology',3,'Psychology is the scientific study of behavior and mental processes. The content focuses on the exploration of major psychological theories and concepts, methods, and research findings in psychology. Topics include the biological bases of behavior, perception, cognition and consciousness, learning, memory, emotion, motivation, development, personality, social psychology, psychological disorders and therapeutic approaches to treatment, and applied psychology.','D'),('RECL10','Creating a Meaningful Life',3,'Study how a meaningful life relates to the freedom to pursue happiness. Examines personal, social, and cultural bases for a creative and successful lifestyle. Learn to recognize and foster creative potential for lifelong personal growth, meaningful rewards, and leisure enjoyment.','E');
/*!40000 ALTER TABLE `ge` ENABLE KEYS */;
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
