/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    - Explore the structure of the database: tables, views and their schemas.
    - Inspect the columns and metadata of a specific view.

System Views Used:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS

Based on: SQL Full Course by Baraa Khatib Salkini (Data With Baraa).
===============================================================================
*/

-- List all tables and views in the database
SELECT 
    TABLE_CATALOG, 
    TABLE_SCHEMA, 
    TABLE_NAME, 
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
ORDER BY TABLE_SCHEMA, TABLE_NAME;

-- List all columns of a specific view (gold.dim_customers)
SELECT
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';
