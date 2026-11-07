/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - Calculate running totals and moving averages of key metrics.
    - Show whether the business is growing or declining over time.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()

Note:
    - DATETRUNC() requires SQL Server 2022 or later.

Based on: SQL analytics course by Baraa Khatib Salkini (Data With Baraa).
===============================================================================
*/

-- Total sales per month and the running total that resets every year
SELECT
    order_date,
    total_sales,
    SUM(total_sales) OVER (PARTITION BY YEAR(order_date) ORDER BY order_date) AS running_total_sales
FROM
(
    SELECT
        DATETRUNC(month, order_date) AS order_date,
        SUM(sales_amount)            AS total_sales
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(month, order_date)
) t;

-- Total sales per year, the running total of sales and the moving average of the yearly average price
SELECT
    order_date,
    total_sales,
    SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales,
    ROUND(AVG(avg_price) OVER (ORDER BY order_date), 2) AS moving_avg_price
FROM
(
    SELECT 
        DATETRUNC(year, order_date) AS order_date,
        SUM(sales_amount) AS total_sales,
        AVG(CAST(price AS FLOAT)) AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(year, order_date)
) t;
