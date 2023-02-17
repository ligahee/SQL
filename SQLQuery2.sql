USE AdventureWorks2019
GO
-- 1
select COUNT(*) AS ProdNum
FROM Production.Product

--2
select COUNT(ProductSubcategoryID) AS ProdNum
FROM Production.Product
where ProductSubcategoryID is not null
--3
SELECT ProductSubcategoryID AS 'Subcategory ID', COUNT(*) AS 'Counted Products'
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL
GROUP BY ProductSubcategoryID;

--4
SELECT COUNT(*) AS ProCOUNT
from Production.Product
WHERE ProductSubcategoryID is NULL

--5
SELECT SUM(p.ProductID) AS SUMPro
from Production.ProductInventory as p

--6
SELECT ProductID, SUM(p.ProductID) AS TheSum
FROM Production.ProductInventory AS p
WHERE p.LocationID = 40
GROUP BY p.LocationID, p.ProductID, p.Quantity
HAVING P.Quantity < 100

--7
SELECT Shelf,ProductID, SUM(p.ProductID) AS TheSum
FROM Production.ProductInventory AS p
WHERE p.LocationID = 40
GROUP BY p.LocationID, p.ProductID, p.Quantity, P.Shelf
HAVING P.Quantity < 100

--8
SELECT AVG(Quantity) AS TheAVG
FROM Production.ProductInventory AS p
WHERE p.LocationID = 10
GROUP BY p.LocationID, p.ProductID, p.Quantity

--9
SELECT p.ProductID, p.Shelf,AVG(p.Quantity) AS TheAVG
FROM Production.ProductInventory AS p
GROUP BY p.ProductID, p.Shelf, p.Quantity

--10
SELECT p.ProductID, p.Shelf,AVG(p.Quantity) AS TheAVG
FROM Production.ProductInventory AS p
where p.Shelf != 'N/A'
GROUP BY p.ProductID, p.Shelf, p.Quantity

--11 average list price in the Production.Product table. This should be grouped independently
--over the Color and the Class column. Exclude the rows where Color or Class are null.
SELECT p.Color,p.Class,COUNT(p.Color) AS TheCount ,AVG(p.ListPrice) AS AVGPrice
FROM Production.Product AS p
where LEN(p.Color)*LEN(p.Class) is not null
GROUP BY p.Color,p.Class

--12 lists the country and province names from person. CountryRegion and person. StateProvince tables. Join them 
SELECT c.Name as Country, s.Name as Province
FROM Person.CountryRegion c inner join Person.StateProvince s on c.CountryRegionCode = s.CountryRegionCode

--13 lists the country and province names from person. CountryRegion and person. 
-- StateProvince tables and list the countries filter them by Germany and Canada. 
-- Join them and produce a result set similar to the following.
SELECT c.Name as Country, s.Name as Province
FROM Person.CountryRegion c inner join Person.StateProvince s on c.CountryRegionCode = s.CountryRegionCode
WHERE c.Name in ('Germany','Canada')

use Northwind
GO
--14 List all Products that has been sold at least once in last 25 years.
SELECT DISTINCT p.ProductName
FROM Products as p
JOIN [Order Details] od ON p.ProductID = od.ProductID
JOIN Orders o ON od.OrderID = o.OrderID
WHERE o.OrderDate >= DATEADD(year,-25,GETDATE())
--15
SELECT TOP 5 o.ShipPostalCode AS [Zip Code], COUNT(*) AS [Product Count]
FROM [Order Details] AS od
INNER JOIN Orders o on od.OrderID = o.OrderID
where o.ShippedDate IS NOT NULL
GROUP BY o.ShipPostalCode
ORDER BY COUNT(*) DESC
--16 List top 5 locations (Zip Code) where the products sold most in last 25 years.
SELECT TOP 5 o.ShipPostalCode AS [Zip Code], COUNT(*) AS [Product Count]
FROM [Order Details] AS od
INNER JOIN Orders o on od.OrderID = o.OrderID
where o.ShippedDate IS NOT NULL
AND o.OrderDate >= DATEADD(year,-25,GETDATE())
GROUP BY o.ShipPostalCode
ORDER BY COUNT(*) DESC
--17  List all city names and number of customers in that city.     
SELECT City, COUNT(*) AS [Customer Num]
FROM Customers
GROUP BY City
--18 List city names which have more than 2 customers, and number of customers in that city
SELECT City, COUNT(*) AS [Customer Num]
FROM Customers
GROUP BY City
HAVING COUNT(*) > 2
--19 List the names of customers who placed orders after 1/1/98 with order date.
SELECT o.OrderDate ,
(SELECT c.ContactName
FROM Customers c
WHERE o.CustomerID = c.CustomerID) AS Name
FROM Orders o 
WHERE o.OrderDate > '1998-01-01'
--20 List the names of all customers with most recent order dates
SELECT Customers.ContactName, MAX(Orders.OrderDate) AS 'Most Recent Order Date'
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.ContactName
ORDER BY MAX(Orders.OrderDate) DESC

--21 Display the names of all customers  along with the  count of products they bought
SELECT c.ContactName, COUNT(*) AS 'Count'
FROM Customers AS c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.ContactName

--22 Display the customer ids who bought more than 100 Products with count of products.
SELECT o.CustomerID, COUNT(*) AS 'Product Count'
FROM Orders AS o
JOIN [Order Details] od ON od.OrderID = od.OrderID
GROUP BY o.CustomerID
HAVING COUNT(*) > 100
--23 Possible ways that suppliers can ship their products.
SELECT s.CompanyName AS [Supplier Company Name], sh.CompanyName AS [Shipping Company Name]
FROM Suppliers AS s
JOIN Products p on s.SupplierID = p.SupplierID
JOIN Shippers sh ON sh.ShipperID = p.SupplierID
--24 Display the products order each day. Show Order date and Product Name.
SELECT o.OrderDate, p.ProductName
FROM Orders AS o
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
ORDER BY o.OrderDate
--25 Displays pairs of employees who have the same job title.
SELECT e1.EmployeeID AS [Employee 1 ID], e1.Title AS [Employee 1 Title], e2.EmployeeID AS [Employee 2 ID], e2.Title AS [Employee 2 Title]
FROM Employees e1
JOIN Employees e2 ON e1.EmployeeID < e2.EmployeeID AND e1.Title = e2.Title
--26 Display all the Managers who have more than 2 employees reporting to them
SELECT e1.FirstName, e1.LastName ,COUNT(e2.EmployeeID) AS 'NUM Employees'
FROM Employees e1
JOIN Employees e2 ON e1.EmployeeID = e2.ReportsTo
WHERE e1.Title LIKE '%Manager%'
GROUP BY e1.EmployeeID,e1.FirstName,e1.LastName
HAVING COUNT(e2.EmployeeID) >2
--27 Display the customers and suppliers by city. The results should have the following
SELECT c.City AS City, c.CompanyName AS Name, c.ContactName, 'Customer' AS 'Type'
FROM Customers  AS c
UNION
SELECT s.City AS City, s.CompanyName AS Name, s.ContactName, 'Supplier' AS 'Type'
FROM Suppliers  AS s
ORDER BY City,Name, Type