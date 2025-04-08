use lessons;
go

-- Drop tables if they already exist (drop in order to handle foreign key dependencies)
DROP TABLE IF EXISTS Projects;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Departments;

-- Create Employees Table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    DepartmentID INT,
    Salary INT
);

-- Insert into Employees
INSERT INTO Employees (EmployeeID, Name, DepartmentID, Salary) VALUES
(1, 'Alice', 101, 60000),
(2, 'Bob', 102, 70000),
(3, 'Charlie', 101, 65000),
(4, 'David', 103, 72000),
(5, 'Eva', NULL, 68000);

-- Create Departments Table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

-- Insert into Departments
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(101, 'IT'),
(102, 'HR'),
(103, 'Finance'),
(104, 'Marketing');

-- Create Projects Table
CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(50),
    EmployeeID INT
);

-- Insert into Projects
INSERT INTO Projects (ProjectID, ProjectName, EmployeeID) VALUES
(1, 'Alpha', 1),
(2, 'Beta', 2),
(3, 'Gamma', 1),
(4, 'Delta', 4),
(5, 'Omega', NULL);

-- 1

select 
	e.Name, 
	d.DepartmentName
from Employees as e
	inner join Departments as d
		on e.DepartmentID = d.DepartmentID

-- 2

select 
	e.Name, 
	d.DepartmentName
from Employees as e
	left outer join Departments as d
		on e.DepartmentID = d.DepartmentID

-- 3

select 
	e.Name, 
	d.DepartmentName
from Employees as e
	right outer join Departments as d
		on e.DepartmentID = d.DepartmentID

-- 4

select 
	e.Name, 
	d.DepartmentName
from Employees as e
	full outer join Departments as d
		on e.DepartmentID = d.DepartmentID

-- 5

select
	d.DepartmentName,
	sum(e.Salary) as TotalSalaryPerDep
from Employees as e
	inner join Departments as d
		on e.DepartmentID = d.DepartmentID
group by d.DepartmentName;

-- 6

select *
from Departments
	cross join Projects

-- 7

select
	e.EmployeeID,
    e.Name as EmployeeName,
    d.DepartmentName,
    p.ProjectName
from Employees as e
	left join Departments as d
		on e.DepartmentID = d.DepartmentID
	left join Projects as p
				on p.EmployeeID = e.EmployeeID