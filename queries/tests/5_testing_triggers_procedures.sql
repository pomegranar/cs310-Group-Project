USE sports;

-- Testing  'register_user' procedure
CALL register_user(
     'in42',
     '12695',
     'Izzatillo',
     'Nematjonov',
     'male',
     '2006-07-22',
     'student',
     'email',
     'izzatillo.nematjonov@dukekunshan.edu.cn'
     );

CALL register_user(
     'lj23',
     '1238905',
     'Lebron',
     'James',
     'male',
     '1984-12-30',
     'staff',
     'email',
     'lebron.james@dukekunshan.edu.cm'
     );


CALL enroll_users_to_classes(
     2,
     1
     );


SELECT * FROM user;
SELECT * FROM class;
SELECT * FROM enrollment;
SELECT * FROM schedule;
SELECT * FROM contact;


SELECT start_time, end_time
FROM schedule
WHERE class_id= 1;


