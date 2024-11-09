SELECT `Firstname`,`Surname`,`Card`,`User_ID`,`Equipment_ID`,`Sport`,`Name`,`Number` 
FROM `Users` JOIN `Equipment` ON Users.`User_ID` = Equipment.`Checked_out_user_id` 
WHERE Equipment.`Checked_out_user_id` IS NOT NULL ORDER BY `User_ID`;
