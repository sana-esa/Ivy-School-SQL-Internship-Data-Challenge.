# Day 1 Solution

# Active Products as a percentage of total products

select concat(round((sum(if(active = "true",1,0))/count(*))*100),"%") as Active_prd_percentage
from products; 


# Classify Stores into Old and New (before 2023 – Old, In or After 2023 New) and then count the stores in each.

select if(year(opened_at)>2022,"New","Old") as Classification , 
		Count(*) as count_of_stores
from stores
Group by Classification;


# Top 5 cities by number of customers along with Old and New classification of stores

select c.city , opened_at, count(*) as count_of_customers , 
		if(year(opened_at)>2022,"New","Old") as classification
from customers c inner join stores s on c.city=s.city
group by city , opened_at
order by 3 desc
limit 5;


# Average order line value 

select round(avg(line_amount),2) avg_line_amt
from order_items oi inner join orders o on oi.order_id=o.order_id
where status <> "Cancelled";

