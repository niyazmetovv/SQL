use lessons;
go


drop table if exists Employees;
drop table if exists Orders_DB1;
drop table if exists Orders_DB2;
drop table if exists WorkLog;

-- ==============================================================
--                          Puzzle 1 DDL                         
-- ==============================================================

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2)
);

INSERT INTO Employees (EmployeeID, Name, Department, Salary)
VALUES
    (1, 'Alice', 'HR', 5000),
    (2, 'Bob', 'IT', 7000),
    (3, 'Charlie', 'Sales', 6000),
    (4, 'David', 'HR', 5500),
    (5, 'Emma', 'IT', 7200);


-- ==============================================================
--                          Puzzle 2 DDL
-- ==============================================================

CREATE TABLE Orders_DB1 (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    Product VARCHAR(50),
    Quantity INT
);

INSERT INTO Orders_DB1 VALUES
(101, 'Alice', 'Laptop', 1),
(102, 'Bob', 'Phone', 2),
(103, 'Charlie', 'Tablet', 1),
(104, 'David', 'Monitor', 1);

CREATE TABLE Orders_DB2 (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    Product VARCHAR(50),
    Quantity INT
);

INSERT INTO Orders_DB2 VALUES
(101, 'Alice', 'Laptop', 1),
(103, 'Charlie', 'Tablet', 1);


-- ==============================================================
--                          Puzzle 3 DDL
-- ==============================================================

CREATE TABLE WorkLog (
    EmployeeID INT,
    EmployeeName VARCHAR(50),
    Department VARCHAR(50),
    WorkDate DATE,
    HoursWorked INT
);

INSERT INTO WorkLog VALUES
(1, 'Alice', 'HR', '2024-03-01', 8),
(2, 'Bob', 'IT', '2024-03-01', 9),
(3, 'Charlie', 'Sales', '2024-03-02', 7),
(1, 'Alice', 'HR', '2024-03-03', 6),
(2, 'Bob', 'IT', '2024-03-03', 8),
(3, 'Charlie', 'Sales', '2024-03-04', 9);

-- ==============================================================
--                          Puzzle 1 DML
-- ==============================================================


-- HR → IT → Sales → HR
DROP TABLE IF EXISTS #EmployeeTransfers;
CREATE TABLE #EmployeeTransfers
(
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2)
);

INSERT INTO #EmployeeTransfers (EmployeeID, Name, Department, Salary)
SELECT
    EmployeeID,
    Name,
    CASE Department
        WHEN 'HR' THEN 'IT'
        WHEN 'IT' THEN 'Sales'
        WHEN 'Sales' THEN 'HR'
        ELSE Department
    END,
    Salary
FROM Employees;

SELECT * FROM #EmployeeTransfers;


-- ==============================================================
--                          Puzzle 2 DML
-- ==============================================================

declare @MissingOrders table
(
	OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    Product VARCHAR(50),
    Quantity INT
);

insert into @MissingOrders(OrderID, CustomerName, Product, Quantity)
(
	SELECT * FROM Orders_DB1
    EXCEPT
    SELECT * FROM Orders_DB2
)

SELECT * FROM @MissingOrders;

-- ==============================================================
--                          Puzzle 3 DML
-- ==============================================================

drop view if exists vw_MonthlyWorkSummary;
;CREATE VIEW vw_MonthlyWorkSummary AS
SELECT 
	w.EmployeeID,
	w.EmployeeName, 
	w.Department, 
	SUM(HoursWorked)  as TotalHoursWorked,
	d.TotalHoursDepartment,
	d.AvgHoursDepartment


FROM WorkLog w
JOIN
(
	SELECT
	    Department,
		SUM(HoursWorked) AS TotalHoursDepartment,
		AVG(HoursWorked) AS AvgHoursDepartment
	FROM WorkLog
	GROUP BY Department
) as d
	on d.Department = w.Department
GROUP BY
	w.EmployeeID, w.EmployeeName, w.Department, 
    d.TotalHoursDepartment, d.AvgHoursDepartment;

select * from vw_MonthlyWorkSummary



