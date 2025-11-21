use retail_db;

/*-- 1) Find the List of customers who had more than 5 session in the website 2025 but no session in the past 45 days
 (treat 1st Sept 2025 as last date and ignore the rows where customer id is null)*/
 
select customer_id
from web_events
where customer_id is not null
group by customer_id
having COUNT(distinct case when STR_TO_DATE(event_datetime, '%d-%m-%Y %H:%i') >= '2025-01-01'
                           and STR_TO_DATE(event_datetime, '%d-%m-%Y %H:%i') <= '2025-09-01' then session_id end) > 5
                           and MAX(STR_TO_DATE(event_datetime, '%d-%m-%Y %H:%i')) < '2025-07-19';
    
    /*-- 2) For each customer find the average no.of events they take to finally purchase something from us. 
    And then divide them into 4 equal groups.*/
    
    with TargetCustomers as (
    
    select customer_id
    from web_events
    where customer_id is not null
    group by customer_id
    having count(distinct case when STR_TO_DATE(event_datetime, '%d-%m-%Y %H:%i') >= '2025-01-01'
                           and  STR_TO_DATE(event_datetime, '%d-%m-%Y %H:%i') <= '2025-09-01' then session_id end) > 5
                           and  MAX(STR_TO_DATE(event_datetime, '%d-%m-%Y %H:%i')) < '2025-07-19'
),
EventsToPurchaseCycles as (
   
    select T.customer_id,STR_TO_DATE(T.event_datetime, '%d-%m-%Y %H:%i') as event_datetime_parsed,
          sum(case when T.event_type != 'purchase' then 1 else 0 end)
            over (partition by T.customer_id order by STR_TO_DATE(T.event_datetime, '%d-%m-%Y %H:%i') 
            rows unbounded preceding ) as cumulative_other_events,
		   case when T.event_type = 'purchase' then 1 else 0 end as is_purchase
    from web_events T
    where T.customer_id in (select customer_id from TargetCustomers)
),
AvgEvents as (
    
    select E.customer_id,
	       E.cumulative_other_events - lag(E.cumulative_other_events, 1, 0)
            over (partition by E.customer_id order by E.event_datetime_parsed) as non_purchase_events_in_cycle
            from EventsToPurchaseCycles E
             where E.is_purchase = 1 
)
select customer_id,
    avg(non_purchase_events_in_cycle) as avg_events_to_purchase,
   ntile(4) over (order by avg(non_purchase_events_in_cycle) asc) as  purchase_quartile_group
from AvgEvents
group by customer_id
order by purchase_quartile_group, avg_events_to_purchase;