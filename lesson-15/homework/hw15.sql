CREATE DATABASE homework15
GO 
USE homework15

--Lesson-15: Subqueries and Exists

--Level 1: Basic Subqueries

--1. Find Employees with Minimum Salary
--Task: Retrieve employees who earn the minimum salary in the company. Tables: employees (columns: id, name, salary)

CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2)
);

INSERT INTO employees (id, name, salary) VALUES
(1, 'Alice', 50000),
(2, 'Bob', 60000),
(3, 'Charlie', 50000);

-- Solution
SELECT id, name, salary
FROM employees
WHERE salary = (SELECT MIN(salary) FROM employees);

--2. Find Products Above Average Price
--Task: Retrieve products priced above the average price. Tables: products (columns: id, product_name, price)

CREATE TABLE products (
    id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2)
);

INSERT INTO products (id, product_name, price) VALUES
(1, 'Laptop', 1200),
(2, 'Tablet', 400),
(3, 'Smartphone', 800),
(4, 'Monitor', 300);

--Solution

SELECT id, product_name, price
FROM products p
WHERE price > (
			SELECT AVG(price) 
			FROM products
			);


--Level 2: Nested Subqueries with Conditions

--3. Find Employees in Sales Department Task: Retrieve employees who work in the "Sales" department. 
--Tables: employees (columns: id, name, department_id), departments (columns: id, department_name)

CREATE TABLE departments (
    id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

CREATE TABLE Employees1 (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    Department_id INT,
    FOREIGN KEY (Department_id) REFERENCES departments(id)
);

INSERT INTO departments (id, department_name) VALUES
(1, 'Sales'),
(2, 'HR');

INSERT INTO Employees1 (id, name, Department_id) VALUES
(1, 'David', 1),
(2, 'Eve', 2),
(3, 'Frank', 1);

-- Solution

SELECT id, department_name
FROM departments
WHERE id in (
	SELECT id
	FROM Employees1
	WHERE Department_id = '1'
);


--4. Find Customers with No Orders
--Task: Retrieve customers who have not placed any orders. Tables: customers (columns: customer_id, name), orders (columns: order_id, customer_id)

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO customers (customer_id, name) VALUES
(1, 'Grace'),
(2, 'Heidi'),
(3, 'Ivan');

INSERT INTO orders (order_id, customer_id) VALUES
(1, 1),
(2, 1);

--Solution

SELECT customer_id, name
FROM customers
WHERE customer_id NOT IN (SELECT customer_id FROM orders)


--Level 3: Aggregation and Grouping in Subqueries

--5. Find Products with Max Price in Each Category
--Task: Retrieve products with the highest price in each category. Tables: products (columns: id, product_name, price, category_id)

DROP TABLE IF EXISTS products 
CREATE TABLE products (
    id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2),
    category_id INT
);

INSERT INTO products (id, product_name, price, category_id) VALUES
(1, 'Tablet', 400, 1),
(2, 'Laptop', 1500, 1),
(3, 'Headphones', 200, 2),
(4, 'Speakers', 300, 2);

--Solution
SELECT id, product_name, price, category_id
FROM products p
WHERE price = (
    SELECT MAX(price)
    FROM products p2
    WHERE p2.category_id = p.category_id
)
ORDER BY category_id;

--6. Find Employees in Department with Highest Average Salary
--Task: Retrieve employees working in the department with the highest average salary. 
--Tables: employees (columns: id, name, salary, department_id), departments (columns: id, department_name)

DROP TABLE IF EXISTS departments1
CREATE TABLE departments1 (
    id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

DROP TABLE IF EXISTS employees
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

INSERT INTO departments1 (id, department_name) VALUES
(1, 'IT'),
(2, 'Sales');

INSERT INTO employees (id, name, salary, department_id) VALUES
(1, 'Jack', 80000, 1),
(2, 'Karen', 70000, 1),
(3, 'Leo', 60000, 2);

--Solution

SELECT e.*, d.department_name
FROM employees e
INNER JOIN departments1 d ON e.department_id = d.id
WHERE e.department_id = (SELECT TOP 1 department_id FROM employees GROUP BY department_id ORDER BY AVG(salary) DESC)
ORDER BY e.id;


--7. Find Employees Earning Above Department Average
--Task: Retrieve employees earning more than the average salary in their department. 
--Tables: employees (columns: id, name, salary, department_id)

CREATE TABLE emps (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2),
    department_id INT
);

INSERT INTO emps (id, name, salary, department_id) VALUES
(1, 'Mike', 50000, 1),
(2, 'Nina', 75000, 1),
(3, 'Olivia', 40000, 2),
(4, 'Paul', 55000, 2);


--Solution

SELECT  e.id, e.name, e.salary, e.department_id 
FROM emps e
WHERE e.salary > (SELECT AVG(salary) FROM emps WHERE department_id = e.department_id)

--8. Find Students with Highest Grade per Course
--Task: Retrieve students who received the highest grade in each course. 
--Tables: students (columns: student_id, name), grades (columns: student_id, course_id, grade)

CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE grades (
    student_id INT,
    course_id INT,
    grade DECIMAL(4, 2),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

INSERT INTO students(student_id, name) VALUES
(1, 'Sarah'),
(2, 'Tom'),
(3, 'Uma');

INSERT INTO grades (student_id, course_id, grade) VALUES
(1, 101, 95),
(2, 101, 85),
(3, 102, 90),
(1, 102, 80);


select s.student_id, s.name, g.course_id, g.grade
from students s
inner join grades g on s.student_id = g.student_id
where g.grade = (select max(grade) from grades g2 where g2.course_id = g.course_id)
order by g.course_id, s.student_id;


--(9) Subqueries with Ranking and Complex Conditions
-- Find Third-Highest Price per Category Task: Retrieve products with the third-highest price in each category. 
-- Tables: products (columns: id, product_name, price, category_id)

DROP TABLE IF EXISTS products
CREATE TABLE products (
    id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2),
    category_id INT
);

INSERT INTO products (id, product_name, price, category_id) VALUES
(1, 'Phone', 800, 1),
(2, 'Laptop', 1500, 1),
(3, 'Tablet', 600, 1),
(4, 'Smartwatch', 300, 1),
(5, 'Headphones', 200, 2),
(6, 'Speakers', 300, 2),
(7, 'Earbuds', 100, 2);


--Solution

SELECT id, category_id, product_name, price 
FROM products p1
where price = (select max(price) 
			   from products 
			   where price < (select max(price) from products where price < (select max(price) from products))) 

--(10) Find Employees whose Salary Between Company Average and Department Max Salary
--Task: Retrieve employees with salaries above the company average but below the maximum in their department. 
--Tables: employees (columns: id, name, salary, department_id)

DROP TABLE IF EXISTS employees
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2),
    department_id INT
);

INSERT INTO employees (id, name, salary, department_id) VALUES
(1, 'Alex', 70000, 1),
(2, 'Blake', 90000, 1),
(3, 'Casey', 50000, 2),
(4, 'Dana', 60000, 2),
(5, 'Evan', 75000, 1);

--(10) Find Employees whose Salary Between Company Average and Department Max Salary
--Task: Retrieve employees with salaries above the company average but below the maximum in their department. 

SELECT e.department_id, e.name, e.salary
FROM employees e
WHERE e.salary BETWEEN (SELECT AVG(salary) FROM employees) 
			   AND (SELECT MAX(salary) FROM employees WHERE department_id = e.department_id);

