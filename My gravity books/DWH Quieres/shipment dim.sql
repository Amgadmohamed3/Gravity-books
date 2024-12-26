--using the datawarehouse to run the queries
use GravityBooks_DWH
go
-- Drop table if exist
if exists (select *
           from   sys.tables
		   where name = 'shipping_Dim')
   drop table shipping_Dim
go
--creating shipping dimension
create table shipping_Dim
(
shipping_sk int primary key identity(1,1),     --Surrogate key
shipping_id int not null,                      --business key
shipping_method varchar(100),
start_date datetime not null default(getdate()),
end_date datetime null,
is_current tinyint not null default(1)
)
go
--drop index if exist
if exists (select * 
           from sys.indexes
		   where name = 'shipping_Dim_shipping_id'
)
drop index shipping_Dim_shipping_id 
on shipping_Dim
go
--create index on the business key
create nonclustered index shipping_Dim_shipping_id
on shipping_Dim(shipping_id)