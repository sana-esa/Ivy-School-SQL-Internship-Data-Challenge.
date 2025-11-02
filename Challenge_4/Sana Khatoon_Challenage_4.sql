use retail_db;

/*-- 1) Monthly Sales Trend : How have total quantity sold and revenue changed month-over-month in the last 12 months?*/

with MonthlySales as (
    select date_format(o.order_datetime, '%Y-%m') as Sales_Month,
        round(sum(oi.line_amount), 2) as Total_Revenue,
        SUM(oi.quantity) as Total_Quantity_Sold
    from orders o
    join order_items oi on o.order_id = oi.order_id
    where o.status <> 'cancelled' 
    group by Sales_Month
),
MonthlyTrends as (
    select Sales_Month,Total_Revenue,Total_Quantity_Sold,
        lag(Total_Revenue, 1) over (order by Sales_Month) as Prev_Month_Revenue,
        lag(Total_Quantity_Sold, 1) over (order by Sales_Month) as Prev_Month_Quantity
    from MonthlySales
)
select Sales_Month,Total_Revenue,Total_Quantity_Sold,
    concat(round(((Total_Revenue - Prev_Month_Revenue) / Prev_Month_Revenue) * 100, 2), '%') as Revenue_MoM_Change,
    concat(round(((Total_Quantity_Sold - Prev_Month_Quantity) / Prev_Month_Quantity) * 100, 2), '%') as Quantity_MoM_Change
    from MonthlyTrends
    where Sales_Month >= '2024-08'
    order by Sales_Month desc;
    
    /*-- 2) Average Order Value (AOV) Trend : How is AOV (revenue ÷ number of orders) trending
by month?*/

with MonthlyAOV as (
    select date_format(o.order_datetime, '%Y-%m') as Sales_Month, 
        sum(oi.line_amount) as Total_Revenue,
        count(distinct o.order_id) as Total_Orders 
    from orders o
    join order_items oi on o.order_id = oi.order_id
    where o.status <> 'cancelled' 
    group by Sales_Month
),
AOVTrends as(
    select Sales_Month,round(Total_Revenue / Total_Orders, 2) as Average_Order_Value,
	lag(round(Total_Revenue / Total_Orders, 2), 1) over (order by Sales_Month) as Prev_Month_AOV
    from MonthlyAOV
)
select Sales_Month,Average_Order_Value,
    concat(
        round(((Average_Order_Value - Prev_Month_AOV) / Prev_Month_AOV) * 100, 2), 
        '%'
    ) as AOV_MoM_Change
from AOVTrends
where Sales_Month >= '2024-08'
order by Sales_Month desc;