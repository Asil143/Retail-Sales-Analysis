CREATE DATABASE project1;

USE project1;

CREATE TABLE
  retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit DECIMAL(10, 2),
    cogs DECIMAL(10, 2),
    total_sale DECIMAL(12, 2)
  );

-- 1. Customer Behavior Analysis

-- Q1: Identify the Most Loyal Customers (with Most Transactions)
SELECT
  customer_id,
  COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY customer_id
ORDER BY total_transactions DESC
LIMIT 5;

-- Q2: Average Spending by Gender
SELECT
  gender,
  ROUND(AVG(total_sale), 2) AS avg_spending
FROM retail_sales
GROUP BY gender
ORDER BY avg_spending DESC;

-- Q3: High-Value Customers (Customers Who Spend More Than Average)
WITH avg_spending AS (
    SELECT AVG(total_sale) AS avg_sale
    FROM retail_sales
  )
SELECT
  customer_id,
  SUM(total_sale) AS total_spent
FROM retail_sales
GROUP BY customer_id
HAVING total_spent > (
    SELECT avg_sale
    FROM avg_spending
  )
ORDER BY total_spent DESC;

-- 2. Sales Performance Metrics

-- Q4: Best-Selling Category by Revenue
SELECT
  category,
  SUM(total_sale) AS total_revenue
FROM retail_sales
GROUP BY category
ORDER BY total_revenue DESC
LIMIT 1;

-- Q5: Identify Slow-Moving Categories (Lowest Sales)
SELECT
  category,
  SUM(total_sale) AS total_revenue
FROM retail_sales
GROUP BY category
ORDER BY total_revenue ASC
LIMIT 3;

-- Q6: Monthly Sales Trend (Total and Average Sales Per Month)
SELECT
  YEAR(sale_date) AS year,
  MONTH(sale_date) AS month,
  SUM(total_sale) AS total_sales,
  ROUND(AVG(total_sale), 2) AS avg_sales
FROM retail_sales
GROUP BY
  year,
  month
ORDER BY
  year,
  month;

-- 3. Trend Identification

-- Q7: Find Peak Sales Hours (Most Active Time for Purchases)
SELECT
  HOUR(sale_time) AS hour_of_day,
  COUNT(*) AS total_orders
FROM retail_sales
GROUP BY hour_of_day
ORDER BY total_orders DESC
LIMIT 3;

-- Q8: Customer Retention - Repeat Buyers
SELECT
  customer_id,
  COUNT(*) AS purchase_count
FROM retail_sales
GROUP BY customer_id
HAVING purchase_count > 1
ORDER BY purchase_count DESC;

-- 4. Profitability Insights

-- Q9: Most Profitable Transactions (Highest Margin)
SELECT
  *,
  (total_sale - cogs) AS profit,
  ROUND(((total_sale - cogs) / cogs) * 100, 2) AS profit_margin
FROM retail_sales
ORDER BY profit DESC
LIMIT 5;

-- Q10: Profit by Category
SELECT
  category,
  SUM(total_sale - cogs) AS total_profit,
  ROUND(AVG(total_sale - cogs), 2) AS avg_profit
FROM retail_sales
GROUP BY category
ORDER BY total_profit DESC;

-- Q11: Sales by Time Shifts
WITH hourly_sale AS (
    SELECT
      *,
      CASE
        WHEN HOUR(sale_time) <= 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
      END AS shift
    FROM retail_sales
  )
SELECT
  shift,
  COUNT(*) AS total_orders,
  SUM(total_sale) AS total_revenue
FROM hourly_sale
GROUP BY shift;
