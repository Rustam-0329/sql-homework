CREATE DATABASE homework12
GO
USE homework12

--Lesson-12: Practice

--1. Combine Two Tables
Create table Person (personId int, firstName varchar(255), lastName varchar(255))
Create table Address (addressId int, personId int, city varchar(255), state varchar(255))
Truncate table Person
insert into Person (personId, lastName, firstName) values ('1', 'Wang', 'Allen')
insert into Person (personId, lastName, firstName) values ('2', 'Alice', 'Bob')
Truncate table Address
insert into Address (addressId, personId, city, state) values ('1', '2', 'New York City', 'New York')
insert into Address (addressId, personId, city, state) values ('2', '3', 'Leetcode', 'California')


Select p.firstName, p.lastname, a.city, a.state
From Person p
Left Join Address a ON p.personId = a.personId;



--2. Employees Earning More Than Their Managers
Create table Employee (id int, name varchar(255), salary int, managerId int)
Truncate table Employee
insert into Employee (id, name, salary, managerId) values ('1', 'Joe', '70000', '3')
insert into Employee (id, name, salary, managerId) values ('2', 'Henry', '80000', '4')
insert into Employee (id, name, salary, managerId) values ('3', 'Sam', '60000', NULL)
insert into Employee (id, name, salary, managerId) values ('4', 'Max', '90000', NULL)

Select emp.name
From Employee emp
Left Join Employee man On emp.managerId = man.Id
where man.salary < emp.salary



--3. Duplicate Emails
Create table Person1 (id int, email varchar(255)) 
Truncate table Person1 
insert into Person1 (id, email) values ('1', 'a@b.com') 
insert into Person1 (id, email) values ('2', 'c@d.com') 
insert into Person1 (id, email) values ('3', 'a@b.com')

Select email, COUNT(email) as num_of_repeated 
From Person1
group by  email
having COUNT(email) > 1


--4. Delete Duplicate Emails
Create table EmailAdds (id int, email varchar(255)) 
Truncate table EmailAdds 
insert into EmailAdds (id, email) values ('1', 'john@example.com ') 
insert into EmailAdds (id, email) values ('2', 'bob@example.com') 
insert into EmailAdds (id, email) values ('3', 'john@example.com')


delete from EmailAdds
where id in (
		select e2.id 
		from EmailAdds e1
		join EmailAdds e2 On e1.email = e2.email and e1.id < e2.id)

select * from EmailAdds

--5. Find those parents who has only girls.
CREATE TABLE boys (
    Id INT PRIMARY KEY,
    name VARCHAR(100),
    ParentName VARCHAR(100)
);

CREATE TABLE girls (
    Id INT PRIMARY KEY,
    name VARCHAR(100),
    ParentName VARCHAR(100)
);

INSERT INTO boys (Id, name, ParentName) 
VALUES 
(1, 'John', 'Michael'),  
(2, 'David', 'James'),   
(3, 'Alex', 'Robert'),   
(4, 'Luke', 'Michael'),  
(5, 'Ethan', 'David'),    
(6, 'Mason', 'George');  


INSERT INTO girls (Id, name, ParentName) 
VALUES 
(1, 'Emma', 'Mike'),  
(2, 'Olivia', 'James'),  
(3, 'Ava', 'Robert'),    
(4, 'Sophia', 'Mike'),  
(5, 'Mia', 'John'),      
(6, 'Isabella', 'Emily'),
(7, 'Charlotte', 'George');

select distinct g.ParentName, g.name
from girls g
full join boys b on g.ParentName = b.ParentName
where b.ParentName is null

--6. Total over 50 and least
select sl.custid,
		SUM(case when sl.freight > 50 then ord.unitprice*ord.qty - ord.unitprice*ord.qty*ord.discount else 0 end) totalSales_above50, min(sl.freight) as min_order
from [TSQL2012].[Sales].[Orders] sl
join [TSQL2012].[Sales].[OrderDetails] ord on sl.orderid = ord.orderid
group by sl.custid


--7. Carts
DROP TABLE IF EXISTS Cart1;
DROP TABLE IF EXISTS Cart2;
GO

CREATE TABLE Cart1
(
Item  VARCHAR(100) PRIMARY KEY
);
GO

CREATE TABLE Cart2
(
Item  VARCHAR(100) PRIMARY KEY
);
GO

INSERT INTO Cart1 (Item) VALUES
('Sugar'),('Bread'),('Juice'),('Soda'),('Flour');
GO

INSERT INTO Cart2 (Item) VALUES
('Sugar'),('Bread'),('Butter'),('Cheese'),('Fruit');
GO

select ISNULL(c1.Item, '') as [Item Cart1], ISNULL(c2.Item, '') as [Item Cart2] from Cart1 c1
full join Cart2 c2 On c1.Item = c2.Item


--8. Customers Who Never Order
Create table Customers (id int, name varchar(255))
Create table Orders (id int, customerId int)
Truncate table Customers
insert into Customers (id, name) values ('1', 'Joe')
insert into Customers (id, name) values ('2', 'Henry')
insert into Customers (id, name) values ('3', 'Sam')
insert into Customers (id, name) values ('4', 'Max')
Truncate table Orders
insert into Orders (id, customerId) values ('1', '3')
insert into Orders (id, customerId) values ('2', '1')

select c.name
from Customers c
left join Orders o On c.id = o.customerId
where o.id is null


--9. Students and Examinations
Create table Students (student_id int, student_name varchar(20))
Create table Subjects (subject_name varchar(20))
Create table Examinations (student_id int, subject_name varchar(20))
Truncate table Students
insert into Students (student_id, student_name) values ('1', 'Alice')
insert into Students (student_id, student_name) values ('2', 'Bob')
insert into Students (student_id, student_name) values ('13', 'John')
insert into Students (student_id, student_name) values ('6', 'Alex')
Truncate table Subjects
insert into Subjects (subject_name) values ('Math')
insert into Subjects (subject_name) values ('Physics')
insert into Subjects (subject_name) values ('Programming')
Truncate table Examinations
insert into Examinations (student_id, subject_name) values ('1', 'Math')
insert into Examinations (student_id, subject_name) values ('1', 'Physics')
insert into Examinations (student_id, subject_name) values ('1', 'Programming')
insert into Examinations (student_id, subject_name) values ('2', 'Programming')
insert into Examinations (student_id, subject_name) values ('1', 'Physics')
insert into Examinations (student_id, subject_name) values ('1', 'Math')
insert into Examinations (student_id, subject_name) values ('13', 'Math')
insert into Examinations (student_id, subject_name) values ('13', 'Programming')
insert into Examinations (student_id, subject_name) values ('13', 'Physics')
insert into Examinations (student_id, subject_name) values ('2', 'Math')
insert into Examinations (student_id, subject_name) values ('1', 'Math')

SELECT 
    st.student_id, 
    st.student_name, 
    sb.subject_name, 
    COUNT(ex.student_id) AS attended_exams
FROM Students st
CROSS JOIN Subjects sb
LEFT JOIN Examinations ex 
    ON st.student_id = ex.student_id 
    AND ex.subject_name = sb.subject_name
GROUP BY st.student_id, st.student_name, sb.subject_name
ORDER BY st.student_id, sb.subject_name

--
