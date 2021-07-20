Задание 1
-- Используя стандартный SQL, из исходной таблицы вывести 1-ый и 5-ый Order id заказа для каждого клиента.
-- – YYYYMMDD HH:MM:SS
-- – Уникальный идентификатор заказа
-- – Уникальный идентификатор клиента

## Вывод 1-ого Order_id для каждого клиента
SELECT
DateTime, Client_id, Order_id
FROM t
WHERE DateTime = (SELECT MIN(DateTime) FROM t t2 WHERE t.client_id = t2.client_id);

## Вывод 1-ого и 5-ого Order_id для каждого клиента

SELECT
    DateTime,
    Client_id,
    Order_id,
    Number
FROM
(
    SELECT
        DateTime,
        Client_id,
        Order_id,
        ROW_NUMBER() OVER(Partition BY Client_id) AS 'Number'
    FROM t
) query_in
WHERE Number = 1 OR Number = 5
;

Задание 2
   
-- Hit id – уникальный идентификатор хита, Client id – уникальный идентификатор клиента,
-- Timestamp – время, в которое произошел хит в секундах, прошедших с какого-то фиксированного момента времени.
-- Необходимо предложить SQL-запрос или несколько запросов, который бы позволял посчитать число сеансов. 
-- Сеансом называется последовательность хитов от одного клиента наибольшей длины, такая что промежуток времени
-- между двумя последовательными хитами составляет не более 30 минут. При составлении SQL-запросов ориентироваться на диалект SQL,
-- используемый в Google Big Query:

WITH client_hit_sorted(client, hit, time)
AS (
	SELECT 
		client_id, 
		hit_id,
		timestamp
	FROM t
	GROUP BY hit_id, client_id
	ORDER BY hit_id, client_id
),

WITH time_difference (time, difference)
AS (
	SELECT
		time,
		IFNULL(LAG(time)
		OVER (ORDER BY time) - time, 0) AS 'difference' 
	FROM client_hit_sorted
	)

SELECT count(difference)
FROM time_difference
WHERE difference <= 1800;
