-- a.	Вывести список сотрудников, получающих заработную плату большую чем у непосредственного руководителя

SELECT employee.name
		FROM  employee
		INNER JOIN employee AS chief ON employee.chief_id = chief.id
		WHERE   employee.salary > chief.salary

-- b.	Вывести по каждому сотруднику, какая на него приходится доля от суммы всех зарплат департамента

	SELECT
			name, 
			ROUND(salary / SUM(salary * 1.0)  OVER ( Partition BY department), 2) AS `Доля`
		FROM employee

-- c.	Вывести департамент с наибольшим количеством сотрудников

SELECT department.name
FROM department 
INNER JOIN employee ON department.id = employee.department_id
GROUP BY department. name

HAVING COUNT(department_id) = 	(
					SELECT MAX( count_employee) AS max_count_employee
					FROM 
						(
						SELECT COUNT(department_id) AS count_employee
						FROM department
						INNER JOIN employee ON department.id = employee.department_id
						GROUP BY department_id) query_1
					);
