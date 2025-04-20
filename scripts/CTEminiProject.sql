--==============================CTE using the SalesDB=============================================
--Step1: Find the total sales per customer
--Step2: Find the last order date for each customer
--Rank3: customers based on the total sales per customer
--Step4: Segment customers based on their total sales
WITH CTE_Total_Sales AS
(
SELECT
	CustomerID,
	SUM(Sales)  TotalSale
FROM Sales.Orders
GROUP BY CustomerID
)
,CTE_Last_Order_Date AS
(
SELECT
	CustomerID,
	MAX(OrderDate) LastOrder
FROM Sales.Orders
GROUP BY CustomerID
)
,CTE_Rank_Customer AS
(
SELECT
CustomerID,
TotalSale,
RANK() OVER(ORDER BY TotalSale DESC) RankCustomer
FROM CTE_Total_Sales
)
,CTE_Customer_Segment AS
(
SELECT
	CustomerID,
	TotalSale,
	CASE WHEN TotalSale > 100 THEN 'High'
		 WHEN TotalSale > 80  THEN 'Medium'
		 ELSE 'Low'
	END  CustomerSegment
FROM CTE_Total_Sales
)
--Main query
SELECT
c.CustomerID,
c.FirstName,
c.LastName,
cts.TotalSale,
clo.LastOrder,
crc.RankCustomer,
csg.CustomerSegment
FROM Sales.Customers c
LEFT JOIN CTE_Total_Sales cts
ON cts.CustomerID = c.CustomerID
LEFT JOIN CTE_Last_Order_Date clo
ON clo.CustomerID = c.CustomerID
LEFT JOIN CTE_Rank_Customer crc
ON crc.CustomerID = c.CustomerID
LEFT JOIN CTE_Customer_Segment csg
ON csg.CustomerID = c.CustomerID
