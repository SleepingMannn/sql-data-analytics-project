/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - Explore the unique values of the dimension columns 
      (countries, categories, product types, etc.).

SQL Functions Used:
    - DISTINCT
    - ORDER BY

Based on: SQL analytics course by Baraa Khatib Salkini (Data With Baraa).
===============================================================================
*/

-- List of unique countries our customers come from
SELECT DISTINCT 
    country 
FROM gold.dim_customers
ORDER BY country;

-- List of unique categories, subcategories and products
SELECT DISTINCT 
    category, 
    subcategory, 
    product_name 
FROM gold.dim_products
ORDER BY category, subcategory, product_name;
