
🛒 Retail Product Combo Recommendation (Bucket Analysis)

This repository contains the SQL solution for a comprehensive Bucket Analysis challenge focused on identifying the most profitable and popular product combinations for targeted cross-selling and recommendation strategies.

The goal is to move beyond simple co-occurrence and measure the actual revenue uplift (profitability) generated when a top-selling product (Hero Product) is purchased as part of a multi-item combo compared to when it is purchased alone.

🎯 The Challenge: Recommend Profitable Combos

The core task, as outlined in the assignment, is to find product combinations that are both popular (high frequency) and profitable (high basket value increase).

Required Steps:

Identify Hero Products: Determine the top 20 products by total revenue.

Map Combos: For each Hero Product, identify every unique combination of other products purchased in the same transaction.

Establish Baseline: Calculate the average total basket value when the Hero Product is purchased alone (single-item order).

Calculate Combo Value: Calculate the average total basket value when the Hero Product is purchased with a specific combo.

Calculate Profitability Lift: Determine the percentage increase in basket value for each combo relative to the baseline.

Recommendation: Output the most profitable and frequent combos.

💾 Solution (Sana Khatoon_Challenge_10.sql)

The correct solution leverages Common Table Expressions (CTEs) and the GROUP_CONCAT function (specific to MySQL/MariaDB) to handle complex aggregation and accurately define the unique product combos in a single-query approach.

Key Logic Points:

GROUP_CONCAT: Used to serialize the IDs of all co-purchased products into a single, canonical string (e.g., "21, 55, 103"), allowing us to group by the full, unique combination.

Baseline Isolation: The AloneBaseline CTE calculates the average basket value only for orders containing one single item (the Hero Product), ensuring a clean comparison.

Profitability Check: The final result set is filtered using a HAVING clause to only show combos that result in a positive revenue lift.

SQL Query Snippet

The solution is implemented in the Sana Khatoon_Challenge_10.sql file.

use retail_db;

WITH
-- 1. Identify the Top 20 Products by Total Revenue
TopHeroProducts as (
    -- ...
    limit 20
),

-- 2. Establish the baseline: Avg basket value when the Hero Product is purchased ALONE
AloneBaseline as (
    -- ... (where total_products_in_order = 1)
),

-- ... CTEs for combo identification and basket value aggregation ...

-- 6. Final Aggregation and Ranking
select 
    p.product_name as hero_product_name,
    gc.co_purchase_product_ids,
    COUNT(gc.order_id) as support_count,
    ROUND(avg(gc.total_basket_value), 2) as avg_basket_value_for_combo,
    ROUND(ab.avg_basket_value_alone, 2) as avg_basket_value_alone,
    ROUND(
        ((avg(gc.total_basket_value) - ab.avg_basket_value_alone) / NULLIF(ab.avg_basket_value_alone, 0)) * 100
    , 2) as pct_revenue_lift_over_alone
from ComboCoOccurrence gc
-- ... joins and grouping ...
having (avg(gc.total_basket_value) - ab.avg_basket_value_alone) > 0
order by
    pct_revenue_lift_over_alone desc,
    support_count desc
limit 100;


⚙️ How to Run

Database: This query is written for a database compatible with the retail_db schema (using tables like order_items and products). The syntax (specifically GROUP_CONCAT) is designed for MySQL/MariaDB.

Execution:

Connect to your database client.

Ensure the retail_db is selected (use retail_db;).

Execute the contents of the Sana Khatoon_Challenge_10.sql file.

Interpretation: The resulting table will show the best combinations, ranked by the highest revenue lift percentage (pct_revenue_lift_over_alone) and supported by high frequency (support_count).
