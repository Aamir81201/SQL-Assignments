CREATE DATABASE SalesDB
GO

USE SalesDB
GO 

CREATE TABLE salesman (
	salesman_id INT PRIMARY KEY IDENTITY(5001,1),
	[name] VARCHAR(30),
	city VARCHAR(30),
	commission NUMERIC(4,2)
)
GO

INSERT INTO salesman VALUES('James Hoog','New York',0.15)
INSERT INTO salesman VALUES('Nail Knite','Paris',0.13)
INSERT INTO salesman VALUES('Lauson Hen','San Jose',0.12)
INSERT INTO salesman VALUES('James Gun','Delhi',0.15)
INSERT INTO salesman VALUES('Pit Alex','London',0.11)
INSERT INTO salesman VALUES('Mc Lyon','Paris',0.14)
INSERT INTO salesman VALUES('Paul Adam','Rome',0.13)
GO

CREATE TABLE customer (
customer_id INT IDENTITY(3001,1) PRIMARY KEY,
cust_name VARCHAR(50),
city VARCHAR(50),
grade INT,
salesman_id INT FOREIGN KEY REFERENCES salesman(salesman_id)
)
GO

INSERT INTO customer(cust_name,city,grade,salesman_id)
VALUES
('Brad Guzan','London',null,5005),
('Nick Rimando','New York',100,5001),
('Jozy Altidor','Moscow',200,5007),
('Fabian Johnson','Paris',300,5006),
('Graham Zusi','California',200,5002),
('Elon Musk', 'Delhi',100,null),
('Brad Davis', 'New York',200,5001),
('Julian Green','London',300,5002),
('Geoff Cameron','Berlin',100,5003),
('Walter White', 'Delhi', 300, null)
GO



CREATE TABLE orders(
ord_no INT PRIMARY KEY IDENTITY(70001,1),
purch_amt FLOAT,
ord_date DATE,
customer_id INT FOREIGN KEY REFERENCES customer(customer_id),
salesman_id INT FOREIGN KEY REFERENCES salesman(salesman_id)
)
GO

INSERT INTO orders VALUES(150.50,'2012-10-05',3005,5002)
INSERT INTO orders VALUES(65.26,'2012-10-05',3002,5001)
INSERT INTO orders VALUES(2480.40,'2012-10-10',3009,5003)
INSERT INTO orders VALUES(110.50,'2012-08-17',3009,5003)
INSERT INTO orders VALUES(2400.60,'2012-07-27',3007,5001)
INSERT INTO orders VALUES(420.50,'2012-06-01',3006,null)
INSERT INTO orders VALUES(948.50,'2012-09-10',3005,5002)
INSERT INTO orders VALUES(5760.00,'2012-09-10',3002,5001)
INSERT INTO orders VALUES(270.65,'2012-09-10',3001,5005)
INSERT INTO orders VALUES(1983.43,'2012-10-10',3004,5006)
INSERT INTO orders VALUES(75.29,'2012-08-17',3003,5007)
INSERT INTO orders VALUES(250.45,'2012-06-27',3008,5002)
INSERT INTO orders VALUES(3045.60,'2012-04-25',3002,5001)
GO


SELECT * FROM customer;
SELECT * FROM orders;
SELECT * FROM salesman;

-------------------------(01)-------------------------------------------------------
SELECT s.[name] AS salesman, c.cust_name, s.city   
FROM salesman s
INNER JOIN customer c
ON s.city=c.city
GO

-------------------------(02)-------------------------------------------------------
SELECT o.ord_no, o.purch_amt, c.cust_name, c.city
FROM orders o
INNER JOIN customer c
ON o.customer_id = c.customer_id
WHERE purch_amt between 500 and 2000
GO

-------------------------(03)-------------------------------------------------------
SELECT c.cust_name, c.city AS cust_city, s.[name] AS salesman, commission
FROM customer c
INNER JOIN salesman S
ON c.salesman_id = s.salesman_id
GO

-------------------------(04)-------------------------------------------------------
SELECT c.cust_name, c.city, s.[name] AS salesman, s.commission
FROM customer c
INNER JOIN salesman s
ON c.salesman_id = s.salesman_id
WHERE s.commission > 0.12
GO

-------------------------(05)-------------------------------------------------------
SELECT c.cust_name, c.city AS customer_city, s.[name] AS salesman,s.city AS salesman_city, s.commission
FROM customer c
INNER JOIN salesman s
ON c.salesman_id = s.salesman_id
WHERE c.city!=s.city AND s.commission > 0.12
GO


-------------------------(06)-------------------------------------------------------
SELECT ord_no, ord_date, purch_amt, cust_name, grade, s.[name] AS salesman, commission
FROM ((orders o
LEFT OUTER JOIN customer c ON o.customer_id = c.customer_id)
LEFT OUTER JOIN salesman s ON o.salesman_id = s.salesman_id)
GO

-------------------------(07)-------------------------------------------------------
SELECT c.customer_id, c.cust_name, c.city AS cust_city,s.city AS salesman_city, 
c.grade, s.salesman_id, s.[name] AS salesman, s.commission, o.ord_no, o.ord_date, o.purch_amt 
FROM ((orders o
INNER JOIN customer c ON o.customer_id = c.customer_id)
INNER JOIN salesman s ON o.salesman_id = s.salesman_id)
GO

-------------------------(08)-------------------------------------------------------
SELECT c.cust_name, c.city AS customer_city, grade,s.[name] AS salesman, s.city AS salesman_city
FROM customer c
LEFT OUTER JOIN salesman s
ON c.salesman_id=s.salesman_id
ORDER BY customer_id ASC
GO


-------------------------(09)-------------------------------------------------------
SELECT c.cust_name, c.city AS customer_city, grade,s.[name] AS salesman, s.city AS salesman_city
FROM customer c
LEFT OUTER JOIN salesman s
ON c.salesman_id=s.salesman_id
WHERE grade < 300
ORDER BY customer_id ASC
GO


-------------------------(10)-------------------------------------------------------
SELECT cust_name, c.city AS cust_city, ord_no, ord_date
FROM customer c
LEFT OUTER JOIN orders o 
ON c.customer_id = o.customer_id
ORDER BY ord_date ASC
GO

-------------------------(11)-------------------------------------------------------
SELECT cust_name, c.city AS cust_city, ord_no, ord_date, purch_amt, s.[name] as salesman, commission
FROM ((customer c
LEFT OUTER JOIN orders o ON c.customer_id = o.customer_id)
LEFT OUTER JOIN salesman s ON c.salesman_id = s.salesman_id)
GO

-------------------------(12)-------------------------------------------------------
SELECT s.[name] AS salesman, cust_name
FROM salesman s
LEFT OUTER JOIN customer c
ON s.salesman_id=c.salesman_id
ORDER BY s.[name] ASC
GO

-------------------------(13)-------------------------------------------------------
SELECT s.[name] AS salesman, c.cust_name, c.city AS cust_city, grade, ord_no, ord_date,purch_amt
FROM ((salesman s
LEFT OUTER JOIN orders o ON s.salesman_id = o.salesman_id)
LEFT OUTER JOIN customer c ON s.salesman_id = c.salesman_id)
GO

-------------------------(14,15)----------------------------------------------------
SELECT  s.[name] AS salesman, c.cust_name, c.grade, o.purch_amt
FROM((salesman s
LEFT OUTER JOIN customer c ON s.salesman_id = c.salesman_id)
LEFT OUTER JOIN orders o ON c.customer_id = o.customer_id )
WHERE (purch_amt > 2000 AND C.grade IS NOT NULL) OR (o.customer_id IS NULL)
GO

-------------------------(16)-------------------------------------------------------
SELECT c.cust_name, c.city AS cust_city, o.ord_no, o.ord_date, o.purch_amt 
FROM customer c
FULL OUTER JOIN orders o
ON c.customer_id = o.customer_id
WHERE c.grade IS NOT NULL
GO

-------------------------(17)-------------------------------------------------------
SELECT *
FROM salesman s
FUll OUTER JOIN customer c
ON s.salesman_id = c.salesman_id
GO


-------------------------(18)-------------------------------------------------------
SELECT s.name AS salesman, c.cust_name
FROM salesman s
CROSS JOIN customer c
WHERE s.city = c.city
GO

-------------------------(19)-------------------------------------------------------
SELECT s.name AS salesman, c.cust_name
FROM salesman s
CROSS JOIN customer c
WHERE s.city = c.city AND c.grade IS NOT NULL
GO

-------------------------(20)-------------------------------------------------------
SELECT s.[name] AS salesman, c.cust_name
FROM salesman s
CROSS JOIN customer c
WHERE s.city != c.city AND c.grade IS NOT NULL
GO
