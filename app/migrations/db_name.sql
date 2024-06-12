-- MySQL dump 10.13  Distrib 8.4.0, for Linux (aarch64)
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_covers`
--

LOCK TABLES `book_covers` WRITE;
/*!40000 ALTER TABLE `book_covers` DISABLE KEYS */;
INSERT INTO `book_covers` VALUES (2,'Notes_of_a_Dirty_Old_Man.jpg','image/jpeg','625af8fc0f0f867560e4b682941a9960'),(3,'cover1__w600.jpg','image/jpeg','f7dc3cf41424061b3b7825be39e17ab6'),(4,'8685806.jpg','image/jpeg','367dfcb80c2394d33f851fc121e10793'),(5,'6496395191.jpg','image/jpeg','d5f81cadfc73d397f0a6a71b2b0fc245'),(6,'uk613724.jpg','image/jpeg','982829b8be106bc87d347b20ab896722');
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
INSERT INTO `book_genres` VALUES (4,1),(5,1),(6,1),(2,2),(3,2),(4,2),(2,3),(3,3),(5,3),(3,4),(4,4);
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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books`
--

LOCK TABLES `books` WRITE;
/*!40000 ALTER TABLE `books` DISABLE KEYS */;
INSERT INTO `books` VALUES (2,'Записки старого козла','Сборник кортких автобиографических расказов ',1998,'АСТ','Чарльз Буковски',312,2),(3,'415 градусов по фарингейту','ю',1986,'Яркие Страницы','Рей Бредбери',282,3),(4,'Скотный двор','/',1984,'XX Век','Джордж Оруэл',350,4),(5,'Чистый код','Создание, анализ и рефакторинг кода',2006,'ЛАНИТ','Роберт Мартин',640,5),(6,'DDD','**Предметно-ориентированное проектирование**\r\nСтруктуризация сложных программных систем ',2011,'АСТ','Эрик Эванс',625,6);
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
  CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`),
  CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `chk_rating` CHECK ((`rating` between 0 and 5))
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
INSERT INTO `reviews` VALUES (4,5,3,5,'user1vvfs','2023-10-27 13:09:09'),(5,5,3,5,'sfsd','2023-10-27 13:09:14'),(6,3,1,3,'q2w3123123','2024-06-12 12:09:38'),(8,5,1,5,'```\r\nfokseofksopfsekfposefkespofksepfosefkse\r\n{}{}{}{}{}{}{}{[][]\r\n```','2024-06-12 17:17:56');
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
  CONSTRAINT `views_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `views`
--

LOCK TABLES `views` WRITE;
/*!40000 ALTER TABLE `views` DISABLE KEYS */;
INSERT INTO `views` VALUES (1,1,6,'2024-06-12 14:50:44'),(2,1,5,'2024-06-12 14:50:46'),(3,1,2,'2024-06-12 14:50:48'),(4,1,3,'2024-06-12 14:50:49');
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
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `visit_logs`
--

LOCK TABLES `visit_logs` WRITE;
/*!40000 ALTER TABLE `visit_logs` DISABLE KEYS */;
INSERT INTO `visit_logs` VALUES (1,'/',NULL,'2024-06-12 16:52:53'),(2,'/books/most_popular',NULL,'2024-06-12 16:52:55'),(3,'/books/add',NULL,'2024-06-12 16:52:56'),(4,'/login',NULL,'2024-06-12 16:52:56'),(5,'/login',NULL,'2024-06-12 16:52:58'),(6,'/login',NULL,'2024-06-12 16:53:00'),(7,'/',1,'2024-06-12 16:53:00'),(8,'/books/most_popular',1,'2024-06-12 16:53:02'),(9,'/',1,'2024-06-12 16:53:04'),(10,'/',NULL,'2024-06-12 17:02:11'),(11,'/books/most_popular',NULL,'2024-06-12 17:02:13'),(12,'/',NULL,'2024-06-12 17:02:15'),(13,'/login',NULL,'2024-06-12 17:02:22'),(14,'/login',NULL,'2024-06-12 17:02:26'),(15,'/',1,'2024-06-12 17:02:26'),(16,'/books/most_popular',1,'2024-06-12 17:02:28'),(17,'/',1,'2024-06-12 17:02:29'),(18,'/books/delete/9',1,'2024-06-12 17:03:12'),(19,'/',1,'2024-06-12 17:03:12'),(20,'/',1,'2024-06-12 17:03:13'),(21,'/',1,'2024-06-12 17:03:14'),(22,'/books/delete/8',1,'2024-06-12 17:03:17'),(23,'/',1,'2024-06-12 17:03:17'),(24,'/',1,'2024-06-12 17:05:59'),(25,'/books/view/5',1,'2024-06-12 17:06:41'),(26,'/',1,'2024-06-12 17:07:10'),(27,'/books/edit/2',1,'2024-06-12 17:12:24'),(28,'/',1,'2024-06-12 17:15:56'),(29,'/',1,'2024-06-12 17:16:35'),(30,'/',1,'2024-06-12 17:16:36'),(31,'/books/view/5',1,'2024-06-12 17:17:31'),(32,'/books/review/5',1,'2024-06-12 17:17:40'),(33,'/books/review/5',1,'2024-06-12 17:17:56'),(34,'/books/view/5',1,'2024-06-12 17:17:56'),(35,'/books/view/5',1,'2024-06-12 17:19:05'),(36,'/books/view/5',1,'2024-06-12 17:19:06'),(37,'/books/view/5',1,'2024-06-12 17:19:06'),(38,'/books/view/5',1,'2024-06-12 17:19:06'),(39,'/books/view/5',1,'2024-06-12 17:19:06'),(40,'/books/view/5',1,'2024-06-12 17:19:06'),(41,'/books/view/5',1,'2024-06-12 17:19:07'),(42,'/books/view/5',1,'2024-06-12 17:19:07'),(43,'/',1,'2024-06-12 17:19:08'),(44,'/books/view/6',1,'2024-06-12 17:19:09'),(45,'/books/most_popular',1,'2024-06-12 17:19:10'),(46,'/',1,'2024-06-12 17:19:14'),(47,'/',1,'2024-06-12 17:19:16'),(48,'/',1,'2024-06-12 17:19:16'),(49,'/books/most_popular',1,'2024-06-12 17:19:17'),(50,'/',1,'2024-06-12 17:19:18'),(51,'/logout',1,'2024-06-12 17:23:48'),(52,'/',NULL,'2024-06-12 17:23:48'),(53,'/favicon.ico',NULL,'2024-06-12 17:23:48'),(54,'/login',NULL,'2024-06-12 17:23:49'),(55,'/login',NULL,'2024-06-12 17:23:53'),(56,'/',2,'2024-06-12 17:23:53'),(57,'/logout',2,'2024-06-12 17:24:05'),(58,'/',NULL,'2024-06-12 17:24:06'),(59,'/login',NULL,'2024-06-12 17:24:06'),(60,'/login',NULL,'2024-06-12 17:24:09'),(61,'/',3,'2024-06-12 17:24:09'),(62,'/',3,'2024-06-12 17:49:04'),(63,'/books/most_popular',3,'2024-06-12 17:49:05');
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

-- Dump completed on 2024-06-12 17:58:37
