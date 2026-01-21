CREATE DATABASE PROJ1;
USE PROJ1;
DROP TABLE IF EXISTS Zepto_Rix;

#Count All The Row's
SELECT COUNT(*)
FROM zepto_v2;


-- --Sample Data
SELECT * FROM zepto_v2


-- Checking null value
SELECT *
FROM zepto_v2
WHERE category IS NULL
   OR name IS NULL
   OR mrp IS NULL
   OR discountPercent IS NULL
   OR availableQuantity IS NULL
   OR discountedSellingPrice IS NULL
   OR weightInGms IS NULL
   OR outOfStock IS NULL
   OR quantity IS NULL;
   
   
--    Different Product Categories
SELECT DISTINCT category
FROM zepto_v2
ORDER BY category;

-- How Many product are inStock 
SELECT outOfStock, COUNT(*) AS total_products
FROM zepto_v2
GROUP BY outOfStock
ORDER BY outOfStock;

-- Product's name that come's multiple Time:
SELECT name, COUNT(*) AS product_count
FROM zepto_v2
GROUP BY name
HAVING COUNT(*) > 1
ORDER BY product_count DESC;


#Data Cleaning Step's ------

-- product with price = Zero
576
WHERE mrp = 0 or discountedSellingPrice = 0;

-- Delete the unsual data
DELETE FROM zepto_v2
WHERE mrp = 0


-- Converting paise to rupee's
UPDATE zepto_v2
SET mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;


-- Check Those updated Col

SELECT mrp, discountedSellingPrice 
From zepto_v2


# -- Business Inshight's Question-- #

Q1. Find the top 10 best-value products based on the discount percentage.
SELECT name,
       category,
       MAX(mrp) AS mrp,
       MAX(discountPercent) AS discountPercent
FROM zepto_v2
GROUP BY name, category
ORDER BY discountPercent DESC
LIMIT 10;


Q2. What are the products with high MRP but out of stock

SELECT DISTINCT name, mrp
FROM zepto_v2
WHERE outOfStock = TRUE
  AND mrp > 300
ORDER BY mrp DESC;
Q3. Calculate estimated revenue for each category
SELECT category,
       SUM(discountedSellingPrice * quantity) AS estimated_revenue
FROM zepto_v2
GROUP BY category
ORDER BY estimated_revenue DESC;
Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%
SELECT name,
       category,
       mrp,
       discountPercent
FROM zepto_v2
WHERE mrp > 500
  AND discountPercent < 10
ORDER BY mrp DESC;

select * from zepto_v2

Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT category,
       AVG(discountPercent) AS avg_discount
FROM zepto_v2
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

`You cannot use a column name in ORDER BY if it’s an aggregate without an alias`

Q6. Find the price per gram for products above 100g and sort by best value

SELECT name,
       category,
       weightInGms,
       discountedSellingPrice,
       discountedSellingPrice / weightInGms AS price_per_gram
FROM zepto_v2
WHERE weightInGms > 100
ORDER BY price_per_gram ASC;


Q7. Group the products into categories like Low, Medium, Bulk

SELECT name,
       category,
       weightInGms,
       CASE
           WHEN weightInGms < 250 THEN 'Low'
           WHEN weightInGms BETWEEN 250 AND 1000 THEN 'Medium'
           ELSE 'Bulk'
       END AS size_category
FROM zepto_v2;

SELECT name,
		category,
        weightInGms,
        CASE
			WHEN 	weightInGms < 250 THEN "Bik Nhi Rha"
            WHEN weightInGms BETWEEN 250 AND 1000 THEN "THIK THAK BIK RHA"
            ELSE "PEL K BIK RHA"
		END AS KITNA_BIK_RHA
	FROM zepto_v2
Q8. What is the total inventory weight per category

SELECT category,
SUM(weightInGms) / 1000.0 as Total_weight
FROM Zepto_v2
GROUP BY category
ORDER BY Total_weight
