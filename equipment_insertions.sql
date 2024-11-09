USE sports_complex;

-- Insert multiple soccer balls
INSERT INTO Equipment (Sport, Name, Number, Picture, Checked_out_user_id, Checkout_time, Due_when, `Condition`)
VALUES 
('Soccer', 'Soccer Ball', 1, NULL, 1, '2024-11-01 14:00:00', '2024-11-10 18:00:00', 'good'),
('Soccer', 'Soccer Ball', 2, NULL, NULL, NULL, NULL, 'good'),
('Soccer', 'Soccer Ball', 3, NULL, 2, '2024-11-02 09:30:00', '2024-11-08 17:00:00', 'damaged'),
('Soccer', 'Soccer Ball', 4, NULL, NULL, NULL, NULL, 'good'),
('Soccer', 'Soccer Ball', 5, NULL, 3, '2024-11-03 13:45:00', '2024-11-12 15:30:00', 'good'),
('Soccer', 'Soccer Ball', 6, NULL, NULL, NULL, NULL, 'good'),
('Soccer', 'Soccer Ball', 7, NULL, 4, '2024-11-04 15:30:00', '2024-11-10 10:00:00', 'good'),
('Soccer', 'Soccer Ball', 8, NULL, NULL, NULL, NULL, 'broken'),
('Soccer', 'Soccer Ball', 9, NULL, 5, '2024-11-05 08:00:00', '2024-11-06 08:00:00', 'good'),
('Soccer', 'Soccer Ball', 10, NULL, NULL, NULL, NULL, 'good');

-- Insert multiple tennis rackets
INSERT INTO Equipment (Sport, Name, Number, Picture, Checked_out_user_id, Checkout_time, Due_when, `Condition`)
VALUES 
('Tennis', 'Tennis Racket', 1, NULL, NULL, NULL, NULL, 'good'),
('Tennis', 'Tennis Racket', 2, NULL, 6, '2024-11-06 10:15:00', '2024-11-08 10:15:00', 'good'),
('Tennis', 'Tennis Racket', 3, NULL, NULL, NULL, NULL, 'damaged'),
('Tennis', 'Tennis Racket', 4, NULL, 7, '2024-11-06 16:00:00', '2024-11-07 16:00:00', 'good'),
('Tennis', 'Tennis Racket', 5, NULL, NULL, NULL, NULL, 'good');

-- Insert multiple badminton shuttlecocks
INSERT INTO Equipment (Sport, Name, Number, Picture, Checked_out_user_id, Checkout_time, Due_when, `Condition`)
VALUES 
('Badminton', 'Badminton Shuttlecock', 1, NULL, NULL, NULL, NULL, 'good'),
('Badminton', 'Badminton Shuttlecock', 2, NULL, NULL, NULL, NULL, 'good'),
('Badminton', 'Badminton Shuttlecock', 3, NULL, NULL, NULL, NULL, 'good'),
('Badminton', 'Badminton Shuttlecock', 4, NULL, NULL, NULL, NULL, 'good'),
('Badminton', 'Badminton Shuttlecock', 5, NULL, NULL, NULL, NULL, 'good');

-- Insert multiple basketballs
INSERT INTO Equipment (Sport, Name, Number, Picture, Checked_out_user_id, Checkout_time, Due_when, `Condition`)
VALUES 
('Basketball', 'Standard Basketball', 1, NULL, 8, '2024-11-05 10:00:00', '2024-11-07 12:00:00', 'good'),
('Basketball', 'Standard Basketball', 2, NULL, NULL, NULL, NULL, 'good'),
('Basketball', 'Standard Basketball', 3, NULL, 9, '2024-11-06 14:30:00', '2024-11-09 16:30:00', 'damaged'),
('Basketball', 'Standard Basketball', 4, NULL, NULL, NULL, NULL, 'good'),
('Basketball', 'Standard Basketball', 5, NULL, 10, '2024-11-07 08:15:00', '2024-11-10 09:30:00', 'good');
