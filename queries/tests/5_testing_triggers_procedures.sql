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

CALL enroll_users_to_classes(
     1,
     7
     );


