--creating datawarhouse
create database GravityBooks_DWH
--using the datawarehouse to run the queries
use GravityBooks_DWH

-- Drop table if exist
if exists (select * 
           from   sys.tables
		   where name = 'Customer_Dim')
    drop table Customer_Dim



--creating customer dimension
create table Customer_Dim
(
customer_sk int primary key identity(1,1) not null,  --Surrogate key
customer_id int not null,                            --business key
fname varchar(200),
lname varchar(200),
email varchar(350) ,
country varchar(200),
city varchar(200),
street_name varchar(200),
street_num varchar(10),
address_status varchar(20),
start_date datetime not null default (getdate()) ,
end_date datetime null,
is_current  TINYINT NOT NULL DEFAULT (1),

)

--drop index if exist
if exists (select *
           from   sys.indexes
		   where name= 'customer_dim_customer_id')
drop index customer_dim_customer_id
on Customer_Dim
go
--create index on the business key
create nonclustered index customer_dim_customer_id 
on Customer_Dim(customer_id)