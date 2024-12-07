-- This will be a list of people along with their outstanding payments due.
WITH fee_list (netid, due) AS (
	SELECT u.netid, sum_fine
	FROM checkout_record r JOIN users u
	ON r.user_id = u.user_id
	WHERE  > r.due_when
	GROUP BY u.netid
	HAVING SUM(r.fine) sum_fine
)
SELECT netid, SUM(due) total
FROM fee_list
ORDER BY total;
