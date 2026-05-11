-- 도서관 데이터 베이스 생성  
CREATE DATABASE LIBRARY_DB
	character SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
    
-- 테이블 생성 
CREATE TABLE AUTHORS (
	ID			int				PRIMARY KEY auto_increment,
    NAME 		VARCHAR(255)	NOT NULL,
    NATIONALITY	VARCHAR(255) 	DEFAULT '한국',
    BIRTH_YEAR 	INT	
);
    
CREATE TABLE CATEGORIES (
	ID			int				primary KEY auto_increment,
    NAME		varchar(255)	NOT NULL UNIQUE,
    DESCRIPTION	varchar(255)
    );
    
INSERT INTO AUTHORS VALUES
	(DEFAULT, '김영하', 			'한국' ,		1968),
	(DEFAULT, '한강', 			'한국' ,		1970),
	(DEFAULT, '무라카미 하루키', 	'일본' ,		1949),
	(DEFAULT, '조지 오웰', 		'영국' ,		1903),
	(DEFAULT, '생텍쥐페리', 		'프랑스' ,	1900);
    
SELECT * FROM AUTHORS;

INSERT INTO categories (name, description) VALUES
('소설',    '국내외 소설 작품'),
('에세이',  '개인 경험과 생각을 담은 글'),
('과학',    '과학 이론 및 교양 과학'),
('역사',    '역사적 사건과 인물'),
('자기계발', '성장과 동기부여 관련');

SELECT * FROM CATEGORIES;

CREATE TABLE BOOKS ( -- AUTHOR 와 CATEGORIES 의 자식 테이블
	ID					int				primary KEY auto_increment,
    TITLE				VARCHAR(255)	NOT NULL,
    AUTHOR_ID			INT,
    CATEGORY_ID			INT,
    ISBN				varchar(255)	UNIQUE,
    PUBLISHED_YEAR		INT,
    TOTAL_COPIES		INT				NOT NULL DEFAULT 1,
    AVAILABLE_COPIES 	int				NOT NULL DEFAULT 1,
    foreign key (AUTHOR_ID) 	REFERENCES AUTHORS(ID) 		ON DELETE SET NULL,
    FOREIGN KEY	(CATEGORY_ID) 	REFERENCES CATEGORIES(ID) 	ON DELETE SET NULL
    );
    
INSERT INTO books (title, author_id, category_id, isbn, published_year, total_copies, available_copies) VALUES
('채식주의자',      2, 1, '9788936434120', 2007, 3, 2),
('알쏭달쏭 나의 삶', 1, 2, '9788954651234', 2019, 2, 1),
('노르웨이의 숲',   3, 1, '9788937460449', 1987, 4, 3),
('1984',           4, 1, '9788937460012', 1949, 3, 3),
('어린 왕자',      5, 1, '9788901000123', 1943, 5, 4),
('작별하지 않는다', 2, 1, '9788936434890', 2021, 2, 0),  -- 재고 0 → 예약 실습용
('호밀밭의 파수꾼', 1, 1, '9788937460555', 1951, 2, 2),
('코스모스',       NULL, 3, '9788983711680', 1980, 2, 2), -- 저자 NULL → LEFT JOIN 실습용
('총균쇠',         NULL, 4, '9791162540355', 1997, 3, 2),
('아주 작은 습관', NULL, 5, '9791162540365', 2019, 4, 4);

SELECT * FROM BOOKS;

CREATE TABLE members ( -- 독립적인 부모 테이블 
    id              INT         	PRIMARY KEY AUTO_INCREMENT,
    name            VARCHAR(255) 	NOT NULL,
    phone           VARCHAR(255) 	UNIQUE,
    email           VARCHAR(255) 	UNIQUE,
    joined_date     DATE        	DEFAULT (CURDATE()),
    membership_type VARCHAR(255) 	DEFAULT ('일반')  -- 일반 / 프리미엄
);

INSERT INTO members (name, phone, email, joined_date, membership_type) VALUES
('김지수', '010-1111-2222', 'jisu@email.com',    '2025-01-10', '프리미엄'),
('이민준', '010-3333-4444', 'minjun@email.com',  '2025-02-15', '일반'),
('박서연', '010-5555-6666', 'seoyeon@email.com', '2025-03-20', '일반'),
('최준혁', '010-7777-8888', 'junhyeok@email.com','2025-04-05', '프리미엄'),
('정하은', '010-9999-0000', 'haeun@email.com',   '2025-06-01', '일반'),
('강도윤', '010-2222-3333', 'doyun@email.com',   '2025-08-10', '일반'),
('윤수아', '010-4444-5555', 'sua@email.com',     '2025-09-01', '일반'),   -- 대출 없음
('임태양', '010-6666-7777', 'taeyang@email.com', '2025-10-15', '일반');   -- 대출 없음

SELECT * FROM MEMBERS;

CREATE TABLE rentals ( -- BOOKS 와 MEMBERS의 자식 테이블
    id          INT         PRIMARY KEY AUTO_INCREMENT,
    book_id     INT         NOT NULL,
    member_id   INT         NOT NULL,
    rented_at   DATE        DEFAULT (CURDATE()), 
    due_date    DATE        NOT NULL,
    returned_at DATE,                            -- NULL = 아직 반납 안 함
    status      VARCHAR(255) DEFAULT '대출중',    -- 대출중 / 반납완료 / 연체
    FOREIGN KEY (book_id)   REFERENCES books(id),
    FOREIGN KEY (member_id) REFERENCES members(id)
); 

INSERT INTO rentals (book_id, member_id, rented_at, due_date, returned_at, status) VALUES
(1,  1, '2026-02-01', '2026-02-15', '2026-02-14', '반납완료'),
(2,  1, '2026-03-01', '2026-03-15', '2026-03-20', '연체'),
(3,  2, '2026-03-10', '2026-03-24', '2026-03-23', '반납완료'),
(4,  2, '2026-04-01', '2026-04-15', NULL,          '대출중'),
(5,  3, '2026-04-05', '2026-04-19', '2026-04-18', '반납완료'),
(6,  3, '2026-04-10', '2026-04-24', NULL,          '대출중'),
(7,  4, '2026-04-15', '2026-04-29', NULL,          '대출중'),
(1,  4, '2026-04-20', '2026-05-04', '2026-05-03', '반납완료'),
(3,  5, '2026-05-01', '2026-05-15', NULL,          '대출중'),
(8,  5, '2026-05-02', '2026-05-16', NULL,          '대출중'),
(9,  1, '2026-05-03', '2026-05-17', NULL,          '대출중'),
(10, 2, '2026-05-04', '2026-05-18', NULL,          '대출중'),
(2,  3, '2026-05-05', '2026-05-19', NULL,          '대출중'),
(5,  4, '2026-03-15', '2026-03-29', '2026-04-05', '연체'),
(4,  5, '2026-04-25', '2026-05-09', '2026-05-08', '반납완료');

SELECT * FROM RENTALS;

CREATE table RESERVATIONS (
	ID				INT				PRIMARY KEY auto_increment,
    BOOK_ID			INT				NOT NULL,
    MEMBER_ID		INT				NOT NULL,
    RESERVED_AT 	DATETIME		DEFAULT CURRENT_TIMESTAMP,
    STATUS			varchar(255) 	DEFAULT '대기중', -- 대기중 / 확정 / 취소
    FOREIGN KEY (BOOK_ID) 	references BOOKS(ID),
    FOREIGN KEY	(MEMBER_ID) references MEMBERS(ID)
);

INSERT INTO reservations (book_id, member_id, reserved_at, status) VALUES
(6, 1, '2026-05-08 10:00:00', '대기중'),
(6, 2, '2026-05-08 11:00:00', '대기중'),
(4, 3, '2026-05-09 09:00:00', '대기중'),
(1, 5, '2026-05-10 14:00:00', '확정'),
(3, 6, '2026-05-10 15:00:00', '취소');

SELECT * FROM RESERVATIONS;

SELECT 
	RT.BOOK_ID,
    B.TITLE,
    MB.NAME,
    RT.MEMBER_ID,
	DATEDIFF(CURDATE(), RT.DUE_DATE) AS 연체일수
FROM 
	RENTALS RT
	LEFT JOIN BOOKS B ON B.ID = RT.BOOK_ID
	LEFT JOIN MEMBERS MB ON MB.ID = RT.MEMBER_ID
WHERE
	STATUS = '연체';
    
-- 장르별 도서수
SELECT
	C.ID, 
    C.NAME,
    COUNT(*) AS 도서수 
FROM
	CATEGORIES C
    LEFT JOIN BOOKS B ON B.CATEGORY_ID = C.ID
GROUP BY 
	C.ID, 
	C.NAME
ORDER BY 
	C.ID ;
    
-- 한 번도 렌탈 된적 없는 
SELECT	
	*
FROM
	MEMBERS MB
    LEFT JOIN RENTALS R ON R.MEMBER_ID = MB.ID
WHERE 
	R.ID IS NULL;
    
CREATE VIEW V_RENTAL_STATUS AS
select
	R.ID,
    R.BOOK_ID,
    B.TITLE,
    R.MEMBER_ID,
    M.NAME,
    DATEDIFF(curdate(),R.DUE_DATE) AS 연체일수,
    R.STATUS
FROM
	RENTALS R 
    LEFT JOIN BOOKS B ON B.ID = R.BOOK_ID
    LEFT JOIN MEMBERS M ON M.ID = R.MEMBER_ID;
    
SELECT 
	* 
FROM 
	v_rental_status VRS
    LEFT JOIN MEMBERS M ON M.ID = VRS.MEMBER_ID
WHERE
	VRS.NAME = '김지수';
    
-- 멤버별로 연체 횟수 

SELECT 	
	M.ID,
    M.NAME,
    COUNT(IF(VRS.STATUS = '연체', '연체', NULL))
FROM
	members M
    LEFT JOIN v_rental_status VRS ON VRS.MEMBER_ID = M.ID
GROUP BY
	M.ID,
    M.NAME;

SELECT
	*,
    IF(STATUS = '연체', '연체', NULL)
from
	v_rental_status;
    
explain SELECT * FROM RENTALS WHERE MEMBER_ID = 1;

CREATE USER 'LIBRARIAN'@'LOCALHOST'
	IDENTIFIED BY 'LIB2026!';
GRANT SELECT ON library_db.* TO 'LIBRARIAN'@'LOCALHOST';
GRANT ALL PRIVILEGES ON library_db.* TO 'LIBRARIAN'@'LOCALHOST';

SELECT * FROM MYSQL.USER;

SELECT '도서수'    AS 항목, COUNT(*) AS 건수 FROM books
UNION ALL
SELECT '회원수',            COUNT(*)        FROM members
UNION ALL
SELECT '대출수',            COUNT(*)        FROM rentals
UNION ALL
SELECT '예약수',            COUNT(*)        FROM reservations
UNION ALL
SELECT '현재대출중',        COUNT(*)        FROM rentals WHERE status = '대출중'
UNION ALL
SELECT '연체건수',          COUNT(*)        FROM rentals WHERE status = '연체';