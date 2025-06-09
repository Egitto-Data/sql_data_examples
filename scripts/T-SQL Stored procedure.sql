USE SalesDB;
--For US customers find the total number of customers and the average score

CREATE PROCEDURE GetCustomerSummary (@Country NVARCHAR(50) = 'USA')
AS
BEGIN
	BEGIN TRY

		DECLARE @TotalCustomers INT, @AvgScore INT
		--Prepare & Cleanup Data
		IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)
		BEGIN
		   PRINT ('Updating NULL Scores to 0')
		   UPDATE Sales.Customers
		   SET Score = 0
		   WHERE Score IS NULL AND Country = @Country;
		END

		ELSE
		BEGIN
			PRINT ('No NULL Scores found')
		END;

		--Generating Reports 
		SELECT
		   @TotalCustomers = COUNT(*),
		   @AvgScore = AVG(Score) 
		FROM Sales.Customers
		WHERE Country = @Country;

		PRINT 'Total Customers from ' + @Country + ':' + CAST(@TotalCustomers AS NVARCHAR);
		PRINT 'Average Score from ' + @Country +':' + CAST(@AvgScore AS NVARCHAR) ;
		--Find the total Nr. of orders and Total Sales 
		SELECT
			COUNT(OrderID) TotalOrders,
			SUM(Sales) TotalSales
		FROM Sales.Orders o
		JOIN Sales.Customers c
		ON c.CustomerID = o.CustomerID
		WHERE c.Country = @Country

	END TRY
	BEGIN CATCH 
		 PRINT ('An error occured.');
		 PRINT ('Error Message: ' + ERROR_MESSAGE());
		 PRINT ('Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR));
		 PRINT ('Error line: ' + CAST(ERROR_LINE() AS NVARCHAR));
		 PRINT ('Procedure Name: ' + ERROR_PROCEDURE());
	END CATCH
END
GO



EXEC GetCustomerSummary @Country = 'Germany'


