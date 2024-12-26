--using the datawarehouse to run the queries
use GravityBooks_DWH
go
-- Drop table if exist
if exists (select *
           from   sys.tables
		   where name = 'order_history')
   drop table order_history
go
--creating order_history dimension
create table order_history
(
order_history_sk int primary key identity(1,1),     --Surrogate key
order_id int not null,                              --business key
order_history_id int not null,
order_status_id int not null, 
order_status varchar(40) not null,
received_date int null,
pending_date int null,
in_progress_date int null,
delivered_date int null,
cancelled_date int null,
returned_date int null,
)
go
---- create foreign keys
alter table order_history add constraint FK_received_date foreign key (received_date)
references date_dim(date_sk)
go
alter table order_history add constraint FK_pending_date foreign key (pending_date)
references date_dim(date_sk)
go
alter table order_history add constraint FK_in_progress_date foreign key (in_progress_date)
references date_dim(date_sk)
go
alter table order_history add constraint FK_delivered_date foreign key (delivered_date)
references date_dim(date_sk)
go
alter table order_history add constraint FK_cancelled_date foreign key (cancelled_date)
references date_dim(date_sk)
go
alter table order_history add constraint FK_returned_date foreign key (returned_date)
references date_dim(date_sk)
--drop index if exist
if exists (select * 
           from sys.indexes
		   where name = 'order_history_order_id'
)
drop index order_history_order_id 
on order_history
go
--create index on the business key
create nonclustered index order_history_order_id 
on order_history(order_id )