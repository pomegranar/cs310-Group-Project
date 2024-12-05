CREATE VIEW checkouts AS
SELECT u.first_name, u.last_name, s.name as sport, e.name as equipment, e.number, b.borrow_date
FROM borrowed b
LEFT JOIN user u ON b.user_id = u.user_id
JOIN equipment e ON b.equipment_id = e.equipment_id
LEFT JOIN sport s ON e.sport_id = s.sport_id
WHERE returned_on IS NULL;