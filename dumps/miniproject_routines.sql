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
-- Dumping events for database 'miniproject'
--

--
-- Dumping routines for database 'miniproject'
--
/*!50003 DROP PROCEDURE IF EXISTS `AddRACForDateRange` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddRACForDateRange`(IN start_date DATE, IN end_date DATE)
BEGIN
    DECLARE current_dt DATE;
    DECLARE day_of_week INT;
    DECLARE next_rac_id INT;

    -- Initialize date loop
    SET current_dt = start_date;

    WHILE current_dt <= end_date DO

        SET day_of_week = DAYOFWEEK(current_dt);  -- 1 = Sunday

        -- Get the next RAC ID
        SELECT COALESCE(MAX(RAC_id), 0) + 1 INTO next_rac_id FROM rac_info;

        -- Insert 5 RAC entries per train-class combination using a window function
        INSERT INTO rac_info (RAC_id, Train_id, Class_id, Availibility, Travel_date)
        SELECT
            next_rac_id + ROW_NUMBER() OVER (ORDER BY t.Train_no, c.Class_id, nums.n) - 1 AS RAC_id,
            t.Train_no,
            c.Class_id,
            'Available',
            current_dt
        FROM trains t
        JOIN (SELECT 1 AS Class_id UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5) c
        JOIN (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5) nums
        WHERE SUBSTRING(t.Days_of_operation, day_of_week, 1) = 'Y';

        -- Increment date
        SET current_dt = DATE_ADD(current_dt, INTERVAL 1 DAY);

    END WHILE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `AddSeatsForDateRange` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddSeatsForDateRange`(IN start_date DATE, IN end_date DATE)
BEGIN
    DECLARE current_dt DATE;
    DECLARE train_id INT;
    DECLARE day_of_week INT;
    DECLARE days_operation VARCHAR(7);
    DECLARE operates_today CHAR(1);
    DECLARE finished INTEGER DEFAULT 0;
    DECLARE next_seat_id INT;
    
    -- Cursor to iterate through all trains
    DECLARE train_cursor CURSOR FOR 
        SELECT Train_no, Days_of_operation 
        FROM trains;
    
    -- Handler for when the cursor is done
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
    
    -- Get the next available seat_id
    SELECT COALESCE(MAX(Seat_id), 0) + 1 INTO next_seat_id FROM seat;
    
    -- Set the starting date
    SET current_dt = start_date;
    
    -- Loop through each date in the range
    WHILE current_dt <= end_date DO
        
        -- Get day of week (1 = Sunday, 2 = Monday, ..., 7 = Saturday)
        SET day_of_week = DAYOFWEEK(current_dt);
        
        -- Open the train cursor
        OPEN train_cursor;
        
        -- Start fetching trains
        train_fetch_loop: LOOP
            FETCH train_cursor INTO train_id, days_operation;
            
            -- Exit loop if all trains have been processed
            IF finished = 1 THEN
                LEAVE train_fetch_loop;
            END IF;
            
            -- Check if the train operates on this day of the week
            -- MySQL's DAYOFWEEK returns 1 for Sunday, we need to adjust to match our format
            -- Days_of_operation format: YYYYYYY (Sunday to Saturday)
            
            -- Get the correct character from days_operation based on day_of_week
            IF day_of_week = 1 THEN
                SET operates_today = SUBSTRING(days_operation, 1, 1); -- Sunday
            ELSEIF day_of_week = 2 THEN
                SET operates_today = SUBSTRING(days_operation, 2, 1); -- Monday
            ELSEIF day_of_week = 3 THEN
                SET operates_today = SUBSTRING(days_operation, 3, 1); -- Tuesday
            ELSEIF day_of_week = 4 THEN
                SET operates_today = SUBSTRING(days_operation, 4, 1); -- Wednesday
            ELSEIF day_of_week = 5 THEN
                SET operates_today = SUBSTRING(days_operation, 5, 1); -- Thursday
            ELSEIF day_of_week = 6 THEN
                SET operates_today = SUBSTRING(days_operation, 6, 1); -- Friday
            ELSE
                SET operates_today = SUBSTRING(days_operation, 7, 1); -- Saturday
            END IF;
            
            -- If the train operates today, add seats for all classes
            IF operates_today = 'Y' THEN
                
                -- Add seats for General class (Class_id = 1)
                INSERT INTO seat (Seat_id, Seat_no, Train_id, Class_id, Availibility, Date)
                VALUES 
                    (next_seat_id, 'GEN-01', train_id, 1, 'Available', current_dt),
                    (next_seat_id + 1, 'GEN-02', train_id, 1, 'Available', current_dt),
                    (next_seat_id + 2, 'GEN-03', train_id, 1, 'Available', current_dt),
                    (next_seat_id + 3, 'GEN-04', train_id, 1, 'Available', current_dt),
                    (next_seat_id + 4, 'GEN-05', train_id, 1, 'Available', current_dt);
                
                SET next_seat_id = next_seat_id + 5;
                
                -- Add seats for Sleeper class (Class_id = 2)
                INSERT INTO seat (Seat_id, Seat_no, Train_id, Class_id, Availibility, Date)
                VALUES 
                    (next_seat_id, 'SL-01', train_id, 2, 'Available', current_dt),
                    (next_seat_id + 1, 'SL-02', train_id, 2, 'Available', current_dt),
                    (next_seat_id + 2, 'SL-03', train_id, 2, 'Available', current_dt),
                    (next_seat_id + 3, 'SL-04', train_id, 2, 'Available', current_dt),
                    (next_seat_id + 4, 'SL-05', train_id, 2, 'Available', current_dt);
                
                SET next_seat_id = next_seat_id + 5;
                
                -- Add seats for 3AC class (Class_id = 3)
                INSERT INTO seat (Seat_id, Seat_no, Train_id, Class_id, Availibility, Date)
                VALUES 
                    (next_seat_id, '3AC-01', train_id, 3, 'Available', current_dt),
                    (next_seat_id + 1, '3AC-02', train_id, 3, 'Available', current_dt),
                    (next_seat_id + 2, '3AC-03', train_id, 3, 'Available', current_dt),
                    (next_seat_id + 3, '3AC-04', train_id, 3, 'Available', current_dt),
                    (next_seat_id + 4, '3AC-05', train_id, 3, 'Available', current_dt);
                
                SET next_seat_id = next_seat_id + 5;
                
                -- Add seats for 2AC class (Class_id = 4)
                INSERT INTO seat (Seat_id, Seat_no, Train_id, Class_id, Availibility, Date)
                VALUES 
                    (next_seat_id, '2AC-01', train_id, 4, 'Available', current_dt),
                    (next_seat_id + 1, '2AC-02', train_id, 4, 'Available', current_dt),
                    (next_seat_id + 2, '2AC-03', train_id, 4, 'Available', current_dt),
                    (next_seat_id + 3, '2AC-04', train_id, 4, 'Available', current_dt),
                    (next_seat_id + 4, '2AC-05', train_id, 4, 'Available', current_dt);
                
                SET next_seat_id = next_seat_id + 5;
                
                -- Add seats for 1AC class (Class_id = 5)
                INSERT INTO seat (Seat_id, Seat_no, Train_id, Class_id, Availibility, Date)
                VALUES 
                    (next_seat_id, '1AC-01', train_id, 5, 'Available', current_dt),
                    (next_seat_id + 1, '1AC-02', train_id, 5, 'Available', current_dt),
                    (next_seat_id + 2, '1AC-03', train_id, 5, 'Available', current_dt),
                    (next_seat_id + 3, '1AC-04', train_id, 5, 'Available', current_dt),
                    (next_seat_id + 4, '1AC-05', train_id, 5, 'Available', current_dt);
                
                SET next_seat_id = next_seat_id + 5;
                
            END IF;
            
        END LOOP train_fetch_loop;
        
        -- Close the cursor
        CLOSE train_cursor;
        
        -- Reset the finished flag
        SET finished = 0;
        
        -- Move to the next date
        SET current_dt = DATE_ADD(current_dt, INTERVAL 1 DAY);
        
    END WHILE;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetAvailableSeats` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAvailableSeats`(
    IN p_train_id INT,
    IN p_class_id VARCHAR(10),
    IN p_travel_date DATE
)
BEGIN
    -- Query available confirmed seats from 'seats'
    SELECT 'CONFIRMED' AS category, COUNT(*) AS seats
    FROM seat
    WHERE Train_id = p_train_id
      AND Class_id = p_class_id
      AND Travel_date = p_travel_date
      AND Availibility = 'Available';

    -- Query available RAC seats from 'rac'
    SELECT 'RAC' AS category, COUNT(*) AS seats
    FROM rac_info
    WHERE Train_id = p_train_id
      AND Class_id = p_class_id
      AND Travel_date = p_travel_date
      AND Availibility = 'Available';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-16  0:37:42
