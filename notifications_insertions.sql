USE sports_complex;

-- Insert sample notifications
INSERT INTO Notifications (To_whom, Message, Status, Send_date)
VALUES 
(1, 'Your equipment is due soon. Please return on time.', 'Sent', '2024-11-05 10:00:00'),
(2, 'Please confirm the return of your basketball.', 'Pending', '2024-11-06 14:30:00'),
(3, 'Equipment return overdue! Fine will be applied if not returned by tomorrow.', 'Sent', '2024-11-07 15:45:00'),
(4, 'Welcome to the complex! Here are some facility guidelines.', 'Sent', '2024-11-08 08:00:00'),
(5, 'Your account has outstanding dues. Please settle by end of the month.', 'Failed', '2024-11-01 09:00:00'),
(6, 'Reminder: please check in with security upon arrival.', 'Pending', '2024-11-04 11:30:00'),
(7, 'New event coming up! Don\'t forget to RSVP.', 'Sent', '2024-11-05 13:00:00'),
(8, 'Thank you for returning the equipment on time!', 'Reply_received', '2024-11-07 16:30:00'),
(9, 'Important update on membership policy.', 'Sent', '2024-11-03 12:00:00'),
(10, 'Notification system update test.', 'Failed', '2024-11-05 11:00:00');

-- Boundary cases for Notifications table
INSERT INTO Notifications (To_whom, Message, Status, Send_date)
VALUES
(1, 'Testing with minimal message.', 'Pending', '2024-11-09 08:00:00'),
(2, 'Testing with maximum length message. ' || REPEAT('Extra data ', 20), 'Sent', '2024-11-09 09:00:00'); -- Boundary for max text length
