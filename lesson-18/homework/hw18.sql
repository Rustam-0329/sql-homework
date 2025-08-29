CREATE DATABASE homework18
GO
USE homework18

--Lesson-18: View, temp table, variable, functions

--You're working in a database for a Retail Sales System. The database contains the following tables:

DROP TABLE IF EXISTS Products;
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);

DROP TABLE IF EXISTS Sales;
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    SaleDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Products (ProductID, ProductName, Category, Price)
VALUES
(1, 'Samsung Galaxy S23', 'Electronics', 899.99),
(2, 'Apple iPhone 14', 'Electronics', 999.99),
(3, 'Sony WH-1000XM5 Headphones', 'Electronics', 349.99),
(4, 'Dell XPS 13 Laptop', 'Electronics', 1249.99),
(5, 'Organic Eggs (12 pack)', 'Groceries', 3.49),
(6, 'Whole Milk (1 gallon)', 'Groceries', 2.99),
(7, 'Alpen Cereal (500g)', 'Groceries', 4.75),
(8, 'Extra Virgin Olive Oil (1L)', 'Groceries', 8.99),
(9, 'Mens Cotton T-Shirt', 'Clothing', 12.99),
(10, 'Womens Jeans - Blue', 'Clothing', 39.99),
(11, 'Unisex Hoodie - Grey', 'Clothing', 29.99),
(12, 'Running Shoes - Black', 'Clothing', 59.95),
(13, 'Ceramic Dinner Plate Set (6 pcs)', 'Home & Kitchen', 24.99),
(14, 'Electric Kettle - 1.7L', 'Home & Kitchen', 34.90),
(15, 'Non-stick Frying Pan - 28cm', 'Home & Kitchen', 18.50),
(16, 'Atomic Habits - James Clear', 'Books', 15.20),
(17, 'Deep Work - Cal Newport', 'Books', 14.35),
(18, 'Rich Dad Poor Dad - Robert Kiyosaki', 'Books', 11.99),
(19, 'LEGO City Police Set', 'Toys', 49.99),
(20, 'Rubiks Cube 3x3', 'Toys', 7.99);

INSERT INTO Sales (SaleID, ProductID, Quantity, SaleDate)
VALUES
(1, 1, 2, '2025-04-01'),
(2, 1, 1, '2025-04-05'),
(3, 2, 1, '2025-04-10'),
(4, 2, 2, '2025-04-15'),
(5, 3, 3, '2025-04-18'),
(6, 3, 1, '2025-04-20'),
(7, 4, 2, '2025-04-21'),
(8, 5, 10, '2025-04-22'),
(9, 6, 5, '2025-04-01'),
(10, 6, 3, '2025-04-11'),
(11, 10, 2, '2025-04-08'),
(12, 12, 1, '2025-04-12'),
(13, 12, 3, '2025-04-14'),
(14, 19, 2, '2025-04-05'),
(15, 20, 4, '2025-04-19'),
(16, 1, 1, '2025-03-15'),
(17, 2, 1, '2025-03-10'),
(18, 5, 5, '2025-02-20'),
(19, 6, 6, '2025-01-18'),
(20, 10, 1, '2024-12-25'),
(21, 1, 1, '2024-04-20');

SELECT * FROM Products
SELECT * FROM Sales

--1. Create a temporary table named MonthlySales to store the total quantity sold and total revenue for each product in the current month.
--Return: ProductID, TotalQuantity, TotalRevenue
IF OBJECT_ID('tempdb..#MonthlySales') IS NOT NULL DROP TABLE #MonthlySales;
CREATE TABLE #MonthlySales 
(
		ProductID INT,
		TotalQuantity INT,
		TotalRevenue DECIMAL(10,2)
);
INSERT INTO #MonthlySales (ProductID, TotalQuantity, TotalRevenue)
SELECT
	p.ProductID,
	SUM(ISNULL(s.Quantity, 0)) AS TotalQuantity,
	SUM(ISNULL(s.Quantity * p.Price, 0)) AS TotalRevenue
FROM Products p
LEFT JOIN Sales s ON s.ProductID = p.ProductID
WHERE (s.SaleDate >= '2025-04-01' AND s.SaleDate <= '2025-04-30')
   OR s.SaleDate IS NULL
GROUP BY p.ProductID;

SELECT * FROM #MonthlySales ORDER BY ProductID;


--2. Create a view named vw_ProductSalesSummary that returns product info along with total sales quantity across all time.
--Return: ProductID, ProductName, Category, TotalQuantitySold
IF OBJECT_ID('dbo.vw_ProductSalesSummary', 'V') IS NOT NULL
    DROP VIEW dbo.vw_ProductSalesSummary;
GO

CREATE VIEW dbo.vw_ProductSalesSummary 
AS
SELECT 
	p.ProductID,
	p.ProductName,
	p.Category,
	ISNULL(SUM(s.Quantity), 0) AS TotalQuantitySold
FROM Products p
LEFT JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.ProductID, p.ProductName, p.Category;
GO

SELECT * FROM dbo.vw_ProductSalesSummary ORDER BY ProductID;

--3. Create a function named fn_GetTotalRevenueForProduct(@ProductID INT)
--Return: total revenue for the given product ID
IF OBJECT_ID('dbo.fn_GetTotalRevenueForProduct', 'FN') IS NOT NULL
    DROP FUNCTION dbo.fn_GetTotalRevenueForProduct1;
GO

CREATE FUNCTION dbo.fn_GetTotalRevenueForProduct1
(
    @ProductID INT
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @TotalRevenue DECIMAL(10, 2);

    SELECT @TotalRevenue = SUM(s.Quantity * p.Price)
    FROM Products AS p
    JOIN Sales AS s ON s.ProductID = p.ProductID
    WHERE p.ProductID = @ProductID;

    RETURN ISNULL(@TotalRevenue, 0);
END;
GO

SELECT [dbo].fn_GetTotalRevenueForProduct1(1) AS Total_Revenue
GO


--4. Create an function fn_GetSalesByCategory(@Category VARCHAR(50))
--Return: ProductName, TotalQuantity, TotalRevenue for all products in that category.

CREATE OR ALTER FUNCTION dbo.fn_GetSalesByCategory(@Category VARCHAR(50))
RETURNS TABLE
AS
RETURN
	SELECT 
		p.ProductName,
        ISNULL(SUM(s.Quantity), 0) AS TotalQuantity,
        ISNULL(SUM(s.Quantity * p.Price), 0.00) AS TotalRevenue
	FROM dbo.Products AS p
    LEFT JOIN dbo.Sales AS s ON s.ProductID = p.ProductID
    WHERE p.Category = @Category
	GROUP BY p.ProductName;
GO

SELECT * FROM dbo.fn_GetSalesByCategory('Electronics');



--5. You have to create a function that get one argument as input from user and the function should return 'Yes' if the input number is a prime number and 'No' otherwise. 
--You can start it like this:

--Create function dbo.fn_IsPrime (@Number INT)
--Returns ...

IF OBJECT_ID('dbo.fn_IsPrime') IS NOT NULL
    DROP FUNCTION dbo.fn_IsPrime;
GO

CREATE FUNCTION dbo.fn_IsPrime(@Number INT)
RETURNS VARCHAR(3)
AS
BEGIN
	IF @Number <= 1
		RETURN 'No';
	IF @Number = 2
		RETURN 'Yes';
	IF @Number % 2 = 0
		RETURN 'No';

	DECLARE @i INT = 3;
	WHILE (@i * @i <= @Number)
	BEGIN
		IF @Number % @i = 0
			RETURN 'No';
		SET @i = @i + 2;
	END;
	RETURN 'Yes';
END;
GO
SELECT dbo.fn_IsPrime(5) AS IsPrime


--6. Create a table-valued function named fn_GetNumbersBetween that accepts two integers as input:
--@Start INT
--@End INT

--The function should return a table with a single column:

--| Number |
--|--------|
--| @Start |
--...
--...
--...
--|   @end |

--It should include all integer values from @Start to @End, inclusive.

CREATE FUNCTION fn_GetNumbersBetween (@Start INT, @end INT)
RETURNS TABLE
AS
RETURN
(

	WITH Numbers AS (
		SELECT @Start AS Number
		WHERE @Start <= @end
		UNION ALL
		SELECT Number + 1
		FROM Numbers
		WHERE Number < @end
	)
	SELECT Number
	FROM Numbers
);
GO

SELECT * FROM dbo.fn_GetNumbersBetween(1, 8);

--7. Write a SQL query to return the Nth highest distinct salary from the Employee table. 
--If there are fewer than N distinct salaries, return NULL.
--Example 1:
--Input.Employee table:

--| id | salary |
--+----+--------+
--| 1  | 100    |
--| 2  | 200    |
--| 3  | 300    |

--n = 2
--Output:

--| getNthHighestSalary(2) |

--|    HighestNSalary      |
--|------------------------|
--| 200                    |

--Example 2:
--Input.Employee table:

--| id | salary |
--|----|--------|
--| 1  | 100    |

--n = 2
--Output:

--| getNthHighestSalary(2) |

--|    HighestNSalary      |
--|        null            |

--SOLUTION

Create table Employee (Id int, Salary int)
Truncate table Employee
insert into Employee (id, salary) values ('1', '100')
insert into Employee (id, salary) values ('2', '200')
insert into Employee (id, salary) values ('3', '300')


CREATE FUNCTION dbo.getNthHighestSalary (@N INT)
RETURNS INT
AS
BEGIN
    DECLARE @Result INT;

   IF (SELECT COUNT(DISTINCT salary) FROM Employee) < @N
        RETURN NULL;

    SELECT @Result = salary
    FROM (
        SELECT DISTINCT salary
        FROM Employee
        ORDER BY salary DESC
        OFFSET (@N - 1) ROWS FETCH NEXT 1 ROWS ONLY
    ) AS RankedSalaries;

    RETURN @Result;
END;
GO

SELECT dbo.getNthHighestSalary(3) AS getNthHighestSalary;

--8. Write a SQL query to find the person who has the most friends.
--Return: Their id, The total number of friends they have

--Friendship is mutual. For example, if user A sends a request to user B and it's accepted, both A and B are considered friends with each other. The test case is guaranteed to have only one user with the most friends.
--Input.RequestAccepted table:

--| requester_id | accepter_id | accept_date |
--+--------------+-------------+-------------+
--| 1            | 2           | 2016/06/03  |
--| 1            | 3           | 2016/06/08  |
--| 2            | 3           | 2016/06/08  |
--| 3            | 4           | 2016/06/09  |

--Output:

--| id | num |
--+----+-----+
--| 3  | 3   |

--Explanation: The person with id 3 is a friend of people 1, 2, and 4, so he has three friends in total, which is the most number than any others.

Create table RequestAccepted (requester_id int not null, accepter_id int null, accept_date date null)
Truncate table RequestAccepted
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('1', '2', '2016/06/03')
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('1', '3', '2016/06/08')
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('2', '3', '2016/06/08')
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('3', '4', '2016/06/09')

SELECT * FROM RequestAccepted

--SOLUTION

;WITH Friends AS (
    -- Person as requester
    SELECT requester_id AS person_id, accepter_id AS friend_id
    FROM RequestAccepted
    UNION ALL
    -- Person as accepter
    SELECT accepter_id AS person_id, requester_id AS friend_id
    FROM RequestAccepted
),
FriendCount AS (
    SELECT 
        person_id AS id,
        COUNT(DISTINCT friend_id) AS num
    FROM Friends
    GROUP BY person_id
)
SELECT TOP 1 id, num
FROM FriendCount
ORDER BY num DESC;

--9. Create a View for Customer Order Summary.
DROP TABLE IF EXISTS Customers
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50)
);

DROP TABLE IF EXISTS Orders
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT FOREIGN KEY REFERENCES Customers(customer_id),
    order_date DATE,
    amount DECIMAL(10,2)
);

-- Customers
INSERT INTO Customers (customer_id, name, city)
VALUES
(1, 'Alice Smith', 'New York'),
(2, 'Bob Jones', 'Chicago'),
(3, 'Carol White', 'Los Angeles');

-- Orders
INSERT INTO Orders (order_id, customer_id, order_date, amount)
VALUES
(101, 1, '2024-12-10', 120.00),
(102, 1, '2024-12-20', 200.00),
(103, 1, '2024-12-30', 220.00),
(104, 2, '2025-01-12', 120.00),
(105, 2, '2025-01-20', 180.00);

--Create a view called vw_CustomerOrderSummary that returns a summary of customer orders. The view must contain the following columns:

--Column Name | Description
--customer_id | Unique identifier of the customer
--name | Full name of the customer
--total_orders | Total number of orders placed by the customer
--total_amount | Cumulative amount spent across all orders
--last_order_date | Date of the most recent order placed by the customer


--SOLUTION
SELECT * FROM Customers
SELECT * FROM Orders


;CREATE VIEW vw_CustomerOrderSummary
AS
SELECT 
	c.customer_id,
	c.name,
	COUNT(o.order_id) AS total_orders,
	SUM(o.amount) AS total_amount,
	MAX(o.order_date) AS last_order_date
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;
GO
SELECT * FROM vw_CustomerOrderSummary;

--10. Write an SQL statement to fill in the missing gaps. You have to write only select statement, no need to modify the table.

DROP TABLE IF EXISTS Gaps;

CREATE TABLE Gaps
(
RowNumber   INTEGER PRIMARY KEY,
TestCase    VARCHAR(100) NULL
);

INSERT INTO Gaps (RowNumber, TestCase) VALUES
(1,'Alpha'),(2,NULL),(3,NULL),(4,NULL),
(5,'Bravo'),(6,NULL),(7,NULL),(8,NULL),(9,NULL),(10,'Charlie'), (11, NULL), (12, NULL)

SELECT * FROM Gaps

--Here is the expected output.

--| RowNumber | Workflow |
--|----------------------|
--| 1         | Alpha    |
--| 2         | Alpha    |
--| 3         | Alpha    |
--| 4         | Alpha    |
--| 5         | Bravo    |
--| 6         | Bravo    |
--| 7         | Bravo    |
--| 8         | Bravo    |
--| 9         | Bravo    |
--| 10        | Charlie  |
--| 11        | Charlie  |
--| 12        | Charlie  |



--SOLUTION

SELECT 
    RowNumber,
    (SELECT TestCase 
     FROM Gaps g2 
     WHERE g2.TestCase IS NOT NULL 
     AND g2.RowNumber <= g1.RowNumber 
     ORDER BY g2.RowNumber DESC 
     OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY) AS Workflow
FROM Gaps g1
ORDER BY RowNumber;
