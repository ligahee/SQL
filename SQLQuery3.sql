USE Northwind
Go

--1 List all cities that have both Employees and Customers
SELECT City
FROM (
SELECT City, 'Employee' AS Type
FROM Employees
union ALL
SELECT City, 'Customer' AS Type
FROM Customers
)AS EC
Group  by City
HAVING COUNT(DISTINCT Type) = 2

--2 List all cities that have Customers but no Employee.
    --Use sub-query
SELECT City
FROM Customers
WHERE City Not in (
	SELECT DISTINCT City
	FROM Employees
	)
	-- Do not use sub-query
SELECT C.City 
FROM Customers AS C
LEFT JOIN Employees e on C.City = e.City
WHERE e.City IS NULL

--3 List all products and their total order quantities throughout all orders.
SELECT p.ProductName, p.ProductID, SUM(od.Quantity) AS [total order quantities]
FROM Products p
inner join [Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY [total order quantities]

--4 List all Customer Cities and total products ordered by that city.
SELECT c.City, SUM(od.Quantity) AS [Total products ordered]
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN [Order Details] od ON od.OrderID  = o.OrderID
GROUP BY c.City

--5 List all Customer Cities that have at least two customers.
 -- Use UNION
SELECT City
FROM Customers
GROUP BY City
HAVING COUNT(CustomerID) >= 2
UNION
SELECT City
FROM Employees
GROUP BY City
HAVING COUNT(EmployeeID) >= 2
	--Use sub-query and no union
SELECT DISTINCT City
FROM Customers
WHERE City IN (
    SELECT City
    FROM Customers
    GROUP BY City
    HAVING COUNT(CustomerID) >= 2
)

--6 Customer Cities that have ordered at least two different kinds of products
SELECT Distinct c.City
FROM Customers c
INNER JOIN Orders o ON o.CustomerID = c.CustomerID
INNER JOIN [Order Details] od ON od.OrderID = o.OrderID
GROUP BY c.CustomerID, c.City
HAVING COUNT(DISTINCT od.ProductID) >= 2

--7 Customers who have ordered products, but have the ‘ship city’ 
--on the order different from their own customer cities
SELECT c.CustomerID, c.CompanyName
FROM Customers c
INNER JOIN Orders o ON o.CustomerID = c.CustomerID
WHERE o.ShipAddress <> c.City

--8 List 5 most popular products, their average price,
--and the customer city that ordered most quantity of it.
SELECT TOP 5
    p.ProductName,
    AVG(od.UnitPrice) AS AvgPrice,
    (SELECT TOP 1 c.City
     FROM Customers c
     INNER JOIN Orders o ON c.CustomerID = o.CustomerID
     INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
     WHERE od.ProductID = p.ProductID
     GROUP BY c.City
     ORDER BY SUM(od.Quantity) DESC
    ) AS MostPopularCity
FROM Products p
INNER JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductName, p.ProductID
ORDER BY SUM(od.Quantity) DESC

--9 List all cities that have never ordered something but we have employees there.
-- USE SUB-QUERY
SELECT DISTINCT  e.City
FROM Employees e
WHERE e.City NOT IN  (
	SELECT DISTINCT o.ShipCity
	FROM Orders o
	WHERE e.EmployeeID = o.EmployeeID)
	GROUP BY e.City

--Do not use sub-query
SELECT DISTINCT e.City
FROM Employees e
LEFT JOIN Orders o ON e.EmployeeID = o.EmployeeID
GROUP BY e.City
HAVING COUNT(DISTINCT o.ShipCity) = 0

--10 List one city, if exists, that is the city from where the employee sold most orders
 -- (not the product quantity) is, 
 --and also the city of most total quantity of products ordered from.
SELECT Top 1 e.City
FROM Orders o
INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
GROUP BY e.City
HAVING COUNT (DISTINCT o.OrderID) = (
	SELECT MAX(NumOrders)
	FROM (
		select COUNT(*) AS NumOrders
		FROM Orders
		GROUP BY EmployeeID) AS oe)
AND  e.City = (
     SELECT TOP 1 o.ShipCity
	 FROM Orders o
	 INNER JOIN [Order Details] od ON od.OrderID = o.OrderID
	 GROUP BY o.ShipCity, o.OrderID
	 ORDER BY SUM(od.Quantity) DESC
	 )

 --How do you remove the duplicates record of a table?
 -- USE 'DISTINCT' IN A SELECT statement
 -- If you want to permanently remove the duplicate rows from the table, 
     --you can use the DELETE statement with a subquery that identifies the duplicates.