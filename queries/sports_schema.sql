IF NOT EXISTS CREATE DATABASE sports;

IF EXISTS DROP user;
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
)

IF EXISTS DROP contact;
CREATE TABLE contact (
	id 			INT AUTO_INCREMENT,
	fullname	VARCHAR(50) NOT NULL,
	number1		INT NOT NULL,
	number2		INT,
	PRIMARY KEY (id)
)

IF EXISTS DROP equipment;
IF EXISTS DROP space;
IF EXISTS DROP class;
IF EXISTS DROP notifs;
IF EXISTS DROP record;

