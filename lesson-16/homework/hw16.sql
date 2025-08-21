CREATE DATABASE homework16
GO 
USE homework16

--Lesson-16: CTEs and Derived Tables

--Data and Tables

DROP TABLE IF EXISTS Numbers1

CREATE TABLE Numbers1(Number INT)

INSERT INTO Numbers1 VALUES (5),(9),(8),(6),(7)

DROP TABLE IF EXISTS FindSameCharacters
CREATE TABLE FindSameCharacters
(
     Id INT
    ,Vals VARCHAR(10)
)
 
INSERT INTO FindSameCharacters VALUES
(1,'aa'),
(2,'cccc'),
(3,'abc'),
(4,'aabc'),
(5,NULL),
(6,'a'),
(7,'zzz'),
(8,'abc')


DROP TABLE IF EXISTS RemoveDuplicateIntsFromNames
CREATE TABLE RemoveDuplicateIntsFromNames
(
      PawanName INT
    , Pawan_slug_name VARCHAR(1000)
)
 
 
INSERT INTO RemoveDuplicateIntsFromNames VALUES
(1,  'PawanA-111'  ),
(2, 'PawanB-123'   ),
(3, 'PawanB-32'    ),
(4, 'PawanC-4444' ),
(5, 'PawanD-3'  )




DROP TABLE IF EXISTS Example
CREATE TABLE Example
(
Id       INTEGER IDENTITY(1,1) PRIMARY KEY,
String VARCHAR(30) NOT NULL
);


INSERT INTO Example VALUES('123456789'),('abcdefghi');

DROP TABLE IF EXISTS Employee
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    DepartmentID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Salary DECIMAL(10, 2)
);

INSERT INTO Employees (EmployeeID, DepartmentID, FirstName, LastName, Salary) VALUES
(1, 1, 'John', 'Doe', 60000.00),
(2, 1, 'Jane', 'Smith', 65000.00),
(3, 2, 'James', 'Brown', 70000.00),
(4, 3, 'Mary', 'Johnson', 75000.00),
(5, 4, 'Linda', 'Williams', 80000.00),
(6, 2, 'Michael', 'Jones', 85000.00),
(7, 1, 'Robert', 'Miller', 55000.00),
(8, 3, 'Patricia', 'Davis', 72000.00),
(9, 4, 'Jennifer', 'García', 77000.00),
(10, 1, 'William', 'Martínez', 69000.00);

DROP TABLE IF EXISTS Departments
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, 'HR'),
(2, 'Sales'),
(3, 'Marketing'),
(4, 'Finance'),
(5, 'IT'),
(6, 'Operations'),
(7, 'Customer Service'),
(8, 'R&D'),
(9, 'Legal'),
(10, 'Logistics');

DROP TABLE IF EXISTS Sales
CREATE TABLE Sales (
    SalesID INT PRIMARY KEY,
    EmployeeID INT,
    ProductID INT,
    SalesAmount DECIMAL(10, 2),
    SaleDate DATE
);
INSERT INTO Sales (SalesID, EmployeeID, ProductID, SalesAmount, SaleDate) VALUES
-- January 2025
(1, 1, 1, 1550.00, '2025-01-02'),
(2, 2, 2, 2050.00, '2025-01-04'),
(3, 3, 3, 1250.00, '2025-01-06'),
(4, 4, 4, 1850.00, '2025-01-08'),
(5, 5, 5, 2250.00, '2025-01-10'),
(6, 6, 6, 1450.00, '2025-01-12'),
(7, 7, 1, 2550.00, '2025-01-14'),
(8, 8, 2, 1750.00, '2025-01-16'),
(9, 9, 3, 1650.00, '2025-01-18'),
(10, 10, 4, 1950.00, '2025-01-20'),
(11, 1, 5, 2150.00, '2025-02-01'),
(12, 2, 6, 1350.00, '2025-02-03'),
(13, 3, 1, 2050.00, '2025-02-05'),
(14, 4, 2, 1850.00, '2025-02-07'),
(15, 5, 3, 1550.00, '2025-02-09'),
(16, 6, 4, 2250.00, '2025-02-11'),
(17, 7, 5, 1750.00, '2025-02-13'),
(18, 8, 6, 1650.00, '2025-02-15'),
(19, 9, 1, 2550.00, '2025-02-17'),
(20, 10, 2, 1850.00, '2025-02-19'),
(21, 1, 3, 1450.00, '2025-03-02'),
(22, 2, 4, 1950.00, '2025-03-05'),
(23, 3, 5, 2150.00, '2025-03-08'),
(24, 4, 6, 1700.00, '2025-03-11'),
(25, 5, 1, 1600.00, '2025-03-14'),
(26, 6, 2, 2050.00, '2025-03-17'),
(27, 7, 3, 2250.00, '2025-03-20'),
(28, 8, 4, 1350.00, '2025-03-23'),
(29, 9, 5, 2550.00, '2025-03-26'),
(30, 10, 6, 1850.00, '2025-03-29'),
(31, 1, 1, 2150.00, '2025-04-02'),
(32, 2, 2, 1750.00, '2025-04-05'),
(33, 3, 3, 1650.00, '2025-04-08'),
(34, 4, 4, 1950.00, '2025-04-11'),
(35, 5, 5, 2050.00, '2025-04-14'),
(36, 6, 6, 2250.00, '2025-04-17'),
(37, 7, 1, 2350.00, '2025-04-20'),
(38, 8, 2, 1800.00, '2025-04-23'),
(39, 9, 3, 1700.00, '2025-04-26'),
(40, 10, 4, 2000.00, '2025-04-29'),
(41, 1, 5, 2200.00, '2025-05-03'),
(42, 2, 6, 1650.00, '2025-05-07'),
(43, 3, 1, 2250.00, '2025-05-11'),
(44, 4, 2, 1800.00, '2025-05-15'),
(45, 5, 3, 1900.00, '2025-05-19'),
(46, 6, 4, 2000.00, '2025-05-23'),
(47, 7, 5, 2400.00, '2025-05-27'),
(48, 8, 6, 2450.00, '2025-05-31'),
(49, 9, 1, 2600.00, '2025-06-04'),
(50, 10, 2, 2050.00, '2025-06-08'),
(51, 1, 3, 1550.00, '2025-06-12'),
(52, 2, 4, 1850.00, '2025-06-16'),
(53, 3, 5, 1950.00, '2025-06-20'),
(54, 4, 6, 1900.00, '2025-06-24'),
(55, 5, 1, 2000.00, '2025-07-01'),
(56, 6, 2, 2100.00, '2025-07-05'),
(57, 7, 3, 2200.00, '2025-07-09'),
(58, 8, 4, 2300.00, '2025-07-13'),
(59, 9, 5, 2350.00, '2025-07-17'),
(60, 10, 6, 2450.00, '2025-08-01');

DROP TABLE IF EXISTS Products
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    CategoryID INT,
    ProductName VARCHAR(100),
    Price DECIMAL(10, 2)
);

INSERT INTO Products (ProductID, CategoryID, ProductName, Price) VALUES
(1, 1, 'Laptop', 1000.00),
(2, 1, 'Smartphone', 800.00),
(3, 2, 'Tablet', 500.00),
(4, 2, 'Monitor', 300.00),
(5, 3, 'Headphones', 150.00),
(6, 3, 'Mouse', 25.00),
(7, 4, 'Keyboard', 50.00),
(8, 4, 'Speaker', 200.00),
(9, 5, 'Smartwatch', 250.00),
(10, 5, 'Camera', 700.00);

--Easy Tasks
--(1) Create a numbers table using a recursive query from 1 to 1000.
;WITH CTE_recursive AS (
	SELECT 1 AS n
	UNION ALL
	SELECT n + 1 
	FROM CTE_recursive
	WHERE n < 1000
)
SELECT * 
FROM CTE_recursive
OPTION (MAXRECURSION 1000);

--(2) Write a query to find the total sales per employee using a derived table.(Sales, Employees)
SELECT 
	e.FirstName,
	e.LastName,
	Total.Total_Sales
FROM Employees e
LEFT JOIN (SELECT EmployeeID, SUM(SalesAmount) AS Total_Sales FROM Sales GROUP BY EmployeeID) AS Total
ON e.EmployeeID = Total.EmployeeID
ORDER BY e.FirstName, e.LastName;

--(3) Create a CTE to find the average salary of employees.(Employees)
;WITH CTE_AvgSalary AS (
	SELECT FirstName, LastName, CAST(AVG(Salary) AS decimal(10,2)) AS AvgSalary 
	FROM Employees
	GROUP BY FirstName, LastName
)
SELECT * FROM CTE_AvgSalary;

--(4) Write a query using a derived table to find the highest sales for each product.(Sales, Products)
;WITH CTE_Highest_Sales AS (
	SELECT 
		p.ProductID,
		p.ProductName, 
		MAX(s.SalesAmount) AS HighestSales
	FROM Products p
	JOIN Sales s ON p.ProductID = s.ProductID
	GROUP BY p.ProductID, p.ProductName
)
SELECT 
	ProductID, 
	ProductName, 
	HighestSales FROM CTE_Highest_Sales
ORDER BY ProductID;

--(5) Beginning at 1, write a statement to double the number for each record, the max value you get should be less than 1000000.
;WITH CTE_dbNum AS (
	SELECT 1 AS n
	UNION ALL
	SELECT n * 2
	FROM CTE_dbNum
	WHERE n * 2 < 1000000
)
SELECT * FROM CTE_dbNum;

--(6) Use a CTE to get the names of employees who have made more than 5 sales.(Sales, Employees)
;WITH CTE_SalesCount AS (
SELECT 
	EmployeeID, 
	COUNT(*) AS #ofSales
FROM Sales 
GROUP BY EmployeeID
HAVING COUNT(*) > 5
)
SELECT 
	e.FirstName,
	e.LastName,
	sc.#ofSales
FROM Employees e
INNER JOIN CTE_SalesCount sc
	ON e.DepartmentID = sc.EmployeeID
ORDER BY e.FirstName, e.LastName;

--(7) Write a query using a CTE to find all products with sales greater than $500.(Sales, Products)
;WITH HighSales AS (
    SELECT 
        s.ProductID,
        s.SalesAmount
    FROM Sales s
    WHERE s.SalesAmount > 500
)
SELECT 
    p.ProductID,
    p.ProductName,
    hs.SalesAmount
FROM Products p
INNER JOIN HighSales hs
    ON p.ProductID = hs.ProductID
ORDER BY p.ProductID, hs.SalesAmount;

--(8) Create a CTE to find employees with salaries above the average salary.(Employees)
;WITH AvgSalary AS (
SELECT FirstName, LastName, Salary
FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees)
)
SELECT * FROM AvgSalary;


--Medium Tasks
--(1) Write a query using a derived table to find the top 5 employees by the number of orders made.(Employees, Sales)
SELECT 
	TOP 5 
	e.FirstName, 
	e.LastName, 
	s.NumofOrders
FROM Employees e
JOIN (SELECT EmployeeID, COUNT(SalesID) AS NumofOrders FROM Sales GROUP BY EmployeeID) AS s
	ON e.EmployeeID = s.EmployeeID
ORDER BY e.FirstName, e.LastName;

--(2) Write a query using a derived table to find the sales per product category.(Sales, Products)
SELECT
	p.ProductID,
	p.ProductName,
	s.TotalSales
FROM Products p
JOIN (SELECT ProductID, SUM(SalesAmount) as TotalSales FROM Sales GROUP BY ProductID) AS s
	ON p.ProductID = s.ProductID;
	
--(3) Write a script to return the factorial of each value next to it.(Numbers1)
;WITH factoralCTE AS
(
	SELECT 
		Number,
		CAST(1 AS BIGINT) AS Factorial,
		1 AS CurrentNum
	FROM Numbers1
	UNION ALL
	SELECT 
		n1.Number,
		f.Factorial * CAST(f.CurrentNum + 1 AS BIGINT),
		f.CurrentNum + 1
	FROM Numbers1 n1
	INNER JOIN factoralCTE f
		ON n1.Number = f.Number AND f.CurrentNum < n1.Number
)
SELECT Number, MAX(Factorial) AS Factorial 
FROM factoralCTE
GROUP BY Number
ORDER BY Number

--(4) This script uses recursion to split a string into rows of substrings for each character in the string.(Example)
;WITH Numbers AS (
	SELECT 1 AS i
	UNION ALL SELECT 2
	UNION ALL SELECT 3
	UNION ALL SELECT 4
	UNION ALL SELECT 5
	UNION ALL SELECT 6
	UNION ALL SELECT 7
	UNION ALL SELECT 8
	UNION ALL SELECT 9
)
SELECT 
	SUBSTRING(MAX(CASE WHEN e.Id = 1 THEN e.String END), n.i, 1) AS Number,
	SUBSTRING(MAX(CASE WHEN e.Id = 2 THEN e.String END), n.i, 1) AS Character
FROM Example e
CROSS JOIN Numbers n
WHERE n.i <= LEN(e.String)
GROUP BY n.i
ORDER BY n.i;

--(5) Use a CTE to calculate the sales difference between the current month and the previous month.(Sales)
SELECT * FROM Sales

;WITH MonthlySalesDiff AS (
	SELECT
		DATEFROMPARTS(YEAR(SaleDate), MONTH(SaleDate), 1) AS Month,
		SUM(SalesAmount) AS TotalSales
	FROM Sales
	GROUP BY YEAR(SaleDate), MONTH(SaleDate)
)
SELECT 
	m1.Month,
	m1.TotalSales,
	m1.TotalSales - m2.TotalSales AS SalesDifference
FROM MonthlySalesDiff m1
LEFT JOIN MonthlySalesDiff m2
	ON m1.Month = DATEADD(MONTH, 1, m2.Month)
ORDER BY m1.Month;

--(6) Create a derived table to find employees with sales over $45000 in each quarter.(Sales, Employees)
SELECT * FROM Sales
SELECT * FROM Employees

SELECT 
	DATEPART(QUARTER, s.SaleDate) AS QuarterlySales,
	e.FirstName,
	e.LastName,
	SUM(s.SalesAmount) AS TotalSales
	FROM Sales s
JOIN Employees e
	ON s.EmployeeID = e.EmployeeID
GROUP BY DATEPART(QUARTER, s.SaleDate), e.FirstName, e.LastName

--Difficult Tasks
--(1) This script uses recursion to calculate Fibonacci numbers
;WITH FibonacciCTE AS (

	SELECT 
		1 AS n,
		CAST(0 AS BIGINT) AS Value,
		CAST(1 AS BIGINT) AS Next_value
	UNION ALL

	SELECT 
		n + 1,
		Next_value,
		Value + Next_value
	FROM FibonacciCTE
	WHERE n + 1 <= 20
)
SELECT n, Value AS Fibonacci_number
FROM FibonacciCTE;

--(2) Find a string where all characters are the same and the length is greater than 1.(FindSameCharacters)

;WITH SameCharCTE AS (
    SELECT Id, Vals
    FROM FindSameCharacters
    WHERE LEN(Vals) > 1 
        AND Vals = REPLICATE(LEFT(Vals, 1), LEN(Vals))
)
SELECT Id, Vals
FROM SameCharCTE
ORDER BY Id;

--(3) Create a numbers table that shows all numbers 1 through n and their order gradually increasing by the next number in the sequence.
--(Example:n=5 | 1, 12, 123, 1234, 12345)

;WITH tabCTE AS (
    SELECT 
		1 AS n, 
		CAST('1' AS VARCHAR(50)) AS Sequence
    UNION ALL
    SELECT 
        n + 1,
        CAST(Sequence + CAST(n + 1 AS VARCHAR(10)) AS VARCHAR(50))
    FROM tabCTE
    WHERE n < 5
)
SELECT n, Sequence
FROM tabCTE
ORDER BY n;

--(4) Write a query using a derived table to find the employees who have made the most sales in the last 6 months.(Employees,Sales)

SELECT 
	e.FirstName,
	e.LastName,
	s.totalSales
FROM Employees e
JOIN 
	(SELECT EmployeeID, SUM(SalesAmount) AS totalSales
	FROM Sales
	WHERE MONTH(SaleDate) >= DATEADD(MONTH, -6, (SELECT MAX(MONTH(SalesAmount)) FROM Sales)) 
		AND SaleDate <= (SELECT MAX(SaleDate) FROM Sales)
	GROUP BY EmployeeID) AS s
		ON e.EmployeeID = s.EmployeeID
	ORDER BY s.totalSales DESC;

--(5) Write a T-SQL query to remove the duplicate integer values present in the string column. Additionally, 
--remove the single integer character that appears in the string.(RemoveDuplicateIntsFromNames)

WITH StringParts AS (
    SELECT 
        PawanName,
        Pawan_slug_name,
        SUBSTRING(Pawan_slug_name, 1, CHARINDEX('-', Pawan_slug_name) - 1) AS NamePart,
        SUBSTRING(Pawan_slug_name, CHARINDEX('-', Pawan_slug_name) + 1, LEN(Pawan_slug_name)) AS NumberPart
    FROM RemoveDuplicateIntsFromNames
)
SELECT 
    PawanName,
    CASE 
        WHEN LEN(NumberPart) = 1 THEN NamePart + '-'
        WHEN PATINDEX('%[^' + LEFT(NumberPart, 1) + ']%', NumberPart) = 0 THEN NamePart + '-' + LEFT(NumberPart, 1)
        ELSE NamePart + '-' + NumberPart
    END AS Pawan_slug_name
FROM StringParts





;WITH SameCharCTE AS (
    SELECT Id, Vals
    FROM FindSameCharacters
    WHERE LEN(Vals) > 1 
        AND Vals = REPLICATE(LEFT(Vals, 1), LEN(Vals))
)
SELECT Id, Vals
FROM SameCharCTE
ORDER BY Id;
