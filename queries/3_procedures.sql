USE sports;

-- DROP PROCEDURE reserve_facility;
-- DROP PROCEDURE checkout_equipment;
-- DROP PROCEDURE register_user;


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

    IF conflict_count > 0 THEN
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
    WHERE user_id = p_user_id AND equipment_id = p_equipment_id AND returned_on IS NULL;

    IF existing_checkouts > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Equipment unavailable.';
    ELSE
        INSERT INTO borrowed (user_id, equipment_id)
        VALUES (p_user_id, p_equipment_id);
    END IF;
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









