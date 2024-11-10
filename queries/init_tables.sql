USE sports_complex;

CREATE TABLE IF NOT EXISTS Users (
    User_ID INT AUTO_INCREMENT PRIMARY KEY,
    Firstname VARCHAR(50) NOT NULL,
    Surname VARCHAR(50) NOT NULL,
    Gender ENUM('male', 'female', 'other', 'prefer_not_to_say'),
    NetID VARCHAR(50) UNIQUE,
    Card VARCHAR(20),
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(15),
    Portrait BLOB,
    Social_credit INT DEFAULT 100 CHECK (Social_credit >= 0),
    Birthday DATE,
    Proof_doc BLOB,
    `Role` ENUM('student', 'faculty', 'staff', 'worker', 'student_worker', 'affiliate', 'alumni', 'guest', 'security'),
    Member_status ENUM('active', 'expired', 'banned', 'restricted'),
    Membership_creation_date DATE,
    Outstanding_due DECIMAL(10, 2) CHECK (Outstanding_due >= 0)
);

CREATE TABLE IF NOT EXISTS Equipment (
    Equipment_ID INT AUTO_INCREMENT PRIMARY KEY,
    Sport VARCHAR(50) NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Number INT NOT NULL CHECK (Number >= 0),
    Picture BLOB,
    Checked_out_user_id INT,
    Checkout_time DATETIME,
    Due_when DATETIME,
    -- Anar: Warning: Condition must be written in `BACKTICKS` because it's apparently a reserved word in MySQL :/  
    `Condition` ENUM('good', 'damaged', 'broken') DEFAULT 'good',
    UNIQUE(Sport, Name, Number),
    FOREIGN KEY (Checked_out_user_id) REFERENCES Users(User_ID) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS Notifications (
    Notif_ID INT AUTO_INCREMENT PRIMARY KEY,
    To_whom INT NOT NULL,
    Message TEXT NOT NULL,
    Notification_type ENUM('reminder', 'warning', 'general'),
    Status ENUM('Sent', 'Pending', 'Failed', 'Reply_received') DEFAULT 'Pending',
    Send_date DATETIME,
    FOREIGN KEY (To_whom) REFERENCES Users(User_ID) ON DELETE CASCADE 
);
