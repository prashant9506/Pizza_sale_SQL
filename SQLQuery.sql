--CREATE TABLE 
	CREATE TABLE pizzas (
		pizza_id VARCHAR(100),
		pizza_type_id VARCHAR(100)
		FOREIGN KEY REFERENCES pizza_types(pizza_type_id),
		size INT,
		price DECIMAL(10, 2) 
	);
	ALTER TABLE pizzas ALTER COLUMN pizza_id VARCHAR(100) NOT NULL;
	ALTER TABLE pizzas ADD PRIMARY KEY(pizza_id)
	ALTER TABLE pizzas ALTER COLUMN size VARCHAR(100)

	CREATE TABLE pizza_types(
		pizza_type_id VARCHAR(100) PRIMARY KEY,
		name VARCHAR(100),
		category VARCHAR(100),
		ingredients VARCHAR(500)
	)

	CREATE TABLE orders (
		order_id INT PRIMARY KEY,
		date DATE,
		time TIME
	)

	CREATE TABLE order_details(
		order_details_id INT PRIMARY KEY,
		order_id INT FOREIGN KEY REFERENCES orders(order_id),
		pizza_id VARCHAR(100) FOREIGN KEY REFERENCES pizzas(pizza_id),
		quantity INT
	)
--import csv data into table using BULK insert
	BULK INSERT pizzas FROM 'C:\Users\mauparas\Desktop\data analyst\Project\pizza_sales\pizzas.csv'
	WITH(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n'
	);

	BULK INSERT pizza_types FROM 'C:\Users\mauparas\Desktop\data analyst\Project\pizza_sales\pizza_types.csv'
	WITH(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n'

	);


	BULK INSERT orders FROM 'C:\Users\mauparas\Desktop\data analyst\Project\pizza_sales\orders.csv'
	WITH(
		FIRSTROW = 2,
		FIELDTERMINATOR =',',
		ROWTERMINATOR ='\n'
	);

	BULK INSERT order_details FROM 'C:\Users\mauparas\Desktop\data analyst\Project\pizza_sales\order_details.csv'
	WITH(
		FIRSTROW =2,
		FIELDTERMINATOR =',',
		ROWTERMINATOR ='\n'
	);
--select all data 
	SELECT * FROM pizza_types
	SELECT * FROM pizzas
	SELECT * FROM orders
	SELECT * FROM order_details

--data cleaning
--step 1 (Retrive duplicate and remove)
--1) Retrive duplicate data
	SELECT pizza_id, COUNT(pizza_id) FROM pizzas GROUP BY pizza_id HAVING COUNT(pizza_id) > 1
	SELECT pizza_type_id, COUNT(pizza_type_id) FROM pizza_types GROUP BY pizza_type_id HAVING COUNT(pizza_type_id) > 1
	SELECT order_id, COUNT(order_id) FROM orders GROUP BY order_id HAVING COUNT(order_id) > 1
	SELECT order_details_id, COUNT(order_details_id) FROM order_details GROUP BY order_details_id HAVING COUNT(order_details_id) > 1

--2) Remove duplicate data
--no duplicate data retrive

--step 2 Handle null value
--1) check null value
	SELECT * FROM pizzas WHERE pizza_id IS NULL OR pizza_type_id IS NULL OR size IS NULL OR price IS NULL;
	SELECT * FROM pizza_types WHERE pizza_type_id IS NULL OR name IS NULL OR category IS NULL OR ingredients IS NULL;
	SELECT * FROM orders WHERE order_id IS NULL OR date IS NULL OR time IS NULL;
	SELECT * FROM order_details WHERE order_details_id IS NULL OR order_id IS NULL OR pizza_id IS NULL OR quantity IS NULL;

--2) handle null value
--No null value fetched

--3) defect value
SELECT * FROM pizza_types WHERE category = 'Mushroom';
UPDATE pizza_types SET category = 'Mushroom' WHERE category = ' Mushroom' ;
UPDATE pizza_types SET name = 'The Pepperoni' WHERE category = 'Mushroom';
-----Data Analysis for business purpose

--1) Retrieve the total number of orders placed.
	SELECT COUNT(order_id) AS total_orders FROM orders

--2) Calculate the total revenue generated from pizza sales.
	SELECT FORMAT(SUM(p.price* o.quantity),'C2','EN-IN') AS total_sales_amount 
	FROM pizzas AS P JOIN order_details AS O ON P.pizza_id = O.pizza_id

--3) Identify the highest-priced pizza.
	SELECT TOP 1 P.pizza_id, PT.name, P.price FROM pizzas AS P JOIN pizza_types AS PT ON P.pizza_type_id = P.pizza_type_id
	ORDER BY P.price DESC

--4) Identify the most common pizza size ordered.
	SELECT P.size, COUNT(O.quantity) AS total_orderd FROM pizzas AS P JOIN order_details AS O ON 
	P.pizza_id = O.pizza_id GROUP BY p.size ORDER BY total_orderd DESC

--5) List the top 5 most ordered pizza types along with their quantities.
	SELECT TOP 5 P.pizza_type_id, pt.name, SUM(O.quantity) AS total_quantity FROM pizzas AS P JOIN pizza_types AS pt ON 
	P.pizza_type_id = PT.pizza_type_id JOIN order_details AS O ON P.pizza_id = O.pizza_id GROUP BY p.pizza_type_id, pt.name ORDER BY total_quantity DESC

--6) The total quantity of each pizza category ordered.
	SELECT PT.category, SUM(O.quantity) AS total_quantity FROM pizzas AS P JOIN pizza_types AS PT ON P.pizza_type_id = PT.pizza_type_id
	JOIN order_details AS O ON P.pizza_id = O.pizza_id GROUP BY PT.category ORDER BY total_quantity DESC;

--7) Determine the distribution of orders by hour of the day.
	SELECT DATEPART(HOUR,time) AS time_hour,COUNT(order_id) AS total_order FROM orders group by DATEPART(HOUR,time) ORDER BY  DATEPART(HOUR,time);

--8) Find the category-wise distribution of pizzas.
	SELECT category, COUNT(name) AS total_pizza FROM pizza_types GROUP BY category;


--9)Group the orders by date and calculate the average number of pizzas ordered per day.
	WITH daily_orders AS (SELECT  CAST(O.date AS DATE) AS order_date, SUM(OD.quantity) AS total_orders FROM orders AS O JOIN order_details AS OD 
	ON O.order_id = OD.order_id GROUP BY CAST(O.date AS DATE))

	SELECT  AVG(total_orders) AS avg_pizza_order_per_day from daily_orders ;


--10) Determine the top 3 most ordered pizza types based on revenue.
	SELECT TOP 3 pt.pizza_type_id, pt.name, SUM(p.price*o.quantity) AS revenue FROM pizza_types AS pt JOIN pizzas AS p 
	ON pt.pizza_type_id = p.pizza_type_id JOIN order_details AS o ON p.pizza_id = o.pizza_id 
	GROUP BY pt.pizza_type_id, pt.name ORDER BY SUM(p.price*o.quantity) DESC;


--11) Calculate the percentage contribution of each pizza type to total revenue.
	WITH all_pizza_orders AS (SELECT pt.category, p.pizza_type_id ,p.price, od.quantity 
	FROM pizza_types AS pt JOIN pizzas AS p ON pt.pizza_type_id = p.pizza_type_id JOIN order_details AS od ON p.pizza_id = od.pizza_id)

	SELECT category ,CAST(ROUND(SUM(quantity * price)*100.0/ SUM(SUM(quantity * price)) OVER (),2) AS DECIMAL(10,2)) AS revenue_percentage
	FROM all_pizza_orders GROUP BY category ORDER BY  revenue_percentage DESC


--12) Analyze the cumulative revenue generated over time.
	WITH daily_revenue AS (SELECT FORMAT(date,'yyyy-MM-dd') AS sale_date, SUM(p.price*od.quantity) AS total_revenue FROM pizzas AS p JOIN order_details AS od ON p.pizza_id = od.pizza_id JOIN orders AS o ON od.order_id = o.order_id
	GROUP BY FORMAT(date,'yyyy-MM-dd'))

	SELECT *, SUM(total_revenue) OVER (ORDER BY sale_date  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_revenue FROM daily_revenue


--13) Determine the top 3 most ordered pizza types based on revenue for each pizza category.
	WITH total_sale AS (
	SELECT pt.name, pt.category, SUM(p.price * od.quantity) AS total_sale_amount FROM pizza_types AS pt JOIN pizzas AS p ON pt.pizza_type_id = p.pizza_type_id 
	JOIN order_details AS od ON p.pizza_id = od.pizza_id GROUP BY pt.name, pt.category
	),
	ranked_sales AS (SELECT *, DENSE_RANK() OVER (PARTITION BY category ORDER BY total_sale_amount DESC) AS revenue_rank FROM total_sale )

	SELECT name, total_sale_amount FROM ranked_sales WHERE  revenue_rank <=3;