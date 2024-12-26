--using the datawarehouse to run the queries
use GravityBooks_DWH
go
-- Drop table if exist
if exists (select *
           from   sys.tables
		   where name = 'book_Dim')
   drop table book_Dim
   go
--creating book dimension
create table book_Dim
(
book_sk int primary key identity(1,1),     --Surrogate key
book_id int not null,                      --business key
title varchar (400),
isban13 varchar(40),
author_name varchar(400),
language_code varchar(8),
langauge_name varchar(50),
num_pages int,
publish_date date,
publish_name nvarchar (400),
start_date datetime not null default(getdate()),
end_date datetime null,
is_current tinyint not null default(1)
)
go
--drop index if exist
if exists (select * 
           from sys.indexes
		   where name = 'book_Dim_book_id'
)
drop index book_Dim_book_id 
on book_Dim
go
--create index on the business key
create nonclustered index book_Dim_book_id
on book_Dim(book_id)