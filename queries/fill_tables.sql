-- Users table insertions
INSERT INTO Users (Firstname, Surname, Gender, NetID, Card, Email, Phone, Social_credit, Birthday, Role, Member_status, Membership_creation_date, Outstanding_due) VALUES
-- Students
('John', 'Smith', 'male', 'js2024', 'CARD001', 'js2024@edu.com', '555-0101', 100, '2000-03-15', 'student', 'active', '2023-08-20', 0.00),
('Emma', 'Johnson', 'female', 'ej2023', 'CARD002', 'ej2023@edu.com', '555-0102', 95, '2001-06-22', 'student', 'active', '2023-08-21', 5.50),
('Michael', 'Williams', 'male', 'mw2025', 'CARD003', 'mw2025@edu.com', '555-0103', 100, '1999-11-30', 'student', 'active', '2023-08-20', 0.00),
-- Continue with more student entries...

-- Faculty
('Sarah', 'Davis', 'female', 'sd_fac', 'CARD031', 'sd_fac@edu.com', '555-0131', 100, '1975-04-18', 'faculty', 'active', '2022-01-15', 0.00),
('Robert', 'Wilson', 'male', 'rw_fac', 'CARD032', 'rw_fac@edu.com', '555-0132', 100, '1980-09-25', 'faculty', 'active', '2022-01-16', 0.00),
-- Continue with more faculty entries...

-- Staff and other roles
('Linda', 'Brown', 'female', 'lb_staff', 'CARD061', 'lb_staff@edu.com', '555-0161', 100, '1985-07-12', 'staff', 'active', '2022-03-01', 0.00),
('James', 'Taylor', 'male', 'jt_security', 'CARD062', 'jt_security@edu.com', '555-0162', 100, '1990-02-28', 'security', 'active', '2022-03-02', 0.00);
-- Continue with more entries...

-- Equipment table insertions
INSERT INTO Equipment (Sport, Name, Number, Checked_out_user_id, Checkout_time, Due_when, `Condition`) VALUES
-- Basketball equipment
('Basketball', 'Basketball', 1, NULL, NULL, NULL, 'good'),
('Basketball', 'Basketball', 2, NULL, NULL, NULL, 'good'),
('Basketball', 'Basketball', 3, NULL, NULL, NULL, 'damaged'),
('Basketball', 'Basketball', 4, NULL, NULL, NULL, 'good'),
('Basketball', 'Basketball', 5, NULL, NULL, NULL, 'good'),

-- Tennis equipment
('Tennis', 'Tennis Racket', 1, NULL, NULL, NULL, 'good'),
('Tennis', 'Tennis Racket', 2, NULL, NULL, NULL, 'good'),
('Tennis', 'Tennis Racket', 3, NULL, NULL, NULL, 'good'),
('Tennis', 'Tennis Racket', 4, NULL, NULL, NULL, 'damaged'),
('Tennis', 'Tennis Racket', 5, NULL, NULL, NULL, 'good'),

-- Soccer equipment
('Soccer', 'Soccer Ball', 1, NULL, NULL, NULL, 'good'),
('Soccer', 'Soccer Ball', 2, NULL, NULL, NULL, 'good'),
('Soccer', 'Soccer Ball', 3, NULL, NULL, NULL, 'good'),
('Soccer', 'Soccer Ball', 4, NULL, NULL, NULL, 'broken'),
('Soccer', 'Soccer Ball', 5, NULL, NULL, NULL, 'good');
-- Continue with more equipment entries...

-- Notifications table insertions
INSERT INTO Notifications (To_whom, Message, Notification_type, Status, Send_date) VALUES
(1, 'Your equipment is due tomorrow', 'reminder', 'Sent', '2024-11-09 14:30:00'),
(2, 'You have outstanding dues', 'warning', 'Sent', '2024-11-09 15:00:00'),
(3, 'Welcome to the sports complex!', 'general', 'Sent', '2024-11-09 16:00:00');
-- Continue with more notification entries...
