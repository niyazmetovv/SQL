use lessons;
go

drop table if exists Shipments;
go
CREATE TABLE Shipments (
    N INT PRIMARY KEY,
    Num INT
);

INSERT INTO Shipments (N, Num) VALUES
(1, 1), (2, 1), (3, 1), (4, 1), (5, 1), (6, 1), (7, 1), (8, 1),
(9, 2), (10, 2), (11, 2), (12, 2), (13, 2), (14, 4), (15, 4), 
(16, 4), (17, 4), (18, 4), (19, 4), (20, 4), (21, 4), (22, 4), 
(23, 4), (24, 4), (25, 4), (26, 5), (27, 5), (28, 5), (29, 5), 
(30, 5), (31, 5), (32, 6), (33, 7);

;WITH all_Days AS (
    SELECT value as dayy from generate_series(1, 40)
),
shipment_data AS (
    SELECT 
        ad.dayy AS N, 
        COALESCE(sh.Num, 0) AS Num
    FROM all_Days ad
    LEFT JOIN Shipments sh ON ad.dayy = sh.N
)


SELECT AVG(Num) as Median
FROM (
    SELECT Num, ROW_NUMBER() OVER (ORDER BY Num) AS rnk
    FROM shipment_data
) AS [sorted_data]
WHERE rnk in (20,21);