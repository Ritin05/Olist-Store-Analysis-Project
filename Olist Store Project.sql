use olist;
select * from olist_order_items_dataset;
select * from olist_order_payments_database;
select * from olist_order_reviews_dataset;
select * from olist_orders_dataset;
select * from olist_products_dataset;
select * from olist_sellers_dataset;

select count(*) from olist_orders_dataset;
select count(*) from olist_products_dataset;
select count(*) from olist_order_items_dataset;

describe olist_orders_dataset;


select * from olist_customers_dataset;

-- KPI 1 No Of Customer,State,City
select count(distinct(customer_unique_id)) as No_Of_Customer,count(distinct(customer_state)) as No_of_State,count(distinct(customer_city)) as No_of_City 
from olist_customers_dataset;


-- KPI 2 Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics

select
case
when weekday(order_purchase_timestamp) in (5,6) then 'weekand'
else 'weekday'
end as Day_end, 
count(distinct(olist_order_payments_database.order_id)) as Number_of_orders,
round(sum(olist_order_payments_database.payment_value)) as Total_payment
from olist_orders_dataset join olist_order_payments_database
on olist_orders_dataset.order_id=olist_order_payments_database.order_id
group by Day_end;

-- KPI 3 Number of Orders with review score 5 and payment type as credit card.
select payment_type,review_score,count(olist_order_payments_database.order_id) as Total_Orders
from olist_order_payments_database
join olist_order_reviews_dataset
on olist_order_reviews_dataset.order_id=olist_order_payments_database.order_id
where review_score=5
group by payment_type
order by Total_Orders desc;

-- KPI 4 Average number of days taken for order_delivered_customer_date for pet_shop

select product_category_name,round(avg(datediff(order_delivered_customer_date,order_purchase_timestamp)),0) as avg_delivery_time
from olist_orders_dataset o
join olist_order_items_dataset i on o.order_id=i.order_id
join olist_products_dataset p on p.product_id=i.product_id
group by product_category_name
order by avg_delivery_time;

-- pet_shop
-- perfumaria
-- pcs


-- KPI 5 Average price and payment values from customers of sao paulo city
select customer_city,round(avg(i.price)) as Average_price, round(avg(p.payment_value)) as average_payment
from olist_customers_dataset c
join olist_orders_dataset o on o.customer_id=c.customer_id
join olist_order_items_dataset i on i.order_id=o.order_id
join olist_order_payments_database p on p.order_id=o.order_id
where c.customer_city= "sao paulo";

-- sao paulo
-- sao carlos
-- uberlandia
-- feliz
-- curitiba

-- KPI 6 Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.
select review_score, round(avg(datediff(order_delivered_customer_date,order_purchase_timestamp)),0) as Shipping_days
from olist_order_reviews_dataset join olist_orders_dataset
on olist_orders_dataset.order_id=olist_order_reviews_dataset.order_id
group by review_score
order by review_score;



