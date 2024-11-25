SELECT `firstname`,`surname`,`card`,`user_id`,`equipment_id`,`sport`,`name`,`number`
FROM `users` JOIN `equipment` ON users.`user_id` = equipment.`checked_out_user_id`
WHERE equipment.`checked_out_user_id` IS NOT NULL ORDER BY `user_id`;
