USE Northwind
GO

------------------------(1)------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE spAvgFreight
@CustomerID nchar(5),
@AverageFreight REAL OUTPUT
AS
BEGIN
	SELECT @AverageFreight = AVG(Freight) from Orders WHERE CustomerID = @CustomerID
END
GO

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


CREATE TRIGGER tr_orders_update
ON Orders
INSTEAD OF UPDATE
AS
BEGIN

	IF(UPDATE(Freight))
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
				Print('Valid Freight : Updated Freight Successfully')
				
				UPDATE Orders
				SET Freight = @freight
				FROM inserted I
				INNER JOIN Orders O
				ON I.OrderID = O.OrderID
			END

			ELSE
			BEGIN
				Print('Failed : Update Freight has exceeded average Freight value of given Customer')
			END
	END

	IF(UPDATE(OrderID))
	BEGIN
		Raiserror('Cannot update OrderID',16,1)
		return
	END
	IF(UPDATE(CustomerID))
	BEGIN
		Raiserror('Cannot update CustomerID',16,1)
		return
	END
	IF(UPDATE(EmployeeID))
	BEGIN
		Raiserror('Cannot update EmployeeID',16,1)
		return
	END
	IF(UPDATE(OrderDate))
	BEGIN
		Raiserror('Cannot update OrderDate',16,1)
		return
	END
	IF(UPDATE(RequiredDate))
	BEGIN
		Raiserror('Cannot update RequiredDate',16,1)
		return
	END
	IF(UPDATE(ShippedDate))
	BEGIN
		Raiserror('Cannot update ShippedDate',16,1)
		return
	END
	IF(UPDATE(ShipVia))
	BEGIN
		Raiserror('Cannot update ShipVia',16,1)
		return
	END
	IF(UPDATE(ShipName))
	BEGIN
		Raiserror('Cannot update ShipName',16,1)
		return
	END
	IF(UPDATE(ShipAddress))
	BEGIN
		Raiserror('Cannot update ShipAddress',16,1)
		return
	END
	IF(UPDATE(ShipCity))
	BEGIN
		Raiserror('Cannot update ShipCity',16,1)
		return
	END
	IF(UPDATE(ShipRegion))
	BEGIN
		Raiserror('Cannot update ShipRegion',16,1)
		return
	END
	IF(UPDATE(ShipPostalCode))
	BEGIN
		Raiserror('Cannot update ShipPostalCode',16,1)
		return
	END
	IF(UPDATE(ShipCountry))
	BEGIN
		Raiserror('Cannot update ShipCountry',16,1)
		return
	END
END
GO

--------Valid---------------------------------------------------------

--insert
INSERT INTO "Orders"
(CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate,
	ShipVia,Freight,ShipName,ShipAddress,ShipCity,ShipRegion,
	ShipPostalCode,ShipCountry)
VALUES (N'REGGC',4,'8/23/1996','9/20/1996','9/3/1996',1,16.45,
	N'Reggiani Caseifici',N'Strada Provinciale 124',N'Reggio Emilia',
	NULL,N'42100',N'Italy')
GO

--update
UPDATE Orders
SET Freight = 5
WHERE OrderID = 10248
GO

--------Invalid--------------------------------------------------------

--insert
INSERT INTO Orders
(CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate,
	ShipVia,Freight,ShipName,ShipAddress,ShipCity,
	ShipRegion,ShipPostalCode,ShipCountry)
VALUES (N'REGGC',4,'8/23/1996','9/20/1996','9/3/1996',1,60.45,
	N'Reggiani Caseifici',N'Strada Provinciale 124',N'Reggio Emilia',
	NULL,N'42100',N'Italy')
GO

--update
UPDATE Orders
SET Freight = 50
WHERE OrderID = 10248
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
GO

spGetSalesByCountry 'UK';
GO

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
GO

spGetSalesByYear '1996'
GO


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
 GO

 spGetSalesByCategories 7
 GO


------------------------(5)------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE spGetTop10MostExpensiveProducts
AS
BEGIN
	SELECT TOP 10 ProductName, UnitPrice
	FROM Products
	ORDER BY UnitPrice DESC;
END
GO


------------------------(6)------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE spInsertCustomerOrderDetails
@OrderID INT,
@ProductID INT,
@UnitPrice MONEY, 
@Quantity INT,
@Discount REAL
AS
BEGIN
	INSERT INTO [Order Details] 
	VALUES(@OrderID,@ProductID,@UnitPrice,@Quantity,@Discount)
END
GO

spInsertCustomerOrderDetails 10248, 20, '10', 5, 0
GO

------------------------(7)------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE spUpdateCustomerOrderDetails
@OrderID INT,
@ProductID INT,
@UnitPrice MONEY, 
@Quantity INT,
@Discount REAL
AS
BEGIN
	UPDATE [Order Details] 
	SET Quantity = @Quantity, Discount = @Discount, UnitPrice = @UnitPrice
	WHERE OrderID = @OrderID AND ProductID = @ProductID
END
GO

spUpdateCustomerOrderDetails 10248, 15, '12', 10, 0.15
GO