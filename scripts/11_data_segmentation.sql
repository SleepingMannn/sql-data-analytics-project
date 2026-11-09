/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - Group data into ranges (segments) and aggregate by the new categories.
    - Used for customer segmentation and product categorization.

SQL Functions Used:
    - CASE: defines the segmentation logic.
    - GROUP BY: groups data into segments.

Based on: SQL Full Course by Baraa Khatib Salkini (Data With Baraa).
===============================================================================
*/

-- Segment products into cost ranges and count how many products fall into each segment
WITH product_segments AS (
    SELECT
        product_key,
        product_name,
        cost,
        CASE 
            WHEN cost < 100 THEN 'Below 100'
            WHEN cost BETWEEN 100 AND 500 THEN '100-500'
            WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
            ELSE 'Above 1000'
        END AS cost_range
    FROM gold.dim_products
)
SELECT 
    cost_range,
    COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC;

/* Group customers into three segments by their spending behavior:
    - VIP: at least 12 months of history and spending more than 5,000.
    - Regular: at least 12 months of history and spending 5,000 or less.
    - New: less than 12 months of history.
   Then count the customers in each segment. */
WITH CTE_customer_spending AS (
    SELECT
        c.customer_key,
        SUM(f.sales_amount) AS total_spending,
        MIN(f.order_date) AS first_order,
        MAX(f.order_date) AS last_order,
        DATEDIFF(month, MIN(f.order_date), MAX(f.order_date)) AS lifespan
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
        ON f.customer_key = c.customer_key
    GROUP BY c.customer_key
)
SELECT 
    customer_segment,
    COUNT(customer_key) AS total_customers
FROM (
    SELECT 
        customer_key,
        CASE 
            WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
            WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
            ELSE 'New'
        END AS customer_segment
    FROM CTE_customer_spending
) AS segmented_customers
GROUP BY customer_segment
ORDER BY total_customers DESC;
