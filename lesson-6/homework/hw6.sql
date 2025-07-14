CREATE DATABASE homework6
GO
USE homework6

--Lesson-6: Practice

--Puzzle 1: Finding Distinct Values
--Question: Explain at least two ways to find distinct values based on two columns.

-- 

/*
Input table (InputTbl):

| col1 | col2 |
|------|------|
| a    | b    |
| a    | b    |
| b    | a    |
| c    | d    |
| c    | d    |
| m    | n    |
| n    | m    |


Result should be like this:

| col1 | col2 |
|------|------|
| a    | b    |
| c    | d    |
| m    | n    |

*/

CREATE TABLE InputTbl (
    col1 VARCHAR(10),
    col2 VARCHAR(10)
);
INSERT INTO InputTbl (col1, col2) VALUES 
('a', 'b'),
('a', 'b'),
('b', 'a'),
('c', 'd'),
('c', 'd'),
('m', 'n'),
('n', 'm');

-- using DISTINCT with conditional row filtering
SELECT DISTINCT col1, col2 FROM InputTbl
WHERE col1 <= col2

--using DISTINCT with CASE statement
SELECT DISTINCT
    CASE WHEN col1 <= col2 THEN col1 
	ELSE col2 
	END AS col1,
    CASE WHEN col1 <= col2 THEN col2 
	ELSE col1 
	END AS col2
FROM InputTbl;

--Puzzle 2: Removing Rows with All Zeroes

--Table Schema:

CREATE TABLE TestMultipleZero (
    A INT NULL,
    B INT NULL,
    C INT NULL,
    D INT NULL
);

INSERT INTO TestMultipleZero(A,B,C,D)
VALUES 
    (0,0,0,1),
    (0,0,1,0),
    (0,1,0,0),
    (1,0,0,0),
    (0,0,0,0),
    (1,1,1,0);

--Question: If all the columns have zero values, then don’t show that row. 
--In this case, we have to remove the 5th row while selecting data.

-- Solution 1
SELECT * 
FROM TestMultipleZero
WHERE A <> 0 OR B <> 0 OR C <> 0 OR D <> 0

-- Solution 2
SELECT * 
FROM TestMultipleZero
WHERE A + B + C + D <> 0

--Puzzle 3: Find those with odd ids
CREATE TABLE section1(id int, name varchar(20))
INSERT INTO section1 values (1, 'Been'),
       (2, 'Roma'),
       (3, 'Steven'),
       (4, 'Paulo'),
       (5, 'Genryh'),
       (6, 'Bruno'),
       (7, 'Fred'),
       (8, 'Andro')

--SOLUTION 1
SELECT * 
FROM section1
WHERE id %2 = 1

--SOLUTION 2
SELECT * 
FROM section1
WHERE id & 1 = 1 --The bitwise AND operator (&) performs a binary operation on id and 1.

--Puzzle 4: Person with the smallest id (use the table in puzzle 3)
SELECT TOP 1 *
FROM section1
ORDER BY id ASC;

--ALTERNATIVE WAY
SELECT *
FROM section1
WHERE id = (SELECT MIN(id) FROM section1);


--Puzzle 5: Person with the highest id (use the table in puzzle 3)
SELECT TOP 1 *
FROM section1
ORDER BY id DESC;

--ALTERNATIVE WAY
SELECT *
FROM section1
WHERE id = (SELECT MAX(id) FROM section1);

--Puzzle 6: People whose name starts with b (use the table in puzzle 3)
SELECT *
FROM section1
WHERE Name LIKE 'B%';

--Puzzle 7: 
CREATE TABLE ProductCodes (
    Code VARCHAR(20)
);

INSERT INTO ProductCodes (Code) VALUES
('X-123'),
('X_456'),
('X#789'),
('X-001'),
('X%202'),
('X_ABC'),
('X#DEF'),
('X-999');

--Write a query to return only the rows where the code contains the literal underscore _ (not as a wildcard).
SELECT * FROM ProductCodes
WHERE Code LIKE '%[_]%'

--ALTERNATIVE WAY
SELECT * FROM ProductCodes
WHERE Code LIKE '%!_%' ESCAPE '!';

