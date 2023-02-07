CREATE DATABASE CompanyDB
GO

USE CompanyDB
GO

CREATE TABLE Department (
dept_id INT PRIMARY KEY,
dept_name NVARCHAR(50) NOT NULL,
)
GO

CREATE TABLE Employee(
emp_id INT PRIMARY KEY IDENTITY(1,1),
dept_id INT FOREIGN KEY REFERENCES Department(dept_id),
mngr_id INT,
emp_name NVARCHAR(50) NOT NULL,
salary MONEY NOT NULL
)
GO

SELECT * FROM Department;
SELECT * FROM Employee;
GO

INSERT INTO Department VALUES (101, '.Net')
INSERT INTO Department VALUES (102, 'Java')
INSERT INTO Department VALUES (103, 'PHP')
INSERT INTO Department VALUES (104, 'QA')
INSERT INTO Department VALUES (105, 'HR')
GO

INSERT INTO Employee VALUES(105, null,'Sweety Patel', '180000')
INSERT INTO Employee VALUES(105, null,'Itesh Sharma', '160000')
INSERT INTO Employee VALUES(102, 2,'Adesh Panchal', '85000')
INSERT INTO Employee VALUES(101, 1,'Harshad Patel', '100000')
INSERT INTO Employee VALUES(103, 1,'Rutvik Vora', '130000')
INSERT INTO Employee VALUES(101, 4,'Aamir Dalal', '150000')
INSERT INTO Employee VALUES(103, 3,'Manish Lakhara', '50000')
INSERT INTO Employee VALUES(103, 5,'Aman Gandhi', '110000')
INSERT INTO Employee VALUES(102, 3,'Rafe Karkun', '50000')
INSERT INTO Employee VALUES(104, 6,'Bilal Majeed', '25000')
INSERT INTO Employee VALUES(102, 5,'Aman Vohra', '85000')
INSERT INTO Employee VALUES(101, 6,'Arsh Dalal', '110000')
INSERT INTO Employee VALUES(103, 5,'Rohan Mahyavanshi', '50000')
INSERT INTO Employee VALUES(104, 6,'Shahrukh Panwala', '20000')
INSERT INTO Employee VALUES(102, 3,'Sahil Udanwala', '80000')
INSERT INTO Employee VALUES(101, 4,'Sohel Chk', '120000')
GO


-------------------------(01)-------------------------------------------------------
SELECT D.dept_name, E.emp_name, E.salary
FROM Employee E
INNER JOIN Department D
ON E.dept_id = D.dept_id
WHERE salary IN (SELECT MAX(salary) FROM Employee GROUP BY dept_id)
GO

-------------------------(02)-------------------------------------------------------
SELECT D.dept_name, COUNT(E.emp_id) AS [Total Employees]
FROM Employee E
INNER JOIN Department D
ON E.dept_id = D.dept_id
GROUP BY D.dept_name
HAVING COUNT(E.emp_id) < 3
GO

-------------------------(03)-------------------------------------------------------
SELECT D.dept_name, COUNT(E.emp_id) AS [Total Employees]
FROM  Department D
LEFT OUTER JOIN Employee E
ON D.dept_id = E.dept_id
GROUP BY D.dept_name
GO

-------------------------(04)-------------------------------------------------------
SELECT D.dept_name, SUM(E.salary) AS [Total Salary]
FROM Department D
LEFT OUTER JOIN Employee E
ON D.dept_id = E.dept_id
GROUP BY D.dept_name
GO
