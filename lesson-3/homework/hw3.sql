--Lesson 3: Importing and Exporting Data

CREATE DATABASE homework3
GO
USE homework3

/*
Easy-Level Tasks (10)

*/
--1.Define and explain the purpose of BULK INSERT in SQL Server.
/*
BULK INSERT is a SQL Server command that efficiently imports large datasets from structured text files (e.g., CSV, TSV) into a table, 
faster than individual INSERT statements. It requires a compatible file format and permissions, using options like FIELDTERMINATOR 
to specify delimiters.
*/

--2.List four file formats that can be imported into SQL Server.
/*
The following file formats can be imported into SQL Server:
1. CSV (Comma-Separated Values)
2. TSV (Tab-Separated Values)
3. XML
4. JSON
*/

--3.Create a table Products with columns: ProductID (INT, PRIMARY KEY), ProductName (VARCHAR(50)), Price (DECIMAL(10,2)).
CREATE TABLE Products (
	ProductID INT PRIMARY KEY,
	ProductName VARCHAR(50),
	Price DECIMAL(10,2)
);

--4.Insert three records into the Products table using INSERT INTO.
INSERT INTO Products (ProductID, ProductName, Price)
VALUES (1, 'Asus', 1200), (2, 'Apple', 2500), (3, 'HP', 1450);

--5.Explain the difference between NULL and NOT NULL.
/*
NULL and NOT NULL are constraints used to define whether a column in a table can or cannot have missing values.

NULL - a column with NULL value represents missing, unknown, or inapplicable data. For example, if Employees table has a
PhoneNumber column that allows NULL, an employee record can exist without a phone number.

NOT NULL - a column with a NOT NULL constraint requires a valid value for every record and cannot contain NULL. For example,
if EmployeeID is set to NOT NULL, every employee must have a unique ID value.

These constraints help ensure data integrity by controlling whether missing values are allowed in column.
*/

--6.Add a UNIQUE constraint to the ProductName column in the Products table.
ALTER TABLE Products
ADD CONSTRAINT UQ_ProductName UNIQUE (ProductName);

--7.Write a comment in a SQL query explaining its purpose.
/*
The comment:
'--Adds a UNIQUE constraint to the ProductName column to ensure no duplicate Product names in the Products table.'
*/

--8.Add CategoryID column to the Products table.
ALTER TABLE Products
ADD CategoryID INT NULL;

--9.Create a table Categories with a CategoryID as PRIMARY KEY and a CategoryName as UNIQUE.
CREATE TABLE Categories (
	CategoryID INT PRIMARY KEY,
	CategoryName VARCHAR(50) UNIQUE
);

--10.Explain the purpose of the IDENTITY column in SQL Server.
/*
The IDENTITY column automatically generates sequential numeric values (e.g., IDENTITY(1,1) starts at 1, increments by 1) for a column, 
typically used for PRIMARY KEYs to ensure unique, non-manual IDs.
*/

/*
Medium-Level Tasks (10)
*/

--11.Use BULK INSERT to import data from a text file into the Products table.
BULK INSERT Products
FROM 'C:\Users\Asus\Downloads\Telegram Desktop\Products.txt'
WITH (
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	FIRSTROW = 2,
	ERRORFILE = 'C:\Users\Asus\Downloads\Telegram Desktop\Products_Errors.txt'
);

--12.Create a FOREIGN KEY in the Products table that references the Categories table.
ALTER TABLE Products
ADD CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryID) 
REFERENCES Categories (CategoryID);

--13.Explain the differences between PRIMARY KEY and UNIQUE KEY.
/*
Both PRIMARY KEY and UNIQUE KEY constraints ensure data uniqueness in a table, but they have distinct purposes and behaviors.
A PRIMARY KEY uniquely identifies each row in a table, does not allow NULL values, and is limited to one per table.
For example, ProductID in Products table ensures each product has a unique, non-null ID. A UNIQUE KEY also enforces uniqueness 
but allows one NULL value and permits multiple UNIQUE constraints per table, as seen with ProductName in Products table.
*/

--14.Add a CHECK constraint to the Products table ensuring Price > 0.
ALTER TABLE Products
ADD CONSTRAINT CHK_Price CHECK (Price > 0);

--15.Modify the Products table to add a column Stock (INT, NOT NULL).
ALTER TABLE Products
ADD Stock INT NOT NULL DEFAULT 0;

--16.Use the IS NULL function to replace NULL values in Price column with a 0.
UPDATE Products
SET Price = 0.00
WHERE Price IS NULL;

--17.Describe the purpose and usage of FOREIGN KEY constraints in SQL Server.
/*
A FOREIGN KEY constraint links two tables to keep data consistent. It ensures that a column in one table 
(like CategoryID in Products table) only contains values that exist in a specific column 
(like CategoryID in the Categories table) or NULL. This prevents errors, such as a product referencing a non-existent category. 
You add it when creating or modifying a table, and it stops actions like deleting a category if products still use it. 
It’s like a rule that keeps relationships between tables accurate and reliable.
*/

/*
Hard-Level Tasks (10)
*/

--18.Write a script to create a Customers table with a CHECK constraint ensuring Age >= 18.
CREATE TABLE Customers (
	CustomerID INT PRIMARY KEY IDENTITY (1,1),
	FirstName VARCHAR(50) NOT NULL,
	Email VARCHAR(50) UNIQUE,	
	Age INT, 
	CONSTRAINT CHK_Age CHECK (Age >= 18)
);
SELECT * FROM Customers

--19.Create a table with an IDENTITY column starting at 100 and incrementing by 10.
CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY IDENTITY(100,10),  
    SupplierName VARCHAR(50) NOT NULL,           
    ContactEmail VARCHAR(50)                     
);
SELECT * FROM Suppliers

--20.Write a query to create a composite PRIMARY KEY in a new table OrderDetails.
 CREATE TABLE OrderDetails (
      OrderID INT,
      ProductID INT,
      Quantity INT NOT NULL,
      UnitPrice DECIMAL(10,2),
      CONSTRAINT PK_OrderDetails PRIMARY KEY (OrderID, ProductID),
      CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY (OrderID) REFERENCES Orders (OrderID),
      CONSTRAINT FK_OrderDetails_Products FOREIGN KEY (ProductID) REFERENCES Products (ProductID)
  );
  SELECT * FROM OrderDetails;

--21.Explain the use of COALESCE and ISNULL functions for handling NULL values.
/*
COALESCE and ISNULL are functions used to handle NULL values by replacing them with a specified non-NULL value, 
ensuring queries return meaningful results instead of NULL.
COALESCE takes multiple arguments and returns the first non-NULL value, making it flexible for checking several columns or values.
ISNULL takes exactly two arguments, replacing a NULL value in the first argument with the second; it’s simpler but less versatile. 
COALESCE is standard SQL and works across databases, while ISNULL is specific to SQL Server and slightly faster in some cases.
*/

--22.Create a table Employees with both PRIMARY KEY on EmpID and UNIQUE KEY on Email.
CREATE TABLE Employees (
	EmpID INT PRIMARY KEY,
	Email VARCHAR(50) UNIQUE,
	FirstName VARCHAR(50) NOT NULL
);

--23.Write a query to create a FOREIGN KEY with ON DELETE CASCADE and ON UPDATE CASCADE options.
ALTER TABLE Products
ADD CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryID)
REFERENCES Categories (CategoryID)
ON DELETE CASCADE
ON UPDATE CASCADE;

