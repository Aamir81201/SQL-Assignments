	USE Northwind;
	GO

	SELECT * FROM Products;
	GO

	SELECT ProductID, ProductName, UnitPrice
	FROM Products
	WHERE (UnitPrice<20) AND (Discontinued=0);
	GO
	
	SELECT ProductID, ProductName, UnitPrice
	FROM Products
	WHERE UnitPrice BETWEEN 15 AND 25;
	GO
	
	SELECT ProductName, UnitPrice
	FROM Products
	WHERE UnitPrice >(SELECT avg(UnitPrice) FROM Products);
	GO

	SELECT TOP 10 ProductName, UnitPrice
	FROM Products
	ORDER BY UnitPrice DESC;
	GO

	SELECT COUNT(discontinued) as Current_Count
	FROM Products
	WHERE (discontinued=0);

	SELECT count(discontinued) as Disontinued_Count
	from products
	where (discontinued=1);
	GO

	SELECT ProductName, UnitsOnOrder, UnitsInStock
	FROM Products
	WHERE UnitsInStock < UnitsOnOrder;
	GO