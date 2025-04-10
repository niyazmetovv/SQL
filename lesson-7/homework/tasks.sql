use lessons;
go

-- drops
drop table if exists Customers;
drop table if exists Orders;
drop table if exists OrderDetails;
drop table if exists Products;

-- Creates and inserts
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10,2)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50)
);


INSERT INTO Customers VALUES 
(1, 'Alice'), (2, 'Bob'), (3, 'Charlie');

INSERT INTO Orders VALUES 
(101, 1, '2024-01-01'), (102, 1, '2024-02-15'),
(103, 2, '2024-03-10'), (104, 2, '2024-04-20');

INSERT INTO OrderDetails VALUES 
(1, 101, 1, 2, 10.00), (2, 101, 2, 1, 20.00),
(3, 102, 1, 3, 10.00), (4, 103, 3, 5, 15.00),
(5, 104, 1, 1, 10.00), (6, 104, 2, 2, 20.00);

INSERT INTO Products VALUES 
(1, 'Laptop', 'Electronics'), 
(2, 'Mouse', 'Electronics'),
(3, 'Book', 'Stationery');

-- 1

select
	*
from Customers as c
	left join orders as o
		on c.CustomerID = o.CustomerID;

-- 2

select
	c.CustomerID,
	c.CustomerName
from Customers as c
	left join orders as o
		on c.CustomerID = o.CustomerID
where OrderID is NULL;

-- 3

select
	os.OrderID,
	p.ProductName,
	od.Quantity
	from Orders as os
		inner join OrderDetails as od
			on os.OrderID = od.OrderID
		inner join Products as p
			on p.ProductID = od.ProductID

-- 4

select
	c.CustomerID,
	c.CustomerName,
	count(o.OrderID) as OrdersCount
from Customers as c
	left join orders as o
		on c.CustomerID = o.CustomerID
group by c.CustomerID, c.CustomerName
having count(o.OrderID) > 1;

--5

SELECT 
    od.OrderID,
    od.ProductID,
    p.ProductName,
    od.Price
FROM 
    OrderDetails od
JOIN 
    Products p ON od.ProductID = p.ProductID
JOIN (
    SELECT 
        OrderID,
        MAX(Price) AS MaxPrice
    FROM 
        OrderDetails
    GROUP BY 
        OrderID
) as max_prices ON od.OrderID = max_prices.OrderID AND od.Price = max_prices.MaxPrice;


-- 6

select
	c.*,
	o.OrderID,
	o.OrderDate
from Customers as c
	join Orders as o
		on c.CustomerID = o.CustomerID
	join (
		select
			CustomerID,
			max(OrderDate) as LatestOrder
		from orders
		group by CustomerID
			
) as FilteredOrders on FilteredOrders.CustomerID = c.CustomerID and o.OrderDate = FilteredOrders.LatestOrder;

-- 7

SELECT 
    c.CustomerID,
    c.CustomerName
FROM Customers AS c
	JOIN Orders AS o 
		ON c.CustomerID = o.CustomerID
	JOIN OrderDetails AS od 
		ON o.OrderID = od.OrderID
	JOIN Products AS p 
		ON od.ProductID = p.ProductID
GROUP BY c.CustomerID, c.CustomerName
HAVING 
    COUNT(DISTINCT CASE WHEN p.Category <> 'Electronics' THEN p.ProductID END) = 0;

-- 8

SELECT 
    c.CustomerID,
    c.CustomerName
FROM Customers AS c
	JOIN Orders AS o 
		ON c.CustomerID = o.CustomerID
	JOIN OrderDetails AS od 
		ON o.OrderID = od.OrderID
	JOIN Products AS p 
		ON od.ProductID = p.ProductID
WHERE p.Category = 'Stationery'

-- 9

SELECT 
    c.CustomerID,
    c.CustomerName,
    SUM(od.Price * od.Quantity) AS TotalSpent
FROM Customers AS c
JOIN Orders AS o ON c.CustomerID = o.CustomerID
JOIN OrderDetails AS od ON o.OrderID = od.OrderID
GROUP BY 
    c.CustomerID,
    c.CustomerName;
