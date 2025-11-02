/* Monthly Sales Trend (Qty & Revenue)

Question:
How have total quantity sold and revenue changed month-over-month in the last 12 months? */

with c as (
select year(order_date) yr , month(order_date) mnth ,
	concat(monthname(order_date),", ",year(order_date)) as mnthyr , 
    round(sum(line_amount)) as revenue , 
    sum(quantity) as qty
from orders as o inner join order_items as oi on oi.order_id = o.order_id
where status <> "Cancelled"
group by yr, mnth, mnthyr)

select mnthyr as month_year , 
		revenue, 
		concat(round(((revenue-lag(revenue) over (order by yr,mnth))/lag(revenue) over (order by yr,mnth))*100,2),"%") MoM_rev,
        Qty,
        concat(round(((qty-lag(qty) over (order by yr,mnth))/lag(qty) over (order by yr,mnth))*100,2),"%") MoM_qty_sold
from c; 



/* Average Order Value (AOV) Trend

Question:
How is AOV (revenue ÷ number of orders) trending by month? */


with c as (
select year(order_date) yr , month(order_date) mnth ,
	concat(monthname(order_date),", ",year(order_date)) as mnthyr , 
    round(sum(line_amount)) as revenue ,
    count(distinct oi.order_id) as count_of_orders,
    round(sum(line_amount)/count(distinct oi.order_id)) as AOV
from orders as o inner join order_items as oi on oi.order_id = o.order_id
where status <> "Cancelled"
group by yr, mnth, mnthyr)


select mnthyr as month_year , 
		AOV, 
		concat(round(((AOV-lag(AOV) over (order by yr , mnth ))/
			lag(revenue) over (order by yr , mnth ))*100,4),"%") MoM_AOV
from c;



/* Returning-Customer Order Share Trend

Question:
What % of monthly orders come from returning customers (i.e., customers who placed at least one order before the current order)? */
