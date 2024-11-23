CREATE DATABASE IF NOT EXISTS sports;

DROP TABLE IF EXISTS user;
CREATE TABLE users (
	id 			INT AUTO_INCREMENT,
	netid		VARCHAR(10) UNIQUE,
	firstname	VARCHAR(50) NOT NULL,
	surname 	VARCHAR(50),
	gender		ENUM('male', 'female', 'other', 'undisclosed'),
	cardnum		INT UNIQUE,
	email 		VARCHAR(100),
	contact		INT UNIQUE,
	emergency	INT,
	PRIMARY KEY (id),
	FOREIGN KEY (contact) 	REFERENCES contact (id),
	FOREIGN KEY (emergency)	REFERENCES contact (id),
	CONSTRAINT 	chk_contact_em_contact CHECK (contact != emergency)
);

DROP TABLE IF EXISTS contact;
CREATE TABLE contact (
	id 			INT AUTO_INCREMENT,
	fullname	VARCHAR(50) NOT NULL,
	number1		INT NOT NULL,
	number2		INT,
	PRIMARY KEY (id)
);

DROP TABLE IF EXISTS membership;
DROP TABLE IF EXISTS equipment;
DROP TABLE IF EXISTS space;
DROP TABLE IF EXISTS class;
DROP TABLE IF EXISTS notifs;
DROP TABLE IF EXISTS record;
DROP VIEW IF EXISTS suspendeds;
DROP TRIGGER IF EXISTS on_reservation;
