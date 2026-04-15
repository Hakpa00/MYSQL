create database `hanip_delivery`;
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

--PK는 NOT NULL이 세트임 CHECK 유효성 검사 



