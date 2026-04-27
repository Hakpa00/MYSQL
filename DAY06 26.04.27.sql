SELECT * FROM restaurants;
SELECT * FROM MENUS;
SELECT * FROM CUSTOMERS;
SELECT * FROM ORDERS;

-- == INNER JOIN 교집합 == -- 
SELECT 
	*
FROM
	MENUS, restaurants -- 합쳐두고
WHERE
	MENUS.RESTAURANT_ID = RESTAURANTS.ID; -- 합쳐둔걸 필터링
    
SELECT 
	*
FROM
	MENUS JOIN restaurants ON RESTAURANTS.ID = MENUS.RESTAURANT_ID; -- JOIN (합치기) /ON 조건 (WHERE) -- 합칠때 필터링
   
-- ==== --   
SELECT
	*
FROM
	ORDERS JOIN customers ON customerS.ID = ORDERS.CUSTOMER_ID; 
    
SELECT
	*
FROM -- 기준 테이블을 왼쪽, 오른쪽에 붙힐 테이블
	ORDERS, CUSTOMERS -- ORDERS 가  CUSTOMERS를 참조 >> 오더정보를 보고싶음 근데 고객이 id로 돼있어서 누군지 알 수 가 없어서 알고 싶음
WHERE -- 조건은 반대로 왼쪽에 붙힐 테이블 오른쪽에 기준 테이블
	CUSTOMERS.ID = ORDERS.CUSTOMER_ID;
    
SELECT
	*
FROM -- 합쳐진 하나의 테이블로 봐야함
	((ORDERS) 
    JOIN customers ON customerS.ID = ORDERS.CUSTOMER_ID) 
    JOIN RESTAURANTS ON restaurants.ID = ORDERS.RESTAURANT_ID
    JOIN MENUS ON MENUS.ID = ORDERS.MENU_ID;
    
SELECT
	ORDERS.ID,
    ORDERS.CUSTOMER_ID,
    CUSTOMERS.ID,
    CUSTOMERS.NAME,
    ORDERS.RESTAURANT_ID,
    RESTAURANTS.ID,
    RESTAURANTS.NAME
FROM -- 합쳐진 하나의 테이블로 봐야함
	((ORDERS) 
    JOIN customers ON customerS.ID = ORDERS.CUSTOMER_ID) 
    JOIN RESTAURANTS ON restaurants.ID = ORDERS.RESTAURANT_ID
    JOIN MENUS ON MENUS.ID = ORDERS.MENU_ID;   

-- 별칭 AS --
 SELECT 
	ORDERS.ID,
    ORDERS.CUSTOMER_ID,
    CUSTOMERS.ID,
    CUSTOMERS.NAME,
    ORDERS.RESTAURANT_ID,
    RESTAURANTS.ID,
    RESTAURANTS.NAME
FROM 
	ORDERS AS OD -- AS 생략하고 띄어쓰기 하고 해도 가능함, 근데 가시성 때문에 컬럼명은 왠만하면 붙여줌 
    JOIN customers CST ON customerS.ID = ORDERS.CUSTOMER_ID
    JOIN RESTAURANTS RST ON restaurants.ID = ORDERS.RESTAURANT_ID
    JOIN MENUS MN ON MENUS.ID = ORDERS.MENU_ID;      

SELECT 
	OD.ID,
    OD.CUSTOMER_ID,
    CST.ID,
    CST.NAME,
    OD.RESTAURANT_ID,
    RST.ID,
    RST.NAME,
    RST.*
FROM 
	ORDERS OD 
    JOIN customers CST ON CST.ID = OD.CUSTOMER_ID
    JOIN RESTAURANTS RST ON RST.ID = OD.RESTAURANT_ID
    JOIN MENUS MN ON MN.ID = OD.MENU_ID;    
    
-- LEFT JOIN : 기준 테이블의 정보는 빠짐없이 나오고, 오른쪽에 필요한 정보 합치기 
SELECT  
	OD.MENU_ID,
    count(*)
FROM 
	ORDERS OD 
    JOIN customers CST ON CST.ID = OD.CUSTOMER_ID
    JOIN RESTAURANTS RST ON RST.ID = OD.RESTAURANT_ID
    JOIN MENUS MN ON MN.ID = OD.MENU_ID   
GROUP BY
	OD.MENU_ID
ORDER BY
	OD.MENU_ID;
    
SELECT
	*
FROM
	restaurants RST
    INNER JOIN ORDERS OD ON OD.RESTAURANT_ID =RST.ID
ORDER BY
	RST.ID; -- 4번 가게 안나옴 << 주문이 없어서
    
SELECT
	*
FROM
	restaurants RST -- 기준이 음식점
	LEFT JOIN ORDERS OD ON OD.RESTAURANT_ID =RST.ID -- 51건
WHERE
	OD.ID IS NULL -- 4번 가게 특정해서 보고 싶을때
ORDER BY
	RST.ID;
    
SELECT
	*
FROM
	ORDERS OD -- 기준이 오더 -- 50건
	LEFT JOIN restaurants RST ON RST.ID = OD.RESTAURANT_ID;
    
-- 가게별로 총 매출, RESTAURANT_ID,NAME,TOTAL
SELECT
	*
FROM ORDERS;

SELECT
	*
FROM RESTAURANTS;


SELECT
	*
FROM
	RESTAURANTS RST
    LEFT JOIN ORDERS OD ON RST.ID = OD.RESTAURANT_ID;
    
-- SELECT 
	-- sum(TOTAL_PRICE) OF 
    
-- == 정답 == --
-- 가게별로 >> 모든 가게가 나와야함 >> LEFT JOIN

SELECT
	*
FROM
	RESTAURANTS; -- 가게다 나오고 뒤에 총매출 나오면 됨, 카테고리/주소/별점 필요없음 표를 상상

SELECT
	RST.ID,
    RST.NAME,
    OD.* -- 여기서 뭘 뽑아올지 생각
FROM
	RESTAURANTS RST
    LEFT JOIN ORDERS OD ON OD.RESTAURANT_ID = RST.ID;
    
SELECT
	RST.ID,
    RST.NAME,
    ifnull(SUM(OD.TOTAL_PRICE),0) AS TOTAL
FROM
	RESTAURANTS RST
    LEFT JOIN ORDERS OD ON OD.RESTAURANT_ID = RST.ID
GROUP BY -- 값이 제각각인 건 그룹 지을 수 없음 >> TOTAL_PRICE 는 메뉴마다 각각 달라서 그룹 못 지음
	RST.ID,
    RST.NAME
ORDER BY
	TOTAL DESC -- 매출이 높은 순서대로 정렬되어 나타남
LIMIT 3; -- 매출 탑 3

-- == RIGHT JOIN은 LEFT로 대체 가능 == -- >> 기준 위치 반대로
-- == CROSS JOIN >> 전체 조합, SELF JOIN == --
-- JOIN 과 GROUP BY를 잘 조합하여 사용해야함 
-- JOIN / GROUP BY / 집계함수 / ..
-- JOIN 은 KEY 값 끼리 
-- JOIN 왼 오 ON 오 왼 

-- LEFT JOIN 후 COUNT(*) 주의
SELECT
	RST.ID,
    RST.NAME,
    ifnull(SUM(OD.TOTAL_PRICE),0) AS TOTAL,
    COUNT(*) -- 4. 서면 삼겹살 카운트가 1 나옴
FROM
	RESTAURANTS RST
    LEFT JOIN ORDERS OD ON OD.RESTAURANT_ID = RST.ID
GROUP BY 
	RST.ID,
    RST.NAME
ORDER BY
	TOTAL DESC;
    
SELECT
	RST.ID,
    RST.NAME,
    ifnull(SUM(OD.TOTAL_PRICE),0) AS TOTAL,
    COUNT(OD.RESTAURANT_ID) -- 4.서면 삼겹살 카운트 0 으로 똑바로 나옴 
FROM
	RESTAURANTS RST
    LEFT JOIN ORDERS OD ON OD.RESTAURANT_ID = RST.ID
GROUP BY 
	RST.ID,
    RST.NAME
ORDER BY
	TOTAL DESC;
    
-- PPT 따라하기 실습 4문제 꼭 풀어보기
-- INNER 와 LEFT의 차이
-- INNER 는 해당하는 값만
-- LEFT (=LEFT OUTER) 는 빠짐없이 모두


-- 대 AI의 시대 어느정도의 코드의 기본지식이 있어야 검증도 하고 즉 지식이 필요함
-- 명령을 추후에 어떻게 쓸 지에 따라 다르게 내릴 수 도 있음 
-- AI : 클로드 코드 
-- 1. 전체 아키텍쳐 이해
-- 2. 프로그램의 영역은 크게 3가지라 나뉨 [화면/저장소/화면에보내주는영역] >> 프론트엔드/백엔드/데이터베이스
-- 백엔드 <> 데이터베이스, 프론트엔드(IOS,ANDROID) - 웹,앱,PC프로그램,응용소프트웨어 >> 백엔드한테 나 이거 필요해 <> 데이터베이스
-- 응용소프트웨어 - 어디서 돌아걸거임? - 공장소프트웨어 
-- 백엔드 : 다리역할 : REST API - 자바스크립트,자바,파이썬
-- DB 


   


    
    


    
    
    
    
    
  	
   
