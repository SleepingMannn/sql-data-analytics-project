/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - Consolidate key product metrics and behaviors in one view.

Highlights:
    1. Essential fields: product name, category, subcategory and cost.
    2. Segments products by revenue: High-Performer, Mid-Range, Low-Performer.
    3. Product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. KPIs:
       - recency (months since the last sale)
       - average order revenue (AOR)
       - average monthly revenue

Based on: SQL Full Course by Baraa Khatib Salkini (Data With Baraa).
===============================================================================
*/

-- =============================================================================
-- Create Report: gold.report_products
-- =============================================================================
IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL
    DROP VIEW gold.report_products;
GO

CREATE VIEW gold.report_products AS

WITH CTE_base_query AS (
/*---------------------------------------------------------------------------
1) Base Query: retrieves the core columns from the fact and product tables
---------------------------------------------------------------------------*/
    SELECT
        f.order_number,
        f.order_date,
        f.customer_key,
        f.sales_amount,
        f.quantity,
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL  -- only valid sales dates
)

, CTE_product_aggregations AS (
/*---------------------------------------------------------------------------
2) Product Aggregations: summarizes key metrics at the product level
---------------------------------------------------------------------------*/
    SELECT
        product_key,
        product_name,
        category,
        subcategory,
        cost,
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
        MAX(order_date) AS last_sale_date,
        COUNT(DISTINCT order_number) AS total_orders,
        COUNT(DISTINCT customer_key) AS total_customers,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)), 1) AS avg_selling_price
    FROM CTE_base_query
    GROUP BY
        product_key,
        product_name,
        category,
        subcategory,
        cost
)

/*---------------------------------------------------------------------------
3) Final Query: segments the products and calculates the KPIs
---------------------------------------------------------------------------*/
SELECT 
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    last_sale_date,
    DATEDIFF(MONTH, last_sale_date, GETDATE()) AS recency_in_months,
    CASE
        WHEN total_sales > 50000 THEN 'High-Performer'
        WHEN total_sales >= 10000 THEN 'Mid-Range'
        ELSE 'Low-Performer'
    END AS product_segment,
    lifespan,
    total_orders,
    total_sales,
    total_quantity,
    total_customers,
    avg_selling_price,
    -- Average order revenue (AOR); 
    CASE 
        WHEN total_orders = 0 THEN 0
        ELSE ROUND(CAST(total_sales AS FLOAT) / total_orders, 2) -- CAST avoids integer division
    END AS avg_order_revenue,
    -- Average monthly revenue
    CASE
        WHEN lifespan = 0 THEN total_sales
        ELSE ROUND(CAST(total_sales AS FLOAT) / lifespan, 2) -- CAST avoids integer division
    END AS avg_monthly_revenue
FROM CTE_product_aggregations;
