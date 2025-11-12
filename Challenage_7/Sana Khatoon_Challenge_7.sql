use retail_db;

with rankedmovements as (
    -- 1. Calculate the Running Total (Current On-Hand Inventory) and rank movements
    select
        store_id,
        product_id,
        movement_datetime,
        date_format(movement_datetime, '%Y-%m') as analysis_month,
        quantity_delta,
        sum(quantity_delta) over (
            partition by store_id, product_id
            order by movement_datetime
        ) as current_on_hand_qty,
        row_number() over (
            partition by store_id, product_id, date_format(movement_datetime, '%Y-%m')
            order by movement_datetime desc
        ) as rn
    from inventory_movements
),
monthlyinventory as (
    -- 2. Extract the End-of-Month (EOM) On-Hand Inventory
    select
        store_id,
        product_id,
        analysis_month,
        current_on_hand_qty as monthly_inventory
    from
        rankedmovements
    where
        rn = 1  
),
monthlysales as (
    -- 3. Calculate the total monthly sales demand (absolute quantity_delta for 'sale' type)
    select
        store_id,
        product_id,
        date_format(movement_datetime, '%Y-%m') as analysis_month,
        sum(abs(quantity_delta)) as monthly_sales_demand
    from
        inventory_movements
    where
        movement_type = 'sale'
    group by
        store_id,
        product_id,
        analysis_month
)
-- 4. Compare and Classify the Inventory vs. Sales Demand
select
    coalesce(MI.store_id, MS.store_id) as store_id,
    coalesce(MI.product_id, MS.product_id) as product_id,
    coalesce(MI.analysis_month, MS.analysis_month) as analysis_month,
    coalesce(MI.monthly_inventory, 0) as monthly_inventory,
    coalesce(MS.monthly_sales_demand, 0) as monthly_sales_demand,
    
    case
        when abs(coalesce(MI.monthly_inventory, 0) - coalesce(MS.monthly_sales_demand, 0)) <= 5
             then 'Within Demand'
        else 'Inventory Issue'
    end as inventory_alignment_status
from
    monthlyinventory MI
left join
    monthlysales MS
    on MI.store_id = MS.store_id
    and MI.product_id = MS.product_id
    and MI.analysis_month = MS.analysis_month

union all


select
    MS.store_id,
    MS.product_id,
    MS.analysis_month,
    coalesce(MI.monthly_inventory, 0) as monthly_inventory,
    coalesce(MS.monthly_sales_demand, 0) as monthly_sales_demand,
    
    case
        when abs(coalesce(MI.monthly_inventory, 0) - coalesce(MS.monthly_sales_demand, 0)) <= 5
             then 'Within Demand'
        else 'Inventory Issue'
    end as inventory_alignment_status
from
    monthlyinventory MI
right join
    monthlysales MS
    on MI.store_id = MS.store_id
    and MI.product_id = MS.product_id
    and MI.analysis_month = MS.analysis_month
where
    MI.store_id is null

order by
    store_id,
    product_id,
    analysis_month;