SELECT *
FROM sales;
-- Data Manipulation or Data Analysis;
/*-- PART 1 Total Sale Analysis - 
a)Calculate the total sales for each respective month? */

SELECT CONCAT(ROUND(SUM(transaction_qty * unit_price))/1000,'K') AS total_sales
FROM sales
WHERE MONTH(transaction_date) = 3 ;-- Filter for month 

-- b) Determine the month on month increase or decrease on sales

SELECT MONTH(transaction_date) AS month ,
	ROUND(SUM(transaction_qty * unit_price),2) AS total_sales ,
    (SUM(transaction_qty * unit_price) - LAG(SUM(transaction_qty * unit_price),1) OVER(ORDER BY MONTH(transaction_date)))
	/ LAG(SUM(transaction_qty * unit_price),1) OVER(ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM sales
WHERE MONTH(transaction_date) IN (4,5)
GROUP BY MONTH(transaction_date)
ORDER BY MONTH(transaction_date);

-- c) Calculate the difference in sales between the selected month and the previois month..
SELECT MONTH(transaction_date) AS month,
ROUND(SUM(transaction_qty * unit_price),2) AS total_sales ,
(SUM(transaction_qty * unit_price) - LAG(SUM(transaction_qty * unit_price),1) OVER(ORDER BY MONTH(transaction_date))) AS sales_diff_pm
FROM sales
WHERE MONTH(transaction_date) IN (4,5)
GROUP BY 1;

-- Part 2 Total order analysis
-- a)calculate the total number of orders for each respective month?
SELECT COUNT(transaction_id) AS total_number_order ,
MONTH(transaction_date) AS month 
FROM sales
WHERE MONTH(transaction_date) = 2;

-- b)Determine the month on month increase or decrease in the number of orders ?
SELECT COUNT(transaction_id) AS num_order ,
MONTH(transaction_date) AS month ,
(COUNT(transaction_id) - LAG((transaction_id),1) OVER(ORDER BY MONTH(transaction_date)))
/ LAG((transaction_id),1) OVER(ORDER BY MONTH(transaction_date)) * 100 AS per_inc_dec
FROM sales
WHERE MONTH(transaction_date) IN (2,3)
GROUP BY MONTH(transaction_date) ;

-- c) Calculate the difference the number of orders between the selected month and previous month?
SELECT COUNT(transaction_id) AS num_order ,
MONTH(transaction_date) AS month ,
(COUNT(transaction_id) - LAG((transaction_id),1) OVER(ORDER BY MONTH(transaction_date))) as quantity_diff_pm
FROM sales
WHERE MONTH(transaction_date) IN (2,3)
GROUP BY MONTH(transaction_date) ;

-- Part 3 Total quantity sold analysis
-- a)Calculate the total quantity sold for each respective month ?

SELECT SUM(transaction_qty) AS total_quantity , 
MONTH(transaction_date) AS month 
FROM  sales 
WHERE MONTH(transaction_date ) = 2;

-- b) What are the top product quantity sold item ?
SELECT COUNT(transaction_qty) AS total_quantity , product_category,
RANK() OVER(ORDER BY COUNT(transaction_qty) DESC) AS sold_product_rank
FROM sales
GROUP BY product_category; 
-- c) Product popularity across store_location
WITH popular_product AS
(
SELECT  store_location , 
product_category,
SUM(transaction_qty) AS quantity_sold ,
RANK() OVER(PARTITION BY store_location ORDER BY SUM(transaction_qty) DESC ) AS top_product_by_location
FROM sales
GROUP BY store_location , product_category
)
SELECT *
FROM popular_product
WHERE top_product_by_location =1; -- Number 1 product across all the store
-- d) Sales analysis by product catagory

SELECT product_category ,
ROUND(SUM(transaction_qty *unit_price),2) AS total_sales
FROM sales
WHERE MONTH(transaction_date) = 5
GROUP BY 1;








-- Part 4 Sales analysis on weekday and weekend 
 -- a) Segment sales data into weekday and weekend to analysize performance variation
 SELECT 
CASE WHEN DAYOFWEEK(transaction_date) IN (1,7) THEN "Weekends"
ELSE 'Weekday' 
END AS day_type ,
ROUND(SUM(transaction_qty * unit_price),1) AS total_sales
FROM sales 
WHERE MONTH(transaction_date) = 5
GROUP BY 1;

-- Daily sales analysis with average line
WITH total_sales_per_day AS
(
SELECT ROUND(SUM(transaction_qty * unit_price),2) AS total_sales
FROM sales
WHERE MONTH(transaction_date) = 5
GROUP BY transaction_date
)
SELECT AVG(total_sales)
FROM total_sales_per_day;

SELECT DAY(transaction_date) AS day_of_month , 
ROUND(SUM(transaction_qty * unit_price),2) AS total_sales
FROM sales
WHERE MONTH(transaction_date) = 5
GROUP BY DAY(transaction_date)
ORDER BY DAY(transaction_date) ASC;

-- Compare daily sales with monthly average
WITH daily_vs_avg AS
(
SELECT DAYOFMONTH(transaction_date) AS day_of_month ,
ROUND(SUM(transaction_qty * unit_price),2) AS total_sales ,
AVG(SUM(transaction_qty * unit_price)) OVER() AS avg_sales
FROM sales
GROUP BY 1
)
SELECT day_of_month,
CASE WHEN total_sales > avg_sales THEN 'Above Average'
WHEN total_sales < avg_sales THEN 'Below Average'
ELSE 'Average'
END AS sales_status
FROM daily_vs_avg;
















