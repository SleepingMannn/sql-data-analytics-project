/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - Calculate the key business metrics ("big numbers") at the highest level of aggregation.
    - Spot overall trends and anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()

Based on: SQL analytics course by Baraa Khatib Salkini (Data With Baraa).
===============================================================================
*/

-- Total sales
SELECT SUM(sales_amount) AS total_sales FROM gold.fact_sales;

-- Total number of items sold
SELECT SUM(quantity) AS total_quantity FROM gold.fact_sales;

-- Average selling price
SELECT AVG(price) AS avg_price FROM gold.fact_sales

-- Total number of orders
SELECT COUNT(order_number) AS total_orders FROM gold.fact_sales;
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales; -- COUNT(DISTINCT) counts unique orders

-- Total number of products
SELECT COUNT(product_name) AS total_products FROM gold.dim_products;

-- Total number of customers
SELECT COUNT(customer_key) AS total_customers FROM gold.dim_customers;

-- Total number of customers who have placed an order
SELECT COUNT(DISTINCT customer_key) AS total_customers FROM gold.fact_sales;

-- Generate a Report with all key metrics of the business
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Products', COUNT(DISTINCT product_name) FROM gold.dim_products
UNION ALL
SELECT 'Total Customers', COUNT(customer_key) FROM gold.dim_customers;
