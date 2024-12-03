SELECT s.name AS sport, e.name, e.number, e.equipment_id
FROM equipment e
JOIN sport s ON e.sport_id = s.sport_id
LEFT OUTER JOIN borrowed b ON e.equipment_id = b.equipment_id
WHERE b.equipment_id IS NULL OR b.returned_on IS NOT NULL;