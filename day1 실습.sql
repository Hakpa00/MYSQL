DROP DATABASE IF EXISTS hanip_delivery;
CREATE DATABASE hanip_delivery
character set utf8mb4
COLLATE utf8mb4_unicode_ci;
use hanip_delivery;
show databases;
create table delivery_riders (
id int,
name varchar(30),
phone varchar(20),
region varchar(30)
);
desc delivery_riders;
show tables;
create table coupons (
id int,
coupon_code varchar(20),
discount_rate int,
valid_until date
);
Desc coupons;
create table restaurants (
id int,
name varchar(50),
category varchar(20),
rating decimal(2,1)
);
desc restaurants;
create table notice (
id int,
title varchar(10),
created_at Datetime,
cotext text,
author varchar(10)
);
desc notice;


