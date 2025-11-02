# Day 2 Solution

# Total Sales in each category

select p.category, round(sum(line_amount),2) as revenue 
from orders o inner join order_items oi on o.order_id = oi.order_id 
		inner join products p on oi.product_id=p.product_id
where status <> "cancelled"
group by category
order by revenue desc;


# Top 5 products in each category based on the quantity sold. Also, showcase the brand they belong to 

with c as (
select category, product_name, brand, sum(quantity) , 
		rank () over (partition by category order by sum(quantity) desc) as rnk
from orders o inner join order_items oi on o.order_id = oi.order_id 
inner join products p on oi.product_id=p.product_id
where status <> "cancelled"
group by category , product_name, brand)

select *
from c
where rnk <= 5;


# Monthly units sold in 2025 in each category

select category, monthname(order_date), sum(quantity)
from orders o inner join order_items oi on o.order_id = oi.order_id
		inner join products p on oi.product_id=p.product_id
where year(order_date) = 2025 and status <> "cancelled"
group by category , month(order_date), monthname(order_date)
order by category , month(order_date);

