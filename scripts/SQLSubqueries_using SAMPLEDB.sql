--Using the SAMPLEDB return all the following:
--return the following product details for the cheapest product in the oes.products table:

USE SAMPLEDB
GO

SELECT
	product_id,
	product_name,
	list_price,
	category_id
FROM oes.products
WHERE list_price = (
                     SELECT
	                   MIN(list_price)
			   FROM oes.products
					);
--Another solution 
SELECT 
    TOP (1) WITH TIES
	product_id,
	product_name,
	list_price,
	category_id
FROM oes.products
ORDER BY list_price ASC;


--Return product details for the cheapest product in each product category by using a correlated subquery

SELECT
	p.product_id,
	p.product_name,
	p.list_price,
	p.category_id
FROM oes.products p
WHERE p.list_price = ( 
                      SELECT
			  MIN(p2.list_price)
			  FROM oes.products p2
			  WHERE P2.category_id = p.category_id
			  );

--Return product details for the cheapest product in each product category by using join to a derived table

SELECT
	p.product_id,
	p.product_name,
	p.list_price,
	p.category_id
FROM oes.products p
INNER JOIN 
           (SELECT
		  category_id,
			  MIN(list_price) AS Min_list_Price
			  FROM oes.products
			  GROUP BY category_id
			  ) p2
ON p.category_id = p2.category_id
AND p.list_price =P2.Min_list_Price;

--Return product details for the cheapest product in each product category by using Commen table expression

WITH Cheapest_Product_By_Category AS
(
SELECT
    category_id,
	MIN(list_price) AS Min_list_Price
	FROM oes.products
	GROUP BY category_id)

SELECT
    p.product_id,
	p.product_name,
	p.list_price,
	p.category_id,
	p2.Min_list_Price
FROM oes.products P
INNER JOIN Cheapest_Product_By_Category p2
ON p.category_id = p2.category_id
AND p.list_price = P2.Min_list_Price;

--Return product details for the cheapest product in each product category by using Commen table expression 
--Including the category name

WITH Cheapest_Product_By_Category AS
(
SELECT
    category_id,
	MIN(list_price) AS Min_list_Price
	FROM oes.products
	GROUP BY category_id
	)

SELECT
    p.product_id,
	p.product_name,
	p.list_price,
	p.category_id,
	p2.Min_list_Price,
	cn.category_name
FROM oes.products P
INNER JOIN oes.product_categories cn
ON p.category_id = cn.category_id
INNER JOIN Cheapest_Product_By_Category p2
ON p.category_id = p2.category_id
AND p.list_price = P2.Min_list_Price;

--Return all employees who have never been the salesperson for any customer orders 
SELECT
	employee_id,
	first_name,
	last_name
FROM hcm.employees
WHERE employee_id NOT IN (
                           SELECT
				   employee_id
				   FROM oes.orders
				   WHERE employee_id IS NOT NULL
                                );
--Another solution using NOT EXISTS operator

SELECT
	e.employee_id,
	e.first_name,
	e.last_name
FROM hcm.employees e
WHERE  NOT EXISTS (
                    SELECT 1
	                FROM oes.orders o
			WHERE o.employee_id = e.employee_id
                        );

--Return unique customers who have ordered the 'PBX Smart Watch 4'
SELECT
	c.customer_id,
	c.first_name,
	c.last_name,
	c.email
FROM oes.customers c
WHERE c.customer_id IN (
                        SELECT
				o.customer_id
				FROM oes.orders o
				JOIN oes.order_items oi
				ON oi.order_id = o.order_id
				JOIN oes.products p
				ON p.product_id = oi.product_id
				WHERE p.product_name = 'PBX Smart Watch 4'
                        )
