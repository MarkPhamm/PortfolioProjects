/*
Analyze what time frame customers often come to buy in to coordinate enough staff to serve customers' shopping needs.
Requirements: Query the average number of customers who come to buy at each store per day according to each time frame of the day. Sales data is limited to the last 6 months of 2020. 
Let assume a staff to serve 8 customers / 1 hour, calculate at the peak time, how many employees each store needs
*/
select store_id,s.code,s.name,h,round(AVG(number_of_customer),2) as avg_number_of_customer from 
(
select CAST(transaction_date as date)as dd,store_id,DATEPART(HOUR,transaction_date) as h,count(distinct(customer_id))*1.0 as number_of_customer from kpim_retail.dbo.pos_sales_header
WHERE CAST(transaction_date as date)between'2020-06-01'and'2020-12-31'
GROUP BY CAST(transaction_date as date),store_id,DATEPART(HOUR,transaction_date)
) r
join kpim_retail.dbo.store s
on r.store_id = s.id
group by store_id,s.code,s.name,h
order by store_id,s.code,s.name,h
--
select store_id,code,name,max(avg_number_of_customer),CEILING(max(avg_number_of_customer)/8) from 
(
select store_id,s.code,s.name,h,round(AVG(number_of_customer),2) as avg_number_of_customer from 
(
select CAST(transaction_date as date)as dd,store_id,DATEPART(HOUR,transaction_date) as h,count(distinct(customer_id))*1.0 as number_of_customer from kpim_retail.dbo.pos_sales_header
WHERE CAST(transaction_date as date)between'2020-06-01'and'2020-12-31'
GROUP BY CAST(transaction_date as date),store_id,DATEPART(HOUR,transaction_date)
) r
join kpim_retail.dbo.store s
on r.store_id = s.id
group by store_id,s.code,s.name,h
) a
group by store_id,code,name
order by store_id,code,name



-- How many provinces in the Middle Area (Miền Trung)

SELECT count(*) FROM kpim_retail.dbo.city
JOIN kpim_retail.dbo.sub_region
ON CITY.sub_region_id = sub_region.id
JOIN kpim_retail.dbo.region
ON sub_region.region_id = region.id
where region.name like '%Trung%'
--19



-- Which province has the highest number of stores in the whole country?
SELECT count(*), district.name FROM kpim_retail.dbo.store

JOIN kpim_retail.dbo.district
ON store.district_id = district.id
GROUP BY district.name
ORDER BY 1 desc
-- Hoàng Mai, Hà Nội, 85



--How many wards in Hà Nội with more than 10 stores?
SELECT count(*), ward.name FROM kpim_retail.dbo.store 

JOIN kpim_retail.dbo.ward ON store.ward_id = ward.id
WHERE store.city_id =24
GROUP BY ward.name
HAVING count(*) >= 10
-- 10



--Which province has the highest ratio of number of stores to number of wards?

select a.district_id,name,stores_per_district,ward_per_district,round(stores_per_district / ward_per_district,4) from
(
select district_id,cast(count(*) as float) as stores_per_district from [kpim_retail].dbo.store 
group by district_id
) as a
join 
(
select district_id, cast(count(*) as float) as ward_per_district from [kpim_retail].dbo.ward
group by district_id
) as b
on a.district_id = b.district_id
join kpim_retail.dbo.district
on a.district_id = district.id
order by 5 desc
-- Cầu Giấy




--3 stores neareast to store VMHNI60 

select code,kpim_retail.dbo.fnc_calc_haversine_distance(latitude,longitude,ala,along) from kpim_retail.dbo.store
join
(
select id, longitude as along, latitude as ala from kpim_retail.dbo.store
where code = 'VMHNI60'
) a
on a.id != store.id
order by 2 
--VMHNI466, VMHNI735, VMHNI92


/*
Get a list of cities and provinces in the North. There is information about domain name, domain code, area name, area code, after id, name, code of province/city. 
The data table is arranged in alphabetical order by domain name, region name and city name.
*/

SELECT 
region.code as region_code,
region.name as region_name, 
sub_region.code as sub_region_code, 
sub_region.name as sub_region_name, 
city.id as city_id,
city.code as city_code,
city.name as city_name  FROM kpim_retail.dbo.city
JOIN kpim_retail.dbo.sub_region
ON CITY.sub_region_id = sub_region.id
JOIN kpim_retail.dbo.region
ON sub_region.region_id = region.id
WHERE region.code = 'MB'
ORDER BY 1,2,3,4 



/*
On the occasion of the establishment of the first branch in Hoan Kiem district - Hanoi, the company plans to organize a gratitude event for loyal customers.All customers with total accumulated purchase value (including VAT) from October 1, 2020 to October 20, 2020 at stores in Hoan Kiem district over 10 million VND will receive a purchase voucher 1 million dong.  Knowing that stores in Hoan Kiem district have district_id=1. 
Get a list of customers who are eligible to participate in the above promotion.The required information includes: customer code, full name, customer name, total purchase value. Sort by descending total purchase value and customer name in Alphabetical order.
*/

SELECT distinct(customer_id) as id, code, full_name,first_name,total_amount FROM 
(
SELECT customer_id, sum(pos_sales_header.total_amount) total_amount FROM  kpim_retail.dbo.store
JOIN kpim_retail.dbo.pos_sales_header
ON store.id = pos_sales_header.store_id
WHERE store.district_id = 1 AND transaction_date <= '2020-10-20' and transaction_date >= '2020-10-01'
GROUP BY customer_id
) as a
JOIN kpim_retail.dbo.customer
ON a.customer_id = customer.id
WHERE total_amount >= 7000000
ORDER BY total_amount desc;

/*
Every week, the lucky spin program will find 5 lucky orders and refund 50% for order not more than 1 million VND. The list of winning orders for the week from August 31, 2020 to September 6, 2020 are orders with the following document_code: 
SO-VMHNI4-202009034389708, SO-VMHNI109-202008316193214, SO-VMHNI51-202008316193066, SO-VMHNI64 -202008316193112, SO-VMHNI48-202009016193491. 
Retrieve order information, information of lucky customers and the amount of money the customer is refunded. The required information includes: order code, store code, store name, time of purchase, customer code, full name, customer name, order value, customer refund amount again.
*/

SELECT document_code,store_id,s.code as store_code, transaction_date,customer_id, full_name,first_name,total_amount, iif(total_amount/2<1000000,total_amount/2,1000000) as promotion_amount from kpim_retail.dbo.pos_sales_header h
join kpim_retail.dbo.customer c
on h.customer_id = c.id
join kpim_retail.dbo.store s
on h.store_id = s.id
where document_code in (
'SO-VMHNI4-202009034389708', 
'SO-VMHNI109-202008316193214', 
'SO-VMHNI51-202008316193066', 
'SO-VMHNI64 -202008316193112', 
'SO-VMHNI48-202009016193491')
order by promotion_amount desc;



-- Summarize sales and average number of products purchased each time a customer buys the product “Cháo Yến Mạch, Chà Là Và Hồ Đào | Herritage Mill, Úc (320 G)” in 2020. 

select 
product_sku_id, 
customer_id,
sum(line_amount) as total_amount,
sum(quantity) as total_quantity, 
count(*) as nb_purchases,
sum(quantity)/count(*) as avg_quantity_per_purchase
from kpim_retail.dbo.product_sku sku 
join kpim_retail.dbo.pos_sales_line line 
on line.product_sku_id = sku.id
where product_sku_id = 91 and YEAR(transaction_date) = 2020
group by product_sku_id, customer_id
order by 2;



--Get a list of the top 20 best-selling instant noodles products in 2019 and 2020. Consider products in the instant food group (sub_category_id=19) and the product name has the word "Mì" or the word "Mỳ". Information returned includes year, product code, product name, country of origin, brand, selling price, quantity sold, sales rating by year. The returned list is sorted by year and by product rating
select year,product_sku_id,code,name,country,brand,price,quantity,DENSE_RANK()OVER(PARTITION BY year ORDER BY quantity desc) as rank from (
select year(transaction_date) as year ,product_sku_id,sum(quantity) as quantity from kpim_retail.dbo.product_sku s
join kpim_retail.dbo.pos_sales_line l
on s.id = l.product_sku_id
and product_subcategory_id = 19
and year(transaction_date) in (2020,2021)
group by year(transaction_date),product_sku_id
) as a
join kpim_retail.dbo.product_sku s
on a.product_sku_id = s.id
where name like '%Mì%' 
or name like '%Mỳ%' 
or name like '%mì%' 
or name like '%mỳ%' 


/*
The store “Cụm 6, Xã Sen Chiểu, Huyện Phúc Thọ, Hà Nội” had customers complaining about the service quality and service attitude of the staff on the afternoon of June 13, 2020.
Query information about employees working the afternoon shift on June 13, 2020 at the store.
*/
select 
day_work,
store.id as store_id,
store.name as store_name,
shift_name,
sales_person_id,
sales_person.code,
full_name,
first_name,
gender
from kpim_retail.dbo.emp_shift_schedule
join kpim_retail.dbo.sales_person
on emp_shift_schedule.sales_person_id = sales_person.id
join kpim_retail.dbo.store
on emp_shift_schedule.store_id = store.id
where emp_shift_schedule.store_id = 1
and day_work = '2020-06-13'
and shift_name like 'c%'





/*
et the TOP 3 stores by sales in Hanoi to award the store of the month of October 2020. Know that stores in Hanoi have city_id=24.
*/
select top(3) store_id,s.code,s.name, total_sales 
from
(
select store_id,sum(line_amount) as total_sales from kpim_retail.dbo.store s
join kpim_retail.dbo.pos_sales_line l
on l.store_id = s.id
where transaction_date between'2020-10-01'and'2020-10-31'and city_id=24
and city_id = 24
group by store_id
) r
join kpim_retail.dbo.store s
on r.store_id = s.id
order by total_sales desc
