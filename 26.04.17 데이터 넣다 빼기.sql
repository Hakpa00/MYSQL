create database `hanip_delivery`;
create database `hanip_delivery2`;
drop database `hanip_delivery2`;
show databases;
create table restaurants (
id int,
name varchar(50),
category varchar(20),
address varchar(100),
rating decimal(2,1) 
);
use hanip_delivery;
show tables;
desc restaurants;
drop table restaurants;

create table restaurants (
id int primary key auto_increment,
name varchar(50),
category varchar(20)
);
insert into restaurants (name, category)
values ('부산명가', '한식');
insert into restaurants (name, category)
values ('해운대통닭','치킨');
insert into restaurants (id, name)
values (1, '부산명가');
INSERT INTO RESTAURANTS (NAME, CATEGORY)
VALUES ('수변최고돼지국밥', '한식');
INSERT INTO RESTAURANTS (NAME, CATEGORY)
VALUES ('테스트가게','컴퓨터');
DESC RESTAURANTS;
SELECT * FROM restaurants;

CREATE TABLE CUSTOMERS (
ID INT PRIMARY KEY AUTO_INCREMENT,
NAME VARCHAR(30) NOT NULL,
PHONE VARCHAR(20) UNIQUE
);
INSERT INTO CUSTOMERS (ID,NAME,PHONE)
VALUES (DEFAULT,'홍길동','010-1234-5671');
SELECT * FROM CUSTOMERS WHERE PHONE = '010-1234-5678';
DROP TABLE RESTAURANTS;

CREATE TABLE RESTAURANTS (
ID INT PRIMARY KEY AUTO_INCREMENT,
NAME VARCHAR(50) NOT NULL,
CATEGORY VARCHAR(20) NOT NULL,
RATING DECIMAL(2,1) DEFAULT 0.0
 CHECK (RATING >= 0.0 AND RATING <= 5.0),
 PRICE INT CHECK (PRICE > 0)
 );
 INSERT INTO RESTAURANTS (NAME, CATEGORY, RATING)
 VALUES('맛집A','한식',4.5);
 INSERT INTO RESTAURANTS (NAME, CATEGORY, RATING)
 VALUES('맛집B','치킨',9.9);
 INSERT INTO RESTAURANTS (NAME, CATEGORY)
 VALUES('맛집C','중식');
 SELECT * FROM restaurants;
 DROP TABLE restaurants;
 DROP TABLE CUSTOMERS;
 
CREATE TABLE restaurants (
    id               INT          PRIMARY KEY AUTO_INCREMENT,
    name             VARCHAR(50)  NOT NULL,
    category         VARCHAR(20)  NOT NULL,
    address          VARCHAR(100),
    rating           DECIMAL(2,1) DEFAULT 0.0,
    created_at       TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
);

-- 주석 
-- CATEGORY를 CATEGORIES 로 이름 변경
-- ALTER는 DDL에서 C,D,A에서 수정 

ALTER TABLE RESTAURANTS 
RENAME COLUMN CATEGORY TO CATEGORIES;
DESC restaurants;

-- PHONE 가게전화번호를 문자열(255) NOT NULL UNIQUE 추가 >> ADD

ALTER TABLE restaurants
ADD COLUMN PHONE VARCHAR(255) NOT NULL UNIQUE;
DESC restaurants;

-- MODIFY 기존 CATEGORY로 다시 이름을 다시 변경하고 CATEGORY의 문자열 크기를 255로 늘린다. 또 DEFAULT은 '기타'로 

ALTER TABLE restaurants
RENAME column CATEGORIES TO CATEGORY;
DESC restaurants;
ALTER TABLE restaurants
MODIFY COLUMN CATEGORY VARCHAR(255) DEFAULT '기타';
DESC restaurants;

-- PK는 NOT NULL이 세트임 CHECK 유효성 검사 restaurants

DESC restaurants;

-- INSERT(데이터 삽입) => CREATE
-- NAME 같은 단어는 이미 MTSQL에서 사용중인 단어 --> 예약어
-- [단건 삽입]

INSERT into `hanip_delivery`.`restaurants` (`ID`,`NAME`,`CATEGORY`,`ADDRESS`,`RATING`,`CREATED_AT`)
VALUES (DEFAULT, '해운대불고기', '한식', '부산 해운대구', 4.2, DEFAULT);

INSERT into hanip_delivery.restaurants (ID,NAME,CATEGORY,ADDRESS,RATING,CREATED_AT)
VALUES (DEFAULT, '해운대불고기', '한식', '부산 해운대구', 4.2, DEFAULT);

INSERT into hanip_delivery.restaurants 
VALUES (DEFAULT, '해운대불고기', '한식', '부산 해운대구', 4.2, DEFAULT);

INSERT into restaurants (ID,NAME,CATEGORY,ADDRESS,RATING,CREATED_AT)
VALUES (DEFAULT,'한식', '해운대불고기', '부산 해운대구', 4.2, DEFAULT);

INSERT into restaurants (NAME,CATEGORY,ADDRESS,RATING)
VALUES ('해운대불고기', '한식', '부산 해운대구', 4.2);

-- [다건 삽입], CTRL D = 복사,라인카피

INSERT into restaurants (NAME,CATEGORY,ADDRESS,RATING)
VALUES 
	('해운대불고기', '한식', '부산 해운대구', 4.2),
	('해운대불고기', '한식', '부산 해운대구', 4.2),
	('해운대불고기', '한식', '부산 해운대구', 4.2),
	('해운대불고기', '한식', '부산 해운대구', 4.2);

INSERT into restaurants
VALUES 
	(DEFAULT,'해운대불고기', '한식', '부산 해운대구', 4.2, DEFAULT),
	(DEFAULT,'해운대불고기', '한식', '부산 해운대구', 4.2, DEFAULT),
	(DEFAULT,'해운대불고기', '한식', '부산 해운대구', 4.2, DEFAULT),
	(DEFAULT,'해운대불고기', '한식', '부산 해운대구', 4.2, DEFAULT);
    
-- SELECT(데이터를 표에 표현) 컬럼명 FROM 테이블 WHERE 조건 
-- AS 알리아스 
SELECT '박정우' AS `이름` ;
SELECT '박정우' AS 이름, '부산' AS 주소;
SELECT 
	'박정우' AS 이름, 
	'부산' AS 주소;
    
SELECT 
	10 + 20 AS SUM,
	ADDRESS AS 주소, 
    NAME AS 가게명, 
    CATEGORY AS 분류
FROM
	RESTAURANTS;
    
SELECT
	* -- (포함되는) 모든것
FROM
    RESTAURANTS;
    
SELECT -- 3
	*
FROM -- 1
	restaurants
WHERE -- (위치를 찾는)조건 -- 2 -- 조건에 맞는 행만 꺼내옴 
	name = '한식';

-- LIKE (와일드카드) % 뭐든 가능 _ 딱 한글자 

SELECT
	*
FROM
	restaurants
WHERE
	NAME LIKE '_%식';
    
-- NOT>AND>OR (괄호)로 잘 묶어야함, 안 묶으면 AND가 OR보다 먼저 계산 되겠지?
-- ORDER BY 순서 정렬 ASC-오름차순-기본값임 생략가능 / DESC-내림차순 
-- 다중 정렬 (카테고리순 - 같으면 평점 내림차순)
-- 	SELECT * FROM restaurants order by CATEGORY ASC, RATING DESC;
-- LIMIT + OFFSET - LIMIT N OFFSET M = 앞에서 M개 건너뛰고 N개 가져오기

truncate restaurants;
INSERT INTO restaurants (name, category, address, rating) VALUES
('한판삼겹살', '한식', '부산시 해운대구 중동 123-1', 4.5),
('도쿄라멘', '일식', '서울시 마포구 홍대입구 45-2', 4.2),
('상하이 딤섬', '중식', '서울시 중구 명동 88-3', 4.0),
('나폴리 피자', '양식', '서울시 강남구 역삼동 210-5', 4.7),
('부산 밀면본가', '한식', '부산시 부산진구 서면 77-8', 4.3),
('스시 하나', '일식', '서울시 용산구 이태원 32-1', 4.6),
('광동 차이나', '중식', '인천시 중구 차이나타운 15-9', 3.8),
('로마의 휴일', '양식', '서울시 서초구 반포동 56-4', 4.1),
('전주비빔밥', '한식', '전주시 완산구 풍남동 99-2', 4.8),
('교토 우동', '일식', '부산시 수영구 민락동 43-7', 4.0),
('베이징 훠궈', '중식', '서울시 영등포구 여의도 28-6', 4.4),
('파리 브런치', '양식', '서울시 마포구 연남동 67-3', 4.2),
('순천만 낙지집', '한식', '광주시 동구 충장로 11-5', 4.5),
('삿포로 스시', '일식', '서울시 강남구 청담동 89-1', 4.7),
('사천 마라탕', '중식', '서울시 관악구 봉천동 34-2', 4.1),
('뉴욕 버거', '양식', '서울시 종로구 인사동 55-9', 3.9),
('경복궁 설렁탕', '한식', '서울시 종로구 삼청동 20-4', 4.6),
('오사카 타코야키', '일식', '부산시 중구 남포동 76-3', 4.3),
('홍콩 완탕면', '중식', '서울시 강서구 화곡동 48-7', 3.7),
('리스본 파스타', '양식', '서울시 송파구 잠실동 101-2', 4.5),
('강릉 초당순두부', '한식', '강릉시 초당동 8-3', 4.9),
('규슈 라멘', '일식', '서울시 마포구 상암동 62-5', 4.4),
('양자강 짬뽕', '중식', '부산시 동래구 온천동 37-1', 4.0),
('바르셀로나 타파스', '양식', '서울시 용산구 한남동 93-8', 4.3),
('진주 냉면', '한식', '경남 진주시 중앙시장 14-6', 4.7),
('하카타 돈코츠', '일식', '서울시 강동구 천호동 29-4', 4.2),
('장가계 양꼬치', '중식', '서울시 구로구 대림동 58-2', 4.1),
('밀라노 리조또', '양식', '서울시 성동구 성수동 77-9', 4.6),
('제주 흑돼지', '한식', '제주시 이도동 5-1', 4.8),
('나고야 히쓰마부시', '일식', '서울시 강남구 논현동 41-3', 4.5),
('청두 마파두부', '중식', '서울시 서대문구 연희동 66-7', 3.9),
('런던 피시앤칩스', '양식', '서울시 중구 을지로 83-5', 3.8),
('안동 찜닭', '한식', '경북 안동시 구시장 22-8', 4.6),
('후쿠오카 모츠나베', '일식', '부산시 해운대구 좌동 51-2', 4.3),
('심양 군만두', '중식', '서울시 중랑구 면목동 39-6', 4.0),
('그리스 무사카', '양식', '서울시 마포구 망원동 74-1', 4.4),
('통영 굴밥', '한식', '경남 통영시 중앙동 3-9', 4.9),
('삼보 덮밥', '일식', '서울시 동작구 노량진 88-4', 4.1),
('광저우 딤섬', '중식', '인천시 남동구 구월동 17-3', 3.8),
('포르투갈 해산물', '양식', '서울시 강남구 압구정 95-6', 4.5),
('춘천 닭갈비', '한식', '강원 춘천시 명동 61-2', 4.7),
('요코하마 야키니쿠', '일식', '서울시 강북구 수유동 46-8', 4.2),
('상해 탕수육', '중식', '부산시 남구 대연동 30-5', 4.3),
('터키 케밥', '양식', '서울시 종로구 창신동 12-7', 4.0),
('목포 세발낙지', '한식', '전남 목포시 원도심 7-4', 4.8),
('도쿄 가쓰동', '일식', '서울시 노원구 상계동 53-1', 4.1),
('충칭 훠궈', '중식', '서울시 광진구 건대입구 68-9', 4.4),
('스페인 파에야', '양식', '서울시 서초구 방배동 84-3', 4.6),
('대구 뭉티기', '한식', '대구시 중구 동성로 19-2', 4.5),
('오키나와 소키소바', '일식', '서울시 영등포구 당산동 72-6', 4.0);

SELECT * FROM RESTAURANTS;

SET @V_LIMIT = 3;
SET @V_PAGE = 3;
SET @V_OFFSET = (@V_PAGE - 1) * @V_LIMIT; -- 페이지 번호에 대한 공식 @=변수 

SELECT 3 INTO V_LIMIT;

SELECT
	*
FROM
	RESTAURANTS
WHERE
	ADDRESS LIKE '부산시%' AND RATING >= 4.3  -- 부산시이면서 4.3 이상
    OR ADDRESS LIKE '%반포동%' AND RATING <= 4.3 ;  -- 또는 반포동, 평점이 4.3 이하 인것
    
SELECT
	*
FROM
	RESTAURANTS
WHERE
	(ADDRESS LIKE '부산시%' OR ADDRESS LIKE '서울시%') AND RATING >= 4.3  -- 부산이나 서울이면서 4.3 이상
order by 	
	CATEGORY ASC,
	RATING DESC -- CATEGORY 오름차순, RATING 내림차순
limit 3
OFFSET 0; -- LIMIT 의 배수만큼 1,2,3 페이지
    

SET @SQL = '
	SELECT
		*
	FROM
		RESTAURANTS
	WHERE
		(ADDRESS LIKE ''부산시%'' OR ADDRESS LIKE ''서울시%'') AND RATING >= 4.3  
	order by 	
		CATEGORY ASC,
		RATING DESC 
	limit ?
	OFFSET ?;	
';

PREPARE STMT FROM @SQL; -- STMT = ?
EXECUTE STMT USING @V_LIMIT, @V_OFFSET;

-- UPDATE - WHERE 이 있어야 안전함 >> 범위 특정 - 아니면 그냥 싹다 바뀌어버림
-- SET SQL_SAFE_UPDATES =1/0 WHERE - 무조건 들어가게 켜기 끄기, PRIMARY KEY 로만

UPDATE RESTAURANTS
SET RATING = 4.6
WHERE ID = '6';

-- DELETE 는 행 삭제 - 애도 WHERE이 중요  AUTO INCREMENT 유지, 조건 가능 
-- FROM WHERE SELECT 


   
   
	

    

    
