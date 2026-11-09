/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - Track how key metrics change over time.
    - Identify trends and seasonality.
    - Measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: YEAR(), MONTH(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT()

Note:
    - DATETRUNC() requires SQL Server 2022 or later.

Based on: SQL Full Course by Baraa Khatib Salkini (Data With Baraa).
===============================================================================
*/

-- Sales performance by year and month
-- Option 1: YEAR() and MONTH()
SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);

-- Option 2: DATETRUNC()
SELECT
    DATETRUNC(month, order_date) AS order_date,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date);

-- Option 3: FORMAT()
-- Sorted by the real date: sorting by the text 'yyyy-MMM' would put months in alphabetical order
SELECT
    FORMAT(order_date, 'yyyy-MMM') AS order_date,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy-MMM')
ORDER BY MIN(order_date);
