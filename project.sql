use AKSHARA;
select * from customer_shopping_cleaned;

select gender,sum(purchase_amount_usd) as revenue from customer_shopping_cleaned group by gender;

select customer_id,purchase_amount_usd from customer_shopping_cleaned where discount_applied='yes' and purchase_amount_usd >=
(select avg(purchase_amount_usd) from customer_shopping_cleaned);

select top 5 review_rating from customer_shopping_cleaned order by review_rating Desc;

select top 5 item_purchased,round(avg(review_rating),2) as "average product rating" from customer_shopping_cleaned
group by item_purchased order by avg(review_rating) desc ;

select shipping_type,avg(purchase_amount_usd) as "avg purchase amount" from customer_shopping_cleaned 
where shipping_type in ('Express','Standard') group by shipping_type;

select count(customer_id) as "total customers",subscription_status,avg(purchase_amount_usd) as "avg purchase_amount",
sum(purchase_amount_usd) as "total revenue" from customer_shopping_cleaned 
group by subscription_status;

select top 5 item_purchased ,100* sum(case when discount_applied='yes' then 1 else 0 end )/count(*)  as discount_rate from customer_shopping_cleaned
group by item_purchased
order by discount_rate desc ;

with customer_type as(
select customer_id,previous_purchases,
case
when previous_purchases= 1 then 'new'
when previous_purchases between 2 and 20 then 'returning'
else 'loyal' end as "segment" from customer_shopping_cleaned)


select segment,count(*) as "no of customers" from customer_type group by segment;

select top 3 count(item_purchased) as count ,item_purchased,category from customer_shopping_cleaned group by category,item_purchased order by count desc;

select age_group,sum(purchase_amount_usd) as total_revenue
from customer_shopping_cleaned
group by age_group
order by total_revenue desc;

with item_count as(select category,item_purchased,count(*) as purchase_count from customer_shopping_cleaned
group by category,item_purchased),
ranked_item as( select *,row_number() over(partition by category order by purchase_count desc) as rn from item_count)
select category,item_purchased,purchase_count,rn from ranked_item where rn<=3;