USE lessons;
go

-- Task 1

drop table if exists [dbo].[TestMultipleZero];

CREATE TABLE [dbo].[TestMultipleZero]
(
    [A] [int] NULL,
    [B] [int] NULL,
    [C] [int] NULL,
    [D] [int] NULL
);
GO

INSERT INTO [dbo].[TestMultipleZero](A,B,C,D)
VALUES 
    (0,0,0,1),
    (0,0,1,0),
    (0,1,0,0),
    (1,0,0,0),
    (0,0,0,0),
    (1,1,1,0);

SELECT *
FROM [dbo].[TestMultipleZero]
WHERE A <> 0 OR B <> 0 OR C <> 0 OR D <> 0;

-- Task 2

drop table if exists TestMax;

CREATE TABLE TestMax
(
    Year1 INT
    ,Max1 INT
    ,Max2 INT
    ,Max3 INT
);
GO
 
INSERT INTO TestMax 
VALUES
    (2001,10,101,87)
    ,(2002,103,19,88)
    ,(2003,21,23,89)
    ,(2004,27,28,91);


select *,
	GREATEST(Max1, Max2, Max3) as MaxValues
from TestMax;


-- Task 3

drop table if exists EmpBirth;

CREATE TABLE EmpBirth
(
    EmpId INT  IDENTITY(1,1) 
    ,EmpName VARCHAR(50) 
    ,BirthDate DATETIME 
);
 
INSERT INTO EmpBirth(EmpName,BirthDate)
SELECT 'Pawan' , '12/04/1983'
UNION ALL
SELECT 'Zuzu' , '11/28/1986'
UNION ALL
SELECT 'Parveen', '05/07/1977'
UNION ALL
SELECT 'Mahesh', '01/13/1983'
UNION ALL
SELECT'Ramesh', '05/09/1983';

select * from EmpBirth
where month(BirthDate) = '05' and day(BirthDate) between '7' and '15' ;

-- Task 4

drop table if exists letters;

create table letters
(letter char(1));

insert into letters
values ('a'), ('a'), ('a'), 
  ('b'), ('c'), ('d'), ('e'), ('f');

SELECT *
FROM letters
ORDER BY 
    CASE
        WHEN letter = 'b' THEN 0
        ELSE 1
    END,
letter;

SELECT * FROM letters
ORDER BY
    CASE 
        WHEN letter = 'b' THEN 1
        ELSE 0
    END,
letter;