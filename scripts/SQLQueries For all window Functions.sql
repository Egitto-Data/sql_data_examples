--This are some scripts training and showing the Use Cases using the Window function 
--The DB Used in this scripts will be SalesDB


USE SalesDB
GO

--Find the total number of customers
--Find the total number of scores for the customers
--Additoinally provide All customers Details

SELECT
*,
		COUNT(*) OVER () TotalCustomers,
		COUNT(Score) OVER () TotalScore
FROM Sales.Customers;

--Check whether the table 'Orders And OrderArchieve' contains any duplicates rows
---------------------------------------------------------------------------------

SELECT
		OrderID,
		COUNT(*) OVER (PARTITION BY OrderID) Uniques
FROM Sales.Orders;
---------------------------------------------------------
SELECT*
FROM
	(
	 SELECT
	       OrderID,
		   COUNT(*) OVER (PARTITION BY OrderID) Uniques
	FROM		Sales.OrdersArchive) T
	WHERE Uniques > 1;
---------------------------------------------------------------
--Find the total sales across all orders 
--and the total sales for each product
--Additionally provide details such order id, ordr date

SELECT
		OrderID,
		OrderDate,
		Sales,
		SUM(Sales) OVER () TOTALSALES,
		SUM(Sales) OVER (PARTITION BY ProductID) TotalSalesByProduct
FROM Sales.Orders;
----------------------------------------------------------------------
--Find the percentage contribuation of each product's sales

SELECT
		OrderID,
		ProductID,
		Sales,
		SUM(Sales) OVER () TotalSales,
		ROUND (CAST (Sales AS FLOAT) / SUM(Sales) OVER () * 100, 3) PercentValu

FROM Sales.Orders;
-----------------------------------------------------------------------------
--Find the average sales for each product//We need to handle the NULLS FIRST

SELECT
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	AVG (COALESCE (Sales, 0)) OVER (PARTITION BY ProductID) AvgerageSales
FROM Sales.Orders;
-----------------------------------------------------------------------------------
--Find all orders where sales are higher than the AVG Sales across all orders 

SELECT*
FROM(
		SELECT
		OrderID,
		ProductID,
		Sales,
		AVG(Sales) OVER () AvgSales
		FROM Sales.Orders)T
WHERE Sales > AvgSales;
----------------------------------------------------------
--Find the highest and the lowest sales across all orders 
--The same for the products 
--Additionally proving the orderId and the order date 
SELECT
		OrderID,
		ProductID,
		OrderDate,
		MAX(Sales) OVER (PARTITION BY ProductID) HighestSales,
		MIN(Sales) OVER (PARTITION BY ProductID) LowestSales
FROM Sales.Orders;
---------------------------------------------------------------------------
--Find the employee who has the highest salary
SELECT*
FROM(
      SELECT 
	   *,
	   MAX(Salary) OVER () HighestSalary
	   FROM Sales.Employees)t
WHERE  Salary = HighestSalary;
--------------------------------------------------------------------------------
--RUNNING TOTAL AND ROLLINING TOTAL 
--Calculate the moving average of sales for each product over time and including the next order
SELECT
	OrderID,
	ProductID,
	OrderDate,
	Sales,
	AVG(Sales) OVER (PARTITION BY ProductID) AvgByProduct,
	AVG(Sales) OVER (PARTITION BY ProductID ORDER BY OrderDate) MovingAvg,
	AVG(Sales) OVER (PARTITION BY ProductID ORDER BY OrderDate ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING)ROLLINGAVG
FROM Sales.Orders;
-----------------------------------------------------------------------------------------------------------------
--Rank the order based n their sales from highest to lowest
SELECT

OrderID,
ProductID,
Sales,
ROW_NUMBER() OVER (ORDER BY Sales desc) Sales_Rank_Row,
RANK() OVER (ORDER BY Sales desc) Sales_Rank_Rank,
DENSE_RANK() OVER (ORDER BY Sales desc) Sales_Dense_Rank
FROM Sales.Orders
----------------------------------------------------------------------------------------------------
--Find the top highest sales for each product 
SELECT*
FROM   (
        SELECT
		OrderID,
		ProductID,
		Sales,
		ROW_NUMBER() OVER (PARTITION BY ProductID ORDER BY Sales) RankByProduct
		FROM Sales.Orders) T
WHERE RankByProduct = 1;
----------------------------------------------------------------------------------------
--Find the lowest 2 customers based on their total sales
SELECT TOP 2

	CustomerID,
	SUM(Sales) TotalSales
	FROM Sales.Orders
	GROUP BY CustomerID
	ORDER BY TotalSales;
--ANOTHER SOLUATION--
SELECT *
FROM(
    SELECT
	CustomerID,
	SUM(Sales) TotalSales,
	ROW_NUMBER() OVER (ORDER BY SUM(Sales)) CustomerRank 
	FROM Sales.Orders
	GROUP BY CustomerID)T
	WHERE CustomerRank <= 2;
----------------------------------------------------------------------------------------------------
--Assign unique IDs to the rows of the 'OrderArchieve' Table
SELECT
ROW_NUMBER() OVER (ORDER BY OrderID, OrderDate) UniqueID,
*
FROM Sales.OrdersArchive
------------------------------------------------------------------------------------------------
--Identify duplicates rows in the table 'OrderArchiev' and return a clean result without any duplicates
SELECT*
FROM
	(SELECT
	ROW_NUMBER() OVER (PARTITION BY OrderID ORDER BY CreationTime desc) rn,
	*
	FROM Sales.OrdersArchive)t WHERE rn = 1;
--------------------------------------------------------------------------------------------------------
--In order to export the data, divide the ordrs into 2 groups.
SELECT
	NTILE(2) OVER (ORDER BY OrderID ) Buckets,
	*
	FROM Sales.Orders
-----------------------;---------------------------------------------------------------------------------
--Find the products that fall within the highest 40% of the prices
SELECT
*,
CONCAT(distrank * 100, '%') PERCENTRANK
FROM(
        SELECT
		Product,
		Price,
		CUME_DIST() OVER (ORDER BY Price desc) Distrank
		FROM Sales.Products)T
WHERE Distrank <=0.4







	
