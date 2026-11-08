/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - Consolidate key customer metrics and behaviors in one view.

Highlights:
    1. Essential fields: name, age and order details.
    2. Segments customers by age group and spending (VIP, Regular, New).
    3. Customer-level metrics:
       - total orders
       - total sales
       - total quantity purchased
       - total products
       - lifespan (in months)
    4. KPIs:
       - recency (months since the last order)
       - average order value
       - average monthly spend

Based on: SQL analytics course by Baraa Khatib Salkini (Data With Baraa).
===============================================================================
*/

-- =============================================================================
-- Create Report: gold.report_customers
-- =============================================================================
IF OBJECT_ID('gold.report_customers', 'V') IS NOT NULL
    DROP VIEW gold.report_customers;
GO

CREATE VIEW gold.report_customers AS

WITH CTE_base_query AS (
/*---------------------------------------------------------------------------
1) Base Query: retrieves the core columns from the tables
---------------------------------------------------------------------------*/
    SELECT
        f.order_number,
        f.product_key,
        f.order_date,
        f.sales_amount,
        f.quantity,
        c.customer_key,
        c.customer_number,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        DATEDIFF(year, c.birthdate, GETDATE()) AS age  -- approximate age (calendar-year difference)
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
        ON c.customer_key = f.customer_key
    WHERE f.order_date IS NOT NULL
)

, CTE_customer_aggregation AS (
/*---------------------------------------------------------------------------
2) Customer Aggregations: summarizes key metrics at the customer level
---------------------------------------------------------------------------*/
    SELECT 
        customer_key,
        customer_number,
        customer_name,
        age,
        COUNT(DISTINCT order_number) AS total_orders,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT product_key) AS total_products,
        MAX(order_date) AS last_order_date,
        DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
    FROM CTE_base_query
    GROUP BY 
        customer_key,
        customer_number,
        customer_name,
        age
)

/*---------------------------------------------------------------------------
3) Final Query: segments the customers and calculates the KPIs
---------------------------------------------------------------------------*/
SELECT
    customer_key,
    customer_number,
    customer_name,
    age,
    CASE 
        WHEN age IS NULL THEN 'n/a'
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50 and above'
    END AS age_group,
    CASE 
        WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
        WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
        ELSE 'New'
    END AS customer_segment,
    last_order_date,
    DATEDIFF(month, last_order_date, GETDATE()) AS recency,
    total_orders,
    total_sales,
    total_quantity,
    total_products,
    lifespan,
    -- Average order value (AOV)
    CASE 
        WHEN total_orders = 0 THEN 0
        ELSE ROUND(CAST(total_sales AS FLOAT) / total_orders, 2) -- CAST avoids integer division
    END AS avg_order_value,
    -- Average monthly spend
    CASE 
        WHEN lifespan = 0 THEN total_sales
        ELSE ROUND(CAST(total_sales AS FLOAT) / lifespan, 2) -- CAST avoids integer division
    END AS avg_monthly_spend
FROM CTE_customer_aggregation;
