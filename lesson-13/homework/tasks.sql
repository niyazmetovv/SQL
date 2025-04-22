use lessons;
go

-- declaring variables I will need

-- for testing using just getdate
declare @input date = getdate();

-- start of month using darefromparts, putting 1 to the day part
declare @start date = datefromparts(year(@input), month(@input), 1);

-- using eomonth for end of month
declare @end date = eomonth(@input)

-- ctes


;with dates
as
(
	-- getting all the dates of month using recursion
	select dt = @start
	union all
	select DATEADD(day, 1, dt)
	from dates
	where dt < @end
		
),
calendar
as
(
	-- using case to seperate weekdays
	select
		WeekNum = DATEPART(week, dt),
		Sunday    = CASE WHEN DATENAME(WEEKDAY, dt) = 'Sunday' THEN DAY(dt) ELSE NULL END,
        Monday    = CASE WHEN DATENAME(WEEKDAY, dt) = 'Monday' THEN DAY(dt) ELSE NULL END,
        Tuesday   = CASE WHEN DATENAME(WEEKDAY, dt) = 'Tuesday' THEN DAY(dt) ELSE NULL END,
        Wednesday = CASE WHEN DATENAME(WEEKDAY, dt) = 'Wednesday' THEN DAY(dt) ELSE NULL END,
        Thursday  = CASE WHEN DATENAME(WEEKDAY, dt) = 'Thursday' THEN DAY(dt) ELSE NULL END,
        Friday    = CASE WHEN DATENAME(WEEKDAY, dt) = 'Friday' THEN DAY(dt) ELSE NULL END,
        Saturday  = CASE WHEN DATENAME(WEEKDAY, dt) = 'Saturday' THEN DAY(dt) ELSE NULL END

	from dates
),
final
as
(
	-- using max to get only non-null values
    SELECT 
		WeekNum,
        Sunday    = MAX(Sunday),
        Monday    = MAX(Monday),
        Tuesday   = MAX(Tuesday),
        Wednesday = MAX(Wednesday),
        Thursday  = MAX(Thursday),
        Friday    = MAX(Friday),
        Saturday  = MAX(Saturday)
    FROM calendar
	-- grouping by weeknum to get whole table
	group by WeekNum
)

-- result ordered by weeknum
select * from final
order by WeekNum;

