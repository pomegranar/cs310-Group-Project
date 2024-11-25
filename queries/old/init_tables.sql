USE sports_complex;
-- hello Donik!!!
DROP TABLE IF EXISTS notifications;
DROP TABLE IF EXISTS checkout_record;
DROP TABLE IF EXISTS equipment;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    firstname VARCHAR(50) NOT NULL,
    surname VARCHAR(50) NOT NULL,
    gender ENUM('male', 'female', 'other', 'prefer_not_to_say'),
    netid VARCHAR(50) UNIQUE,
    card VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    portrait BLOB,
    social_credit INT DEFAULT 100 CHECK (social_credit >= 0),
    birthday DATE,
    proof_doc BLOB,
    `Role` ENUM('student', 'faculty', 'staff', 'worker', 'student_worker',
        'affiliate', 'alumni', 'guest', 'security'),
    member_status ENUM('active', 'expired', 'banned', 'restricted'),
    membership_creation_date DATE,
    outstanding_due DECIMAL(10, 2) CHECK (outstanding_due >= 0)
);

CREATE TABLE equipment (
    equipment_id INT AUTO_INCREMENT PRIMARY KEY,
    sport VARCHAR(50) NOT NULL,
    name VARCHAR(100) NOT NULL,
    number INT NOT NULL CHECK (number >= 0),
    picture BLOB,
    checked_out_user_id INT,
    checkout_time DATETIME,
    due_when DATETIME,
    -- Anar: Warning: Condition must be written in `BACKTICKS` because it's apparently a reserved word in MySQL :/
    `condition` ENUM('good', 'damaged', 'broken') DEFAULT 'good',
    UNIQUE(sport, name, number),
    FOREIGN KEY (checked_out_user_id) REFERENCES users(user_id) ON DELETE SET NULL
);

CREATE TABLE  checkout_record(
    checkout_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    equipment_id INT,
    check_out_date DATETIME,
    due_date DATETIME DEFAULT (DATE_ADD(CURRENT_DATE(), INTERVAL 1 DAY)),
    actual_return_date DATETIME,
    fine numeric(4,2),
    FOREIGN KEY (equipment_ID) REFERENCES equipment (equipment_id),
    FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE
);

CREATE TABLE notifications (
    notif_id INT AUTO_INCREMENT PRIMARY KEY,
    to_whom INT NOT NULL,
    message TEXT NOT NULL,
    notification_type ENUM('reminder', 'warning', 'general'),
    Status ENUM('sent', 'pending', 'failed', 'reply_received') DEFAULT 'pending',
    Send_date DATETIME,
    referred_checkout_id INT,
    FOREIGN KEY (to_whom) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (referred_checkout_id) REFERENCES checkout_record(checkout_id) ON DELETE CASCADE
);

