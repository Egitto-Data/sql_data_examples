--Find the products that have a price higher than the AVG price of all products
SELECT*
FROM(

		SELECT
		ProductID,
		Price,
		AVG(Price) OVER () TotalAvg
		FROM Sales.Products
		)T
WHERE Price > TotalAvg;

------------------------------------------------------------------------------------------------------------
--Rank customers based on the total amount of sales
SELECT*,
RANK() OVER(ORDER BY TotalSales DESC) CustomerRank
FROM(
		SELECT
		CustomerID,
		SUM(Sales) TotalSales
		FROM Sales.Orders
		GROUP BY CustomerID)T;
-----------------------------------------------------------------------------------
--Show the product id's, names, prices and total numbers of orders
SELECT
	ProductID,
	Product,
	Price,
	(SELECT COUNT(*) FROM sales.Orders) TotalOrders
FROM sales.Products;
--------------------------------------------------------------------------------------
--Show all customer details and find total orders of each customer
SELECT
C.*,
O.TotalOrders
FROM Sales.Customers C
LEFT JOIN
	(SELECT
	CustomerID,
	COUNT(*) TotalOrders
	FROM Sales.Orders
	GROUP BY CustomerID) O
ON C.CustomerID = O.CustomerID;
-------------------------------------------------------------------------------
--Find the products that have a price higher than the AVG price of all products
SELECT
productID,
price
FROM Sales.Products
WHERE Price > (SELECT AVG(Price) FROM Sales.Products) ;
-------------------------------------------------------------------------------
--Show the details of orders made by customers in Germany
SELECT*
FROM Sales.Orders
WHERE CustomerID IN (SELECT CustomerID FROM Sales.Customers WHERE Country = 'Germany');
---------------------------------------------------------------------------------
--Find female employees whose salaries are greater than the salaries of any male employees 
SELECT
	EmployeeID,
	FirstName,
	Salary
FROM Sales.Employees
WHERE Gender ='F' 
AND Salary > ANY (SELECT Salary FROM Sales.Employees WHERE Gender ='M');
------------------------------------------------------------------------------------------
--Show all customers details and find the total orders of each customer
SELECT
*,
(SELECT COUNT(*) FROM Sales.Orders o WHERE o.CustomerID = c.CustomerID ) TotalSales
FROM Sales.Customers c
------------------------------------------------------------------------------------------









