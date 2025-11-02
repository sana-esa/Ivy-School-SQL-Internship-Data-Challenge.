use retail_db;

/*--1) Total orders and average shipping cost of each carrier*/

select carrier,count(order_id) as TotalOrders,               
    avg(shipping_cost) as AverageShippingCost   
from shipments
group by carrier                                       
order by TotalOrders desc;  

/*--2) For each carrier, calculate the percentage of orders with a shipping lead time greater than the overall average lead time, 
and the percentage of orders with a shipping lead time less than the overall average lead time.
(Shipping lead time = delivered_at - shipped_at)*/

with OverallAverage as (
    select avg(timestampdiff(SECOND, shipped_at, delivered_at)) as overall_avg_lead_time_sec
    from shipments
),
ShipmentLeadTimes as (
    select carrier,timestampdiff(SECOND, shipped_at, delivered_at) as lead_time_sec,
       (select overall_avg_lead_time_sec from OverallAverage) as avg_time
    from shipments
)
select slt.carrier,round(
(sum(case when slt.lead_time_sec < slt.avg_time then 1.0 else 0.0 end) / count(slt.carrier)) * 100
    , 2) as Percent_Faster_Than_Avg,
    round(
        (sum(case when slt.lead_time_sec > slt.avg_time then 1.0 ELSE 0.0 end) / count(slt.carrier)) * 100
    , 2) as Percent_Slower_Than_Avg
from ShipmentLeadTimes slt
group by slt.carrier
order by Percent_Faster_Than_Avg desc;

/*--3) Cost-to-serve per order = shipping_cost + (unit_cost*quantity) for items in the order; list top 20 costliest orders.*/

with OrderProductCost as(
    select oi.order_id,sum(oi.quantity * p.unit_cost) as TotalProductCost
    from order_items oi
    join products p on oi.product_id = p.product_id
    group by oi.order_id
)
select opc.order_id,s.carrier,
    round(s.shipping_cost, 2) as shipping_cost,
    round(opc.TotalProductCost, 2) as TotalProductCost,
   round(s.shipping_cost + opc.TotalProductCost, 2) as Cost_to_Serve
from OrderProductCost opc
join shipments s on opc.order_id = s.order_id
order by Cost_to_Serve desc
limit 20;
