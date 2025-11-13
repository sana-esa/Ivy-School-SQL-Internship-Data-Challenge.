# day 8

# compute add_to_cart counts per Product brand
with c as(
select mid(event_json,locate(":",event_json)+2,locate(",",event_json)-locate(":",event_json)-2) as prod_id , 
		count(*) as total_add_to_carts
from web_events
where event_type = "add_to_cart" and customer_id <> ""
group by prod_id
order by total_add_to_carts desc)


select  brand , sum(total_add_to_carts) as total_add_to_cart
from c inner join products p on c.prod_id=p.product_id
group by brand
order by total_add_to_cart desc;


# Create a Funnel: page_view → add_to_cart → checkout → purchase rates per campaign. 
with c as(
select utm_campaign , event_type, count(*) cnt
from web_events
where event_type not in ("search") and customer_id <> ""
group by utm_campaign , event_type
order by utm_campaign , cnt desc)

select * , round((cnt/first_value(cnt) over (partition by utm_campaign order by cnt desc))*100,2)
from c;


# Create a per-user feature table: last_event date, no.of sessions in past 30 days, add_to_carts in past 30 days, purchases in past 30 days.

with c as(
select customer_id , 
		count(*) no_of_sessions,
        sum(if(event_type="add_to_cart",1,0)) as add_to_carts, 
        sum(if(event_type="purchase",1,0)) as purchases
from web_events
where (event_date = "2025-09-01" - interval 30 day) and customer_id <> ""
group by customer_id),

t as(
select distinct(customer_id) as customer_id,
		first_value(event_date) over (partition by customer_id order by event_date desc) as last_event_date
from web_events
where customer_id <> "")

select t.customer_id, last_event_date, 
	ifnull(no_of_sessions,0) as no_of_sessions , 
    ifnull(add_to_carts,0) as add_to_carts ,
    ifnull(purchases,0) as purchases
from t left join c on t.customer_id = c.customer_id
order by customer_id;

