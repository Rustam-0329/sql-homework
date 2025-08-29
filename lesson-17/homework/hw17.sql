CREATE DATABASE homework17
GO
USE homework17


--PRACTICE

--1. You must provide a report of all distributors and their sales by region. 
--If a distributor did not have any sales for a region, provide a zero-dollar value for that day. 
--Assume there is at least one sale for each region

--SQL Setup:
DROP TABLE IF EXISTS #RegionSales;
GO
CREATE TABLE #RegionSales (
  Region      VARCHAR(100),
  Distributor VARCHAR(100),
  Sales       INTEGER NOT NULL,
  PRIMARY KEY (Region, Distributor)
);
GO
INSERT INTO #RegionSales (Region, Distributor, Sales) VALUES
('North','ACE',10), ('South','ACE',67), ('East','ACE',54),
('North','ACME',65), ('South','ACME',9), ('East','ACME',1), ('West','ACME',7),
('North','Direct Parts',8), ('South','Direct Parts',7), ('West','Direct Parts',12);

--SOLUTION
SELECT 
	r.Region,
	d.Distributor,
	COALESCE(rs.Sales, 0) AS Sales
	FROM (SELECT DISTINCT Distributor FROM #RegionSales) AS d
CROSS JOIN (SELECT DISTINCT Region FROM #RegionSales) AS r
LEFT JOIN #RegionSales rs ON rs.Distributor = d.Distributor AND rs.Region = r.Region 
ORDER BY d.Distributor


--2. Find managers with at least five direct reports
--SQL Setup:

DROP TABLE IF EXISTS Employee;
GO
CREATE TABLE Employee (id INT, name VARCHAR(255), department VARCHAR(255), managerId INT);
TRUNCATE TABLE Employee;
INSERT INTO Employee VALUES
(101, 'John', 'A', NULL), (102, 'Dan', 'A', 101), (103, 'James', 'A', 101),
(104, 'Amy', 'A', 101), (105, 'Anne', 'A', 101), (106, 'Ron', 'B', 101);

--SOLUTION

WITH DirectReports AS (
    SELECT 
        e1.id,
        e1.name,
        COUNT(e2.id) AS report_count
    FROM Employee e1
    JOIN Employee e2 ON e2.managerId = e1.id
    GROUP BY e1.id, e1.name
)
SELECT name
FROM DirectReports
WHERE report_count >= 5;


--3. Write a solution to get the names of products that have at least 100 units ordered in February 2020 and their amount.
--SQL Setup:
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Orders
GO
CREATE TABLE Products (product_id INT, product_name VARCHAR(40), product_category VARCHAR(40));
CREATE TABLE Orders (product_id INT, order_date DATE, unit INT);
TRUNCATE TABLE Products;
INSERT INTO Products VALUES
(1, 'Leetcode Solutions', 'Book'),
(2, 'Jewels of Stringology', 'Book'),
(3, 'HP', 'Laptop'), (4, 'Lenovo', 'Laptop'), (5, 'Leetcode Kit', 'T-shirt');
TRUNCATE TABLE Orders;
INSERT INTO Orders VALUES
(1,'2020-02-05',60),(1,'2020-02-10',70),
(2,'2020-01-18',30),(2,'2020-02-11',80),
(3,'2020-02-17',2),(3,'2020-02-24',3),
(4,'2020-03-01',20),(4,'2020-03-04',30),(4,'2020-03-04',60),
(5,'2020-02-25',50),(5,'2020-02-27',50),(5,'2020-03-01',50);

--SOLUTION

;WITH CTE_qty AS (
	SELECT p.product_id, p.product_name, SUM(o.unit) AS quatityOfOrder
	FROM Products p
	JOIN Orders o ON p.product_id = o.product_id
	WHERE MONTH(o.order_date) = 2 AND YEAR(o.order_date) = 2020
	GROUP BY p.product_id, p.product_name
) 
SELECT 
	product_name,
	quatityOfOrder
FROM CTE_qty
WHERE quatityOfOrder >= 100;



--4. Write an SQL statement that returns the vendor from which each customer has placed the most orders
--SQL Setup:

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
  OrderID    INTEGER PRIMARY KEY,
  CustomerID INTEGER NOT NULL,
  [Count]    MONEY NOT NULL,
  Vendor     VARCHAR(100) NOT NULL
);
INSERT INTO Orders VALUES
(1,1001,12,'Direct Parts'), (2,1001,54,'Direct Parts'), (3,1001,32,'ACME'),
(4,2002,7,'ACME'), (5,2002,16,'ACME'), (6,2002,5,'Direct Parts');

--SOLUTION

;WITH CTE_maxOrd AS (
	SELECT 
		CustomerID,
		Vendor,
		SUM(Count) AS TotalQuantity
	FROM Orders
	GROUP BY CustomerID, Vendor
)
SELECT 
	CustomerID,
	Vendor
FROM CTE_maxOrd c1
WHERE TotalQuantity = (SELECT MAX(TotalQuantity) FROM CTE_maxOrd c2 WHERE c2.CustomerID = c1.CustomerID)
ORDER BY CustomerID;

--5. You will be given a number as a variable called @Check_Prime check if this number 
--is prime then return 'This number is prime' else return 'This number is not prime'


DECLARE @Check_Prime INT = 91;
-- Your WHILE-based SQL logic here

--SOLUTION
 DECLARE @Divisor INT = 2;
 DECLARE @IsPrime BIT = 1; --1 FOR PRIME, 0 FOR NOT PRIME
 
 IF @Divisor < 2
	SET @IsPrime = 0;

ELSE
BEGIN
	WHILE @Divisor <= SQRT(@Check_Prime)
	BEGIN
		IF @Check_Prime % @Divisor = 0
		BEGIN
			SET @IsPrime = 0;
			BREAK;
		END
		SET @Divisor = @Divisor + 1;
	END
END

IF @IsPrime = 1
	PRINT CAST(@Check_Prime AS VARCHAR) + ' is a Prime Number';
ELSE
	PRINT CAST(@Check_Prime AS VARCHAR) + ' is NOT a Prime Number';


--6. Write an SQL query to return the number of locations,in which location most signals sent, 
--and total number of signal for each device from the given table.
--SQL Setup:

CREATE TABLE Device(
  Device_id INT,
  Locations VARCHAR(25)
);
INSERT INTO Device VALUES
(12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'),
(12,'Hosur'), (12,'Hosur'),
(13,'Hyderabad'), (13,'Hyderabad'), (13,'Secunderabad'),
(13,'Secunderabad'), (13,'Secunderabad');

--SOLUTION

SELECT * 
FROM Device

;WITH SignalCounts AS (
	SELECT 
		Device_id,
		Locations,
		COUNT(*) AS signal_count
	FROM Device
	GROUP BY Device_id, Locations
),
MostSignalSent AS (
	SELECT
		Device_id,
		COUNT(DISTINCT Locations) AS no_of_location,
		COUNT(*) AS no_of_signals,
		(
			SELECT TOP 1 Locations
			FROM SignalCounts sc
			WHERE sc.Device_id = d.Device_id
			ORDER BY signal_count DESC, Locations
		) AS max_signal_location
	FROM Device d
	GROUP BY Device_id
)
SELECT
	Device_id,
	no_of_location,
	max_signal_location,
	no_of_signals
FROM MostSignalSent;

--7. Write a SQL to find all Employees who earn more than the average salary in their corresponding department. 
--Return EmpID, EmpName,Salary in your output
--SQL Setup:
DROP TABLE IF EXISTS Employee
CREATE TABLE Employee (
  EmpID INT,
  EmpName VARCHAR(30),
  Salary FLOAT,
  DeptID INT
);
INSERT INTO Employee VALUES
(1001,'Mark',60000,2), (1002,'Antony',40000,2), (1003,'Andrew',15000,1),
(1004,'Peter',35000,1), (1005,'John',55000,1), (1006,'Albert',25000,3), (1007,'Donald',35000,3);

--SOLUTION
SELECT * FROM Employee

;WITH AVGsalary AS (
	SELECT DeptID, AVG(Salary) AS Avg_Salary 
	FROM Employee
	GROUP BY DeptID
)
SELECT 
	e.EmpID,
	e.EmpName,
	e.Salary
FROM Employee e
INNER JOIN AVGsalary avs ON e.DeptID = avs.DeptID
WHERE e.Salary >= avs.Avg_Salary;

--8. You are part of an office lottery pool where you keep a table of the winning lottery numbers along with a table of each ticket’s chosen numbers. 
--If a ticket has some but not all the winning numbers, you win $10. If a ticket has all the winning numbers, you win $100. 
--Calculate the total winnings for today’s drawing.
--Winning Numbers:

-- Step 1: Create the table
CREATE TABLE Numbers (
    Number INT
);

-- Step 2: Insert values into the table
INSERT INTO Numbers (Number)
VALUES
(25),
(45),
(78);


-- Step 1: Create the Tickets table
CREATE TABLE Tickets (
    TicketID VARCHAR(10),
    Number INT
);

-- Step 2: Insert the data into the table
INSERT INTO Tickets (TicketID, Number)
VALUES
('A23423', 25),
('A23423', 45),
('A23423', 78),
('B35643', 25),
('B35643', 45),
('B35643', 98),
('C98787', 67),
('C98787', 86),
('C98787', 91);

SELECT * FROM Numbers
SELECT * FROM Tickets

--SOLUTION

;WITH MatchCounts AS (
    SELECT 
        t.TicketID,
        COUNT(n.Number) AS match_count,
        (SELECT COUNT(*) FROM Numbers) AS total_winning_numbers
    FROM Tickets t
    LEFT JOIN Numbers n ON t.Number = n.Number
    GROUP BY t.TicketID
)
SELECT SUM(
    CASE 
        WHEN match_count = total_winning_numbers THEN 100
        WHEN match_count > 0 THEN 10
        ELSE 0
    END
) AS total_winnings
FROM MatchCounts;


--9. The Spending table keeps the logs of the spendings history of users that make purchases from an online shopping website which has a desktop and a mobile devices.
--Write an SQL query to find the total number of users and the total amount spent using mobile only, desktop only and both mobile and desktop together for each date.

CREATE TABLE Spending (
  User_id INT,
  Spend_date DATE,
  Platform VARCHAR(10),
  Amount INT
);
INSERT INTO Spending VALUES
(1,'2019-07-01','Mobile',100),
(1,'2019-07-01','Desktop',100),
(2,'2019-07-01','Mobile',100),
(2,'2019-07-02','Mobile',100),
(3,'2019-07-01','Desktop',100),
(3,'2019-07-02','Desktop',100);


--SOLUTION

WITH UserPlatformCount AS (
    SELECT 
        Spend_date,
        User_id,
        SUM(CASE WHEN Platform = 'Mobile' THEN 1 ELSE 0 END) AS mobile_count,
        SUM(CASE WHEN Platform = 'Desktop' THEN 1 ELSE 0 END) AS desktop_count,
        SUM(Amount) AS total_amount
    FROM Spending
    GROUP BY Spend_date, User_id
)
SELECT 
    Spend_date,
    CASE 
        WHEN mobile_count > 0 AND desktop_count > 0 THEN 'both'
        WHEN mobile_count > 0 THEN 'mobile only'
        WHEN desktop_count > 0 THEN 'desktop only'
    END AS platform,
    COUNT(DISTINCT User_id) AS total_users,
    SUM(total_amount) AS total_amount
FROM UserPlatformCount
GROUP BY 
    Spend_date,
    CASE 
        WHEN mobile_count > 0 AND desktop_count > 0 THEN 'both'
        WHEN mobile_count > 0 THEN 'mobile only'
        WHEN desktop_count > 0 THEN 'desktop only'
    END
UNION
SELECT 
    Spend_date,
    'both' AS platform,
    0 AS total_users,
    0 AS total_amount
FROM Spending
WHERE Spend_date NOT IN (
    SELECT Spend_date 
    FROM UserPlatformCount 
    WHERE mobile_count > 0 AND desktop_count > 0
)
GROUP BY Spend_date
ORDER BY total_users DESC, Spend_date;


--10. Write an SQL Statement to de-group the following data.
--Input Table: 'Grouped'

DROP TABLE IF EXISTS Grouped;
CREATE TABLE Grouped
(
  Product  VARCHAR(100) PRIMARY KEY,
  Quantity INTEGER NOT NULL
);
INSERT INTO Grouped (Product, Quantity) VALUES
('Pencil', 3), ('Eraser', 4), ('Notebook', 2);

--SOLUTION
-- Calculate the maximum Quantity needed for recursion
DECLARE @max_quantity INT = (SELECT MAX(Quantity) FROM Grouped);

;WITH Numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1
    FROM Numbers
    WHERE n < @max_quantity
)
SELECT 
    g.Product,
    1 AS Quantity
FROM Grouped g
CROSS APPLY (
    SELECT n
    FROM Numbers
    WHERE n <= g.Quantity
) n
ORDER BY g.Product;
