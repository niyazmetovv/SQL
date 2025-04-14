use lessons;
go

-- Task 1
drop table if exists Employees;
go
CREATE TABLE Employees
(
	EmployeeID  INTEGER PRIMARY KEY,
	ManagerID   INTEGER NULL,
	JobTitle    VARCHAR(100) NOT NULL
);
go
INSERT INTO Employees (EmployeeID, ManagerID, JobTitle) 
VALUES
	(1001, NULL, 'President'),
	(2002, 1001, 'Director'),
	(3003, 1001, 'Office Manager'),
	(4004, 2002, 'Engineer'),
	(5005, 2002, 'Engineer'),
	(6006, 2002, 'Engineer');


; with cte AS(
	select *, 0 AS Depth
	From Employees
	where ManagerID IS NULL
	UNION ALL
	select e.*, Depth + 1
	from Employees e
	join cte
		on e.ManagerID = cte.EmployeeID
)

select * from cte;

-- Task 2

;WITH factorial(Num, Factorial) AS 
(
    SELECT 1, 1
    UNION ALL
    SELECT Num + 1, Factorial * (Num + 1)
    FROM factorial
    WHERE Num < 10
)
SELECT * FROM factorial;


-- Task 3

WITH fib(n, Fibonacci_number, Prev) AS 
(
    SELECT 1, 1, 0
    UNION ALL
    SELECT n + 1, Fibonacci_number + Prev, Fibonacci_number
    FROM fib
    WHERE n < 10
)
SELECT n, Fibonacci_number FROM fib;
