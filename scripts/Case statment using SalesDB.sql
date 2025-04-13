/*Create report showing total sales for each of the following categories :
  High (sales > 50), Medium (sales 21-50), and low (sales 20 or less)
  sort the result from the highest to the lowest*/--USING THE SalesDB DATABASE

  SELECT
	  Category,
	  SUM (Sales) AS totalSales
  FROM(
  SELECT
	  OrderID,
	  Sales,
  CASE
      WHEN Sales > 50 THEN 'High'
	  WHEN Sales > 20 THEN 'Medium'
	  ELSE 'Low'
 END Category
  FROM Sales.Orders
  )t
GROUP BY Category
ORDER BY totalSales DESC 