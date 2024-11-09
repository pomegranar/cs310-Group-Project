CREATE DATABASE sports_complex_db;
CREATE USER 'djangouser'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON sports_complex_db.* TO 'djangouser'@'localhost';
FLUSH PRIVILEGES;
