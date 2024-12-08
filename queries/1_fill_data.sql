USE sports;

INSERT INTO user (netid, card_number, first_name, last_name, gender, birthday, role) VALUES
('an301', '112233', 'Anar', 'Nyambayar', 'male', '2005-01-01', 'student'),
('srb94', '696969', 'Sean', 'Bugarin', 'male', '2004-08-11', 'student'),
('de82', '420420', 'Doniyor', 'Erkinov', 'male', '2003-11-01', 'student'),
('mm940', '1104380', 'Mustafa', 'Misir', 'male', '1900-4-05', 'faculty'), -- Couldn't find his birthday
('aa846', '32134243', 'Avidikhuu', 'Altangerel', 'male', '2005-11-01', 'student');

-- all coaches have the same birthday for simplicity of filling data*
INSERT INTO user (netid, card_number, first_name, last_name, gender, birthday, role) VALUES
('jm195', '3498201', 'Jose', 'Mourinho', 'male', '1980-06-01', 'staff'),
('pg438', '5781934', 'Pep', 'Guardiola', 'male', '1980-07-01', 'staff'),
('kn702', '9027615', 'Khabib', 'Nurmagomedov','male', '1985-06-01', 'staff'),
('dc586', '6182947', 'Daniel', 'Cormier', 'male', '1982-06-01', 'staff'),
('rf314', '7458302', 'Roger', 'Federer', 'male', '1981-07-01', 'staff'),
('sw829', '1037856', 'Serena', 'Williams', 'female', '1982-08-01', 'staff');

INSERT INTO user (netid, card_number, first_name, last_name, gender, birthday, role) VALUES
( 'lj23','1238905','Lebron','James','male','1984-12-30','staff');


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

INSERT INTO sport (name) VALUES
('Brazilian jiu-jitsu'),
('Combat Sambo'),
('Boxing');

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


INSERT INTO facility (name, reservable, floor) VALUES
('Football stadium', TRUE, 1),
('Martial Arts Room', TRUE, 4),
('Table Tennis Court', TRUE, 3),
('Dance Room', TRUE, 3),
('Climbing Complex', TRUE, 1),
('Volleyball ', TRUE, 1);


INSERT INTO class(sport_id, instructor_id, location) VALUES
(6, 10, 2),
(6, 11, 2),
(8, 6, 5),
(8, 7, 5),
(15, 8, 6),
(14, 9, 6);



INSERT INTO schedule(class_id, day_of_week, start_time, end_time) VALUES
(1, 'Monday', '10:00:00', '11:00:00'),
(1, 'Thursday', '10:00:00', '11:00:00'),
(2, 'Tuesday', '10:00:00', '11:00:00'),
(2, 'Friday', '10:00:00', '11:00:00'),
(3, 'Monday', '11:00:00', '12:00:00'),
(3, 'Thursday', '11:00:00', '12:00:00'),
(4, 'Tuesday', '11:00:00', '12:00:00'),
(4,'Friday', '11:00:00', '12:00:00' ),
(6, 'Monday', '10:00:00', '11:00:00'),
(6, 'Wednesday', '10:00:00', '11:00:00'),
(5, 'Tuesday', '11:00:00', '12:00:00'),
(5, 'Friday', '11:00:00', '12:00:00');


INSERT INTO announcement(sport_id, message) VALUES
(1, 'Luka Doncic is coming to campus to give a talk! December 8, 17:00. IB'),
(8, 'Cristiano Ronaldo is visiting our campus for a masterclass on December 9, 15:00!'),
(15, 'Watch Islam Makhachev press conference for UFC311 live on DKU TV!');

INSERT INTO subscription(user_id, sport_id) VALUES
(4, 8),
(3, 15),
(1, 1);

