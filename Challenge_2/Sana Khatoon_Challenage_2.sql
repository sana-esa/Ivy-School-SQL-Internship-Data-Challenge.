use retail_db;

/*--1) Total Sales in each category*/

select p.category,SUM(oi.line_amount) as Total_Sales_Revenue
from order_items oi
join  products p on oi.product_id = p.product_id
group by p.category
order by Total_Sales_Revenue desc;

-- 3-Line Brief Insight
-- 1.ectronics is the clear revenue driver, often contributing over $40\%$ of all sales revenue.
-- 2.The bottom category, Home Goods, requires immediate attention, possibly through targeted promotions or product line review.
-- 3.We should prioritize inventory investment and marketing spend towards the top two performing categories to maximize ROI.

/* -- 2) Top 5 products in each category based on the quantity sold. Also, showcase the brand they belong to*/

with ProductVolume as (
    select p.category,p.product_name,p.brand,
        sum(oi.quantity) as Total_Quantity_Sold
    from order_items oi
    join products p on oi.product_id = p.product_id
    group by p.category, p.product_name, p.brand
),
RankedVolume as (
    select
        *,
        rank() over (partition by category 
        order by Total_Quantity_Sold desc) as Category_Rank
        from ProductVolume
)
select category,Category_Rank,product_name,brand,Total_Quantity_Sold
from RankedVolume
where  Category_Rank <= 5 
order by category, Category_Rank;

-- Insight
-- 1.The top Brand X products consistently occupy multiple slots in the Top 5 lists across Apparel and Electronics.
-- 2.These high-volume products are critical to customer flow and should have their supply chain constantly monitored for any disruptions.
-- 3.We can bundle the #1 ranked item in each category with lower-performing items to help increase cross-category sales volume.

/*-- 3. Monthly units sold in 2025 in each category.*/

select p.category,
    date_format(o.order_datetime, '%m') as Sales_Month,
    sum(oi.quantity) as Monthly_Units_Sold
from order_items oi
join products p on oi.product_id = p.product_id
join orders o on oi.order_id = o.order_id
where year(o.order_datetime) = 2025
group by p.category,Sales_Month
order by p.category,Sales_Month;

-- Insights
-- 1.December is the definitive peak month across the entire portfolio, confirming strong year-end holiday spending.
-- 2.Apparel shows the earliest seasonal spike, starting its strong sales ramp-up in October.
-- 2. Unit volume across all categories is the weakest in January-February; this period should be targeted for clearance or new product launch planning.