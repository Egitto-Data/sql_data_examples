USE SAMPLEDB
GO

--Retrieve all the employees, who still working.

SELECT
e.employee_id,
e.first_name,
e.last_name,
e.salary,
d.department_name
FROM hcm.employees e INNER JOIN hcm.departments d
ON e.department_id = d.department_id;


--Write a query to return all the employees including 
--employees who dont belong to a department:-

SELECT
e.employee_id,
e.first_name,
e.last_name,
e.salary,
d.department_name
FROM hcm.employees e LEFT OUTER JOIN hcm.departments d
ON e.department_id = d.department_id;

--Return the total number of employees in each departmen 
--include the department name in the query result .
--Also, include employees who have not been assigned to a department.

SELECT 
d.department_name,
COUNT(*) AS employee_count
FROM hcm.employees e LEFT OUTER JOIN hcm.departments d
ON e.department_id = d.department_id
GROUP BY d.department_name;