USE sports;

-- DROP TRIGGER apply_penalty_overdue_equipment;
-- DROP TRIGGER prevent_duplicate_borrow;
-- DROP TRIGGER update_equipment_on_borrow;
-- DROP TRIGGER prevent_borrowed_equipment_borrow;


## TRIGGER to apply penalty for users who hasn't returned the borrowed equipment
DELIMITER $$

CREATE TRIGGER apply_penalty_overdue_equipment
    AFTER INSERT ON borrowed
    FOR EACH ROW
    BEGIN
    IF NEW.returned_on IS NULL AND NEW.due_date < NOW() THEN
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


## TRIGGER to avoid imposing multiple penalty fees for a user who already has that penalty
DELIMITER $$

CREATE TRIGGER prevent_duplicate_borrow
    BEFORE INSERT ON borrowed
    FOR EACH ROW
    BEGIN
        IF EXISTS(
            SELECT borrow_id FROM borrowed
            WHERE user_id= NEW.user_id AND equipment_id= NEW.equipment_id
                ) THEN SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT= 'User already has a penalty for this equipment';
            END IF;
    END $$

DELIMITER ;


## TRIGGER that updates the equipment status once it is borrowed by a user
DELIMITER $$
CREATE TRIGGER update_equipment_on_borrow
    AFTER INSERT ON borrowed
    FOR EACH ROW
    BEGIN
        UPDATE equipment
        SET equipment_availability= 'borrowed'
        WHERE equipment_id= NEW.equipment_id;
    END $$

DELIMITER ;


## TRIGGER that updates the equipment status once it is returned by the user
DELIMITER $$
CREATE TRIGGER update_equipment_on_return
    AFTER UPDATE ON borrowed
    FOR EACH ROW
    BEGIN
        UPDATE equipment
        SET equipment_availability= 'available'
        WHERE equipment_id= NEW.equipment_id AND returned_on IS NOT NULL;
    END $$

DELIMITER ;


## TRIGGER to preventing a borrowed equipment to be borrowed again
DELIMITER $$

CREATE TRIGGER prevent_borrowed_equipment_borrow
    BEFORE INSERT ON borrowed
    FOR EACH ROW
    BEGIN
        IF EXISTS(
            SELECT equipment_id FROM equipment
            WHERE equipment_availability= 'borrowed'
                ) THEN SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT= 'The equipment was already borrowed! Please borrow another equipment';
            END IF;
    END $$

DELIMITER ;




CREATE PROCEDURE user_return_equipment()





DELETE FROM borrowed;
DELETE FROM penalty;


INSERT INTO borrowed(user_id, equipment_id, borrow_date, due_date, returned_on)
VALUES(4, 6, '2024-12-04', '2024-12-05', NULL);


SELECT * FROM penalty;

SELECT * FROM borrowed;

SELECT * FROM equipment;


