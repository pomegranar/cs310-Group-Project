CREATE DATABASE IF NOT EXISTS sports;
use sports;

DROP TABLE IF EXISTS user; --
DROP TABLE IF EXISTS contact; --
DROP TABLE IF EXISTS membership;
DROP TABLE IF EXISTS sport;
DROP TABLE IF EXISTS facility;
DROP TABLE IF EXISTS instructor;
DROP TABLE IF EXISTS session;
DROP TABLE IF EXISTS time_slot;

DROP TABLE IF EXISTS equipment;
DROP TABLE IF EXISTS class;
DROP TABLE IF EXISTS notifs;
DROP TABLE IF EXISTS record;
DROP TABLE IF EXISTS booking;
DROP TABLE IF EXISTS session_enrollment;
DROP VIEW IF EXISTS suspendeds;
DROP TRIGGER IF EXISTS on_reservation;



CREATE TABLE user (
	userid 		INT AUTO_INCREMENT,
	netid		VARCHAR(8) UNIQUE,
	firstname	VARCHAR(50) NOT NULL,
	surname 	VARCHAR(50),
	gender		ENUM('male', 'female', 'other', 'undisclosed'),
	card_number	INT UNIQUE, -- This is the code from the card scanner.
	email 		VARCHAR(100),
	phone_number	BIGINT UNIQUE CHECK(length(phone_number)<= 15),
	emergency_contact	INT,
	PRIMARY KEY (userID),
	FOREIGN KEY (emergency_contact)	REFERENCES contact (emergency_contactID),
	CONSTRAINT 	chk_contact_em_contact CHECK (user.phone_number != emergency_contact)
);

CREATE TABLE contact (
	emergency_contactID     INT AUTO_INCREMENT,
	firstname	VARCHAR(50) NOT NULL,
    surname     VARCHAR(50) NOT NULL,
	phone_number BIGINT UNIQUE CHECK(length(phone_number)<= 15),
	email 		VARCHAR(100),
    relationship ENUM ('parent', 'sibling', 'friend', 'coursemate', 'other') NOT NULL,
	PRIMARY KEY (emergency_contactID)
);



CREATE TABLE membership (
    membershipID INT AUTO_INCREMENT,
    userID   INT,
    start_date DATE,
    end_date DATE,
    status ENUM ('active', 'expired', 'cancelled'),
    additional_notes VARCHAR(200),
    PRIMARY KEY (membershipID),
    FOREIGN KEY (userID) REFERENCES user (userID)
);


CREATE TABLE sport(
    sportID INT AUTO_INCREMENT,
    name VARCHAR(60),
    description VARCHAR(150),
    status ENUM ('active', 'unavailable') DEFAULT 'active',
    PRIMARY KEY (sportID)
);



CREATE TABLE facility(
    facilityID INT AUTO_INCREMENT,
    sportID INT,
    description VARCHAR(100),
    type ENUM ('indoor', 'outdoor'),
    capacity INT CHECK(length(capacity)<= 3),
    PRIMARY KEY  (facilityID),
    FOREIGN KEY (sportID) REFERENCES sport(sportID)
);


CREATE TABLE instructor(
    instructorID INT AUTO_INCREMENT,
    firstname	VARCHAR(50) NOT NULL,
	surname 	VARCHAR(50),
	gender		ENUM('male', 'female', 'other', 'undisclosed'),
	email 		VARCHAR(100),
    sportID INT,
    PRIMARY KEY (instructorID),
    FOREIGN KEY (sportID) REFERENCES sport(sportID)
);


CREATE TABLE session(
    sessionID INT AUTO_INCREMENT,
    instructorID INT,
    facilityID INT,
    time_slotID INT,
    name VARCHAR(50),
    year NUMERIC(4, 0) CHECK (year> 2018 AND year<2100),
    semester VARCHAR(30) CHECK (semester IN ('fall', 'spring')),
    PRIMARY KEY (sessionID),
    FOREIGN KEY (time_slotID) REFERENCES time_slot(time_slotID),
    FOREIGN KEY (instructorID) REFERENCES  instructor(instructorID),
    FOREIGN KEY (facilityID) REFERENCES facility(facilityID)
);



CREATE TABLE time_slot(
    time_slotID INT AUTO_INCREMENT,
    day  VARCHAR(40) CHECK (day in ('monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday')),
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    PRIMARY KEY  (time_slotID)
);


CREATE TABLE booking(
    bookingID INT AUTO_INCREMENT,
    memberID INT,
    facilityID INT,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    status ENUM ('active', 'cancelled') DEFAULT 'active',
    PRIMARY KEY (bookingID),
    FOREIGN KEY (memberID) REFERENCES membership(membershipID),
    FOREIGN KEY (facilityID) REFERENCES facility(facilityID)
);



CREATE TABLE session_enrollment(
    enrollmentID INT AUTO_INCREMENT,
    membershipID INT,
    sessionID INT,
    enrollment_date DATE NOT NULL,
    attendance_status ENUM ('enrolled', 'dropped') DEFAULT 'enrolled',
    PRIMARY KEY (enrollmentID),
    FOREIGN KEY (membershipID) REFERENCES membership(membershipID),
    FOREIGN KEY (sessionID) REFERENCES session(sessionID)
);





