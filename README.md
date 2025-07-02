# sql-homework

--Homework 1
--Lesson 1: Introduction to SQL Server and SSMS

--1) Define the following terms: data, database, relational database, and table.

--DATA - a collection of facts, figures, numbers or observations which can be processed to gain knowledge and insights
--DATABASE - an organized collection of data stored electronically in a computer system
--RELATIONAL DATABASE - a type of database that organizes data into one or more tables, which are structured with rows and columns
--TABLE - a structured set of data arranged in rows and columns

--2) List five key features of SQL Server.

--SQL Server efficiently stores and manages data in organized tables(1), perfect for handling large datasets(2). Its strong security
--features(3) keep sensitive information safe. It processes queries quickly(4) and built-in BI tools helps create reports. SQL Server
--highly scalable(5), supporting small apps to large cloud-based systems across platforms.


--3) What are the different authentication modes available when connecting to SQL Server? (Give at least 2)

--Windows Authentication Mode;
--SQL Server Authentication Mode;


--4) Create a new database in SSMS named SchoolDB 5) Write and execute a query to create a table called Students with columns:
--StudentID (INT, PRIMARY KEY), Name (VARCHAR(50)), Age (INT)

CREATE DATABASE SchoolDB
CREATE TABLE Students (StudentID int, Name varchar(50), Age int)
INSERT INTO Students values (1, 'Rustam Gulyamov', 36), (2, 'Ahror Jurayev', 28), (3, 'Munisa Samadova', 26)
SELECT * FROM Students


--6) Describe the differences between SQL Server, SSMS, and SQL

--SQL Server is a database management system by Microsoft that stores, manages, and retrieves data, acting as the core software for handling databases.
--SSMS - SQL Server Management Studio is a graphical tool used to manage SQL Server, it acts as IDE.
--SQL - is a language used to interact with SQL Server, allowing us to write commands to query or modify data.

--7) Research and explain the different SQL commands: DQL, DML, DDL, DCL, TCL with examples

--DQL-Data Query Language: retrieves data from a database without modifying it.
--For example: SELECT * FROM Employees WHERE Department = 'Sales'

--DML-Data Manipulation Language: modifies data in a database (insert, update, or delete)
--For example: INSERT INTO Employees (Name, Department) VALUES ('John Doe', 'HR')

--DDL-Data Definition Language: defines or modifies the structure of database objects like tables or schemas
--For example: CREATE TABLE Products (ID INT, Name VARCHAR(50), Price DECIMAL)

--DCL-Data Control Language: manages access and permissions for database users
--For example: GRANT SELECT ON Employees TO User1 (is gives User1 permission to view data in Employees table)

--TCL-Transaction Control Language: manages transactions to ensure data integrity 
--For example: UPDATE Students 
             --SET NAME = 'Akmal' 
			 --WHERE NAME = 'Bahodir' 
			 --COMMIT 
			 --ROLLBACK

--8) Write a query to insert three records into the Students table
INSERT INTO Students values (4, 'Abror Asrorov', 21), (5, 'Diyora Kamolova', 25), (6, 'Rahima Qudratova', 18)
SELECT * FROM Students

--9) Restore AdventureWorksDW2022.bak file to your server.

--Step 1: Download the '.bak' file
--Step 2: Open SSMS
--Step 3: Select 'Database' in Object Explorer and right-click on it, then select 'Restore Database'
--Step 4: Select 'Device' and click the '...'
--Step 5: Select 'Add' and locate the '.bak' file and click OK
