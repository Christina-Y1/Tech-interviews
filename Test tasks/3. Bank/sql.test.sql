-- 1. Напишите как минимум 2 способами скрипт, оставляющий только уникальные значения в таблице:

SELECT col1, col2, col3
FROM tab
GROUP BY col1, col2, col3;

SELECT DISTINCT col1, col2, col3
FROM tab;

-- 2. Напишите запрос, возвращающий последнее событие для каждого типа событий:

SELECT type, date, col1, col2
FROM events e1
WHERE date = (SELECT MAX(date) FROM events e2 WHERE e2.type = e1.type);

SELECT type, date, col1, col2
FROM events 
INNER JOIN (SELECT type, MAX(date) AS date FROM events GROUP BY type) USING(type, date)

-- 3. Напишите скрипт обновляющий значение AMOUNT в таблице BALANCE на основании данных из таблицы OPERATIONS за текущий день.

UPDATE balance
SET amount = amount + (SELECT SUM(amount) FROM operations WHERE balance.account = account AND date = NOW());

-- 4. Сколько записей будет удалено из таблицы ниже в результате выполнения выражения: delete from table_name where age=null?

Записи не будут удалены (будет удалено 0 записей), для удаления заменяем «=» на «IS».

/* 5. В таблице u_m05k1.orders содержатся сведения о покупках, она состоит из следующих столбцов: 
•	Amnt – сумма покупки
•	Odate – Дата покупки
•	Cid – ID покупателя, совершившего покупку
•	Sid – ID продавца, совершившего продажу. 

Таблица u_m05k1.customers содержит сведения о покупателях, она состоит из следующих столбцов: 
•	Cid – ID покупателя
•	Cname – фамилия покупателя
•	Sid – ID продавца, прикрепленного к данному покупателю.
Составьте запрос, который выводит общую стоимость заказов для тех продавцов, у которых эта сумма превышает стоимость самого крупного заказа в таблице. */

SELECT Sid, SUM(Amnt) 
FROM u_m05k1.orders 
GROUP BY Sid
HAVING SUM(Amnt)  > (SELECT MAX(Amnt) FROM orders);


/*  6. В таблице u_m05k1.t_preapr_corporate в поле id находятся уникальные идентификаторы клиентов. 
В таблице d_client (схема dwhinform, линк dsacrm) находятся личные данные, в частности в поле birth_date - день рождения клиента. 
Таблицы связаны по id клиента: t_preapr_corporate.id=d_client.client_mnem. 
Необходимо выбрать из таблицы u_m05k1.t_preapr_corporate все id клиентов, которым не менее 20-ти и не более 55 лет. При этом в конечной выборке не должно быть повторений. */

SELECT DISTINCT id
FROM t_preapr_corporate
JOIN d_client ON t_preapr_corporate.id=d_client.client_mnem
WHERE TIMESTAMPDIFF(YEAR, birth_date, CURDATE() ) BETWEEN 20 AND 55;

/* 7. В таблице dwhinform.rrss_products в поле category_name находятся названия проектов. Стоит обратить внимание, что названия могут повторяться. 
В связанной с ней таблице dwhinform.f_deal находятся записи, содержащие договоры, соответствующие проектам. Связь - по названию продукта: f_deal.product =  rrss_products.type. 

Помимо этого таблица f_deal содержит следующие поля:
•	deal_id - уникальный номер договора
•	date_lst_mntd - признак актуальности записи (date_lst_mntd ='31.12.2999' – актуальная запись)
•	deal_status - статус договора
•	principal_value - сумма задолженности
•	ovrdue_principal - сумма просроченной задолженности. 

Требуется в одной выборке показать следующие столбцы, при этом данные должны быть актуальны: 
a)	название проекта; 
b)	количество всех договоров по каждому проекту; 
c)	количество всех договоров в статусе договора 'A' по каждому проекту;
d)	общий портфель по каждому проекту; 
e)	просроченный портфель по каждому проекту. */

SELECT 
	rrss_products.type,
	FIRST(category_name) AS название_проекта,
	COUNT(deal_id) AS количество_договоров,
	SUM(IF(deal_status = 'A', 1, 0)) AS количество_договоров_а
	SUM(principal_value) AS общий_портфель,
	SUM(ovrdue_principal) AS просроченный_портфель
FROM rrss_products 
JOIN f_deal ON f_deal.product =  rrss_products.type
WHERE f_deal.date_lst_mntd = '31.12.2999'
GROUP BY rrss_products.type;



