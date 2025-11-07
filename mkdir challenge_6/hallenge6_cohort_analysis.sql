use retail_db;

create view Cohort_Table as 
with  RankedOrders as (
    select customer_id,order_datetime,
        row_number() over(PARTITION BY customer_id ORDER BY order_datetime ASC) as order_rank
    from orders
),
FirstSecondOrders as  (
    select r1.customer_id,
        r1.order_datetime as first_order_date,
        r2.order_datetime AS second_order_date
    from RankedOrders r1
    join RankedOrders r2
	on r1.customer_id = r2.customer_id
    where r1.order_rank = 1
	and r2.order_rank = 2 
)
select customer_id,
  datediff(second_order_date, first_order_date) as days_between_orders,
    case
        when datediff(second_order_date, first_order_date) <= 30 then 'Cohort 1'
        when datediff(second_order_date, first_order_date) <= 60 then'Cohort 2'
        when datediff(second_order_date, first_order_date) <= 90 then'Cohort 3'
        else 'Cohort 4'
    end as cohort
from FirstSecondOrders;

/*-- 1) Percentage of customers in each Cohort */
with TotalCustomers as (
    select count(customer_id) as total_count
    from  Cohort_Table
)
select cohort,count(customer_id) as  customer_count,
    round(cast(count(customer_id) * 100.0 / (select total_count from TotalCustomers) as real), 2) as percentage
from Cohort_Table
group by cohort
order by cohort;

/*-- 2) Average difference in days between the first and second order for each cohort.*/

select cohort,
round(avg(days_between_orders), 2) as average_days_between_orders
from Cohort_Table
group by cohort
order by cohort;
