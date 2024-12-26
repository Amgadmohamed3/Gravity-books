-- joining customer dimension
select c.customer_id,c.first_name,c.last_name,c.email,cy.country_name,adds.city,adds.street_name,adds.street_number,ads.address_status
from customer c left join customer_address ad
on c.customer_id=ad.customer_id
left join address_status ads
on ads.status_id=ad.status_id
left join address adds
on adds.address_id=ad.address_id
left join country cy
on cy.country_id=adds.country_id

--joining book dimension
select b.book_id,b.title,b.isbn13,a.author_name,bl.language_code,
       bl.language_name,b.num_pages,b.publication_date,p.publisher_name
from book b left join book_author ba
on b.book_id=ba.book_id
left join author a 
on a.author_id=ba.author_id
left join publisher p
on p.publisher_id=b.publisher_id
left join book_language bl
on bl.language_id=b.language_id

--order_history

create view order_hist
as (
select o.order_id,
       o.history_id,
       o.status_id,
       os.status_value,
       history.Received_d,
       history.Pending_Delivery_d,
       history.Delivery_In_Progress_d,
       history.Delivered_d,
       history.Cancelled_d,
       history.Returned_d
from order_history o
INNER JOIN
    (
      select oh.order_id,
             CAST(MAX(CASE WHEN os.status_value = 'Order Received' THEN oh.status_date END) AS date) AS Received_d,
             CAST(MAX(CASE WHEN os.status_value = 'Pending Delivery' THEN oh.status_date END) AS date) AS Pending_Delivery_d,
             CAST(MAX(CASE WHEN os.status_value = 'Delivery In Progress' THEN oh.status_date END) AS date) AS Delivery_In_Progress_d,
             CAST(MAX(CASE WHEN os.status_value = 'Delivered' THEN oh.status_date END) AS date) AS Delivered_d,
             CAST(MAX(CASE WHEN os.status_value = 'Cancelled' THEN oh.status_date END) AS date) AS Cancelled_d,
             CAST(MAX(CASE WHEN os.status_value = 'Returned' THEN oh.status_date END) AS date) AS Returned_d
        from order_history oh
        INNER JOIN order_status os
		ON os.status_id = oh.status_id
        group by oh.order_id
    ) as history
    on history.order_id = o.order_id
inner join order_status os
ON os.status_id = o.status_id
)

--sales fact
select b.book_id,ol.line_id,co.order_id,sm.method_id,c.customer_id,co.order_date,ol.price,sm.cost
from book b inner join order_line ol
on b.book_id=ol.book_id
inner join cust_order co
on co.order_id=ol.order_id
inner join shipping_method sm
on sm.method_id=co.shipping_method_id
inner join customer c
on c.customer_id=co.customer_id



