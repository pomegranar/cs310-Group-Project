CREATE DATABASE IF NOT EXISTS sports;
use sports;

DROP TABLE IF EXISTS user;

CREATE TABLE user (
	userID 		INT AUTO_INCREMENT,
	netID		VARCHAR(8) UNIQUE,
	firstname	VARCHAR(50) NOT NULL,
	surname 	VARCHAR(50),
	gender		ENUM('male', 'female', 'other', 'undisclosed'),
	card_number		INT UNIQUE,
	email 		VARCHAR(100),
	phone_number	BIGINT UNIQUE CHECK(length(phone_number)<= 15),
	emergency_contact	INT,
	PRIMARY KEY (userID),
	FOREIGN KEY (emergency_contact)	REFERENCES emergency_info (emergency_contactID),
	CONSTRAINT 	chk_contact_em_contact CHECK (user.phone_number != emergency_contact)
);


DROP TABLE IF EXISTS emergency_info;

CREATE TABLE emergency_info (
	emergency_contactID     INT AUTO_INCREMENT,
	firstname	VARCHAR(50) NOT NULL,
    surname     VARCHAR(50) NOT NULL,
	phone_number BIGINT UNIQUE CHECK(length(phone_number)<= 15),
	email 		VARCHAR(100),
    relationship ENUM ('parent', 'sibling', 'friend', 'coursemate', 'other') NOT NULL,
	PRIMARY KEY (emergency_contactID)
);


DROP TABLE IF EXISTS membership;

CREATE TABLE membership (
    membershipID INT AUTO_INCREMENT,
    userID   INT,
    start_date DATE,
    end_date DATE,
    status ENUM ('Active', 'Expired', 'Cancelled'),
    additional_notes VARCHAR(200),
    PRIMARY KEY (membershipID),
    FOREIGN KEY (userID) REFERENCES user (userID)
);


DROP TABLE IF EXISTS sport;

CREATE TABLE sport(
    sportID INT AUTO_INCREMENT,
    name VARCHAR(60),
    description VARCHAR(150),
    status ENUM ('active', 'unavailable'),
    PRIMARY KEY (sportID)
);


DROP TABLE IF EXISTS  facility;

CREATE TABLE facility(
    facilityID INT AUTO_INCREMENT,
    name VARCHAR(40),
    type ENUM ('indoor', 'outdoor'),
    capacity INT CHECK(length(capacity)<= 3),
    PRIMARY KEY  (facilityID)
);


DROP TABLE IF EXISTS instructor;

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


DROP TABLE IF EXISTS session;

CREATE TABLE session(
    sessionID INT AUTO_INCREMENT,
    instructorID INT,
    facilityID INT,
    name VARCHAR(50),
    year NUMERIC(4, 0) CHECK (year> 2018 AND year<2100),
    time_slotID INT,
    PRIMARY KEY (sessionID),
    FOREIGN KEY (time_slotID) REFERENCES time_slot(time_slotID)
);


DROP TABLE IF EXISTS time_slot;

CREATE TABLE time_slot(
    time_slotID INT AUTO_INCREMENT,
    day  VARCHAR(40) CHECK (day in ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')),
    start_time TIME,
    end_time TIME,
    PRIMARY KEY  (time_slotID)
);


DROP TABLE IF EXISTS booking;

# CREATE TABLE booking(
#     bookingID INT AUTO_INCREMENT,
#     memberID INT,
#     facilityID INT,
#
# )







DROP TABLE IF EXISTS equipment;
DROP TABLE IF EXISTS space;
DROP TABLE IF EXISTS class;
DROP TABLE IF EXISTS notifs;
DROP TABLE IF EXISTS record;
DROP VIEW IF EXISTS suspendeds;
DROP TRIGGER IF EXISTS on_reservation;
