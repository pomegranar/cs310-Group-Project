USE sports;

-- DROP TRIGGER set_due_date
-- DROP TRIGGER apply_penalty_overdue_equipment;
-- DROP TRIGGER prevent_duplicate_borrow;
-- DROP TRIGGER send_reminder_to_return;
-- DROP TRIGGER penalty_notification;


-- TRIGGER to set the due date and time to specifically 9pm the current day.
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


-- TRIGGER to avoid making a user to borrow the same item multiple time before the user returns the item
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



-- TRIGGER to send notifications to a user who is subscribed for an event
DELIMITER $$

CREATE TRIGGER announcement_notification
    AFTER INSERT ON announcement
    FOR EACH ROW
    BEGIN
        DECLARE user_count INT DEFAULT 0; -- number of users subscribed to a particular sport announcements
        DECLARE index_num INT DEFAULT 0;

        SELECT COUNT(*) INTO user_count
        FROM subscription
        WHERE sport_id= NEW.sport_id;

        -- derive the user_id for the current index
        WHILE index_num < user_count DO
            INSERT INTO notification(user_id, message, timestamp)
            SELECT
                    subscription.user_id,
            CONCAT('Dear ', user.first_name, ' ', user.last_name, ' you are receiving a new notification for the following sport: ', sport.name , '.',
                       'The message content is: ', NEW.message),
            NOW()
            FROM subscription
            JOIN user USING (user_id)
            JOIN sport USING (sport_id)
            WHERE subscription.sport_id= NEW.sport_id;

            SET index_num= index_num + 1;

        END WHILE;

    END $$




