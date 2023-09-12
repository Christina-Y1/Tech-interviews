
SELECT 
	report_dt, tb_name, gender, age_group, COUNT(client_id), AVG(salary)
FROM
	(
	SELECT
		report_dt, client_id, tb_name, gender, salary,
		CASE
		    WHEN age <= 18 THEN 'Group 1'
			WHEN age > 18 AND age <= 30 THEN 'Group 2'
			WHEN age > 30 AND age <= 60 THEN 'Group 3'
			WHEN age > 60 THEN 'Group 4'
		END AS "age_group"
	FROM 
		(
		(SELECT report_dt, client_dk AS client_id, tb_name, salary FROM clnt_aggr) t
			LEFT JOIN
		(SELECT client_dk, gender, age, actual_from_dt, actual_to_dt FROM clnt_data) t2 
			ON t.client_id = t2.client_dk AND (t.report_dt BETWEEN t2.actual_from_dt AND t2.actual_to_dt)
		) 
	)
GROUP BY report_dt, tb_name, gender, age_group
