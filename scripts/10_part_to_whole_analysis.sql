/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - Find the proportion of each part relative to the whole.
    - Show which categories contribute the most to overall results.

SQL Functions Used:
    - SUM() OVER(): total across all rows.
    - CAST(), ROUND(): percentage calculation.

Based on: SQL Full Course by Baraa Khatib Salkini (Data With Baraa).
===============================================================================
*/

-- Which categories contribute the most to overall sales?
WITH CTE_category_sales AS (
    SELECT
        p.category,
        SUM(f.sales_amount) AS total_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.category
)
SELECT
    category,
    total_sales,
    SUM(total_sales) OVER () AS overall_sales,
    ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER ()) * 100, 2) AS percentage_of_total
FROM CTE_category_sales
ORDER BY total_sales DESC;
