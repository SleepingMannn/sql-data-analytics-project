/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - Find the earliest and latest dates in the data.
    - Understand the scope of the data and its time span.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()

Based on: SQL analytics course by Baraa Khatib Salkini (Data With Baraa).
===============================================================================
*/

-- First and last order date, and the time span in months
SELECT 
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS order_range_months
FROM gold.fact_sales;

-- Oldest and youngest customer by birthdate
-- (DATEDIFF counts calendar-year boundaries, so the age can be off by one year)
SELECT
    MIN(birthdate) AS oldest_birthdate,
    DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS oldest_age,
    MAX(birthdate) AS youngest_birthdate,
    DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS youngest_age
FROM gold.dim_customers;
