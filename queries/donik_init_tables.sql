CREATE TABLE User (
    user_ID INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    net_ID VARCHAR(50),
    Card VARCHAR(20),
    email VARCHAR(100),
    phone VARCHAR(15),
    portrait BLOB,
    social_credit_score NUMERIC(4, 0) DEFAULT 100,
    birthday DATE,
    proof_doc BLOB,
    `role` ENUM('student', 'faculty', 'staff', 'worker', 'student_worker', 'affiliate', 'alumni', 'guest', 'security'),
    member_status ENUM('active', 'expired', 'banned', 'restricted'),
    membership_creation_date DATE,
    outstanding_due DECIMAL(10, 2)
);

CREATE TABLE Equipment (
    equipment_ID INT AUTO_INCREMENT PRIMARY KEY,
    sport VARCHAR(50),
    name VARCHAR(100),
    number INT,
    picture BLOB,
    -- Anar: Warning: Condition must be written in `BACKTICKS` because it's apparently a reserved word in MySQL :/
    status ENUM('good', 'damaged', 'broken')
);

CREATE TABLE Notification(
    notif_ID INT AUTO_INCREMENT PRIMARY KEY,
    to_whom INT,
    message TEXT,
    status ENUM('Sent', 'Pending', 'Failed', 'Reply_received'),
    send_date DATETIME,
    FOREIGN KEY (to_whom) REFERENCES User(user_ID)
);

CREATE TABLE Checkout_Record(
    check_out_ID INT AUTO_INCREMENT PRIMARY KEY,
    user_ID INT,
    equipment_ID INT,
    check_out_date DATETIME,
    due_date DATETIME,
    actual_return_date DATETIME,
    fine numeric(4,2),
    FOREIGN KEY (equipment_ID) REFERENCES Equipment (equipment_ID),
    FOREIGN KEY (user_ID) REFERENCES User (user_ID)
);
