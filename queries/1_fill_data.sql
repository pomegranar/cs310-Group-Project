USE sports;

INSERT INTO user (netid, card_number, first_name, last_name, gender, birthday, role) VALUES
('an301', '112233', 'Anar', 'Nyambayar', 'male', '2005-01-01', 'student'),
('srb94', '696969', 'Sean', 'Bugarin', 'male', '2004-08-11', 'student'),
('de82', '420420', 'Doniyor', 'Erkinov', 'male', '2003-11-01', 'student'),
('mm940', '1104380', 'Mustafa', 'Misir', 'male', '1900-4-05', 'faculty'), -- Couldn't find his birthday
('aa846', '32134243', 'Avidikhuu', 'Altangerel', 'male', '2005-11-01', 'student');

INSERT INTO membership (user_id, start_date, end_date, state) VALUES
(1, '2024-08-13', '2025-08-13', 'active'),
(2, '2024-08-13', '2025-08-13', 'active'),
(3, '2024-08-13', '2025-08-13', 'active'),
(4, '2024-08-13', '2025-08-13', 'active'),
(5, '2023-08-13', '2024-08-13', 'expired');


INSERT INTO sport (name) VALUES
('Basketball'),
('Volleyball'),
('Badminton'),
('Billiards'),
('Table Tennis'),
('Tennis'),
('Squash'),
('Football'),
('American Football'),
('Ultimate Frisbee'),
('Dance'),
('Climbing'),
('Cycling');

INSERT INTO equipment (sport_id, name, number) VALUES
(1, 'ball', 1),
(1, 'ball', 2),
(1, 'ball', 3),
(1, 'ball', 4),
(1, 'ball', 5),
(1, 'ball', 6),
(2, 'ball', 1),
(2, 'ball', 2),
(2, 'ball', 3),
(2, 'ball', 4),
(8, 'ball', 1),
(8, 'ball', 2),
(8, 'ball', 3),
(8, 'ball', 4),
(12, 'shoes-40', 1),
(12, 'shoes-40', 2),
(12, 'shoes-36', 1),
(12, 'shoes-36', 2),
(7, 'racquet', 1),
(7, 'racquet', 2),
(7, 'racquet', 3),
(7, 'racquet', 4);

INSERT INTO facility (name, reservable, floor) VALUES
('Basketball Court', TRUE, 1),
('Tennis Court', TRUE, 1),
('Squash Room', TRUE, 4),
('Badminton Court', TRUE, 1);


INSERT INTO class(sport_id, instructor_id, location) VALUES
(1,  3, 1);



INSERT INTO schedule(class_id, day_of_week, start_time, end_time) VALUES
(1, 'Monday', '2024-12-02 08:00:00', '2024-12-02 08:00:00'),
(1, 'Wednesday', '2024-12-02 08:00:00', '2024-12-02 08:00:00');


