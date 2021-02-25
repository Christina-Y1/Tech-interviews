1. Задание

-- 1) Какая категория приносит самый большой оборот (за весь период)?

SELECT SKU, sum (REVENUE) as sum
FROM table1 
GROUP BY SKU
ORDER BY sum desc;


-- 2) Какой SKU не продавался наибольшее кол-во дней и сколько это дней?
SELECT SKU, COUNT (*) FROM table1 GROUP BY SKU;

SELECT SKU, COUNT (*) FROM table1 
WHERE REVENUE IS NOT NULL
GROUP BY SKU
ORDER BY COUNT (*);


--3) Какая средняя выручка в день у самого плохого по выручке телевизора (учитываются дни, когда были продажи)?
SELECT SKU, sum (REVENUE) as sum 
FROM table1 
WHERE SKU BETWEEN 9 AND 15 
GROUP BY SKU 
ORDER BY sum;

SELECT SKU, avg (REVENUE) as average 
FROM table1 
WHERE SKU=12 AND REVENUE IS NOT NULL;

-- 4) Определить прирост каждой недели к средненедельной выручке за 4 предшествующих промо-недели?
-- 5) Для каждой недели вывести 2 топовых по выручке товара в каждой категории (используя как можно меньше подзапросов)?



2. Задание
-- Необходимо получить таблицу Дата, Предыдущая дата, Последующая дата, Дата начала месяца, Дата окончания месяца, сколько дней осталось до конца года.
-- Все, кроме последнего, решать через оконные функции.

use Ozon;
DROP TABLE IF EXISTS test2;
CREATE TABLE test2 (
		id SERIAL PRIMARY KEY, 
		main_date DATETIME NOT NULL
);

SELECT * FROM Ozon.test2;
INSERT INTO test2 VALUES ('1', '1984-01-04 20:30:21'),
('2', '1979-05-25 03:25:29')

SELECT *, DATE_SUB (main_date, INTERVAL 1 DAY) as previous_date FROM Ozon.test2; 
SELECT *, DATE_ADD (main_date, INTERVAL 1 DAY) as next_date FROM Ozon.test2;



3. Задание 
-- Требуется написать запрос, возвращающий для каждого абонента минимальную дату, когда количество событий было максимально, — и максимальную дату,
-- когда количество событий было минимально, а также количество событий. 
-- Таблицу для задания необходимо заполнить произвольными данными

DROP TABLE IF EXISTS test;
CREATE TABLE test (
		id SERIAL PRIMARY KEY, 
		user VARCHAR(64) NOT NULL,
		date_1 DATETIME NOT NULL, 
                     date_2 DATETIME NOT NULL,
		event_1 INT(10) UNSIGNED NOT NULL,
                     event_2 INT(10) UNSIGNED NOT NULL
);

INSERT INTO `test` VALUES ('1','maiya.hilll@example.net','2016-06-13 22:27:07','1982-01-04 20:30:21','596','3416451'),
('2','alexanne.prosacco@example.net','2011-06-18 00:42:03','1997-05-16 17:03:23','9481','7'),
('3','fstreich@example.com','1992-07-12 15:54:15','1974-03-05 23:43:34','367','51'),
('4','grady26@example.net','2013-08-02 13:11:04','2011-12-18 14:57:59','95957073','427'),
('5','reyna.homenick@example.org','1990-08-08 05:53:41','1984-01-20 10:44:55','197','79666'),
('6','xhayes@example.net','2010-11-06 18:14:49','2017-07-28 15:33:05','90026','2756'),
('7','braxton.dach@example.org','1997-10-28 16:26:56','1972-03-03 10:33:58','0','585'),
('8','leffler.heloise@example.org','1977-04-26 03:00:22','1997-10-02 05:38:10','6534119','63129'),
('9','kernser@example.org','1979-05-25 03:25:29','2004-12-15 19:09:43','102836523','35'),
('10','lilian00@example.org','1984-02-09 09:24:39','1994-04-14 18:31:24','6370680','5221551'),
('11','huels.laney@example.com','1991-05-06 01:24:47','2002-11-18 20:58:08','4670124','90902391'),
('12','elebsack@example.net','1972-03-16 12:08:43','1975-08-01 11:49:44','567','814425762'),
('13','maxie32@example.com','1987-10-22 00:39:55','2008-08-10 22:34:46','105745','1'),
('14','becker.fausto@example.net','2003-01-01 22:41:45','1987-01-25 05:13:50','665942','603743453'),
('15','lonny20@example.org','1973-04-04 07:16:49','1996-08-27 08:19:05','28359036','304319'),
('16','jada.marquardt@example.org','1978-09-12 12:13:47','2003-11-29 14:25:32','399','1623'),
('17','keenan89@example.com','1983-10-06 06:25:29','2005-03-17 10:20:52','10321547','247'),
('18','filomena.nader@example.net','1988-07-11 00:03:10','1988-06-20 18:29:30','99970697','70222'),
('19','cartwright.gonzalo@example.net','1990-05-14 18:05:05','2008-10-09 17:58:03','5610','3'),
('20','jhand@example.com','2015-08-06 07:44:33','1986-03-08 04:26:52','4068518','111781'),
('21','armand.hintz@example.org','2000-07-11 14:51:26','1974-11-14 13:00:24','28745494','16207'),
('22','alisha.o\'hara@example.org','2005-09-11 05:11:32','2010-05-08 02:51:21','37618653','142'),
('23','sfisher@example.net','1989-07-08 18:08:01','1988-11-06 17:36:07','44177','4'),
('24','rahul81@example.net','1977-09-18 04:58:47','2006-09-03 07:58:26','94','75389'),
('25','zbarrows@example.org','2018-06-10 15:44:46','2002-08-16 17:05:49','31','37'),
('26','catherine.okuneva@example.com','1973-07-26 18:48:27','2020-06-23 21:19:23','6','2192569'),
('27','klabadie@example.net','1977-02-25 21:00:57','1987-11-15 21:34:31','594','4643'),
('28','krath@example.net','1997-11-17 13:25:09','2012-09-21 12:46:34','69001','62295'),
('29','timmothy.abbott@example.org','1983-10-18 01:20:27','1971-12-16 15:06:34','4133','2944'),
('30','delaney.ernser@example.com','1983-11-09 22:29:23','2004-01-12 13:23:55','94936623','30125439');
Решение
SELECT * FROM Ozon.test;
SELECT id, user, GREATEST(date_1, date_2) as max_date, LEAST(event_1, event_2) as min_event FROM Ozon.test;
SELECT id, user, GREATEST(event_1, event_2) as max_event, LEAST(date_1, date_2) as min_date FROM Ozon.test;



4. Задание 
-- В течение дня ресторан посещают разные посетители. В то же время ресторан рекламируют, чтобы увеличить доход от клиентов.
-- Напишите SQL-запрос, чтобы вычислить скользящее среднее, сколько клиенты потратили в течение 7 дней (текущий день и 6 дней до него) на анализ роста своего бизнеса.
-- Выходные данные должны содержать три столбца {visit_on, amount, avg_amount (в среднем за 7 дней)}

use Ozon;
DROP TABLE IF EXISTS rest;
CREATE TABLE rest (
		id SERIAL PRIMARY KEY, 
		Name VARCHAR(64) NOT NULL,
		Phone BIGINT(10) UNSIGNED NOT NULL, 
		Visited_on DATE NOT NULL,
		Amount INT(10) UNSIGNED NOT NULL
);

INSERT INTO `rest` VALUES ('1','Bernhard','89163331122','2020-10-10','4488'),
('2','Henri','89163331120','2020-10-03','10'),
('3','Guiseppe','8963331122','2020-10-06','8816'),
('4','Marjorie','8916333991','2020-10-08','5098'),
('5','Faye','8926788881','2020-10-09','38197'),
('6','Guiseppe','99','2020-10-05','4036'),
('7','Felipe','459817','2020-10-06','1633'),
('8','Gerda','892600001','2020-09-28','5426'),
('9','Edwardo','895557743','2020-10-07','4132'),
('10','Jovani','891000000','2020-10-09','8109'),
('11','Faye','891000009','2020-10-09','7735'),
('12','Preston','8910890000','2020-10-08','90'),
('13','Mona','891089060','2020-10-07','1974'),
('14','Felipe','8926890000','2020-10-03','799'); 

SELECT * FROM Ozon.rest order by Visited_on;
SELECT Visited_on, sum(Amount) as total_amount_per_day 
FROM Ozon.rest 
GROUP BY Visited_on
ORDER BY Visited_on;
