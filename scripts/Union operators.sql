--Union queries

SELECT 
  FirstName,
  LastName
FROM Sales.Customers

UNION ALL

SELECT 
   FirstName,
   LastName
FROM Sales.Employees

SELECT 
  FirstName,
  LastName
FROM Sales.Customers

INTERSECT

SELECT 
   FirstName,
   LastName
FROM Sales.Employees