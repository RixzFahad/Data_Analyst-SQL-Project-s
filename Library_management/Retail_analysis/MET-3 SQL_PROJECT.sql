Select * FROM retail_sales;-- 
# write a query to cahnge data type of price_per_cap float to int
# write a query to change column sale_date  position at last
SELECT sale_date FROM retail_sales;

ALTER TABLE retail_sales
MODIFY sale_date date
AFTER cogs;

ALTER TABLE retail_sales
MODIFY sale_date date
AFTER transactions_id;

ALTER TABLE retail_sales
CHANGE price_per_unit price_per_unit int;


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'.
SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';
-- CHANGING THE POSITION FOR DATE-- 
ALTER TABLE retail_sales
MODIFY sale_date date
AFTER sale_time;
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022.
SELECT * 
FROM retail_sales
WHERE category = "Clothing"
 and quantity >3 
 and MONTH(sale_date) = 11 
 AND YEAR(sale_date) = 2022;
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category,
SUM(total_sale) AS Total_rev
FROM retail_Sales
GROUP BY category;
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT  AVG(age)
FROM retail_sales
WHERE category = "Beauty";
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * 
FROM retail_sales
WHERE total_sale>1000;
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT category,
gender,
COUNT( DISTINCT transactions_id) AS total_transaction
FROM retail_sales
GROUP BY category, gender;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
SELECT 
	YEAR(sale_date) AS year,
	MONTH(sale_date) AS month,
	AVG(total_sale) AS avg_monthly_sale
FROM retail_sales
GROUP BY YEAR(sale_date), MONTH(sale_date);

-- 2 --

SELECT 
    year,
    month,
    total_sales
FROM (
    SELECT 
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        SUM(total_sale) AS total_sales,
        RANK() OVER (
            PARTITION BY YEAR(sale_date)
            ORDER BY SUM(total_sale) DESC
        ) AS sales_rank
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) t
WHERE sales_rank = 1;

 -- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales.
 SELECT 
 DISTINCT customer_id,
 SUM(total_sale) AS Total_Sales
 FROM retail_Sales
 GROUP BY customer_id
 ORDER BY Total_Sales DESC
 LIMIT 5;
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
	category,
	COUNT(DISTINCT customer_id) AS unique_customer
FROM retail_sales
GROUP BY category;
SELECT
    CASE
        WHEN HOUR(sale_time) <= 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 13 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(transactions_id) AS number_of_orders
FROM retail_sales
GROUP BY shift;





