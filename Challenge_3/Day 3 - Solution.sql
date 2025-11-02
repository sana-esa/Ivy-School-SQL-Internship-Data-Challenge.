# Day 3 Solution
use retail_db;
# Total orders and average shipping cost of each carrier

select carrier, round(avg(shipping_cost)) average_shipping_cost , count(*) as total_orders
from shipment s inner join orders o on o.order_id=s.order_id  
where status <> "cancelled"
group by carrier;


/* For each carrier, calculate the percentage of orders with a shipping lead time greater than the overall average lead time, 
and the percentage of orders with a shipping lead time less than the overall average lead time.
(Shipping lead time = delivered_at - shipped_at) */

select avg(timestampdiff(day,shippedat,deliveredat)) into @avg_lead_time
from shipment;

select carrier , 
	(sum(if(timestampdiff(day,shippedat,deliveredat)>@avg_lead_time,1,0))/count(*))*100 as above_average,
	(sum(if(timestampdiff(day,shippedat,deliveredat)<@avg_lead_time,1,0))/count(*))*100 as below_average
from shipment s inner join orders o on o.order_id=s.order_id  
where status <> "cancelled"
group by carrier;


/* Cost-to-serve per order = shipping_cost + (unit_cost*quantity) 
  for items in the order; list top 20 costliest orders.*/
  
with c as(
select o.order_id , round(sum(unit_cost*quantity),2) order_cost
from orders o inner join order_items oi on oi.order_id=o.order_id 
	inner join products p on oi.product_id = p.product_id
where status <> "Cancelled"
group by order_id)

select c.order_id , round(shipping_cost + order_cost,2) as cost_to_serve
from c inner join shipment s on c.order_id=s.order_id
order by cost_to_serve desc
limit 20;