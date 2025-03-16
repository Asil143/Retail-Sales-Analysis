# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `project1`

This project is a SQL-based analysis of retail sales data, designed to uncover customer behavior, sales performance, profitability insights, and trends. It includes a database schema for storing transaction data and a collection of analytical queries to extract meaningful business insights.
The goal is to provide actionable insights for a retail business, such as identifying loyal customers, peak sales times, and the most profitable product categories.




## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `project1`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE project1;

CREATE TABLE retail_sales (
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
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Identify the Most Loyal Customers (with Most Transactions)**:
```sql
SELECT customer_id, COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY customer_id
ORDER BY total_transactions DESC
LIMIT 5;
```

2. **Average Spending by Gender**:
```sql
SELECT gender, ROUND(AVG(total_sale), 2) AS avg_spending
FROM retail_sales
GROUP BY gender
ORDER BY avg_spending DESC;
```

3. **High-Value Customers (Customers Who Spend More Than Average).**:
```sql
WITH avg_spending AS (
    SELECT AVG(total_sale) AS avg_sale
    FROM retail_sales
)
SELECT customer_id, SUM(total_sale) AS total_spent
FROM retail_sales
GROUP BY customer_id
HAVING total_spent > (SELECT avg_sale FROM avg_spending)
ORDER BY total_spent DESC;
```

4. **Best-Selling Category by Revenue.**:
```sql
SELECT category, SUM(total_sale) AS total_revenue
FROM retail_sales
GROUP BY category
ORDER BY total_revenue DESC
LIMIT 1;
```

5. **Identify Slow-Moving Categories (Lowest Sales).**:
```sql
SELECT category, SUM(total_sale) AS total_revenue
FROM retail_sales
GROUP BY category
ORDER BY total_revenue ASC
LIMIT 3;
```

6. **Monthly Sales Trend (Total and Average Sales Per Month)**:
```sql
SELECT
    YEAR(sale_date) AS year,
    MONTH(sale_date) AS month,
    SUM(total_sale) AS total_sales,
    ROUND(AVG(total_sale), 2) AS avg_sales
FROM retail_sales
GROUP BY year, month
ORDER BY year, month;
```

7. **Find Peak Sales Hours (Most Active Time for Purchases)**:
```sql
SELECT HOUR(sale_time) AS hour_of_day, COUNT(*) AS total_orders
FROM retail_sales
GROUP BY hour_of_day
ORDER BY total_orders DESC
LIMIT 3;
```

8. **Customer Retention - Repeat Buyers**:
```sql
SELECT customer_id, COUNT(*) AS purchase_count
FROM retail_sales
GROUP BY customer_id
HAVING purchase_count > 1
ORDER BY purchase_count DESC;
```

9. **Most Profitable Transactions (Highest Margin).**:
```sql
SELECT *,
       (total_sale - cogs) AS profit,
       ROUND(((total_sale - cogs) / cogs) * 100, 2) AS profit_margin
FROM retail_sales
ORDER BY profit DESC
LIMIT 5;
```

10. **Profit by Category**:
```sql
SELECT category,
       SUM(total_sale - cogs) AS total_profit,
       ROUND(AVG(total_sale - cogs), 2) AS avg_profit
FROM retail_sales
GROUP BY category
ORDER BY total_profit DESC;
```

## Findings

- **Customer Behavior**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
-                        The top 5 most loyal customers (by transaction count) are identified, showcasing repeat buyers.
                         Female customers tend to have a slightly higher average spending compared to male customers.
                         High-value customers (those spending more than the average) are identified, highlighting potential targets for loyalty programs.
- **Sales Performance**: The best-selling category by revenue provides insights into the most profitable product line.
                         Slow-moving categories are identified to help optimize inventory and marketing efforts.
                         Monthly analysis reveals seasonal sales patterns and average monthly revenue.
- **Trend Identification**: Peak sales hours (most transactions) occur during specific time frames, allowing for better staff allocation and promotions.
                            Repeat buyers are analyzed to evaluate customer retention rates and drive loyalty campaigns.

- **Profitability Insights**: The most profitable transactions are highlighted, identifying which deals yield the highest margins.
                              Category-wise profit analysis reveals which product lines generate the most profit and average margins.
                              Sales by time shifts (morning, afternoon, evening) provide insights into when the business is most profitable.

## Reports

- **Customer Behavior Report**: Identifies loyal customers, average spending by gender, and high-value customers.
- **Sales Performance Report**: Includes best-selling and slow-moving categories along with monthly sales trends.
- **Trend Analysis Report**: Highlights peak sales hours and customer retention through repeat buyer analysis.
- **Profitability Report**: Examines the most profitable transactions, profit by category, and revenue by time shifts.
  
## Conclusion

This project provides a thorough exploration of retail sales using SQL, covering key aspects of data handling such as database creation, data analysis, and business insights. The queries analyze customer behavior, sales performance, trend identification, and profitability, enabling informed business decisions. The findings can assist in optimizing marketing strategies, enhancing customer loyalty, and improving operational efficiency.
