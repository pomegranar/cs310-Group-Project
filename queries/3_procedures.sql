USE sports;

-- DROP PROCEDURE reserve_facility;
-- DROP PROCEDURE checkout_equipment;
-- DROP PROCEDURE register_user;
-- DROP PROCEDURE enroll_users_to_classes;
-- DROP PROCEDURE create_new_announcement;
-- DROP PROCEDURE create_new_subscription_for_user;


-- PROCEDURE FOR FACILITY RESERVATION
DELIMITER //

CREATE PROCEDURE reserve_facility(
    IN p_user_id INT,
    IN p_facility_id INT,
    IN p_reserve_date DATE,
    IN p_start_time TIME,
    IN p_end_time TIME
)
BEGIN
    DECLARE conflict_count INT;
    DECLARE reservation_duration INT;

    -- Calculating the reservation duration in minutes
    SET reservation_duration = TIME_TO_SEC(p_end_time) / 60 - TIME_TO_SEC(p_start_time) / 60;

    -- Checking for time conflicts
    SELECT COUNT(*) INTO conflict_count
    FROM reservation
    WHERE facility_id = p_facility_id
      AND reserve_date = p_reserve_date
      AND (
        (p_start_time >= start_time AND p_start_time < end_time) OR
        (p_end_time > start_time AND p_end_time <= end_time) OR
        (p_start_time <= start_time AND p_end_time >= end_time)
      );

    IF p_user_id IN (SELECT user_id FROM penalty) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User has a penalty and can not make reservations until fees are paid.';
    -- ELSEIF CURTIME() > '21:00:00' OR CURTIME() < '07:00:00' THEN
    --     SIGNAL SQLSTATE '45000'
    --     SET MESSAGE_TEXT = 'The Sports Complex is closed for the day, come back tomorrow after 7am!';
    ELSEIF p_user_id NOT IN (SELECT user_id FROM active_members) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User has no active membership.';
    ELSEIF conflict_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Reservation time conflict detected.';
    ELSEIF reservation_duration > 60 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Reservation duration exceeds one hour.';
    ELSEIF p_reserve_date < CURRENT_DATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT  = 'Please select a date in the future.';
    ELSEIF DATE(p_reserve_date) = CURDATE() AND TIME(p_start_time) < CURTIME() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT  = 'Please select a date in the future.';
    ELSE
        INSERT INTO reservation (user_id, facility_id, reserve_date, start_time, end_time)
        VALUES (p_user_id, p_facility_id, p_reserve_date, p_start_time, p_end_time);
    END IF;
END //

DELIMITER ;



-- CHECKOUT PROCEDURE
DELIMITER //

CREATE PROCEDURE checkout_equipment(
    IN p_user_id INT,
    IN p_equipment_id INT
)
BEGIN
    DECLARE existing_checkouts INT;

    SELECT COUNT(*) INTO existing_checkouts
    FROM borrowed
    WHERE equipment_id = p_equipment_id AND returned_on IS NULL;

    IF existing_checkouts > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Equipment unavailable.';
    -- ELSEIF CURTIME() > '21:00:00' OR CURTIME() < '07:00:00' THEN
    --     SIGNAL SQLSTATE '45000'
    --     SET MESSAGE_TEXT = 'The Sports Complex is closed for the day, come back tomorrow after 7am!';
    ELSEIF p_user_id IN (SELECT user_id FROM penalty) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User has a penalty and can not check out equipment until fees are paid.';
    ELSEIF p_user_id NOT IN (SELECT user_id FROM active_members) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User has no active membership.';
    ELSE
        INSERT INTO borrowed (user_id, equipment_id)
        VALUES (p_user_id, p_equipment_id);
    END IF;
END //

DELIMITER ;


-- EQUIPMENT CHECK IN PROCEDURE
DELIMITER //

CREATE PROCEDURE check_in_equipment(
    IN user_id INT,
    IN equipment_ids TEXT
)
BEGIN
    DECLARE id INT;
    DECLARE done INT DEFAULT FALSE;
    DECLARE cur CURSOR FOR SELECT id FROM JSON_TABLE(equipment_ids, '$[*]' COLUMNS (id INT PATH '$')) t;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    check_in_loop: LOOP
        FETCH cur INTO id;
        IF done THEN
            LEAVE check_in_loop;
        END IF;

        UPDATE borrowed
        SET returned_on = NOW()
        WHERE user_id = user_id AND equipment_id = id AND returned_on IS NULL;
    END LOOP;

    CLOSE cur;
END //

DELIMITER ;


-- PROCEDURE TO REGISTER NEW USERS
DELIMITER $$

CREATE PROCEDURE register_user(
    IN p_netid VARCHAR(10),
    IN p_card_number VARCHAR(10),
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_gender ENUM('male', 'female', 'other', 'undisclosed'),
    IN p_birthday DATE,
    IN p_role ENUM('student', 'faculty', 'staff', 'worker', 'student_worker', 'affiliate', 'alumni', 'guest', 'security', 'other'),
    IN p_info_type ENUM('phone', 'email', 'address', 'emergency'),
    IN p_info VARCHAR(100)
)
BEGIN
    DECLARE new_user_id INT;

    -- Check if netid already exists
    IF EXISTS(SELECT * FROM user WHERE netid = p_netid) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The user already exists. Please add another user.';

    -- Check if card_number already exists
    ELSEIF EXISTS(SELECT * FROM user WHERE card_number = p_card_number) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The user already exists. Please add another user.';

    ELSEIF p_birthday > CURRENT_DATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'You cannot add a user whose birthday is in the future! Please change the birthday value';

    ELSEIF p_first_name IS NULL OR TRIM(p_first_name) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'First name value cannot be empty';

    ELSEIF p_gender NOT IN ('male', 'female', 'other', 'undisclosed') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid gender specified';

    ELSEIF p_role NOT IN ('student', 'faculty', 'staff', 'worker', 'student_worker', 'affiliate', 'alumni', 'guest', 'security', 'other') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid role specified';

    ELSEIF p_info_type NOT IN ('phone', 'email', 'address', 'emergency') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid contact information type';

    ELSE
        -- Insert the new user into the user table
        INSERT INTO user(netid, card_number, first_name, last_name, gender, birthday, role)
        VALUES (p_netid, p_card_number, p_first_name, p_last_name, p_gender, p_birthday, p_role);


        SET new_user_id = LAST_INSERT_ID();
        -- Insert contact information for the new user
        INSERT INTO contact( user_id, info_type, info)
        VALUES( new_user_id,p_info_type, p_info);

    END IF;
END $$

DELIMITER ;



-- PROCEDURE TO ENROLL USERS TO CLASSES
DELIMITER $$

CREATE PROCEDURE enroll_users_to_classes(
    IN p_user_id INT,
    IN p_class_id INT
)
BEGIN
    DECLARE conflict_count INT;
    DECLARE class_start_time DATETIME;
    DECLARE class_end_time DATETIME;

    -- deriving start and end times of classes from the schedule
    SELECT start_time, end_time INTO class_start_time, class_end_time
    FROM schedule
    WHERE class_id= p_class_id
    LIMIT 1;

    -- Checking for time conflicts
    SELECT COUNT(*) INTO conflict_count
    FROM enrollment
    JOIN schedule USING (class_id)
    WHERE enrollment.user_id= p_user_id AND
        (
            (class_start_time >= schedule.start_time AND class_start_time < schedule.end_time) OR
            (class_end_time > schedule.start_time AND class_end_time <= schedule.end_time) OR
            (class_start_time <= schedule.start_time AND class_end_time >= schedule.end_time)
        );

    IF EXISTS(SELECT * FROM enrollment WHERE user_id= p_user_id AND class_id= p_class_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The user has already enrolled in this class';

    ELSEIF conflict_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Class schedule time conflict detected.';

    ELSE
        INSERT INTO enrollment(user_id, class_id)
        VALUES (p_user_id, p_class_id);

    END IF;
END $$

DELIMITER ;


-- PROCEDURE TO CREATE NEW EVENTS TO ANNOUNCEMENTS
DELIMITER $$

CREATE PROCEDURE create_new_announcement(
    IN p_sport_id INT,
    IN p_message TEXT,
    IN p_timestamp DATETIME
)
BEGIN
    IF EXISTS(SELECT * FROM announcement
              WHERE p_sport_id= sport_id AND p_message= message) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The announcement already exists for this sport';

    ELSEIF NOT EXISTS(SELECT sport_id FROM sport
                      WHERE p_sport_id= sport_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'There is no such sport to make an announcement for.';

    ELSEIF p_message IS NULL OR TRIM(p_message)= '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Announcement message cannot be empty';

    ELSEIF p_timestamp IS NULL THEN
        SET p_timestamp= CURRENT_TIMESTAMP;

    ELSE
        INSERT INTO announcement(sport_id, message, timestamp)
        VALUES(p_sport_id, p_message, p_timestamp);

    END IF;
END $$

DELIMITER ;


-- PROCEDURE TO CREATE NEW SUBSCRIPTIONS
DELIMITER $$

CREATE PROCEDURE create_new_subscription_for_user(
    IN p_user_id INT,
    IN p_sport_id TEXT,
    IN p_sub_date DATETIME
)
BEGIN
    IF EXISTS(SELECT * FROM subscription
              WHERE p_sport_id= sport_id AND p_user_id= user_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The subscription for this user for this sport already exists.';

    ELSEIF NOT EXISTS(SELECT sport_id FROM sport
                      WHERE p_sport_id= sport_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'There is no such sport to subscribe for.';

    ELSEIF p_sub_date IS NULL THEN
        SET p_sub_date= CURRENT_TIMESTAMP;

    ELSE
        INSERT INTO subscription(user_id,sport_id, sub_date)
        VALUES(p_user_id, p_sport_id, p_sub_date);

    END IF;
END $$






