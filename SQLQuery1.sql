USE AdventureWorks2019
GO

--1 retrieves the columns ProductID, Name, Color and ListPrice from
--the Production.Product table, with no filter
Select ProductID, Name, Color,  ListPrice
FROM Production.Product

--2 excludes the rows that ListPrice is 0
Select ProductID, Name, Color,  ListPrice
FROM Production.Product
WHERE ListPrice != 0

--3 the rows that are NULL for the Color column
Select ProductID, Name, Color,  ListPrice
FROM Production.Product
WHERE Color is null

--4 the rows that are not NULL for the Color column
Select ProductID, Name, Color,  ListPrice
FROM Production.Product
WHERE Color is not null

--5 the rows that are not NULL for the column Color, and the column ListPrice has a value greater than zero.
Select ProductID, Name, Color,  ListPrice
FROM Production.Product
WHERE Color is not null and ListPrice > 0

--6 concatenates the columns Name and Color
--from the Production.Product table by excluding the rows that are null for color.
SELECT Name+''+Color AS "Name Color"
FROM Production.Product
where Color is not null

--7 
SELECT Name, Color
FROM Production.Product
where (Name Like '%Crankarm' OR Name Like 'Chainring%')

--8  retrieve the to the columns ProductID and Name 
--from the Production.Product table filtered by ProductID from 400 to 500
SELECT Name, ProductID
FROM Production.Product
where ProductID between 400 and 500

--9 ProductID, Name and color 
--from the Production.Product table restricted to the colors black and blue
SELECT Name, ProductID, Color
FROM Production.Product
where Color IN ('black','blue')

--10 Get a result set on products that begins with the letter S
Select *
From  Production.Product
where Name LIKE 'S%'

--11 retrieves the columns Name and ListPrice from the Production.Product table. 
Select TOP(6)
Name, ListPrice
FROM Production.Product
where (Name Like 'Seat%' OR Name Like 'Short%[^S-X]') and ListPrice IN (0,53.99)
ORDER BY Name 

--12 
Select TOP(5)
Name, ListPrice
FROM Production.Product
where (Name Like 'A%' OR Name Like 'S%') and ListPrice IN (0,8.99, 159)
ORDER BY Name 

--13
Select *
FROM Production.Product
where Name Like 'SPO[^K]%'
ORDER BY Name 

--14 retrieves unique colors, Order the results  in descending  manner
Select Distinct Color 
FROM Production.Product
WHERE Color is not null
ORDER BY Color DESC

--15 unique combination of columns ProductSubcategoryID and Color from the Production.Product table
Select ProductSubcategoryID, Color
FROM Production.Product
WHERE LEN(ProductSubcategoryID)*LEN(Color) is not null
ORDER BY ProductSubcategoryID, Color