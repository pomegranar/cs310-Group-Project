USE sports;

-- DROP TRIGGER apply_penalty_overdue_equipment;
-- DROP TRIGGER prevent_duplicate_borrow;
-- DROP TRIGGER update_equipment_on_borrow;
-- DROP TRIGGER prevent_borrowed_equipment_borrow;


-- This trigger sets the due date and time to specifically 9pm the current day.
CREATE TRIGGER set_due_date
BEFORE INSERT ON borrowed
FOR EACH ROW
SET NEW.due_when = ADDTIME(DATE(NEW.borrow_when), '21:00:00');


-- TRIGGER to apply penalty for users who hasn't returned the borrowed equipment
DELIMITER $$

CREATE TRIGGER apply_penalty_overdue_equipment
    AFTER INSERT ON borrowed
    FOR EACH ROW
    BEGIN
    IF NEW.returned_on IS NULL AND NEW.due_when < NOW() THEN
            INSERT INTO penalty (user_id, fee, equipment_id, issued_date)
            VALUES (
                NEW.user_id,
                25.00, -- Penalty fee amount
                 NEW.equipment_id,
                NOW()
            );
        END IF;
    END$$

DELIMITER ;


-- TRIGGER to avoid imposing multiple penalty fees for a user who already has that penalty
DELIMITER $$

CREATE TRIGGER prevent_duplicate_borrow
    BEFORE INSERT ON borrowed
    FOR EACH ROW
    BEGIN
        IF EXISTS(
            SELECT borrow_id FROM borrowed
            WHERE user_id= NEW.user_id AND equipment_id= NEW.equipment_id
                ) THEN SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT= 'User has already borrowed this equipment!';
            END IF;
    END $$

DELIMITER ;


-- TRIGGER to send notification when there is an hour left before the deadline of the return time
DELIMITER $$
CREATE TRIGGER send_reminder_to_return
    AFTER INSERT ON borrowed
    FOR EACH ROW
    BEGIN
        IF NEW.returned_on IS NULL AND NEW.due_when> DATE_SUB(NOW(), INTERVAL 1 HOUR) THEN
            INSERT INTO notification(user_id, message, timestamp)
            SELECT
                    NEW.user_id,
                    CONCAT('Dear ', user.first_name, ' ', user.last_name, ', please return the following item: ', equipment.name, ' within an hour; otherwise you will be issued with a 25RMB penalty. Thank you'
                    ),
                    NOW()
            FROM user
            JOIN borrowed USING(user_id)
            JOIN equipment USING (equipment_id)
            WHERE user.user_id= NEW.user_id;
        END IF;
    END $$

DELIMITER ;


-- TRIGGER to send notification when the user has been issued a penalty
DELIMITER $$
CREATE TRIGGER penalty_notification
    AFTER INSERT ON penalty
    FOR EACH ROW
    BEGIN
        INSERT INTO notification(user_id, message, timestamp)
        SELECT
                NEW.user_id,
                CONCAT('Dear ', user.first_name, ' ', user.last_name, ' since you have not returned the item: ', equipment.name,
                       ' before the due time which was at ', borrowed.due_when, ','
                       'you will now be fined with 25 RMB penalty'),
                NOW()
        FROM user
        JOIN borrowed USING(user_id)
        JOIN equipment USING (equipment_id)
        WHERE user.user_id= NEW.user_id;
    END $$

DELIMITER ;



DELETE FROM borrowed;
DELETE FROM penalty;
DELETE FROM notification;


INSERT INTO borrowed(user_id, equipment_id, borrow_when, due_when, returned_on) VALUES
(4, 6, '2024-12-06 17:30:00', '2024-12-07 01:36:00', NULL),
(5, 3, '2024-12-06 17:30:00', '2024-12-06 23:00:00', NULL);

