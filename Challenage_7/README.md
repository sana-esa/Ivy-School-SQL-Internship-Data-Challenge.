📊 Inventory Alignment Analysis Challenge
This SQL challenge (Inventory_vs_Sales_Alignment_Query.sql) is designed to analyze the alignment between End-of-Month (EOM) on-hand inventory and the total sales demand for a given month, at the Store-Product level. The goal is to identify inventory statuses that are either well-aligned with demand or flag them as potential "Inventory Issues.

🎯 Objective
The primary objective is to calculate and compare two key metrics for every store_id, product_id, and analysis_month:

EOM On-Hand Inventory: The final quantity of a product at the end of the last recorded movement in the month.

Monthly Sales Demand: The total quantity of units sold for that product during the month.

The final output classifies the inventory health based on the absolute difference between these two metrics.

🛠️ Prerequisites
A MySQL/MariaDB environment.

A database named retail_db.

A table named inventory_movements with the following key columns:

store_id

product_id

movement_datetime (used for running total and time-based filtering)

quantity_delta (positive for restock/returns, negative for sales/shipment)

movement_type (e.g., 'sale', 'restock')

💡 SQL Query Breakdown
The solution uses three Common Table Expressions (CTEs) and a final UNION ALL operation for a comprehensive join.

1. rankedmovements (CTE)
Purpose: Calculate the running total of inventory (current_on_hand_qty) for each (store_id, product_id) pair, ordered by movement_datetime.

Key Technique: Uses a window function (SUM() OVER (PARTITION BY ... ORDER BY ...)) for the running total.

2. monthlyinventory (CTE)
Purpose: Extract the End-of-Month (EOM) On-Hand Inventory.

Filtering: Selects only the records where rn = 1 from the rankedmovements CTE. This record represents the final inventory level after the last transaction of the month.

3. monthlysales (CTE)
Purpose: Calculate the Total Monthly Sales Demand.

Calculation: Sums the absolute value of quantity_delta (abs(quantity_delta)) only for movements where movement_type = 'sale'.

4. Final Comparison and Classification
Joining: A FULL OUTER JOIN effect is achieved using a LEFT JOIN combined with a RIGHT JOIN (with a WHERE MI.store_id is null) connected by UNION ALL. This ensures all combinations of (Store, Product, Month) that exist in either EOM Inventory or Sales Demand are included.

Coalescing: The COALESCE() function is used to substitute NULL values (from the join) with 0, particularly for monthly_inventory or monthly_sales_demand if one side of the join is missing.

Classification: The final CASE statement determines the status:

'Within Demand': If the absolute difference between monthly_inventory and monthly_sales_demand is less than or equal to 5.

'Inventory Issue': Otherwise.

Column                          Description
store_id                      Identifier for the retail location.
product_id                   Identifier for the product.
analysis_month,              The month and year (YYYY-MM) being analyzed.
monthly_inventory            The End-of-Month On-Hand Inventory (0 if no movements).
monthly_sales_demand         The total units sold during the month (0 if no sales).
inventory_alignment_status   Classification: 'Within Demand' or 'Inventory Issue'.

Ranking: Assigns a rank (rn) within each (store_id, product_id, analysis_month) partition, ordering by movement_datetime DESC. This ensures the latest movement gets rank rn=1.
