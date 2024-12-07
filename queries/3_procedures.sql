DELIMITER //

-- FACILITY RESERVATIONS PROCEDURE
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


-- CHECKOUT PROCEDURE
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