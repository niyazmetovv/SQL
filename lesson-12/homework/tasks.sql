use lessons;
go

----====================================================
----                   Task 1
----====================================================


-- creating proc
ALTER  procedure sp_mainn (@name_of_db varchar(255))
as
begin
	-- dynamic sql
	declare @sql nvarchar(MAX);

	-- setting as string to execute later
set @sql =

	-- using N, coz sql server expects unicode
N'SELECT ' +
               'TABLE_CATALOG AS DatabaseName, ' +
               'TABLE_SCHEMA AS SchemaName, ' +
               'TABLE_NAME AS TableName, ' +
               'COLUMN_NAME AS ColumnName, ' +
               'CONCAT(DATA_TYPE, ''('' + ' +
               'CASE ' +
               'WHEN CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR) = ''-1'' ' +
               'THEN ''max'' ' +
               'ELSE CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR) ' +
               'END + '')'') AS DataType ' +
               'FROM ' + QUOTENAME(@name_of_db) + '.INFORMATION_SCHEMA.COLUMNS;';

    -- executing with (stored procedure) sp_executesql for better performance
    EXEC sp_executesql @sql;
end;
go

-- declaring variables that i will need in loop
declare @name varchar(255);
declare @i int = 1;
declare @count int;

--setting count to num of databases
select @count = count(1) from  sys.databases
	where name not in ('master', 'tempdb', 'model', 'msdb');

-- using loop to iterate through all databases and their tables ...
while @i <= @count
begin
-- using common table expression to get a temporary (for one use) tables each time
   ;with cte as (
		select name, ROW_NUMBER() OVER(order BY name) as rn
		from sys.databases where name not in ('master', 'tempdb', 'model', 'msdb')
	)
	-- used row_number to number the databases, then setting names with help of it and i variable
	select @name=name from cte
	where rn = @i;
	-- incrementing i
	set @i = @i + 1;
	-- finally executing st
	exec sp_mainn @name;
end

--====================================================
--                   Task 2
--====================================================
DROP PROCEDURE IF EXISTS sp_dbs;
GO

CREATE PROCEDURE sp_dbs (@db_name VARCHAR(255) = NULL)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @sql NVARCHAR(MAX) = N'';
    
    IF @db_name IS NOT NULL
    BEGIN
        SET @sql = '
        SELECT 
            ''' + @db_name + ''' AS DatabaseName,
            OBJECT_SCHEMA_NAME(o.object_id, DB_ID(''' + @db_name + ''')) AS SchemaName,
            o.name AS ObjectName,
            p.name AS ParameterName,
            t.name AS DataType,
            p.max_length AS MaxLength
        FROM ' + QUOTENAME(@db_name) + '.sys.objects o
        LEFT JOIN ' + QUOTENAME(@db_name) + '.sys.parameters p ON o.object_id = p.object_id
        LEFT JOIN ' + QUOTENAME(@db_name) + '.sys.types t ON p.user_type_id = t.user_type_id
        WHERE o.type IN (''P'', ''FN'', ''IF'', ''TF'');
        ';
    END
    ELSE
    BEGIN
        SELECT @sql = STRING_AGG('
        BEGIN TRY
            SELECT 
                ''' + name + ''' AS DatabaseName,
                OBJECT_SCHEMA_NAME(o.object_id, DB_ID(''' + name + ''')) AS SchemaName,
                o.name AS ObjectName,
                p.name AS ParameterName,
                t.name AS DataType,
                p.max_length AS MaxLength
            FROM ' + QUOTENAME(name) + '.sys.objects o
            LEFT JOIN ' + QUOTENAME(name) + '.sys.parameters p ON o.object_id = p.object_id
            LEFT JOIN ' + QUOTENAME(name) + '.sys.types t ON p.user_type_id = t.user_type_id
            WHERE o.type IN (''P'', ''FN'', ''IF'', ''TF'');
        END TRY
        BEGIN CATCH
        END CATCH;', CHAR(10))
        FROM sys.databases
        WHERE state = 0 AND name NOT IN ('tempdb');
    END

    EXEC sp_executesql @sql;
END;
GO


EXEC sp_dbs;



