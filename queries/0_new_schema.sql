DROP DATABASE IF EXISTS sports;

CREATE DATABASE sports;

USE sports;

CREATE TABLE
    user(
        user_id 	INT PRIMARY KEY AUTO_INCREMENT,
        netid 		VARCHAR(10) UNIQUE,
        card_number VARCHAR(20) UNIQUE,
        first_name 	VARCHAR(50) NOT NULL,
        last_name	VARCHAR(50),
        gender 		ENUM('male', 'female', 'other', 'undisclosed'),
        birthday 	DATE, -- Age will be dynamically calculated in queries since it's a derived attribute.
        role 		ENUM(
            'student',
            'faculty',
            'staff',
            'worker',
            'student_worker',
            'affiliate',
            'alumni',
            'guest',
            'security',
            'other'
        )
    );

CREATE TABLE
    contact (
        contact_id 	INT PRIMARY KEY AUTO_INCREMENT,
        user_id 	INT NOT NULL,
        info 		VARCHAR(100),
        info_type 	ENUM('phone', 'email', 'address', 'emergency'),
        FOREIGN KEY (user_id) REFERENCES user(user_id)
    );

CREATE TABLE
    membership (
        membership_id 	INT PRIMARY KEY AUTO_INCREMENT,
        user_id 		INT,
        start_date 		DATE,
        end_date 		DATE,
        state 			ENUM('active', 'expired', 'pending', 'suspended'),
        admin_notes 	VARCHAR(200),
        FOREIGN KEY (user_id) REFERENCES user(user_id)
    );


CREATE TABLE
    sport (
        sport_id 	INT PRIMARY KEY AUTO_INCREMENT,
        name 		VARCHAR(200)
    );


CREATE TABLE
    equipment (
        equipment_id INT PRIMARY KEY AUTO_INCREMENT,
        name 		VARCHAR(100) NOT NULL,
        number 		INT CHECK (number >= 0), -- i.e. Ball #2, Ball #6, Bike #3
        equipment_availability ENUM('available', 'borrowed', 'not returned on time') DEFAULT 'available',
        admin_note 	TEXT,
        sport_id 	INT,
        FOREIGN KEY (sport_id) REFERENCES sport (sport_id)
    );


CREATE TABLE
    penalty (
        penalty_id 	INT PRIMARY KEY AUTO_INCREMENT,
        user_id 	INT,
        fee 		DECIMAL(10, 2),
        equipment_id 		INT,
        issued_date DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES user(user_id),
        FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id)
    );


CREATE TABLE
    subscription (
        subscription_id INT PRIMARY KEY AUTO_INCREMENT,
        user_id 		INT NOT NULL,
        sport_id 		INT NOT NULL,
        sub_date 		DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES user(user_id),
        FOREIGN KEY (sport_id) REFERENCES sport (sport_id)
    );


CREATE TABLE
    facility (
        facility_id INT PRIMARY KEY AUTO_INCREMENT,
        name 		VARCHAR(100) NOT NULL,
        reservable 	BOOLEAN NOT NULL,
        floor 		INT NOT NULL
    );


CREATE TABLE
    class (
        class_id 		INT PRIMARY KEY AUTO_INCREMENT,
        sport_id 		INT,
        instructor_id 	INT NOT NULL,
        location 		INT,
        schedule 		TEXT, -- Maybe we can expand this into a multivariable attribute with timestamp values for each day of the week?
        FOREIGN KEY (sport_id) REFERENCES sport (sport_id),
        FOREIGN KEY (instructor_id) REFERENCES user(user_id),
        FOREIGN KEY (location) REFERENCES facility (facility_id)
    );


CREATE TABLE
    reservation (
        reservation_id 	INT PRIMARY KEY AUTO_INCREMENT,
        user_id 		INT,
        facility_id 	INT,
        reserve_date 	DATE,
        start_time		TIME NOT NULL,
        end_time		TIME NOT NULL,
        FOREIGN KEY (user_id) REFERENCES user(user_id),
        FOREIGN KEY (facility_id) REFERENCES facility (facility_id),
        CONSTRAINT unique_reservation UNIQUE (facility_id, reserve_date, start_time, end_time)
    );


CREATE TABLE
    borrowed (
        borrow_id 	INT PRIMARY KEY AUTO_INCREMENT,
        user_id 	INT NOT NULL,
        equipment_id INT NOT NULL,
        borrow_date DATETIME DEFAULT CURRENT_TIMESTAMP,
        due_date 	DATETIME DEFAULT CURRENT_TIMESTAMP,
        returned_on DATETIME DEFAULT NULL,
        FOREIGN KEY (user_id) REFERENCES user(user_id),
        FOREIGN KEY (equipment_id) REFERENCES equipment (equipment_id)
    );


CREATE TABLE
    notification (
        notification_id INT PRIMARY KEY AUTO_INCREMENT,
        user_id 		INT,
        message 		TEXT,
        timestamp 		DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES user(user_id)
    );

CREATE TABLE
    announcement (
        announcement_id INT PRIMARY KEY AUTO_INCREMENT,
        sport_id 		INT,
        message 		TEXT,
        timestamp 		DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (sport_id) REFERENCES sport (sport_id)
    );

CREATE TABLE
    enrollment (
        enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
        user_id 	INT,
        class_id 	INT,
        FOREIGN KEY (user_id) REFERENCES user(user_id),
        FOREIGN KEY (class_id) REFERENCES class (class_id)
    );
