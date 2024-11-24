DROP DATABASE IF EXISTS sports;
CREATE DATABASE sports;
USE sports;

CREATE TABLE user (
    user_id 		INT PRIMARY KEY AUTO_INCREMENT,
	netid 			VARCHAR(10) UNIQUE,
    first_name 		VARCHAR(50) NOT NULL,
    last_name 		VARCHAR(50),
    gender			ENUM('male', 'female', 'other', 'undisclosed'),
    birthday 		DATE, -- Age will be dynamically calculated in queries since it's a derived attribute.
    email 			VARCHAR(100),
    telephone	 	VARCHAR(15),
    emergency_contact VARCHAR(255), -- Emergency contact can simply be a long varchar or text since only real humans will read it anyways.
    member_status 	BOOLEAN DEFAULT FALSE
);

CREATE TABLE membership (
    membership_id 	INT PRIMARY KEY AUTO_INCREMENT,
    user_id 		INT,
    start_date 		DATE,
    end_date 		DATE,
    state 			ENUM ('active', 'expired', 'pending', 'suspended'),
    admin_notes 	VARCHAR(200),
    FOREIGN KEY (user_id) REFERENCES user(user_id)
);

CREATE TABLE penalty (
    penalty_id 	INT PRIMARY KEY AUTO_INCREMENT,
    user_id 	INT,
    fee 		DECIMAL(10, 2),
    reason 		TEXT,
    issued_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES user(user_id)
);

CREATE TABLE sport (
    sport_id 	INT PRIMARY KEY AUTO_INCREMENT,
    name 		VARCHAR(200)
);

CREATE TABLE subscription (
    subscription_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id         INT NOT NULL,
    sport_id        INT NOT NULL,
    sub_date 		DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (sport_id) REFERENCES sport(sport_id)
);

CREATE TABLE instructor (
    instructor_id 	INT PRIMARY KEY AUTO_INCREMENT,
    name 			VARCHAR(100),
    contact_info 	VARCHAR(255)
);

CREATE TABLE facility (
    facility_id INT PRIMARY KEY AUTO_INCREMENT,
    name 		VARCHAR(100) NOT NULL,
    reservable	BOOLEAN NOT NULL,
    floor	 	INT NOT NULL
);

CREATE TABLE class (
    class_id 		INT PRIMARY KEY AUTO_INCREMENT,
    sport_id 		INT,
    instructor_id 	INT NOT NULL,
    location	 	INT,
    schedule 		TEXT, -- Maybe we can expand this into a multivariable attribute with timestamp values for each day of the week?
    FOREIGN KEY (sport_id) REFERENCES sport(sport_id),
    FOREIGN KEY (instructor_id) REFERENCES instructor(instructor_id),
	FOREIGN KEY (location) REFERENCES facility(facility_id)
);

CREATE TABLE reservation (
    reservation_id 	INT PRIMARY KEY AUTO_INCREMENT,
    user_id 		INT,
    facility_id 	INT,
    reserve_date 	DATE,
    time_slot 		VARCHAR(50), -- How can we constrain this to one hour and check for time conflicts?
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (facility_id) REFERENCES facility(facility_id)
);

CREATE TABLE equipment (
    equipment_id INT PRIMARY KEY AUTO_INCREMENT,
    name 		 VARCHAR(100) NOT NULL,
    number		 INT CHECK (number >= 0), -- i.e. Ball #2, Ball #6, Bike #3
    admin_note	 TEXT,
    sport_id 	 INT,
    FOREIGN KEY (sport_id) REFERENCES sport(sport_id)
);

CREATE TABLE borrowed (
    borrow_id 		INT PRIMARY KEY AUTO_INCREMENT,
    user_id 		INT,
    equipment_id 	INT,
    borrow_date 	DATETIME DEFAULT CURRENT_TIMESTAMP,
    return_date 	DATETIME DEFAULT CURRENT_TIMESTAMP,
    last_returned	DATETIME,
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id)
);

CREATE TABLE notification (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id 		INT,
    message 		TEXT,
    timestamp 		DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES user(user_id)
);

CREATE TABLE announcement (
    announcement_id INT PRIMARY KEY AUTO_INCREMENT,
    sport_id 		INT,
    message 		TEXT,
    timestamp 		DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sport_id) REFERENCES sport(sport_id)
);

CREATE TABLE enrollment (
    enrollment_id 	INT PRIMARY KEY AUTO_INCREMENT,
    user_id 		INT,
    class_id 		INT,
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (class_id) REFERENCES class(class_id)
);
