CREATE DATABASE homework20
GO
USE homework20;

CREATE TABLE #Sales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT,
    Price DECIMAL(10,2),
    SaleDate DATE
);


INSERT INTO #Sales (CustomerName, Product, Quantity, Price, SaleDate) VALUES
('Alice', 'Laptop', 1, 1200.00, '2024-01-15'),
('Bob', 'Smartphone', 2, 800.00, '2024-02-10'),
('Charlie', 'Tablet', 1, 500.00, '2024-02-20'),
('David', 'Laptop', 1, 1300.00, '2024-03-05'),
('Eve', 'Smartphone', 3, 750.00, '2024-03-12'),
('Frank', 'Headphones', 2, 100.00, '2024-04-08'),
('Grace', 'Smartwatch', 1, 300.00, '2024-04-25'),
('Hannah', 'Tablet', 2, 480.00, '2024-05-05'),
('Isaac', 'Laptop', 1, 1250.00, '2024-05-15'),
('Jack', 'Smartphone', 1, 820.00, '2024-06-01');

-----------------------------------------------------------------------------------------------

--1. Find customers who purchased at least one item in March 2024 using EXISTS

SELECT * FROM #Sales

SELECT DISTINCT
	CustomerName,
	Product,
	Quantity,
	SaleDate
FROM #Sales s1
WHERE EXISTS (
	SELECT 1
	FROM #Sales s2
	WHERE 
		s2.SaleID = s1.SaleID AND
		s2.SaleDate >= '2024-03-01' 
		AND s2.SaleDate < '2024-04-01'
);

-----------------------------------------------------------------------------------------------

--2. Find the product with the highest total sales revenue using a subquery.

SELECT 
	Product,
	SUM(Quantity * Price) AS TotalSalesRevenue
FROM #Sales
GROUP BY Product
HAVING SUM(Quantity * Price) = (SELECT MAX(TotalSalesRevenue) 
								FROM (SELECT SUM(Quantity * Price) AS TotalSalesRevenue 
									  FROM #Sales 
									  GROUP BY Product) AS ProductTotals);

-----------------------------------------------------------------------------------------------

--3. Find the second highest sale amount using a subquery

SELECT
	SaleID,
	CustomerName,
	Product,
	(Quantity * Price) AS SaleAmount
FROM #Sales
WHERE (Quantity * Price) = (
			SELECT MAX(t.TotalSale)
			FROM (SELECT DISTINCT TOP 2 (Quantity * Price) AS TotalSale
				  FROM #Sales
				  ORDER BY TotalSale DESC) AS t);

-----------------------------------------------------------------------------------------------

--4. Find the total quantity of products sold per month using a subquery

SELECT
	#ofMonth,
	Month,
	TotalQuantity
FROM (
		SELECT
			MONTH(SaleDate) AS #ofMonth,
			DATENAME(MONTH, SaleDate) AS Month,
			SUM(Quantity) AS TotalQuantity
		FROM #Sales
		GROUP BY MONTH(SaleDate), DATENAME(MONTH, SaleDate)
	) AS MonthlySales
ORDER BY #ofMonth;

-----------------------------------------------------------------------------------------------

--5. Find customers who bought same products as another customer using EXISTS

SELECT
    s1.CustomerName,
    s1.Product
FROM
    #Sales AS s1
WHERE EXISTS (
    SELECT 1
    FROM #Sales AS s2
    WHERE
        s2.Product = s1.Product 
		AND s2.CustomerName <> s1.CustomerName
)
ORDER BY s1.Product, s1.CustomerName;


-----------------------------------------------------------------------------------------------


--6. Return how many fruits does each person have in individual fruit level

create table Fruits(Name varchar(50), Fruit varchar(50))
insert into Fruits values ('Francesko', 'Apple'), ('Francesko', 'Apple'), ('Francesko', 'Apple'), ('Francesko', 'Orange'),
							('Francesko', 'Banana'), ('Francesko', 'Orange'), ('Li', 'Apple'), 
							('Li', 'Orange'), ('Li', 'Apple'), ('Li', 'Banana'), ('Mario', 'Apple'), ('Mario', 'Apple'), 
							('Mario', 'Apple'), ('Mario', 'Banana'), ('Mario', 'Banana'), 
							('Mario', 'Orange')

--Solution:

SELECT 
	Name,
	SUM(CASE WHEN Fruit = 'Apple' THEN 1 ELSE 0 END) AS Apple,
	SUM(CASE WHEN Fruit = 'Banana' THEN 1 ELSE 0 END) AS Banana,
	SUM(CASE WHEN Fruit = 'Orange' THEN 1 ELSE 0 END) AS Orange
FROM Fruits
GROUP BY Name;


-----------------------------------------------------------------------------------------------


--7. Return older people in the family with younger ones

create table Family(ParentId int, ChildID int)
insert into Family values (1, 2), (2, 3), (3, 4)

--1 Oldest person in the family --grandfather 2 Father 3 Son 4 Grandson

--+-----+-----+
--| PID |CHID |
--+-----+-----+
--|  1  |  2  |
--|  1  |  3  |
--|  1  |  4  |
--|  2  |  3  |
--|  2  |  4  |
--|  3  |  4  |
--+-----+-----+

--Solution:


WITH Descendants AS (
    SELECT
        ParentId AS OlderPerson,
        ChildID AS YoungerPerson
    FROM Family
    UNION ALL
    SELECT
        D.OlderPerson,
        F.ChildID AS YoungerPerson
    FROM Descendants AS D
    JOIN Family AS F ON D.YoungerPerson = F.ParentId
)
SELECT DISTINCT
    OlderPerson,
    YoungerPerson
FROM
    Descendants
ORDER BY
    OlderPerson, YoungerPerson;

-----------------------------------------------------------------------------------------------


--8.Write an SQL statement given the following requirements. 
--For every customer that had a delivery to California, provide a result set of the customer orders that were delivered to Texas

CREATE TABLE #Orders
(
CustomerID     INTEGER,
OrderID        INTEGER,
DeliveryState  VARCHAR(100) NOT NULL,
Amount         MONEY NOT NULL,
PRIMARY KEY (CustomerID, OrderID)
);

INSERT INTO #Orders (CustomerID, OrderID, DeliveryState, Amount) VALUES
(1001,1,'CA',340),(1001,2,'TX',950),(1001,3,'TX',670),
(1001,4,'TX',860),(2002,5,'WA',320),(3003,6,'CA',650),
(3003,7,'CA',830),(4004,8,'TX',120);


--Solution:

SELECT
    CustomerID,
    OrderID,
    DeliveryState,
    Amount
FROM
    #Orders
WHERE
    DeliveryState = 'TX' 
	AND CustomerID IN (
        SELECT CustomerID
        FROM #Orders
        WHERE DeliveryState = 'CA'
    );

-----------------------------------------------------------------------------------------------


--9. Insert the names of residents if they are missing

create table #residents(resid int identity, fullname varchar(50), address varchar(100))

insert into #residents values 
('Dragan', 'city=Bratislava country=Slovakia name=Dragan age=45'),
('Diogo', 'city=Lisboa country=Portugal age=26'),
('Celine', 'city=Marseille country=France name=Celine age=21'),
('Theo', 'city=Milan country=Italy age=28'),
('Rajabboy', 'city=Tashkent country=Uzbekistan age=22')


--Solution:

SELECT 
    resid,
    fullname,
    CASE 
        WHEN CHARINDEX('name=', address) > 0 THEN address
        ELSE 
            CASE 
                WHEN CHARINDEX('country=', address) > 0 AND CHARINDEX('age=', address) > 0 
                THEN CONCAT(
                    SUBSTRING(address, 1, CHARINDEX('country=', address) + CHARINDEX(' ', address, CHARINDEX('country=', address)) - 1),
                    ' name=', fullname, 
                    SUBSTRING(address, CHARINDEX('age=', address) - 1, LEN(address))
                )
                ELSE CONCAT(address, ' name=', fullname)
            END
    END AS address
FROM #residents;

-----------------------------------------------------------------------------------------------


--10. Write a query to return the route to reach from Tashkent to Khorezm. The result should include the cheapest and the most expensive routes

CREATE TABLE #Routes
(
RouteID        INTEGER NOT NULL,
DepartureCity  VARCHAR(30) NOT NULL,
ArrivalCity    VARCHAR(30) NOT NULL,
Cost           MONEY NOT NULL,
PRIMARY KEY (DepartureCity, ArrivalCity)
);

INSERT INTO #Routes (RouteID, DepartureCity, ArrivalCity, Cost) VALUES
(1,'Tashkent','Samarkand',100),
(2,'Samarkand','Bukhoro',200),
(3,'Bukhoro','Khorezm',300),
(4,'Samarkand','Khorezm',400),
(5,'Tashkent','Jizzakh',100),
(6,'Jizzakh','Samarkand',50);

--Solution:

;WITH AllRoutes AS (
    SELECT
        DepartureCity,
        ArrivalCity,
        CAST(DepartureCity + ' - ' + ArrivalCity AS VARCHAR(MAX)) AS Path,
        Cost AS TotalCost,
        1 AS n
    FROM #Routes
    WHERE DepartureCity = 'Tashkent'
    UNION ALL
    SELECT
        T1.DepartureCity,
        T2.ArrivalCity,
        CAST(T1.Path + ' - ' + T2.ArrivalCity AS VARCHAR(MAX)) AS Path,
        T1.TotalCost + T2.Cost,
        T1.n + 1
    FROM AllRoutes AS T1
    JOIN #Routes AS T2 ON T1.ArrivalCity = T2.DepartureCity
    WHERE CHARINDEX(T2.ArrivalCity, T1.Path) = 0
),
RankedRoutes AS (
    SELECT
        Path,
        TotalCost,
        ROW_NUMBER() OVER (ORDER BY TotalCost ASC) AS RankAsc,
        ROW_NUMBER() OVER (ORDER BY TotalCost DESC) AS RankDesc
    FROM AllRoutes
    WHERE ArrivalCity = 'Khorezm'
)
SELECT
    Path,
    TotalCost AS RouteCost,
    CASE
        WHEN RankAsc = 1 THEN 'CheapestRoute'
        WHEN RankDesc = 1 THEN 'MostExpensiveRoute'
    END AS RouteType
FROM RankedRoutes
WHERE RankAsc = 1 OR RankDesc = 1
ORDER BY TotalCost;


-----------------------------------------------------------------------------------------------


--11. Rank products based on their order of insertion.

CREATE TABLE #RankingPuzzle
(
     ID INT
    ,Vals VARCHAR(10)
)

 
INSERT INTO #RankingPuzzle VALUES
(1,'Product'),
(2,'a'),
(3,'a'),
(4,'a'),
(5,'a'),
(6,'Product'),
(7,'b'),
(8,'b'),
(9,'Product'),
(10,'c')

--Solution:

SELECT
    ID,
    Vals,
    ROW_NUMBER() OVER (ORDER BY ID) AS Ranked
FROM #RankingPuzzle;


-----------------------------------------------------------------------------------------------


--12. Find employees whose sales were higher than the average sales in their department

CREATE TABLE #EmployeeSales (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeName VARCHAR(100),
    Department VARCHAR(50),
    SalesAmount DECIMAL(10,2),
    SalesMonth INT,
    SalesYear INT
);

INSERT INTO #EmployeeSales (EmployeeName, Department, SalesAmount, SalesMonth, SalesYear) VALUES
('Alice', 'Electronics', 5000, 1, 2024),
('Bob', 'Electronics', 7000, 1, 2024),
('Charlie', 'Furniture', 3000, 1, 2024),
('David', 'Furniture', 4500, 1, 2024),
('Eve', 'Clothing', 6000, 1, 2024),
('Frank', 'Electronics', 8000, 2, 2024),
('Grace', 'Furniture', 3200, 2, 2024),
('Hannah', 'Clothing', 7200, 2, 2024),
('Isaac', 'Electronics', 9100, 3, 2024),
('Jack', 'Furniture', 5300, 3, 2024),
('Kevin', 'Clothing', 6800, 3, 2024),
('Laura', 'Electronics', 6500, 4, 2024),
('Mia', 'Furniture', 4000, 4, 2024),
('Nathan', 'Clothing', 7800, 4, 2024);

--Solution:

--Find employees whose sales were higher than the average sales in their department
;WITH AvgSales AS (
	SELECT 
		EmployeeName,
		Department,
		SalesAmount,
		AVG(SalesAmount) OVER(PARTITION BY Department) AS Avg_Sales
	FROM #EmployeeSales
)
SELECT 
	EmployeeName,
	Department,
	SalesAmount,
	Avg_Sales
FROM AvgSales
WHERE SalesAmount > Avg_Sales;


-----------------------------------------------------------------------------------------------

--13. Find employees who had the highest sales in any given month using EXISTS

SELECT
    e1.EmployeeID,
    e1.EmployeeName,
    e1.Department,
    e1.SalesAmount,
    e1.SalesMonth,
    e1.SalesYear
FROM #EmployeeSales e1
WHERE EXISTS (
    SELECT 1
    FROM #EmployeeSales e2
    WHERE e2.SalesMonth = e1.SalesMonth
    AND e2.SalesYear = e1.SalesYear
    GROUP BY e2.SalesMonth, e2.SalesYear
    HAVING MAX(e2.SalesAmount) = e1.SalesAmount
)
ORDER BY e1.SalesMonth, e1.SalesYear;


-----------------------------------------------------------------------------------------------


--14. Find employees who made sales in every month using NOT EXISTS

SELECT DISTINCT
    e1.EmployeeID,
    e1.EmployeeName,
    e1.Department
FROM #EmployeeSales e1
WHERE NOT EXISTS (
    SELECT DISTINCT SalesMonth, SalesYear
    FROM #EmployeeSales e2
    WHERE NOT EXISTS (
        SELECT 1
        FROM #EmployeeSales e3
        WHERE e3.EmployeeName = e1.EmployeeName
        AND e3.SalesMonth = e2.SalesMonth
        AND e3.SalesYear = e2.SalesYear
    )
)
ORDER BY e1.EmployeeID;


-----------------------------------------------------------------------------------------------


--15. Retrieve the names of products that are more expensive than the average price of all products.

CREATE TABLE Products (
    ProductID   INT PRIMARY KEY,
    Name        VARCHAR(50),
    Category    VARCHAR(50),
    Price       DECIMAL(10,2),
    Stock       INT
);

INSERT INTO Products (ProductID, Name, Category, Price, Stock) VALUES
(1, 'Laptop', 'Electronics', 1200.00, 15),
(2, 'Smartphone', 'Electronics', 800.00, 30),
(3, 'Tablet', 'Electronics', 500.00, 25),
(4, 'Headphones', 'Accessories', 150.00, 50),
(5, 'Keyboard', 'Accessories', 100.00, 40),
(6, 'Monitor', 'Electronics', 300.00, 20),
(7, 'Mouse', 'Accessories', 50.00, 60),
(8, 'Chair', 'Furniture', 200.00, 10),
(9, 'Desk', 'Furniture', 400.00, 5),
(10, 'Printer', 'Office Supplies', 250.00, 12),
(11, 'Scanner', 'Office Supplies', 180.00, 8),
(12, 'Notebook', 'Stationery', 10.00, 100),
(13, 'Pen', 'Stationery', 2.00, 500),
(14, 'Backpack', 'Accessories', 80.00, 30),
(15, 'Lamp', 'Furniture', 60.00, 25);


SELECT
    ProductID,
    Name,
    Category,
    Price
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products)
ORDER BY Price DESC;


-----------------------------------------------------------------------------------------------


--16. Find the products that have a stock count lower than the highest stock count.

SELECT * 
FROM Products
WHERE Stock < (SELECT MAX(Stock) FROM Products)
ORDER BY Stock DESC;

-----------------------------------------------------------------------------------------------


--17. Get the names of products that belong to the same category as 'Laptop'.

SELECT * 
FROM Products
WHERE Category = 'Electronics'


-----------------------------------------------------------------------------------------------


--18. Retrieve products whose price is greater than the lowest price in the Electronics category.

SELECT 
	ProductID,
    Name,
    Category,
    Price,
    Stock
FROM Products
WHERE Price > (SELECT MIN(Price) FROM Products WHERE Category = 'Electronics')
ORDER BY Price DESC;

-----------------------------------------------------------------------------------------------

--19. Find the products that have a higher price than the average price of their respective category.

;WITH AVGPrice AS (
	SELECT 
		Name,
		Category,
		Price,
		AVG(Price) OVER(PARTITION BY Category) AS Avg_Price
	FROM Products
)
SELECT 
	Name,
	Category,
	Price,
	Avg_Price
FROM AVGPrice
WHERE Price > Avg_Price;

-----------------------------------------------------------------------------------------------

--20. Find the products that have been ordered at least once.

CREATE TABLE Orders (
    OrderID    INT PRIMARY KEY,
    ProductID  INT,
    Quantity   INT,
    OrderDate  DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Orders (OrderID, ProductID, Quantity, OrderDate) VALUES
(1, 1, 2, '2024-03-01'),
(2, 3, 5, '2024-03-05'),
(3, 2, 3, '2024-03-07'),
(4, 5, 4, '2024-03-10'),
(5, 8, 1, '2024-03-12'),
(6, 10, 2, '2024-03-15'),
(7, 12, 10, '2024-03-18'),
(8, 7, 6, '2024-03-20'),
(9, 6, 2, '2024-03-22'),
(10, 4, 3, '2024-03-25'),
(11, 9, 2, '2024-03-28'),
(12, 11, 1, '2024-03-30'),
(13, 14, 4, '2024-04-02'),
(14, 15, 5, '2024-04-05'),
(15, 13, 20, '2024-04-08');


SELECT 
	o1.OrderID,
	o1.ProductID,
	o1.Quantity,
	o1.OrderDate
FROM Orders o1
WHERE EXISTS (
	SELECT 1 
	FROM Orders o2
	WHERE o2.ProductID = o1.ProductID
)
ORDER BY o1.ProductID;

-----------------------------------------------------------------------------------------------


--21. Retrieve the names of products that have been ordered more than the average quantity ordered.

SELECT *
FROM Orders
WHERE Quantity > (SELECT AVG(Quantity) FROM Orders)


-----------------------------------------------------------------------------------------------

--22. Find the products that have never been ordered.

SELECT *
FROM Orders o1
WHERE NOT EXISTS (
	SELECT 1 
	FROM Orders o2
	WHERE o2.ProductID = o1.ProductID
)
ORDER BY o1.ProductID;


-----------------------------------------------------------------------------------------------


--23. Retrieve the product with the highest total quantity ordered.

SELECT *
FROM Orders
WHERE Quantity = (SELECT MAX(Quantity) FROM Orders)
