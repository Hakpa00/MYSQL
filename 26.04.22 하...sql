SELECT * FROM `26.04.22`.customers;
select * from orders;

select * from customers;

select * from restaurants;

select * from menus;

-- count 함수 
select count(*) from customers; -- 모든 컬럼 기준
select count(email) from customers; -- 선택한 컬럼 기준

select sum(total_price) from orders; -- count 함수가 아닌 경우는 모두 특정 컬럼을 선택해야함 ! sum (*) 불가
select concat(sum(total_price),'원') from orders;

select avg(total_price) from orders;
select round(avg(total_price),2) from orders;
select avg(quantity) from orders;
select round(avg(quantity),1) from orders;

select max(total_price) from orders;
select min(total_price) from orders;

select 
	category, 
	count(category) 
from 
	restaurants 
group by 
	category;
    
select 
	customer_id,
    restaurant_id,
    sum(total_price),
    count(*),
    max(total_price)
from 
	orders
group by
	customer_id,
    restaurant_id;

select
	restaurant_id,
    menu_id,
	count(*) as '총 주문 건수',
	sum(*) as '합계'
from
	orders
group by
	restaurant_id,
    menu_id
order by
	restaurant_id,
    menu_id;
    
-- having (집계 이후의 결과에 조건 처리)
select 
	menu_id, 
	sum(total_price) as total
from 
	orders 
where 
	menu_id > 5 
group by  
	menu_id
having 
	sum(total_price) > 30000 
order by
	total;
    
select
	restaurant_id,
	year(order_date),
	month(order_date),
    count(*),
    sum(total_price),
    sum(quantity)
from
	orders
group by
	year(order_date),
    month(order_date),
    restaurant_id
order by
    restaurant_id;
    
select count(*) as 총주문수, sum(total_price) as 총매출 from orders;
select restaurant_id, count(*) as 주문수, sum(total_price) as 총매출
from orders
group by restaurant_id
order by 총매출 desc;
select restaurant_id, count(*) AS 주문수
from orders
group by restaurant_id
having 주문수 >= 5;
select date_format(order_date, '%Y-%m') as 월, 
count(*) as 주문수, sum(total_price) as 매출
from orders
group by 월 order by 월;
select customer_id,count(*) as 주문횟수,sum(total_price) as 총지출
from orders
group by customer_id
order by 총지출 desc limit 3;
