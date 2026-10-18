USE `goit-rdb-hw-03`;

-- Завдання 1
/* за допомогою вкладеного запиту в операторі SELECT 
відобразити таблицю order_details 
та поле customer_id з таблиці orders 
відповідно для кожного поля запису з таблиці order_details.
*/

SELECT
	od.*,
	(SELECT 
	customer_id 
	FROM orders o 
	WHERE o.order_id = od.order_id) 
	AS customer_id
FROM order_details od;

-- Завдання 2
/* відобразити таблицю order_details та 
за допомогою вкладеного запиту в операторі WHERE 
відфільтрувати результати так, щоб відповідний 
запис із таблиці orders виконував умову shipper_id=3.
*/

SELECT
	*
FROM order_details od
WHERE od.order_id IN (
	SELECT o.order_id 
    FROM orders o
    WHERE o.shipper_id = 3
    );

-- Завдання 3
/* запит, вкладений в операторі FROM, який буде обирати рядки 
з умовою quantity>10 з таблиці order_details. 
Для отриманих даних знайти середнє значення поля quantity,
групувати слід за order_id.
*/

SELECT 
	order_id,
    AVG(quantity) as avg_quantity
FROM
	(SELECT * FROM order_details WHERE quantity > 10) AS temp_table
GROUP BY
    order_id;

-- Завдання 4
/* Розв’язати завдання 3, використовуючи оператор WITH 
для створення тимчасової таблиці temp.
*/

WITH temp AS (
    SELECT order_id, quantity
    FROM order_details
    WHERE quantity > 10
)
SELECT order_id, AVG(quantity) AS avg_quantity
FROM temp
GROUP BY order_id;

-- Завдання 5
/* Створити функцію з двома параметрами, яка буде ділити перший параметр на другий. 
Обидва параметри та значення, що повертається, повинні мати тип FLOAT.
Використати конструкцію DROP FUNCTION IF EXISTS. 
Застосувати функцію до атрибута quantity таблиці order_details. 
Другим параметром може бути довільне число на ваш розсуд.
*/

DROP FUNCTION IF EXISTS Divide;

DELIMITER //

CREATE FUNCTION Divide(input_number1 FLOAT, input_number2 FLOAT)
RETURNS FLOAT
DETERMINISTIC 
NO SQL
BEGIN
    DECLARE result FLOAT;
    SET result = input_number1 / input_number2;
    RETURN result;
END //

DELIMITER ;

SELECT 
    order_id,
    product_id,
    quantity,
    Divide(quantity, 2.0) AS divided_quantity
FROM order_details;