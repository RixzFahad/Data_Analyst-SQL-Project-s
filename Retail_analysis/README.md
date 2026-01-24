# 🛒 Retail Sales SQL Analysis Project

## 📌 Project Overview

This project focuses on analyzing retail sales data using **SQL
(MySQL)** to answer real-world business questions.\
The goal is to demonstrate practical SQL skills such as filtering,
aggregation, grouping, date functions, and window functions.

This project is ideal for **Data Analyst / SQL portfolio** purposes.

------------------------------------------------------------------------

## 🗂️ Dataset Description

The dataset contains retail transaction records with the following key
columns:

-   `transaction_id`
-   `sale_date`
-   `sale_time`
-   `customer_id`
-   `gender`
-   `age`
-   `category`
-   `quantity`
-   `price_per_unit`
-   `total_sale`

------------------------------------------------------------------------

## 🧠 Business Questions Solved

1.  Retrieve all sales made on a specific date\
2.  Transactions in Clothing category with quantity \> 10 (Nov 2022)\
3.  Total sales for each category\
4.  Average age of customers in Beauty category\
5.  Transactions with total sales greater than 1000\
6.  Total transactions by gender and category\
7.  Average monthly sales & best-selling month per year\
8.  Top 5 customers by total sales\
9.  Unique customers per category\
10. Orders by shift (Morning / Afternoon / Evening)

------------------------------------------------------------------------

## 🛠️ SQL Concepts Used

-   `SELECT`, `WHERE`, `GROUP BY`, `ORDER BY`
-   Aggregate functions: `SUM()`, `AVG()`, `COUNT()`
-   `CASE` statements
-   Date & Time functions: `YEAR()`, `MONTH()`, `HOUR()`
-   Window functions: `RANK()`
-   Subqueries

------------------------------------------------------------------------

## 📊 Sample Query

``` sql
SELECT
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;
```

------------------------------------------------------------------------

## 🚀 Tools & Technologies

-   MySQL
-   SQL
-   MySQL Workbench

------------------------------------------------------------------------

## 🎯 Key Learnings

-   Writing optimized SQL queries for business analysis
-   Handling date and time-based analysis
-   Using window functions for ranking problems
-   Translating business questions into SQL logic

------------------------------------------------------------------------

## 📌 Author

**Rixz**\
Aspiring Data Analyst \| SQL \| Power BI \| Data Science

------------------------------------------------------------------------

⭐ If you found this project useful, feel free to star it and connect!
