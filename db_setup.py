import mysql.connector

password = input("Enter password, but be warned as it will be visible: ")

# Establish connection to MySQL
conn = mysql.connector.connect(
    host="localhost",
    user="root",  # Replace with your MySQL username
    password=password  # Replace with your MySQL password
)

cursor = conn.cursor()

# Create database if it doesn't exist
cursor.execute("CREATE DATABASE IF NOT EXISTS sports_complex")
cursor.execute("USE sports_complex")

# Create Users table
cursor.execute("""
CREATE TABLE IF NOT EXISTS Users (
    User_ID INT AUTO_INCREMENT PRIMARY KEY,
    Firstname VARCHAR(50),
    Surname VARCHAR(50),
    NetID VARCHAR(50),
    Card VARCHAR(20),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    Portrait BLOB,
    Social_credit INT DEFAULT 100,
    Birthday DATE,
    Proof_doc BLOB,
    `Role` ENUM('student', 'faculty', 'staff', 'worker', 'student_worker', 'affiliate', 'alumni', 'guest', 'security'),
    Member_status ENUM('active', 'expired', 'banned', 'restricted'),
    Membership_creation_date DATE,
    Outstanding_due DECIMAL(10, 2)
)""")

# Create Equipment table
cursor.execute("""
CREATE TABLE IF NOT EXISTS Equipment (
    Equipment_ID INT AUTO_INCREMENT PRIMARY KEY,
    Sport VARCHAR(50),
    Name VARCHAR(100),
    Number INT,
    Picture BLOB,
    Checked_out_user_id INT,
    Checkout_time DATETIME,
    Due_when DATETIME,
    -- Anar: Warning: Condition must be written in `BACKTICKS` because it's apparently a reserved word in MySQL :/  
    `Condition` ENUM('good', 'damaged', 'broken'),
    FOREIGN KEY (Checked_out_user_id) REFERENCES Users(User_ID)
)""")

# Create Notifications table
cursor.execute("""
CREATE TABLE IF NOT EXISTS Notifications (
    Notif_ID INT AUTO_INCREMENT PRIMARY KEY,
    To_whom INT,
    Message TEXT,
    Status ENUM('Sent', 'Pending', 'Failed', 'Reply_received'),
    Send_date DATETIME,
    FOREIGN KEY (To_whom) REFERENCES Users(User_ID)
)""")

cursor.close()
conn.close()
print("Database setup complete.")
