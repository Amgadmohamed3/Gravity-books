--using the datawarehouse to run the queries
use gravitybooks_dwh
go

-- drop the table if exist
if exists (select * 
           from   sys.tables
           where name = 'date_dim')
    drop table date_dim
go

--creating customer dimension
create table date_dim(
    date_sk int not null primary key, -- format: yyyymmdd / surrogate key
    date date not null,
    day char(2) not null,
    dayofweek varchar(9) not null,
    dayofmonth tinyint not null,
    dayofyear int not null,
    weekofmonth tinyint not null,
    weekofyear tinyint not null,
    month char(2) not null,
    monthname varchar(9) not null,
    quarter tinyint not null,
    year char(4) not null,
    isweekend bit not null,
    isholiday bit not null,
    holidayname varchar(50) null
)

-- populate the dim_date table
declare @startdate date = '2000-01-01'
declare @enddate date = '2050-01-01' -- non-inclusive
declare @date date = @startdate

while @date < @enddate
begin
    declare @dayofweekname varchar(9) = datename(weekday, @date)
    declare @isweekend bit = case when @dayofweekname in ('saturday', 'sunday') then 1 else 0 end
    declare @isholiday bit = 0
    declare @holidayname varchar(50) = null

    -- check for holidays
    if (month(@date) = 1 and day(@date) = 1)
	begin 
	set @isholiday = 1
	set @holidayname = 'New year''s Day'
	end
    if (month(@date) = 12 and day(@date) = 25)
	begin
	set @isholiday = 1
	set @holidayname = 'Christmas Day'
	end
	if(month(@date)=10 and day(@date)=31)
	begin
	set @isholiday = 1
	set @holidayname='Halloween'
	end
	if(month(@date)=2 and day(@date)=14)
	begin
	set @isholiday = 1
	set @holidayname='Valentine''s Day'
	end

    -- insert data into dim_date table
    insert into date_dim (
        date_sk,
        date,
        day,
        dayofweek,
        dayofmonth,
        dayofyear,
        weekofmonth,
        weekofyear,
        month,
        monthname,
        quarter,
        year,
        isweekend,
        isholiday,
        holidayname
    )
    select
        convert(int, format(@date, 'yyyyMMdd')) as date_sk,
        @date as date,
        format(@date, 'dd') as day,
        @dayofweekname as dayofweek,
        day(@date) as dayofmonth,
        datepart(dayofyear, @date) as dayofyear,
        (datepart(day, @date) - 1) / 7 + 1 as weekofmonth,
        datepart(week, @date) as weekofyear,
        format(@date, 'MM') as month,
        datename(month, @date) as monthname,
        datepart(quarter, @date) as quarter,
        format(@date, 'yyyy') as year,
        @isweekend as isweekend,
        @isholiday as isholiday,
        @holidayname as holidayname

    -- increment date
    set @date = dateadd(day, 1, @date)
end

--drop index if exist
if exists (select *
           from   sys.indexes
           where name= 'date_dim_date')
  drop index date_dim_date
  on date_dim
go
--create index on the date
create nonclustered index date_dim_date
on date_dim(date)

--drop index if exist
if exists (select *
           from   sys.indexes
           where name= 'date_dim_month')
drop index date_dim_month
on date_dim
go
--create index on the month
create nonclustered index date_dim_month 
on date_dim(month)

--drop index if exist
if exists (select *
           from   sys.indexes
           where name= 'date_dim_year')
drop index date_dim_year
on date_dim
go
--create index on the year
create nonclustered index date_dim_year
on date_dim(year)

--drop index if exist
if exists (select *
           from   sys.indexes
           where name= 'date_dim_quarter')
drop index date_dim_quarter
on date_dim
go
--create index on the quarter
create nonclustered index date_dim_quarter
on date_dim(quarter)
