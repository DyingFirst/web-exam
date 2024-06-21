-- MySQL dump 10.13  Distrib 8.4.0, for Linux (x86_64)
--
-- Host: localhost    Database: baseWeb
-- ------------------------------------------------------
-- Server version	8.4.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `book_covers`
--

DROP TABLE IF EXISTS `book_covers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book_covers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `file_name` varchar(255) NOT NULL,
  `mime_type` varchar(255) NOT NULL,
  `md5_hash` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `md5_hash` (`md5_hash`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_covers`
--

LOCK TABLES `book_covers` WRITE;
/*!40000 ALTER TABLE `book_covers` DISABLE KEYS */;
INSERT INTO `book_covers` VALUES (2,'Notes_of_a_Dirty_Old_Man.jpg','image/jpeg','625af8fc0f0f867560e4b682941a9960'),(3,'cover1__w600.jpg','image/jpeg','f7dc3cf41424061b3b7825be39e17ab6'),(13,'Aleksandr_Dyuma__Graf_MonteKristo.jpeg','image/jpeg','af35ef000ea262f0d236305395eec0ca'),(16,'Dzhoan_Rouling__Garri_Potter_i_uznik_Azkabana.jpeg','image/jpeg','8e617e9ad6224f3fa648b5b07c57a9e5');
/*!40000 ALTER TABLE `book_covers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book_genres`
--

DROP TABLE IF EXISTS `book_genres`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book_genres` (
  `book_id` int NOT NULL,
  `genre_id` int NOT NULL,
  PRIMARY KEY (`book_id`,`genre_id`),
  KEY `genre_id` (`genre_id`),
  CONSTRAINT `book_genres_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`),
  CONSTRAINT `book_genres_ibfk_2` FOREIGN KEY (`genre_id`) REFERENCES `genres` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_genres`
--

LOCK TABLES `book_genres` WRITE;
/*!40000 ALTER TABLE `book_genres` DISABLE KEYS */;
INSERT INTO `book_genres` VALUES (16,1),(2,2),(12,2),(16,2),(2,3),(16,5);
/*!40000 ALTER TABLE `book_genres` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `books`
--

DROP TABLE IF EXISTS `books`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `books` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `short_description` text NOT NULL,
  `year` smallint NOT NULL,
  `publisher` varchar(255) NOT NULL,
  `author` varchar(255) NOT NULL,
  `page_count` int NOT NULL,
  `cover_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `cover_id` (`cover_id`),
  CONSTRAINT `books_ibfk_1` FOREIGN KEY (`cover_id`) REFERENCES `book_covers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books`
--

LOCK TABLES `books` WRITE;
/*!40000 ALTER TABLE `books` DISABLE KEYS */;
INSERT INTO `books` VALUES (2,'Записки старого козл','Сборник кортких автобиографических расказов ',1998,'АСТ','Чарльз Буковски',312,2),(3,'415 градусов по фарингейту','ю',1986,'Яркие Страницы','Рей Бредбери',282,3),(12,'Test','&lt;script&gt;RTE&lt;/script&gt;\n',2022,'Test','Test',202,13),(16,'SKFD','dfdfds&lt;script&gt;SQL INJECTION&lt;/script&gt;',2024,'DFsdf','Gena',202,16);
/*!40000 ALTER TABLE `books` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `genres`
--

DROP TABLE IF EXISTS `genres`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genres` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genres`
--

LOCK TABLES `genres` WRITE;
/*!40000 ALTER TABLE `genres` DISABLE KEYS */;
INSERT INTO `genres` VALUES (5,'Детектив'),(3,'Драма'),(4,'Приключения'),(2,'Роман'),(1,'Фантастика');
/*!40000 ALTER TABLE `genres` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviews` (
  `id` int NOT NULL AUTO_INCREMENT,
  `book_id` int NOT NULL,
  `user_id` int NOT NULL,
  `rating` int NOT NULL,
  `text` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `book_id` (`book_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`) ON DELETE CASCADE,
  CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `chk_rating` CHECK ((`rating` between 0 and 5))
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
INSERT INTO `reviews` VALUES (14,2,1,5,'&lt;script&gt;HOHOHO&lt;/script&gt;','2024-06-20 22:13:20'),(15,16,1,5,'Nice','2024-06-21 01:26:12');
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'administrator','суперпользователь, имеет полный доступ к системе, в том числе к созданию и удалению книг'),(2,'moderator','может редактировать данные книг и производить модерацию рецензий'),(3,'user','может оставлять рецензии'),(4,'anonymous','может просматривать книги ');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `login` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `first_name` varchar(255) NOT NULL,
  `middle_name` varchar(255) DEFAULT NULL,
  `role_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `login` (`login`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918','Петров','Иван','Сергеевич',1),(2,'moder','b465361ffa25886d97c693b209bd347e600d1b14d397a8e42b7b7c408f32f0a9','Сидоров','Петр','Александрович',2),(3,'user1','0a041b9462caa4a31bac3567e0b6e6fd9100787db2ab433d96f6d178cabfce90','Ванин','Артем','Викторович',3),(4,'user2','6025d18fe48abd45168528f18a82e265dd98d421a7084aa09f61b341703901a3','Кузнецов','Алексей',NULL,3),(5,'anonymous','0\n','anonymous','anonymous','anonymous',4);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `views`
--

DROP TABLE IF EXISTS `views`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `views` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `book_id` int DEFAULT NULL,
  `view_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `book_id` (`book_id`),
  CONSTRAINT `views_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `views_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `views`
--

LOCK TABLES `views` WRITE;
/*!40000 ALTER TABLE `views` DISABLE KEYS */;
INSERT INTO `views` VALUES (3,1,2,'2024-06-12 14:50:48'),(4,1,3,'2024-06-12 14:50:49'),(9,1,12,'2024-06-20 21:22:50'),(13,1,12,'2024-06-21 00:43:16'),(14,1,2,'2024-06-21 01:13:02'),(15,1,3,'2024-06-21 01:14:53'),(16,3,12,'2024-06-21 02:29:13'),(17,3,3,'2024-06-21 02:29:20'),(18,2,12,'2024-06-21 02:48:49'),(19,1,16,'2024-06-21 04:26:02');
/*!40000 ALTER TABLE `views` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `visit_logs`
--

DROP TABLE IF EXISTS `visit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `visit_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `path` varchar(255) NOT NULL,
  `user_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `visit_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=529 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `visit_logs`
--

LOCK TABLES `visit_logs` WRITE;
/*!40000 ALTER TABLE `visit_logs` DISABLE KEYS */;
INSERT INTO `visit_logs` VALUES (1,'/',NULL,'2024-06-12 16:52:53'),(2,'/books/most_popular',NULL,'2024-06-12 16:52:55'),(3,'/books/add',NULL,'2024-06-12 16:52:56'),(4,'/login',NULL,'2024-06-12 16:52:56'),(5,'/login',NULL,'2024-06-12 16:52:58'),(6,'/login',NULL,'2024-06-12 16:53:00'),(7,'/',1,'2024-06-12 16:53:00'),(8,'/books/most_popular',1,'2024-06-12 16:53:02'),(9,'/',1,'2024-06-12 16:53:04'),(10,'/',NULL,'2024-06-12 17:02:11'),(11,'/books/most_popular',NULL,'2024-06-12 17:02:13'),(12,'/',NULL,'2024-06-12 17:02:15'),(13,'/login',NULL,'2024-06-12 17:02:22'),(14,'/login',NULL,'2024-06-12 17:02:26'),(15,'/',1,'2024-06-12 17:02:26'),(16,'/books/most_popular',1,'2024-06-12 17:02:28'),(17,'/',1,'2024-06-12 17:02:29'),(18,'/books/delete/9',1,'2024-06-12 17:03:12'),(19,'/',1,'2024-06-12 17:03:12'),(20,'/',1,'2024-06-12 17:03:13'),(21,'/',1,'2024-06-12 17:03:14'),(22,'/books/delete/8',1,'2024-06-12 17:03:17'),(23,'/',1,'2024-06-12 17:03:17'),(24,'/',1,'2024-06-12 17:05:59'),(25,'/books/view/5',1,'2024-06-12 17:06:41'),(26,'/',1,'2024-06-12 17:07:10'),(27,'/books/edit/2',1,'2024-06-12 17:12:24'),(28,'/',1,'2024-06-12 17:15:56'),(29,'/',1,'2024-06-12 17:16:35'),(30,'/',1,'2024-06-12 17:16:36'),(31,'/books/view/5',1,'2024-06-12 17:17:31'),(32,'/books/review/5',1,'2024-06-12 17:17:40'),(33,'/books/review/5',1,'2024-06-12 17:17:56'),(34,'/books/view/5',1,'2024-06-12 17:17:56'),(35,'/books/view/5',1,'2024-06-12 17:19:05'),(36,'/books/view/5',1,'2024-06-12 17:19:06'),(37,'/books/view/5',1,'2024-06-12 17:19:06'),(38,'/books/view/5',1,'2024-06-12 17:19:06'),(39,'/books/view/5',1,'2024-06-12 17:19:06'),(40,'/books/view/5',1,'2024-06-12 17:19:06'),(41,'/books/view/5',1,'2024-06-12 17:19:07'),(42,'/books/view/5',1,'2024-06-12 17:19:07'),(43,'/',1,'2024-06-12 17:19:08'),(44,'/books/view/6',1,'2024-06-12 17:19:09'),(45,'/books/most_popular',1,'2024-06-12 17:19:10'),(46,'/',1,'2024-06-12 17:19:14'),(47,'/',1,'2024-06-12 17:19:16'),(48,'/',1,'2024-06-12 17:19:16'),(49,'/books/most_popular',1,'2024-06-12 17:19:17'),(50,'/',1,'2024-06-12 17:19:18'),(51,'/logout',1,'2024-06-12 17:23:48'),(52,'/',NULL,'2024-06-12 17:23:48'),(53,'/favicon.ico',NULL,'2024-06-12 17:23:48'),(54,'/login',NULL,'2024-06-12 17:23:49'),(55,'/login',NULL,'2024-06-12 17:23:53'),(56,'/',2,'2024-06-12 17:23:53'),(57,'/logout',2,'2024-06-12 17:24:05'),(58,'/',NULL,'2024-06-12 17:24:06'),(59,'/login',NULL,'2024-06-12 17:24:06'),(60,'/login',NULL,'2024-06-12 17:24:09'),(61,'/',3,'2024-06-12 17:24:09'),(62,'/',3,'2024-06-12 17:49:04'),(63,'/books/most_popular',3,'2024-06-12 17:49:05'),(64,'/',1,'2024-06-20 13:09:46'),(65,'/',NULL,'2024-06-20 13:39:14'),(66,'/',1,'2024-06-20 14:25:28'),(67,'/',1,'2024-06-20 14:25:28'),(68,'/',1,'2024-06-20 14:25:28'),(69,'/',1,'2024-06-20 14:25:28'),(70,'/',1,'2024-06-20 14:25:33'),(71,'/',NULL,'2024-06-20 14:26:55'),(72,'/',NULL,'2024-06-20 14:26:55'),(73,'/favicon.ico',NULL,'2024-06-20 14:26:56'),(74,'/books/view/6',NULL,'2024-06-20 14:27:29'),(75,'/',NULL,'2024-06-20 14:27:31'),(76,'/books/add',NULL,'2024-06-20 14:27:32'),(77,'/login',NULL,'2024-06-20 14:27:32'),(78,'/books/most_popular',NULL,'2024-06-20 14:27:35'),(79,'/robots.txt',NULL,'2024-06-20 14:27:35'),(80,'/',NULL,'2024-06-20 14:27:35'),(81,'/login',NULL,'2024-06-20 14:27:37'),(82,'/books/add',NULL,'2024-06-20 14:27:38'),(83,'/login',NULL,'2024-06-20 14:27:38'),(84,'/login',NULL,'2024-06-20 14:27:41'),(85,'/books/most_popular',NULL,'2024-06-20 14:27:42'),(86,'/',NULL,'2024-06-20 14:27:48'),(87,'/books/add',NULL,'2024-06-20 14:28:23'),(88,'/login',NULL,'2024-06-20 14:28:23'),(89,'/',NULL,'2024-06-20 14:28:25'),(90,'/login',NULL,'2024-06-20 14:28:26'),(91,'/login',NULL,'2024-06-20 14:28:31'),(92,'/',1,'2024-06-20 14:28:31'),(93,'/books/add',1,'2024-06-20 14:28:36'),(94,'/books/add',1,'2024-06-20 14:28:55'),(95,'/',1,'2024-06-20 14:28:55'),(96,'/books/view/10',1,'2024-06-20 14:29:17'),(97,'/books/review/10',1,'2024-06-20 14:29:19'),(98,'/books/review/10',1,'2024-06-20 14:29:26'),(99,'/books/view/10',1,'2024-06-20 14:29:26'),(100,'/books/review/10',1,'2024-06-20 14:29:29'),(101,'/books/review/10',1,'2024-06-20 14:29:31'),(102,'/books/view/10',1,'2024-06-20 14:29:31'),(103,'/',1,'2024-06-20 14:29:44'),(104,'/books/delete/10',1,'2024-06-20 14:33:00'),(105,'/',1,'2024-06-20 14:33:00'),(106,'/books/delete/10',1,'2024-06-20 14:33:04'),(107,'/',1,'2024-06-20 14:33:04'),(108,'/books/edit/6',1,'2024-06-20 14:33:15'),(109,'/logout',1,'2024-06-20 14:33:19'),(110,'/',NULL,'2024-06-20 14:33:19'),(111,'/books/edit/6',NULL,'2024-06-20 14:33:20'),(112,'/login',NULL,'2024-06-20 14:33:20'),(113,'/login',NULL,'2024-06-20 14:33:29'),(114,'/books/edit/6',3,'2024-06-20 14:33:29'),(115,'/login',3,'2024-06-20 14:33:32'),(116,'/login',3,'2024-06-20 14:33:38'),(117,'/books/edit/6',4,'2024-06-20 14:33:38'),(118,'/login',4,'2024-06-20 14:33:40'),(119,'/login',4,'2024-06-20 14:33:44'),(120,'/login',4,'2024-06-20 14:33:51'),(121,'/',2,'2024-06-20 14:33:51'),(122,'/books/most_popular',2,'2024-06-20 14:33:57'),(123,'/books/add',2,'2024-06-20 14:33:57'),(124,'/books/add',2,'2024-06-20 14:34:02'),(125,'/',2,'2024-06-20 14:34:07'),(126,'/logout',2,'2024-06-20 14:34:09'),(127,'/',NULL,'2024-06-20 14:34:09'),(128,'/login',NULL,'2024-06-20 14:34:12'),(129,'/login',NULL,'2024-06-20 14:34:21'),(130,'/',3,'2024-06-20 14:34:21'),(131,'/books/add',3,'2024-06-20 14:34:22'),(132,'/',3,'2024-06-20 14:34:24'),(133,'/books/most_popular',3,'2024-06-20 14:35:10'),(134,'/books/add',3,'2024-06-20 14:35:12'),(135,'/logout',3,'2024-06-20 14:35:48'),(136,'/',NULL,'2024-06-20 14:35:48'),(137,'/books/most_popular',NULL,'2024-06-20 14:35:49'),(138,'/login',NULL,'2024-06-20 14:35:50'),(139,'/login',NULL,'2024-06-20 14:35:53'),(140,'/',1,'2024-06-20 14:35:53'),(141,'/',1,'2024-06-20 14:35:55'),(142,'/books/most_popular',1,'2024-06-20 14:35:56'),(143,'/',1,'2024-06-20 14:56:04'),(144,'/books/add',1,'2024-06-20 14:56:06'),(145,'/books/add',1,'2024-06-20 14:58:09'),(146,'/',1,'2024-06-20 14:58:09'),(147,'/books/delete/11',1,'2024-06-20 14:58:17'),(148,'/',1,'2024-06-20 14:58:17'),(149,'/',1,'2024-06-20 14:58:24'),(150,'/',1,'2024-06-20 14:58:25'),(151,'/',1,'2024-06-20 14:58:25'),(152,'/robots.txt',1,'2024-06-20 15:00:13'),(153,'/',NULL,'2024-06-20 18:02:39'),(154,'/favicon.ico',NULL,'2024-06-20 18:02:42'),(155,'/books/add',NULL,'2024-06-20 18:02:56'),(156,'/login',NULL,'2024-06-20 18:02:58'),(157,'/login',NULL,'2024-06-20 18:03:24'),(158,'/books/add',1,'2024-06-20 18:03:26'),(159,'/',1,'2024-06-20 18:03:32'),(160,'/',1,'2024-06-20 18:03:47'),(161,'/',1,'2024-06-20 18:03:52'),(162,'/',1,'2024-06-20 18:03:59'),(163,'/',1,'2024-06-20 18:04:03'),(164,'/',1,'2024-06-20 18:18:28'),(165,'/books/view/6',1,'2024-06-20 18:18:32'),(166,'/books/review/6',1,'2024-06-20 18:18:46'),(167,'/books/review/6',1,'2024-06-20 18:19:06'),(168,'/books/view/6',1,'2024-06-20 18:19:08'),(169,'/books/view/6',1,'2024-06-20 18:21:32'),(170,'/',1,'2024-06-20 18:21:37'),(171,'/books/add',1,'2024-06-20 18:21:39'),(172,'/books/add',1,'2024-06-20 18:22:42'),(173,'/',1,'2024-06-20 18:22:44'),(174,'/books/view/12',1,'2024-06-20 18:22:51'),(175,'/books/most_popular',1,'2024-06-20 18:23:39'),(176,'/',1,'2024-06-20 18:23:56'),(177,'/books/add',1,'2024-06-20 19:40:17'),(178,'/logout',1,'2024-06-20 19:40:21'),(179,'/',NULL,'2024-06-20 19:40:22'),(180,'/books/add',NULL,'2024-06-20 19:40:27'),(181,'/login',NULL,'2024-06-20 19:40:28'),(182,'/login',NULL,'2024-06-20 19:40:57'),(183,'/books/add',2,'2024-06-20 19:40:58'),(184,'/',2,'2024-06-20 19:42:26'),(185,'/books/add',2,'2024-06-20 19:42:32'),(186,'/books/add',2,'2024-06-20 19:46:40'),(187,'/',2,'2024-06-20 19:46:41'),(188,'/books/add',2,'2024-06-20 19:46:58'),(189,'/',2,'2024-06-20 19:46:59'),(190,'/logout',2,'2024-06-20 19:52:53'),(191,'/',NULL,'2024-06-20 19:52:54'),(192,'/login',NULL,'2024-06-20 19:52:58'),(193,'/login',NULL,'2024-06-20 19:53:02'),(194,'/',NULL,'2024-06-20 19:53:08'),(195,'/books/view/6',NULL,'2024-06-20 19:53:13'),(196,'/',NULL,'2024-06-20 19:53:18'),(197,'/books/add',NULL,'2024-06-20 20:00:20'),(198,'/login',NULL,'2024-06-20 20:00:21'),(199,'/login',NULL,'2024-06-20 20:00:24'),(200,'/books/add',1,'2024-06-20 20:00:26'),(201,'/books/add',1,'2024-06-20 20:00:55'),(202,'/',1,'2024-06-20 20:00:57'),(203,'/books/delete/13',1,'2024-06-20 20:01:04'),(204,'/',1,'2024-06-20 20:01:07'),(205,'/',1,'2024-06-20 20:01:11'),(206,'/',1,'2024-06-20 20:08:13'),(207,'/books/add',1,'2024-06-20 20:08:17'),(208,'/books/add',1,'2024-06-20 20:11:25'),(209,'/',1,'2024-06-20 20:11:30'),(210,'/books/edit/6',1,'2024-06-20 20:11:36'),(211,'/books/edit/6',1,'2024-06-20 20:13:52'),(212,'/',1,'2024-06-20 20:13:54'),(213,'/books/edit/6',1,'2024-06-20 20:14:05'),(214,'/books/edit/6',1,'2024-06-20 20:14:15'),(215,'/',1,'2024-06-20 20:14:17'),(216,'/books/edit/6',1,'2024-06-20 20:14:22'),(217,'/books/edit/6',1,'2024-06-20 20:14:29'),(218,'/',1,'2024-06-20 20:14:31'),(219,'/books/edit/6',1,'2024-06-20 20:14:46'),(220,'/books/edit/6',1,'2024-06-20 20:14:52'),(221,'/',1,'2024-06-20 20:14:55'),(222,'/books/add',1,'2024-06-20 20:15:43'),(223,'/books/add',1,'2024-06-20 20:16:17'),(224,'/',1,'2024-06-20 20:16:20'),(225,'/books/edit/14',1,'2024-06-20 20:16:27'),(226,'/logout',1,'2024-06-20 20:16:35'),(227,'/',NULL,'2024-06-20 20:16:37'),(228,'/login',NULL,'2024-06-20 20:18:05'),(229,'/login',NULL,'2024-06-20 20:18:15'),(230,'/',NULL,'2024-06-20 20:18:32'),(231,'/books/view/14',NULL,'2024-06-20 20:18:36'),(232,'/login',NULL,'2024-06-20 20:18:43'),(233,'/login',NULL,'2024-06-20 20:20:25'),(234,'/login',NULL,'2024-06-20 20:20:36'),(235,'/login',NULL,'2024-06-20 20:20:51'),(236,'/',3,'2024-06-20 20:20:53'),(237,'/books/edit/14',3,'2024-06-20 20:21:51'),(238,'/',3,'2024-06-20 20:21:53'),(239,'/books/view/10',3,'2024-06-20 20:23:06'),(240,'/',3,'2024-06-20 20:26:36'),(241,'/books/delete/10',3,'2024-06-20 20:27:20'),(242,'/',3,'2024-06-20 20:28:13'),(243,'/logout',3,'2024-06-20 20:28:17'),(244,'/',NULL,'2024-06-20 20:28:19'),(245,'/login',NULL,'2024-06-20 20:28:23'),(246,'/login',NULL,'2024-06-20 20:28:29'),(247,'/',1,'2024-06-20 20:28:30'),(248,'/books/delete/10',1,'2024-06-20 20:28:36'),(249,'/',1,'2024-06-20 20:28:39'),(250,'/',1,'2024-06-20 20:29:54'),(251,'/books/delete/10',1,'2024-06-20 20:29:59'),(252,'/',1,'2024-06-20 20:30:02'),(253,'/books/delete/14',1,'2024-06-20 20:31:00'),(254,'/',1,'2024-06-20 20:31:03'),(255,'/books/delete/3',1,'2024-06-20 20:33:48'),(256,'/',1,'2024-06-20 20:33:51'),(257,'/',1,'2024-06-20 20:38:33'),(258,'/books/delete/6',1,'2024-06-20 20:38:51'),(259,'/',1,'2024-06-20 20:38:53'),(260,'/books/delete/6',1,'2024-06-20 20:40:14'),(261,'/',1,'2024-06-20 20:40:16'),(262,'/',1,'2024-06-20 20:43:30'),(263,'/books/delete/6',1,'2024-06-20 20:43:36'),(264,'/',1,'2024-06-20 20:43:38'),(265,'/books/delete/5',1,'2024-06-20 20:43:45'),(266,'/',1,'2024-06-20 20:43:47'),(267,'/',1,'2024-06-20 20:43:53'),(268,'/',1,'2024-06-20 20:48:58'),(269,'/books/delete/5',1,'2024-06-20 20:49:06'),(270,'/',1,'2024-06-20 20:49:08'),(271,'/books/view/4',1,'2024-06-20 20:49:17'),(272,'/books/review/4',1,'2024-06-20 20:49:21'),(273,'/books/review/4',1,'2024-06-20 20:49:29'),(274,'/books/view/4',1,'2024-06-20 20:49:30'),(275,'/',1,'2024-06-20 20:49:47'),(276,'/books/view/4',1,'2024-06-20 20:50:00'),(277,'/',1,'2024-06-20 20:50:05'),(278,'/books/delete/4',1,'2024-06-20 20:50:10'),(279,'/',1,'2024-06-20 20:50:13'),(280,'/books/add',1,'2024-06-20 20:50:20'),(281,'/books/add',1,'2024-06-20 20:50:44'),(282,'/',1,'2024-06-20 20:50:47'),(283,'/books/view/15',1,'2024-06-20 20:50:56'),(284,'/books/review/15',1,'2024-06-20 20:51:00'),(285,'/books/review/15',1,'2024-06-20 20:51:21'),(286,'/books/view/15',1,'2024-06-20 20:51:23'),(287,'/',1,'2024-06-20 20:51:28'),(288,'/books/delete/15',1,'2024-06-20 20:51:34'),(289,'/',1,'2024-06-20 20:51:36'),(290,'/books/edit/6',1,'2024-06-20 20:57:05'),(291,'/',1,'2024-06-20 20:57:10'),(292,'/books/delete/10',1,'2024-06-20 20:57:19'),(293,'/',1,'2024-06-20 20:57:22'),(294,'/books/edit/13',1,'2024-06-20 20:57:58'),(295,'/books/edit',1,'2024-06-20 21:00:17'),(296,'/',1,'2024-06-20 21:00:22'),(297,'/books/edit/2',1,'2024-06-20 21:00:26'),(298,'/books/edit/2',1,'2024-06-20 21:00:34'),(299,'/',1,'2024-06-20 21:00:37'),(300,'/books/edit/12',1,'2024-06-20 21:02:21'),(301,'/books/edit/12',1,'2024-06-20 21:06:28'),(302,'/books/edit/12',1,'2024-06-20 21:23:04'),(303,'/books/edit/12',1,'2024-06-20 21:24:22'),(304,'/books/edit/12',1,'2024-06-20 21:24:51'),(305,'/books/edit/12',1,'2024-06-20 21:25:11'),(306,'/books/edit/12',1,'2024-06-20 21:25:56'),(307,'/books/edit/12',1,'2024-06-20 21:27:01'),(308,'/books/edit/12',1,'2024-06-20 21:28:20'),(309,'/books/edit/12',1,'2024-06-20 21:29:14'),(310,'/books/edit/12',1,'2024-06-20 21:29:43'),(311,'/books/edit/12',1,'2024-06-20 21:30:39'),(312,'/books/edit/12',1,'2024-06-20 21:31:06'),(313,'/books/edit/12',1,'2024-06-20 21:31:35'),(314,'/books/edit/12',1,'2024-06-20 21:31:49'),(315,'/books/edit/12',1,'2024-06-20 21:32:14'),(316,'/books/edit/12',1,'2024-06-20 21:34:22'),(317,'/books/edit/12',1,'2024-06-20 21:35:04'),(318,'/books/edit/12',1,'2024-06-20 21:36:41'),(319,'/books/edit/12',1,'2024-06-20 21:37:31'),(320,'/books/edit/12',1,'2024-06-20 21:38:29'),(321,'/books/edit/12',1,'2024-06-20 21:40:02'),(322,'/',NULL,'2024-06-20 21:40:23'),(323,'/books/edit/12',1,'2024-06-20 21:40:38'),(324,'/',1,'2024-06-20 21:40:39'),(325,'/books/edit/2',1,'2024-06-20 21:40:44'),(326,'/',1,'2024-06-20 21:40:50'),(327,'/books/edit/3',1,'2024-06-20 21:40:54'),(328,'/books/edit/2',1,'2024-06-20 21:41:46'),(329,'/books/edit/12',1,'2024-06-20 21:41:51'),(330,'/books/edit/12',1,'2024-06-20 21:42:21'),(331,'/',1,'2024-06-20 21:42:22'),(332,'/books/edit/12',1,'2024-06-20 21:42:25'),(333,'/',1,'2024-06-20 21:42:30'),(334,'/books/view/12',1,'2024-06-20 21:42:32'),(335,'/books/view/12',1,'2024-06-20 21:42:55'),(336,'/books/view/12',1,'2024-06-20 21:43:18'),(337,'/',1,'2024-06-20 21:43:32'),(338,'/books/edit/12',1,'2024-06-20 21:43:35'),(339,'/',1,'2024-06-20 21:45:12'),(340,'/books/view/12',1,'2024-06-20 21:45:15'),(341,'/books/view/12',1,'2024-06-20 21:47:38'),(342,'/',1,'2024-06-20 21:47:40'),(343,'/books/edit/12',1,'2024-06-20 21:47:43'),(344,'/books/edit/12',1,'2024-06-20 21:48:03'),(345,'/',1,'2024-06-20 21:48:04'),(346,'/books/edit/12',1,'2024-06-20 21:48:07'),(347,'/',1,'2024-06-20 21:48:12'),(348,'/books/view/12',1,'2024-06-20 21:48:14'),(349,'/books/edit/12',1,'2024-06-20 21:48:20'),(350,'/books/edit/12',1,'2024-06-20 21:49:30'),(351,'/books/edit/12',1,'2024-06-20 21:49:55'),(352,'/',1,'2024-06-20 21:49:56'),(353,'/books/view/12',1,'2024-06-20 21:49:59'),(354,'/',1,'2024-06-20 21:50:03'),(355,'/books/edit/12',1,'2024-06-20 21:50:05'),(356,'/books/edit/12',1,'2024-06-20 21:51:57'),(357,'/books/edit/12',1,'2024-06-20 21:52:59'),(358,'/',1,'2024-06-20 21:53:07'),(359,'/books/edit/12',1,'2024-06-20 21:53:10'),(360,'/',1,'2024-06-20 21:53:14'),(361,'/books/view/12',1,'2024-06-20 21:53:17'),(362,'/',1,'2024-06-20 21:54:16'),(363,'/books/edit/12',1,'2024-06-20 21:54:19'),(364,'/',1,'2024-06-20 21:54:32'),(365,'/books/add',1,'2024-06-20 21:58:04'),(366,'/logout',1,'2024-06-20 21:59:58'),(367,'/',NULL,'2024-06-20 21:59:59'),(368,'/books/add',NULL,'2024-06-20 22:00:10'),(369,'/login',NULL,'2024-06-20 22:00:10'),(370,'/login',NULL,'2024-06-20 22:00:17'),(371,'/books/add',3,'2024-06-20 22:00:18'),(372,'/books/add',3,'2024-06-20 22:00:31'),(373,'/',3,'2024-06-20 22:00:32'),(374,'/books/add',3,'2024-06-20 22:00:48'),(375,'/',3,'2024-06-20 22:00:49'),(376,'/books/edit/12',3,'2024-06-20 22:02:36'),(377,'/',3,'2024-06-20 22:02:37'),(378,'/books/edit/100',3,'2024-06-20 22:02:49'),(379,'/',3,'2024-06-20 22:02:50'),(380,'/logout',3,'2024-06-20 22:02:53'),(381,'/',NULL,'2024-06-20 22:02:54'),(382,'/login',NULL,'2024-06-20 22:02:56'),(383,'/login',NULL,'2024-06-20 22:02:59'),(384,'/',1,'2024-06-20 22:03:00'),(385,'/books/edit/100',1,'2024-06-20 22:03:06'),(386,'/',1,'2024-06-20 22:06:09'),(387,'/logout',1,'2024-06-20 22:06:16'),(388,'/',NULL,'2024-06-20 22:06:16'),(389,'/',NULL,'2024-06-20 22:08:27'),(390,'/login',NULL,'2024-06-20 22:08:30'),(391,'/login',NULL,'2024-06-20 22:08:37'),(392,'/',3,'2024-06-20 22:08:38'),(393,'/logout',3,'2024-06-20 22:08:40'),(394,'/',NULL,'2024-06-20 22:08:41'),(395,'/login',NULL,'2024-06-20 22:08:45'),(396,'/login',NULL,'2024-06-20 22:08:53'),(397,'/',2,'2024-06-20 22:08:54'),(398,'/logout',2,'2024-06-20 22:08:57'),(399,'/',NULL,'2024-06-20 22:08:58'),(400,'/login',NULL,'2024-06-20 22:09:01'),(401,'/login',NULL,'2024-06-20 22:09:06'),(402,'/',1,'2024-06-20 22:09:07'),(403,'/books/edit/2',1,'2024-06-20 22:12:55'),(404,'/',1,'2024-06-20 22:12:59'),(405,'/books/view/2',1,'2024-06-20 22:13:03'),(406,'/books/review/2',1,'2024-06-20 22:13:06'),(407,'/books/review/2',1,'2024-06-20 22:13:20'),(408,'/books/view/2',1,'2024-06-20 22:13:21'),(409,'/books/most_popular',1,'2024-06-20 22:14:44'),(410,'/books/view/3',1,'2024-06-20 22:14:54'),(411,'/books/view/3',1,'2024-06-20 22:14:59'),(412,'/',1,'2024-06-20 22:15:01'),(413,'/books/view/3',1,'2024-06-20 22:15:04'),(414,'/',1,'2024-06-20 22:15:07'),(415,'/books/most_popular',1,'2024-06-20 22:15:09'),(416,'/books/most_popular',1,'2024-06-20 22:32:02'),(417,'/stats',1,'2024-06-20 22:32:05'),(418,'/',1,'2024-06-20 23:20:09'),(419,'/stats',1,'2024-06-20 23:20:12'),(420,'/stats',1,'2024-06-20 23:20:16'),(421,'/stats',1,'2024-06-20 23:20:19'),(422,'/stats',1,'2024-06-20 23:21:05'),(423,'/stats',1,'2024-06-20 23:22:21'),(424,'/stats',1,'2024-06-20 23:23:19'),(425,'/stats',1,'2024-06-20 23:23:30'),(426,'/stats',1,'2024-06-20 23:23:33'),(427,'/stats',1,'2024-06-20 23:23:36'),(428,'/stats',1,'2024-06-20 23:23:38'),(429,'/stats',1,'2024-06-20 23:23:40'),(430,'/stats',1,'2024-06-20 23:23:43'),(431,'/stats',1,'2024-06-20 23:24:37'),(432,'/stats',1,'2024-06-20 23:25:59'),(433,'/stats',1,'2024-06-20 23:26:03'),(434,'/stats',1,'2024-06-20 23:27:59'),(435,'/stats',1,'2024-06-20 23:28:03'),(436,'/logout',1,'2024-06-20 23:28:31'),(437,'/',NULL,'2024-06-20 23:28:32'),(438,'/books/view/2',NULL,'2024-06-20 23:28:35'),(439,'/login',NULL,'2024-06-20 23:28:39'),(440,'/login',NULL,'2024-06-20 23:28:42'),(441,'/',1,'2024-06-20 23:28:43'),(442,'/stats',1,'2024-06-20 23:28:45'),(443,'/stats',1,'2024-06-20 23:28:50'),(444,'/stats',1,'2024-06-20 23:28:52'),(445,'/logout',1,'2024-06-20 23:28:58'),(446,'/',NULL,'2024-06-20 23:28:58'),(447,'/login',NULL,'2024-06-20 23:29:04'),(448,'/login',NULL,'2024-06-20 23:29:11'),(449,'/',3,'2024-06-20 23:29:12'),(450,'/books/view/12',3,'2024-06-20 23:29:15'),(451,'/',3,'2024-06-20 23:29:19'),(452,'/books/view/3',3,'2024-06-20 23:29:21'),(453,'/logout',3,'2024-06-20 23:29:25'),(454,'/',NULL,'2024-06-20 23:29:26'),(455,'/login',NULL,'2024-06-20 23:29:29'),(456,'/login',NULL,'2024-06-20 23:29:34'),(457,'/',1,'2024-06-20 23:29:35'),(458,'/stats',1,'2024-06-20 23:29:39'),(459,'/stats',1,'2024-06-20 23:33:46'),(460,'/stats',1,'2024-06-20 23:35:09'),(461,'/stats',1,'2024-06-20 23:35:20'),(462,'/stats',1,'2024-06-20 23:35:24'),(463,'/stats',1,'2024-06-20 23:35:46'),(464,'/stats',1,'2024-06-20 23:35:49'),(465,'/stats',1,'2024-06-20 23:36:48'),(466,'/stats',1,'2024-06-20 23:36:51'),(467,'/logout',1,'2024-06-20 23:48:15'),(468,'/',NULL,'2024-06-20 23:48:15'),(469,'/login',NULL,'2024-06-20 23:48:19'),(470,'/login',NULL,'2024-06-20 23:48:28'),(471,'/',2,'2024-06-20 23:48:29'),(472,'/books/view/12',2,'2024-06-20 23:48:50'),(473,'/books/view/12',2,'2024-06-20 23:49:00'),(474,'/',2,'2024-06-20 23:49:10'),(475,'/books/view/12',2,'2024-06-20 23:49:12'),(476,'/',2,'2024-06-20 23:49:20'),(477,'/books/view/12',2,'2024-06-20 23:49:23'),(478,'/',2,'2024-06-20 23:56:14'),(479,'/books/last_viewed',2,'2024-06-20 23:56:15'),(480,'/',2,'2024-06-20 23:58:07'),(481,'/',2,'2024-06-21 00:00:25'),(482,'/',2,'2024-06-21 00:02:38'),(483,'/books/edit/3',2,'2024-06-21 00:02:46'),(484,'/books/edit/3',2,'2024-06-21 00:04:07'),(485,'/',2,'2024-06-21 00:05:12'),(486,'/books/edit/3',2,'2024-06-21 00:05:22'),(487,'/',2,'2024-06-21 00:05:27'),(488,'/logout',2,'2024-06-21 00:49:25'),(489,'/',NULL,'2024-06-21 00:49:26'),(490,'/login',NULL,'2024-06-21 00:49:28'),(491,'/login',NULL,'2024-06-21 00:49:34'),(492,'/',1,'2024-06-21 00:49:35'),(493,'/stats',1,'2024-06-21 00:49:38'),(494,'/stats',1,'2024-06-21 00:50:04'),(495,'/stats',1,'2024-06-21 00:50:22'),(496,'/stats',1,'2024-06-21 00:50:45'),(497,'/stats',1,'2024-06-21 00:52:22'),(498,'/stats',1,'2024-06-21 01:10:41'),(499,'/export_user_log_csv',1,'2024-06-21 01:10:44'),(500,'/export_user_log_csv',1,'2024-06-21 01:11:44'),(501,'/export_user_log_csv',1,'2024-06-21 01:12:13'),(502,'/stats',1,'2024-06-21 01:12:22'),(503,'/stats',1,'2024-06-21 01:12:25'),(504,'/',1,'2024-06-21 01:20:38'),(505,'/stats',1,'2024-06-21 01:20:40'),(506,'/export_user_log_csv',1,'2024-06-21 01:20:45'),(507,'/stats',1,'2024-06-21 01:21:51'),(508,'/export_user_log_csv',1,'2024-06-21 01:21:58'),(509,'/stats',1,'2024-06-21 01:22:40'),(510,'/export_view_stats_csv',1,'2024-06-21 01:22:45'),(511,'/stats',1,'2024-06-21 01:23:10'),(512,'/export_view_stats_csv',1,'2024-06-21 01:23:14'),(513,'/',1,'2024-06-21 01:24:29'),(514,'/stats',1,'2024-06-21 01:24:32'),(515,'/stats',1,'2024-06-21 01:24:42'),(516,'/stats',1,'2024-06-21 01:24:46'),(517,'/stats',1,'2024-06-21 01:24:49'),(518,'/stats',1,'2024-06-21 01:24:57'),(519,'/',1,'2024-06-21 01:25:05'),(520,'/books/add',1,'2024-06-21 01:25:10'),(521,'/books/add',1,'2024-06-21 01:25:54'),(522,'/',1,'2024-06-21 01:25:56'),(523,'/books/view/16',1,'2024-06-21 01:26:03'),(524,'/books/review/16',1,'2024-06-21 01:26:07'),(525,'/books/review/16',1,'2024-06-21 01:26:12'),(526,'/books/view/16',1,'2024-06-21 01:26:13'),(527,'/',1,'2024-06-21 01:26:17'),(528,'/stats',1,'2024-06-21 01:26:19');
/*!40000 ALTER TABLE `visit_logs` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-06-21  4:43:55
