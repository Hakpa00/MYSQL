select round(avg(price)) from menus;
select * from menus where price > (select round(avg(price)) from menus); -- 서브쿼리는 항상 ()로 묶어줘야함
-- select * from>1 menus where>2 price > (select>2-3 round(avg(price)>2-2) from>2-1 menus);

-- 메뉴의 가격이 평균 가격보다 크고 /  평균가격보다 큰 메뉴들의 가격 평균 미만인 것
-- 실패 ? > select * from menus where price < round(avg(select * from menus where price > (select round(avg(price)) from menus)));
	
-- 평균가격보다 큰 메뉴들의 가격 평균
select avg(price) from menus where price > (select round(avg(price)) from menus);

-- select * from menus where price > (select round(avg(price)) from menus) 
-- select avg(price) from menus where price > (select round(avg(price)) from menus)

select * from menus where price > (select round(avg(price)) from menus) -- 메뉴 가격이 평균가격 보다 큰 것 
	and price < (select avg(price) from menus where price > (select round(avg(price)) from menus)); -- 평균가격보다 큰 가격 평균 미만 
    

-- 정답 --
select 
	*
from	
	menus
where
	price > (select
				round(avg(price))
			from	
				menus)
	and price < (select round(avg(price))
			from
				menus
			where
				price > (select 
							round(avg(price))
						from
							menus));
                            
select
	*
from
	menus;

select
	id
from
	restaurants
where
	name = '해운대 치킨집';
    
select
	id
from
	menus
where
    restaurant_id = (
					select
						id
					from
						restaurants
					where
						name = '해운대 치킨집');
                        
-- == 다중행 서브쿼리 조건처리 == --
-- IN = 일치
select * from restaurants where id = 1 or id = 2 or id = 3;
select * from restaurants where id in (1,2,3);

select * from restaurants where category = '한식';
select id from restaurants where category = '한식';

select * from restaurants where id in(select id from restaurants where category = '한식'); 

select * from menus where id in(select id from restaurants where category = '한식'); -- 한식 메뉴

-- 주문이 들어온 적 없는 메뉴 찾기
select * from orders;
select * from menus;
select distinct menu_id from orders; -- 중복 없이

select * from menus where id in (select distinct menu_id from orders); -- 주문이 들어온 적 있는 메뉴
select * from menus where id not in (select distinct menu_id from orders); -- 주문 한번도 안들어온 메뉴

-- ANY 
select * from menus where price > any (select max(price) from menus group by restaurant_id); -- 가게별로 가장 비싼 것

-- ALL = 모두 만족
select * from ORDERS where TOTAL_price > ALL (select max(price) from menus group by restaurant_id); 
 
-- FROM절 서브쿼리 >> 테이블로서 취급 가능 >> 보통 JOIN 할 때 씀
SELECT
	*
FROM
	(SELECT 
		restaurant_ID, 
		COUNT(*), 
		SUM(TOTAL_PRICE) 
	FROM 
		ORDERS 
	GROUP BY 
		RESTAURANT_ID
	ORDER BY
		RESTAURANT_ID) AS ORDERS2; -- AS 생략 가능

SELECT
	count(*) -- ORDERS2의 행의 갯수
FROM
	(SELECT 
		restaurant_ID, 
		COUNT(*), 
		SUM(TOTAL_PRICE) 
	FROM 
		ORDERS 
	GROUP BY 
		RESTAURANT_ID
	ORDER BY
		RESTAURANT_ID) AS ORDERS2;

SELECT
	RESTAURANT_ID,
	ORDERS2.ORDER_COUNT, -- ORDERS2의 COUNT 열
    ORDER_TOTAL_PRICE
FROM
	(SELECT 
		restaurant_ID, 
		COUNT(*) AS ORDER_COUNT, 
		SUM(TOTAL_PRICE) AS ORDER_TOTAL_PRICE
	FROM 
		ORDERS 
	GROUP BY 
		RESTAURANT_ID
	ORDER BY
		RESTAURANT_ID) AS ORDERS2;
        
SELECT
	*
FROM
	MENUS MN -- OG 테이블을 JOIN 기준은 RESTAURANT_ID
    LEFT JOIN (SELECT 
					RESTAURANT_ID, 
                    MENU_ID,
                    COUNT(*) AS ORDER_COUNT, 
                    SUM(TOTAL_PRICE) AS ORDER_TOTAL_PRICE 
				FROM
					ORDERS 
				GROUP BY
					RESTAURANT_ID,
                    MENU_ID) OG ON (OG.RESTAURANT_ID = MN.RESTAURANT_ID AND OG.MENU_ID = MN.ID); -- 가게와 메뉴별로의 [주문횟수와 총 금액]
                    
-- SELECT에서의 서브쿼리 (스칼라 서브쿼리)
SELECT * FROM MENUS MN LEFT JOIN RESTAURANTS RST ON RST.ID = MN.RESTAURANT_ID; -- 메뉴에서 가게 ID로 가게이름을 알고 싶을 때
SELECT *, (SELECT `NAME` FROM RESTAURANTS WHERE ID = RESTAURANT_ID) AS RESTAURANT_NAME FROM MENUS;

SELECT 
	ID, -- 메뉴의 아이디
    restaurant_ID, -- ID를 가지고 조건 검사 -- FROM 레스토랑의 아이디
    NAME,
    PRICE, 
    (SELECT `NAME` FROM RESTAURANTS WHERE ID = RESTAURANT_ID) AS RESTAURANT_NAME 
FROM 
	MENUS; -- 레스토랑 ID만 존재하기 때문에 이름을 가지고 오는 것
    
SELECT
	NAME,
    PRICE,
    (SELECT ROUND(AVG(PRICE)) FROM MENUS) AS AVG_PRICE,
	PRICE - (SELECT ROUND(AVG(PRICE)) FROM MENUS) AS 평균과의차이,
    CASE
		WHEN PRICE > (SELECT ROUND(AVG(PRICE)) FROM MENUS) THEN '평균초과'
        ELSE '평균이하'
	END AS 등급
FROM
	MENUS;
    
-- EXISTS/NOT EXISTS : 존재 >> 결과가 1행이상이면 TRUE/ 0행이면 TRUE >> 실제 값 아닌 존재 여부만 확인 >> 빠름 
SELECT 
	* 
FROM 
	RESTAURANTS RST
WHERE 
	EXISTS (SELECT 1 FROM ORDERS OD WHERE OD.RESTAURANT_ID = RST.ID ); -- 9건

SELECT 
	* 
FROM 
	RESTAURANTS RST
WHERE 
	EXISTS (SELECT 1 FROM ORDERS OD WHERE OD.RESTAURANT_ID = 4 ); -- 4번 레스토랑 경우에는 주문이 없다, 존재하지않음 ,1이 안나옴

SELECT 
	* 
FROM 
	RESTAURANTS RST
WHERE 
	NOT EXISTS (SELECT 1 FROM ORDERS OD WHERE OD.RESTAURANT_ID = RST.ID ); -- 1건 >> 4번 레스토랑 

-- UNION : 더하기 : 합집합 - 중복 제거 
SELECT '김준일', '부산동래구', 33 -- ,34 이거 안됨 
UNION 
SELECT '김준이', '부산진구', '서른넷'
UNION 
SELECT '부산남구','김준삼', 35; -- 순서는 상관없는데 열 갯수는 같아야함 

-- UNION ALL - 중복 포함
SELECT '김준일', 33
UNION ALL 
SELECT '김준일', 33
UNION ALL
SELECT '김준이', 34;

-- UNION 으로 하면 [김준일 33] 이 하나만 나옴
SELECT '김준일', 33
UNION  
SELECT '김준일', 33
UNION 
SELECT '김준이', 34;

SELECT '김준일' AS 이름 , 33 AS 나이
UNION  
SELECT '김준일', 33
UNION ALL
SELECT '김준이', 34;

SELECT 1 AS ID, '일' AS DAY_OF_WEEK
UNION SELECT 2, '월' 
UNION SELECT 3, '화' 
UNION SELECT 4, '수' 
UNION SELECT 5, '목' 
UNION SELECT 6, '금' 
UNION SELECT 7, '토';

SELECT *
FROM
	(SELECT 1 AS ID, '일' AS DAY_OF_WEEK
	UNION SELECT 2, '월' 
	UNION SELECT 3, '화' 
	UNION SELECT 4, '수' 
	UNION SELECT 5, '목' 
	UNION SELECT 6, '금' 
	UNION SELECT 7, '토') WEEK_TABLE
WHERE
	ID IN (3,4,5);

-- 성능이 중요하면 UNION ALL 중복이 없다고 확신될 때 >> 중복검사가 없으니까 빠르겠죠?

SELECT 
	ID,
    CATEGORY
FROM
	RESTAURANTS 
UNION ALL
SELECT
	ID,
    NAME
FROM 
	MENUS
ORDER BY
	ID; -- 다른 테이블이더라도 열만 맞춰주면 새로운 테이블 생성가능
    
-- 서브 쿼리 VS JOIN
-- 성능적으로는 JOIN이 우수 

WITH MENU AS (SELECT
		MN.ID,
        MN.NAME AS MENU_NAME,
        MN.PRICE,
        RST.NAME AS RESTAURANT_NAME
	FROM
		MENUS MN
		LEFT JOIN RESTAURANTS RST ON RST.ID = MN.RESTAURANT_ID
) -- CTE ( 중간 결고 재사용)

SELECT
	*
FROM
	MENUS;

SELECT
	MENU2.PRICE
FROM
	(SELECT
		MN.ID,
        MN.NAME AS MENU_NAME,
        MN.PRICE,
        RST.NAME AS RESTAURANT_NAME
	FROM
		MENUS MN
		LEFT JOIN RESTAURANTS RST ON RST.ID = MN.RESTAURANT_ID) AS MENU2;

        




