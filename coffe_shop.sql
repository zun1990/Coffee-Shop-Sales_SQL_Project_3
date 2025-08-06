CREATE DATABASE sql_project_5;
USE sql_project_5;
SELECT *
FROM coffe_shop_sales;
-- Data Cleaning 
CREATE TABLE sales
SELECT *
FROM coffe_shop_sales; -- Create a new table to clean and manuplate data and keep the original table intact;

SELECT * FROM sales;
DESCRIBE sales;
-- Change transaction_date column from text to Date type
UPDATE sales
SET transaction_date = STR_TO_DATE(transaction_date, '%Y-%m-%d');
ALTER TABLE sales
MODIFY COLUMN transaction_date DATE;

-- Change transaction_time column from text to Date type

UPDATE sales
SET transaction_time = STR_TO_DATE(transaction_time, '%h:%i:%s %p');
ALTER TABLE sales
MODIFY COLUMN transaction_time TIME;
-- Rename column name 
ALTER TABLE sales
RENAME COLUMN ï»¿transaction_id TO transaction_id;


