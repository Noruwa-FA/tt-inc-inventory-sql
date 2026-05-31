-- ============================================================
-- T.T Inc. Inventory Optimisation - SQL Capstone
-- Author: Success Noruwa
-- Description: Supply chain analysis for consumer electronics
-- using sales, product, and economic indicator data
-- ============================================================

-- ============================================================
-- SECTION 1: BASIC SALES ANALYSIS
-- ============================================================

-- 1. Total units sold per product SKU
SELECT 
    p.product_id,
    p.product_category,
    SUM(s.sales_quantity) AS total_units_sold
FROM sales s
JOIN product_information p ON s.product_id = p.product_id
GROUP BY p.product_id, p.product_category
ORDER BY total_units_sold DESC;

-- 2. Which product category had the highest sales volume last month?
SELECT 
    p.product_category,
    SUM(s.sales_quantity) AS total_units_sold
FROM sales s
JOIN product_information p ON s.product_id = p.product_id
WHERE s.sales_month = (SELECT MAX(sales_month) FROM sales)
GROUP BY p.product_category
ORDER BY total_units_sold DESC
LIMIT 1;

-- 3. Top 10 best-selling product SKUs
SELECT 
    s.product_id,
    p.product_category,
    SUM(s.sales_quantity) AS total_units_sold
FROM sales s
JOIN product_information p ON s.product_id = p.product_id
GROUP BY s.product_id, p.product_category
ORDER BY total_units_sold DESC
LIMIT 10;

-- 4. Average sales quantity per product category
SELECT 
    p.product_category,
    ROUND(AVG(s.sales_quantity), 2) AS avg_sales_quantity,
    COUNT(DISTINCT p.product_id) AS total_skus
FROM sales s
JOIN product_information p ON s.product_id = p.product_id
GROUP BY p.product_category
ORDER BY avg_sales_quantity DESC;
