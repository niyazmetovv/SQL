USE lessons;
go


IF OBJECT_ID('dbo.Employees', 'U') IS NOT NULL
    DROP TABLE dbo.Employees;

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    [Name] VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2),
    HireDate DATE
);


INSERT INTO Employees (EmployeeID, [Name], Department, Salary, HireDate) VALUES
(1, 'Alice Johnson', 'HR', 55000.00, '2018-03-15'),
(2, 'Bob Smith', 'IT', 72000.00, '2019-07-22'),
(3, 'Charlie Davis', 'Finance', 68000.00, '2020-01-10'),
(4, 'Diana Lopez', 'Marketing', 68000.00, '2017-11-05'),
(5, 'Ethan Brown', 'IT', 75000.00, '2021-06-01'),
(6, 'Fiona Green', 'HR', 53000.00, '2022-09-19'),
(7, 'George Wilson', 'Finance', 71000.00, '2016-12-30'),
(8, 'Hannah White', 'Marketing', 59000.00, '2018-05-20'),
(9, 'Ivan Turner', 'IT', 80000.00, '2023-01-12'),
(10, 'Jasmine Patel', 'Finance', 66500.00, '2020-08-14');

-- 1

SELECT *, ROW_NUMBER() OVER(ORDER BY Salary)
FROM Employees;

-- 2

-- To see them
SELECT *, DENSE_RANK() OVER(ORDER BY Salary)
FROM Employees;

-- To print them only
SELECT e.EmployeeID, e.[Name], e.Salary
FROM Employees e
WHERE e.Salary IN (
    SELECT Salary
    FROM Employees
    GROUP BY Salary
    HAVING COUNT(*) > 1
);


-- 3

SELECT  *
FROM
(SELECT 
	*, 
	ROW_NUMBER() OVER(PARTITION BY Department ORDER BY Salary DESC) AS SalaryRank 
	FROM Employees) as DeptTopEarners
WHERE SalaryRank IN (1, 2);


-- 4

SELECT * FROM 
(SELECT 
	*,
	ROW_NUMBER() OVER(PARTITION BY department ORDER BY salary) AS SalaryRank
	FROM employees) AS DeptLowestEarners
WHERE SalaryRank = 1;

-- 5

SELECT 
    *,
    SUM(Salary) OVER (
        PARTITION BY Department 
        ORDER BY Salary
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RunningTotal
FROM Employees;

-- 6

SELECT DISTINCT Department, DepartmentTotalSalary
FROM (SELECT 
    *, 
    SUM(Salary) OVER(PARTITION BY Department) AS DepartmentTotalSalary
FROM Employees) AS SumSalaryPerDep;

-- 7

SELECT DISTINCT Department, DepartmentAverageSalary
FROM (SELECT 
    *, 
    AVG(Salary) OVER(PARTITION BY Department) AS DepartmentAverageSalary
FROM Employees) AS SumSalaryPerDep;

-- 8

SELECT *, (DepartmentAverageSalary - Salary) AS DiffSalary
FROM (SELECT 
    *, 
    AVG(Salary) OVER(PARTITION BY Department) AS DepartmentAverageSalary
FROM Employees) AS SumSalaryPerDep
ORDER BY EmployeeID;

-- 9

SELECT 
	*,
	AVG(Salary) OVER(ORDER BY EmployeeID
	ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS MovingAvgSalary
FROM Employees;

-- 10

SELECT SUM(Salary) AS Last3HiredSalaryTotal
FROM (SELECT 
	TOP 3 Salary
	FROM Employees
	ORDER BY HireDate DESC
) AS Last3Hired;

-- 11

SELECT 
	*,
	AVG(Salary) OVER(ORDER BY EmployeeID
	ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS RunningAvgSalary
FROM Employees;

-- 12

SELECT *,
	MAX(Salary) OVER(ORDER BY EmployeeID
	ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS MaxSalarySliding
FROM Employees;

-- 13

SELECT *,
	CAST((Salary  * 100)/ DepartmentTotalSalary AS DECIMAL(5, 2)) AS SalaryPercent
FROM(
	SELECT *,
		SUM(Salary) OVER(PARTITION BY Department) AS DepartmentTotalSalary
	FROM Employees
) AS SumSalaryPerDep;

