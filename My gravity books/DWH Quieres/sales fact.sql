--using the datawarehouse to run the queries
use GravityBooks_DWH
go
-- Drop table if exist
if exists (select *
           from   sys.tables
		   where name = 'sales_Fact')
   drop table sales_Fact
go
--creating sales fact
create table sales_Fact
(
sales_sk int primary key identity(1,1), --Surrogate key
shipping_sk int null,                   --foreign key
customer_sk int null,                   --foreign key
date_sk int null,                       --foreign key
book_sk int null,                       --foreign key
price decimal(5,2),                     --measure
shipping_cost decimal(6,2),             --measure

constraint fact_shipping_fk foreign key (shipping_sk) references shipping_dim(shipping_sk),
constraint fact_customer_fk foreign key (customer_sk) references customer_dim(customer_sk),
constraint fact_date_fk     foreign key (date_sk)     references date_dim(date_sk),
constraint fact_book_fk     foreign key (book_sk)     references book_dim(book_sk)
)
go
--drop index if exist
if exists (select * 
           from sys.indexes
		   where name = 'shipping_Dim_fact'
)
drop index shipping_Dim_fact 
on sales_Fact
go
--create index on the foreign key
create index shipping_Dim_fact
on sales_Fact(shipping_sk)

--drop index if exist
if exists (select * 
           from sys.indexes
		   where name = 'customer_Dim_fact'
)
drop index customer_Dim_fact
on sales_Fact
go
--create index on the foreign key
create nonclustered index customer_Dim_fact
on sales_Fact(customer_sk)

--drop index if exist
if exists (select * 
           from sys.indexes
		   where name = 'date_Dim_fact'
)
drop index date_Dim_fact
on sales_Fact
go
--create index on the foreign key
create nonclustered index date_Dim_fact
on sales_Fact(date_sk)


--drop index if exist
if exists (select * 
           from sys.indexes
		   where name = 'book_Dim_fact'
)
drop index book_Dim_fact 
on sales_Fact
go
--create index on the foreign key
create nonclustered index book_Dim_fact
on sales_Fact(book_sk)

--adding source_system_code column to indicate the data's source and for auditing purposes
alter table shipping_Dim 
add source_system_code tinyint
go
alter table book_Dim 
add source_system_code tinyint
go
alter table customer_Dim 
add source_system_code tinyint
go
alter table order_history
add source_system_code tinyint
go
alter table sales_fact
add source_system_code tinyint