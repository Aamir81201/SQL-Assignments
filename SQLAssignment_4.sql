USE Northwind
GO

------------------------(1)------------------------------------------------------------------------------------------------------------------------------

ALTER PROCEDURE spAvgFreight
@CustomerID nchar(5),
@AverageFreight REAL OUTPUT
AS
BEGIN
	SELECT @AverageFreight = AVG(Freight) from Orders WHERE CustomerID = @CustomerID
END


CREATE TRIGGER tr_orders_insert
ON Orders
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @cust nchar(5);
	DECLARE @freight REAL;
	DECLARE @avg REAL;

	SELECT @Cust = I.CustomerID FROM Orders O INNER JOIN inserted I ON O.CustomerID = I.CustomerID
	SELECT @freight = I.Freight FROM Orders O INNER JOIN inserted I ON O.CustomerID = I.CustomerID

	EXEC spAvgFreight
		@CustomerID = @Cust,
		@AverageFreight = @avg OUTPUT;
	
		IF(@freight<@avg)
		BEGIN
			Print('Valid Freight : Inserted Successfully')
			INSERT INTO Orders
			SELECT CustomerID, EmployeeID, OrderDate, RequiredDate, ShippedDate, ShipVia, Freight, ShipName, ShipAddress, ShipCity, ShipRegion, ShipPostalCode, ShipCountry
			FROM inserted
		END

		ELSE
		BEGIN
			Print('Failed : Inserted Freight has exceeded average Freight value of Inserted Customer')
		END
END
GO

--Valid (Avg = 23)
INSERT INTO "Orders"
("CustomerID","EmployeeID","OrderDate","RequiredDate",
	"ShippedDate","ShipVia","Freight","ShipName","ShipAddress",
	"ShipCity","ShipRegion","ShipPostalCode","ShipCountry")
VALUES (N'REGGC',4,'8/23/1996','9/20/1996','9/3/1996',1,16.45,
	N'Reggiani Caseifici',N'Strada Provinciale 124',N'Reggio Emilia',
	NULL,N'42100',N'Italy')
GO

--Invalid (Avg = 23)
INSERT INTO "Orders"
("CustomerID","EmployeeID","OrderDate","RequiredDate",
	"ShippedDate","ShipVia","Freight","ShipName","ShipAddress",
	"ShipCity","ShipRegion","ShipPostalCode","ShipCountry")
VALUES (N'REGGC',4,'8/23/1996','9/20/1996','9/3/1996',1,60.45,
	N'Reggiani Caseifici',N'Strada Provinciale 124',N'Reggio Emilia',
	NULL,N'42100',N'Italy')
GO


------------------------(2)------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE spGetSalesByCountry
@country varchar(50)
AS
BEGIN
	SELECT E.EmployeeID, E.FirstName, E.LastName, COUNT(O.OrderID) [Total Orders], SUM(os.Subtotal) [Sales Amount] 
	FROM Employees E
	INNER JOIN (Orders O INNER JOIN [Order Subtotals] OS ON O.OrderID = OS.OrderID)
	ON E.EmployeeID = O.EmployeeID
	WHERE ShipCountry = ISNULL(@country,ShipCountry)
	Group By E.EmployeeID, E.FirstName, E.LastName
END

spGetSalesByCountry 'UK'


------------------------(3)------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE spGetSalesByYear
@year varchar(4)
AS
BEGIN
	SELECT O.OrderID, O.ShippedDate, OS.Subtotal
	FROM Orders O
	INNER JOIN [Order Subtotals] OS 
	ON OS.OrderID = O.OrderID
	WHERE YEAR(ShippedDate) = @year
END

spGetSalesByYear '1996'


------------------------(4)------------------------------------------------------------------------------------------------------------------------------

 CREATE PROCEDURE spGetSalesByCategories
 @Category INT
 AS
 BEGIN 
	SELECT C.CategoryName, P.ProductID, P.ProductName, COUNT(OD.OrderID) [Total Orders], SUM(OS.Subtotal) [Sales Amount]
	FROM [Order Details] OD
	INNER JOIN Products P ON OD.ProductID = P.ProductID
	INNER JOIN [Order Subtotals] OS ON OD.OrderID = OS.OrderID
	INNER JOIN Categories C ON P.CategoryID = C.CategoryID
	WHERE P.CategoryID = @Category
	GROUP BY P.ProductID, P.ProductName, C.CategoryName
 END

 spGetSalesByCategories 7


------------------------(5)------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE spGetTop10MostExpensiveProducts
AS
BEGIN
	SELECT TOP 10 ProductName, UnitPrice
	FROM Products
	ORDER BY UnitPrice DESC;
END



------------------------(6)------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE spInsertCustomerOrderDetails
@OrderID INT,
@ProductID INT,
@UnitPrice MONEY, 
@Quantity INT,
@Discount REAL
AS
BEGIN
INSERT "Order Details" VALUES(@OrderID,@ProductID,@UnitPrice,@Quantity,@Discount)
END



------------------------(7)------------------------------------------------------------------------------------------------------------------------------