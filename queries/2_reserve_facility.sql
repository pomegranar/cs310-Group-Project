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

    -- Calculate reservation duration in minutes
    SET reservation_duration = TIME_TO_SEC(p_end_time) / 60 - TIME_TO_SEC(p_start_time) / 60;

    -- Check for time conflicts
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
    ELSE
        INSERT INTO reservation (user_id, facility_id, reserve_date, start_time, end_time)
        VALUES (p_user_id, p_facility_id, p_reserve_date, p_start_time, p_end_time);
    END IF;
END //

DELIMITER ;
