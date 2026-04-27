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
	sum(quantity) as '총 판매 수량'
from
	orders
group by
	restaurant_id,
    menu_id
order by
	restaurant_id,
    menu_id;
    
-- F W (G,H) S O L OF
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

-- 1.총 주문 건수와 전체 매출
select count(*) as `총 주문 건수`, sum(total_price) as `전체 매출` from orders;
-- 2. 가게별 주문 수, 매출 랭킹 많은 순
select restaurant_id, count(*) as `가게별 총 주문 건수`, sum(total_price + delivery_fee) as `가게별 매출`
from orders
group by restaurant_id
order by `가게별 매출` desc;
-- 3. 주문이 5건 이상인 가게
select restaurant_id
from orders
group by restaurant_id
having count(*) >= 5;
-- 4. 월별 주문 트렌드 (최근 3달)
select date_sub(now(), interval 3 month);
select restaurant_id, menu_id, sum(quantity)
from orders
where order_date > date_sub((select max(order_date) from orders), interval 3 month)
group by restaurant_id, menu_id
order by sum(quantity) desc;
-- 5. 고객별 지출 TOP3
select customer_id, sum(total_price + delivery_fee) as `총지출`
from orders
group by customer_id
order by `총지출` desc 
limit 3;
-- 가게별 주문 건수 3 이상, 총 주문 금액 10,000 이상
select 
	*
from
	orders
group by
	restaurant_id
having
	count(*) >= 3
    and avg(total_price) >= 10000;
-- 월별 주문 건수 조회, 주문 가장 많았던 달을 첫 번째 행으로 출력
select 
	year(order_date),
    month(order_date),
    count(*)
from 
	orders
group by
	year(order_date),
    month(order_date)
order by
	count(*) desc
limit 1;
    
