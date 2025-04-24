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
/*!50003 DROP PROCEDURE IF EXISTS `book_tickets` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `book_tickets`(
    IN p_travel_date DATE,
    IN p_passenger_ids VARCHAR(255),
    IN p_class_id INT,
    IN p_boarding_station_id INT,
    IN p_arrival_station_id INT,
    IN p_train_id INT,
    IN p_payment_mode VARCHAR(50)
)
BEGIN
    -- Declare variables
    DECLARE v_passenger_id INT;
    DECLARE v_passenger_count INT DEFAULT 0;
    DECLARE v_remaining VARCHAR(255);
    DECLARE v_fare_multiplier DECIMAL(10,2);
    DECLARE v_seat_id INT;
    DECLARE v_seat_no VARCHAR(10);
    DECLARE v_boarding_sequence INT;
    DECLARE v_arrival_sequence INT;
    DECLARE v_station_difference INT;
    DECLARE v_passenger_amount DECIMAL(10,2);
    DECLARE v_category VARCHAR(50);
    DECLARE v_ticket_id INT;  -- Common ticket id for the booking
    DECLARE v_payment_id INT; -- Common payment id for the booking
    DECLARE v_available_count INT;
    DECLARE v_rac_count INT;
    DECLARE v_waiting_count INT;
    DECLARE v_ticket_status VARCHAR(20);
    DECLARE v_current_date DATE;
    DECLARE v_has_seat_entries INT;
    DECLARE i INT DEFAULT 1;
    DECLARE v_offset INT;
    DECLARE v_total_amount DECIMAL(10,2) DEFAULT 0;

    -- Set current booking date
    SET v_current_date = CURDATE();

    -- Check if there are any seat entries for the given train, date, and class
    SELECT COUNT(*) INTO v_has_seat_entries 
    FROM seat 
    WHERE Train_id = p_train_id 
      AND Travel_date = p_travel_date 
      AND Class_id = p_class_id;

    IF v_has_seat_entries = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No seat entries available for this train, date and class';
    END IF;

    -- Get fare multiplier for the class
    SELECT Fare_multiplier INTO v_fare_multiplier 
    FROM class 
    WHERE Class_id = p_class_id;

    -- Get sequence numbers for boarding and arrival stations
    SELECT Station_sequence INTO v_boarding_sequence 
    FROM routes 
    WHERE Train_id = p_train_id 
      AND Station_id = p_boarding_station_id;

    SELECT Station_sequence INTO v_arrival_sequence 
    FROM routes 
    WHERE Train_id = p_train_id 
      AND Station_id = p_arrival_station_id;

    IF v_boarding_sequence IS NULL OR v_arrival_sequence IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid boarding or arrival station for this train';
    END IF;

    IF v_boarding_sequence >= v_arrival_sequence THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Boarding station must come before arrival station in route';
    END IF;

    -- Calculate the station difference
    SET v_station_difference = v_arrival_sequence - v_boarding_sequence;

    -- Count available seats, existing RAC and waiting list entries
    SELECT COUNT(*) INTO v_available_count
    FROM seat
    WHERE Train_id = p_train_id 
      AND Class_id = p_class_id 
      AND Travel_date = p_travel_date
      AND Availibility = 'Available';

    SELECT COUNT(*) INTO v_rac_count
    FROM RAC_info
    WHERE Train_id = p_train_id 
      AND Class_id = p_class_id 
      AND Travel_date = p_travel_date;

    SELECT COUNT(*) INTO v_waiting_count
    FROM WL_info
    WHERE Train_id = p_train_id 
      AND Class_id = p_class_id 
      AND Travel_date = p_travel_date;

    -- Generate a common PNR for this booking
    SET @v_common_pnr = CONCAT('PNR', LPAD(FLOOR(RAND() * 1000000), 6, '0'));

    -- Create a temporary table to store passenger IDs (parsed from comma-separated list)
    CREATE TEMPORARY TABLE IF NOT EXISTS temp_passengers (id INT);
    SET v_remaining = p_passenger_ids;
    WHILE LENGTH(v_remaining) > 0 DO
        SET v_passenger_count = v_passenger_count + 1;
        IF LOCATE(',', v_remaining) > 0 THEN
            SET v_passenger_id = SUBSTRING(v_remaining, 1, LOCATE(',', v_remaining) - 1);
            SET v_remaining = SUBSTRING(v_remaining, LOCATE(',', v_remaining) + 1);
        ELSE
            SET v_passenger_id = v_remaining;
            SET v_remaining = '';
        END IF;
        INSERT INTO temp_passengers (id) VALUES (v_passenger_id);
    END WHILE;

    -- Check overall capacity (RAC limit is 5 and waiting list limit is set as 1000)
    IF v_passenger_count > (v_available_count + (5 - v_rac_count) + 1000) THEN
        DROP TEMPORARY TABLE IF EXISTS temp_passengers;
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Not enough seats available for all passengers (including RAC and waiting)';
    END IF;

    -- Create a temporary table to hold ticket details for each passenger
    CREATE TEMPORARY TABLE IF NOT EXISTS temp_ticket_details (
        Passenger_id INT,
        seat_id INT,
        ticket_status VARCHAR(20)
    );

    -- Process each passenger: compute fare, assign seat/RAC/waiting, and store ticket details
    SET i = 1;
    WHILE i <= v_passenger_count DO
        SET v_offset = i - 1;
        SELECT id INTO v_passenger_id FROM temp_passengers LIMIT v_offset, 1;

        -- Retrieve the passenger's category
        SET v_category = NULL;
        SELECT Category INTO v_category FROM passengers WHERE Passenger_id = v_passenger_id;

        -- Calculate base fare: 500 + (station difference * fare multiplier)
        SET v_passenger_amount = 500 + (v_station_difference * v_fare_multiplier);
        -- Apply 10% discount ONLY if category is not NULL (i.e. only for passenger 1004 per your data)
        IF v_category IS NOT NULL THEN
            SET v_passenger_amount = v_passenger_amount * 0.9;
        END IF;
        SET v_passenger_amount = FLOOR(v_passenger_amount);
        SET v_total_amount = v_total_amount + v_passenger_amount;

        -- Determine ticket status based on seat availability
        IF v_available_count > 0 THEN
            SELECT Seat_id, Seat_no INTO v_seat_id, v_seat_no
            FROM seat
            WHERE Train_id = p_train_id 
              AND Class_id = p_class_id 
              AND Travel_date = p_travel_date
              AND Availibility = 'Available'
            LIMIT 1;
            SET v_ticket_status = 'Confirmed';
            SET v_available_count = v_available_count - 1;
            UPDATE seat SET Availibility = 'Booked' WHERE Seat_id = v_seat_id;
        ELSE
            -- Check if RAC slots are available (maximum 5 allowed)
            SELECT COUNT(*) INTO v_rac_count
            FROM RAC_info
            WHERE Train_id = p_train_id 
            AND Class_id = p_class_id 
            AND Travel_date = p_travel_date
            AND Availibility = 'Booked';

            IF 5 - v_rac_count > 0 THEN
                -- Pick the first available RAC slot
                SELECT RAC_id INTO v_seat_id
                FROM RAC_info
                WHERE Train_id = p_train_id 
                AND Class_id = p_class_id 
                AND Travel_date = p_travel_date
                AND Availibility = 'Available'
                LIMIT 1;

                -- Mark as RAC booked
                SET v_ticket_status = 'RAC';
                SET v_seat_no = CONCAT('RAC', v_seat_id);

                UPDATE RAC_info
                SET Availibility = 'Booked'
                WHERE RAC_id = v_seat_id;

            ELSE
                -- No RAC slots — move to waiting list
                SET v_ticket_status = 'Waiting';
                SET v_seat_id = NULL;
                SET v_waiting_count = v_waiting_count + 1;
                SET v_seat_no = CONCAT('WL', v_waiting_count);

                INSERT INTO WL_info (Train_id, Class_id, Travel_date)
                VALUES (p_train_id, p_class_id, p_travel_date);
            END IF;
        END IF;



        -- Store the computed ticket details into temporary table
        INSERT INTO temp_ticket_details (Passenger_id, seat_id, ticket_status)
        VALUES (v_passenger_id, v_seat_id, v_ticket_status);

        SET i = i + 1;
    END WHILE;

    -- Generate a common Ticket ID and Payment ID for the entire booking
    SELECT IFNULL(MAX(Ticket_id), 0) + 1 INTO v_ticket_id FROM ticket;
    SET v_payment_id = v_ticket_id;  -- Shared Payment ID

    -- Insert the Payment record first (to satisfy the foreign key constraint)
    INSERT INTO payment (Payment_id, Ticket_id, Amount, Payment_mode, Date_of_Payment)
    VALUES (v_payment_id, v_ticket_id, v_total_amount, p_payment_mode, v_current_date);

    -- Now, insert Ticket records for each passenger referencing the same Ticket ID and Payment ID
    INSERT INTO ticket (
        Ticket_id, 
        Passenger_id, 
        Train_id, 
        PNR, 
        Class_id, 
        Seat_id,
        Boarding_station, 
        Arrival_station, 
        Ticket_status, 
        Payment_id, 
        Travel_date
    )
    SELECT 
        v_ticket_id, 
        Passenger_id, 
        p_train_id, 
        @v_common_pnr, 
        p_class_id, 
        seat_id,
        p_boarding_station_id, 
        p_arrival_station_id, 
        ticket_status, 
        v_payment_id, 
        p_travel_date
    FROM temp_ticket_details;

    -- Output booking summary
    SELECT 
        @v_common_pnr AS PNR,
        v_passenger_count AS Total_Tickets_Booked,
        v_total_amount AS Total_Amount_Charged;

    DROP TABLE temp_passengers;
    DROP TABLE temp_ticket_details;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CalculateTotalRevenue` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CalculateTotalRevenue`(
    IN p_start_date DATE,
    IN p_end_date DATE
)
BEGIN
    SELECT 
        SUM(Amount) AS Total_Revenue
    FROM payment
    WHERE Date_of_Payment BETWEEN p_start_date AND p_end_date;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CalculateTrainCancellationRefund` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CalculateTrainCancellationRefund`(
    IN p_train_no INT,
    IN p_travel_date DATE
)
BEGIN
    SELECT 
        SUM(pm.Amount) AS Total_Refund_Amount
    FROM payment pm
    WHERE pm.Payment_id IN (
        SELECT DISTINCT tk.Payment_id
        FROM ticket tk
        WHERE tk.Train_id = p_train_no
          AND tk.Travel_date = p_travel_date
          AND tk.Ticket_status IN ('Confirmed', 'RAC', 'Waiting')
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cancel_ticket` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cancel_ticket`(IN p_ticket_id INT)
BEGIN 
    DECLARE v_ticket_id, v_seat_id, v_train_id, v_class_id, v_payment_id, v_refund_id, 
v_passenger_count, v_cancelled_confirmed, v_cancelled_rac, v_cancelled_waiting, done INT 
DEFAULT 0; 
    DECLARE v_pnr VARCHAR(10);  
    DECLARE v_travel_date, v_payment_date, v_today DATE; 
    DECLARE v_payment_amount, v_refund_amount DECIMAL(10,2); 
     
    DECLARE seat_cursor CURSOR FOR SELECT Seat_id FROM temp_ticket_details WHERE 
Ticket_status='Confirmed'; 
    DECLARE rac_cursor CURSOR FOR SELECT Seat_id FROM rac_info WHERE 
Train_id=v_train_id AND Class_id=v_class_id AND Travel_date=v_travel_date; 
 
    START TRANSACTION; 
 
    SELECT Train_id, Class_id, Travel_date, Payment_id, PNR, COUNT(*)  
    INTO v_train_id, v_class_id, v_travel_date, v_payment_id, v_pnr, v_passenger_count 
    FROM ticket WHERE Ticket_id=p_ticket_id GROUP BY Train_id, Class_id, Travel_date, 
Payment_id, PNR; 
 
    IF v_train_id IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Ticket not found'; 
ROLLBACK; END IF; 
 
    SELECT Amount, Date_of_Payment INTO v_payment_amount, v_payment_date FROM 
payment WHERE Payment_id=v_payment_id; 
 
    SET v_today=CURDATE(),  
        v_refund_amount=CASE  
            WHEN DATEDIFF(v_travel_date,v_today)>=5 THEN v_payment_amount  
            WHEN DATEDIFF(v_travel_date,v_today)>=2 THEN v_payment_amount*0.5  
            WHEN DATEDIFF(v_travel_date,v_today)>=1 THEN v_payment_amount*0.25  
            ELSE 0  
        END, 
        v_refund_id=FLOOR(5000000+RAND()*4000000); 
 
    INSERT INTO refund_record (Refund_id, Payment_id, Amount, Booking_date, 
Cancellation_date) 
    VALUES (v_refund_id, v_payment_id, v_refund_amount, v_payment_date, v_today); 
 
    DROP TABLE IF EXISTS temp_ticket_details; 
    CREATE TABLE temp_ticket_details AS SELECT Ticket_id, Passenger_id, Seat_id, Ticket_status 
FROM ticket WHERE PNR=v_pnr; 
 
    SELECT  
        SUM(CASE WHEN Ticket_status='Confirmed' THEN 1 ELSE 0 END), 
        SUM(CASE WHEN Ticket_status='RAC' THEN 1 ELSE 0 END), 
        SUM(CASE WHEN Ticket_status='Waiting' THEN 1 ELSE 0 END) 
    INTO v_cancelled_confirmed, v_cancelled_rac, v_cancelled_waiting FROM 
temp_ticket_details; 
 
    OPEN seat_cursor; 
    read_seat: LOOP 
        FETCH seat_cursor INTO v_seat_id; 
        IF done THEN LEAVE read_seat; END IF; 
        UPDATE seat SET Availability='Available' WHERE Seat_id=v_seat_id; 
    END LOOP; 
    CLOSE seat_cursor; 
 
    OPEN rac_cursor; 
    read_rac: LOOP 
        FETCH rac_cursor INTO v_seat_id; 
        IF done THEN LEAVE read_rac; END IF; 
        UPDATE rac_info SET Availability='Available' WHERE Seat_id=v_seat_id AND 
Train_id=v_train_id AND Class_id=v_class_id AND Travel_date=v_travel_date; 
    END LOOP; 
    CLOSE rac_cursor; 
    DELETE FROM wl_info WHERE Train_id=v_train_id AND Class_id=v_class_id AND 
Travel_date=v_travel_date; 
    DELETE FROM ticket WHERE PNR=v_pnr; 
    DELETE FROM payment WHERE Payment_id=v_payment_id; 
    COMMIT; 
    SELECT p_ticket_id AS Cancelled_Ticket_ID, v_pnr AS Cancelled_PNR, v_passenger_count AS 
Passengers_AAected,  
           v_refund_amount AS Refund_Amount, v_refund_id AS Refund_ID,  
           v_cancelled_confirmed AS Confirmed_Tickets_Cancelled, v_cancelled_rac AS 
RAC_Tickets_Cancelled,  
           v_cancelled_waiting AS Waiting_Tickets_Cancelled; END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CheckPNRStatus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CheckPNRStatus`(
    IN p_pnr VARCHAR(10)
)
BEGIN
    SELECT t.PNR, p.Name, p.Age, p.Gender, tr.Train_name, 
           s1.Station_name AS Boarding_station, 
           s2.Station_name AS Arrival_station, 
           c.Class_name, 
           COALESCE(se.Seat_no, 'Not Assigned') AS Seat_no, 
           t.Ticket_status,
           t.Travel_date,
           CASE 
               WHEN t.Ticket_status = 'Waitlisted' THEN
                   (SELECT COUNT(*) + 1 FROM ticket 
                    WHERE Train_id = t.Train_id AND Class_id = t.Class_id 
                    AND Ticket_status = 'Waitlisted' AND Travel_date = t.Travel_date 
                    AND Ticket_id < t.Ticket_id)
               ELSE NULL
           END AS Waitlist_Position
    FROM ticket t
    JOIN passengers p ON t.Passenger_id = p.Passenger_id
    JOIN trains tr ON t.Train_id = tr.Train_no
    JOIN stations s1 ON t.Boarding_station = s1.Station_id
    JOIN stations s2 ON t.Arrival_station = s2.Station_id
    JOIN class c ON t.Class_id = c.Class_id
    LEFT JOIN seat se ON t.Seat_id = se.Seat_id
    WHERE t.PNR = p_pnr
    ORDER BY p.Name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `FindBusiestTrain` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FindBusiestTrain`()
BEGIN
    -- Find the train with the maximum number of unique ticket-passenger pairs
    SELECT Train_id, COUNT(DISTINCT Ticket_id, Passenger_id) AS Total_Pairs
    FROM ticket
    GROUP BY Train_id
    ORDER BY Total_Pairs DESC
    LIMIT 1;
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
      AND Availibility = 'Available'
      
	UNION ALL
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
/*!50003 DROP PROCEDURE IF EXISTS `GetPassengerList` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetPassengerList`(
    IN p_train_id INT,
    IN p_travel_date DATE
)
BEGIN
    SELECT 
        tk.Ticket_status AS Passenger_Type,
        tk.PNR,
        p.Name,
        p.Age,
        p.Gender,
        p.Category,
        c.Class_name,
        COALESCE(se.Seat_no, 'Not Assigned') AS Seat_no,
        s1.Station_name AS Boarding_station,
        s2.Station_name AS Arrival_station,
        pm.Amount AS Ticket_Amount
    FROM ticket tk
    JOIN passengers p ON tk.Passenger_id = p.Passenger_id
    JOIN class c ON tk.Class_id = c.Class_id
    LEFT JOIN seat se ON tk.Seat_id = se.Seat_id
    JOIN stations s1 ON tk.Boarding_station = s1.Station_id
    JOIN stations s2 ON tk.Arrival_station = s2.Station_id
    JOIN payment pm ON tk.Payment_id = pm.Payment_id
    WHERE tk.Train_id = p_train_id
    AND tk.Travel_date = p_travel_date
    ORDER BY tk.Ticket_status, p.Name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetTrainSchedule` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetTrainSchedule`(
    IN p_train_id INT
)
BEGIN
    -- Get basic train information
    SELECT t.Train_no, t.Train_name, t.Type, 
           CASE 
               WHEN SUBSTRING(t.Days_of_operation, 1, 1) = 'Y' THEN 'Mon, ' ELSE '' END +
               CASE WHEN SUBSTRING(t.Days_of_operation, 2, 1) = 'Y' THEN 'Tue, ' ELSE '' END +
               CASE WHEN SUBSTRING(t.Days_of_operation, 3, 1) = 'Y' THEN 'Wed, ' ELSE '' END +
               CASE WHEN SUBSTRING(t.Days_of_operation, 4, 1) = 'Y' THEN 'Thu, ' ELSE '' END +
               CASE WHEN SUBSTRING(t.Days_of_operation, 5, 1) = 'Y' THEN 'Fri, ' ELSE '' END +
               CASE WHEN SUBSTRING(t.Days_of_operation, 6, 1) = 'Y' THEN 'Sat, ' ELSE '' END +
               CASE WHEN SUBSTRING(t.Days_of_operation, 7, 1) = 'Y' THEN 'Sun' ELSE '' END AS Running_Days
    FROM trains t
    WHERE t.Train_no = p_train_id;
    
    -- Get detailed schedule
    SELECT r.Station_sequence AS Stop_Number, 
           s.Station_name, 
           r.Arrival_time, 
           r.Departure_time,
           CASE
               WHEN r.Arrival_time IS NULL THEN 'Source Station'
               WHEN r.Departure_time IS NULL THEN 'Destination Station'
               ELSE 'Intermediate Station'
           END AS Station_Type,
           TIMEDIFF(r.Departure_time, r.Arrival_time) AS Halt_Time
    FROM routes r
    JOIN stations s ON r.Station_id = s.Station_id
    WHERE r.Train_id = p_train_id
    ORDER BY r.Station_sequence;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetWaitlistedPassengers` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetWaitlistedPassengers`(
    IN p_train_id INT
)
BEGIN
    SELECT 
        passengers.Passenger_id,
        passengers.Name,
        ticket.Travel_Date
    FROM ticket
    JOIN passengers ON ticket.Passenger_id = passengers.Passenger_id
    WHERE ticket.Train_id = p_train_id
      AND ticket.Ticket_status = 'Waiting'
    ORDER BY passengers.Name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_trains_by_date` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_trains_by_date`(IN travel_date DATE)
BEGIN
SELECT DISTINCT Train_no, Train_name
FROM trains
WHERE SUBSTRING(days_of_operation, DAYOFWEEK(travel_date), 1) = 'Y';
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

-- Dump completed on 2025-04-24  6:38:30
