--write a query to return employee details for all employees as well as the first
--and last name of each employee's manager. Include the following columns:
--employee_id, first_name, last_name, manager_fist_name, manager_last_name.

SELECT 
  e.employee_id,
  e.first_name,
  e.last_name,
  e.manager_id,
  m.first_name AS manager_first_name,
  m.last_name AS manager_last_name

FROM  hcm.employees e  LEFT JOIN hcm.employees m
ON e.manager_id = m.employee_id
ORDER BY employee_id;


--Write a query to return all the products at each warehouse.
--including : product_id, product_name, warehouse_id, warehouse_name, quantity_on_hand.

SELECT
  p.product_id,
  p.product_name,
  w.warehouse_id,
  w.warehouse_name,
  i.quantity_on_hand
FROM oes.products p INNER JOIN oes.inventories i
ON p.product_id = i.product_id 
INNER JOIN oes.warehouses w
ON i.warehouse_id = w.warehouse_id;

--Write a query to return the following attributes for all employees from
--Australia: employee_id, fist_name, last_name, department_name, job_title,
--state_province.

SELECT* FROM hcm.employees;
SELECT* FROM hcm.departments;
SELECT* FROM hcm.jobs;
SELECT* FROM hcm.countries;


SELECT 
  e.employee_id,
  e.first_name,
  e.last_name,
  d.department_name,
  j.job_title,
  c.country_name
FROM hcm.employees e LEFT JOIN hcm.departments d
ON e.department_id = d.department_id
LEFT JOIN hcm.jobs j
ON e.job_id = j.job_id
LEFT JOIN hcm.countries c
ON e.country_id = c.country_id
WHERE country_name = 'Australia'
ORDER BY employee_id;


--Return the total quantity ordered of each product in each catagory 
--Not including products which have never been ordered . Include the product name
--and catagory name// Order the result by category name from A-Z and then within
--each category name order by product name from A-Z.


SELECT   
     pc.category_name,
	 p.product_name,
	 SUM(oi.quantity) as total_quantity_ordered
FROM oes.products p
JOIN oes.order_items oi
ON p.product_id = oi.product_id
JOIN oes.product_categories pc
ON pc.category_id = p.category_id
GROUP BY pc.category_name, p.product_name
ORDER BY pc.category_name, p.product_name;



