-- ============================================================
-- T.T Inc. Inventory Optimisation - Promotional Impact
-- Author: Success Noruwa
-- Description: Promotional impact on sales and
-- category performance with promotions breakdown
-- ============================================================

-- 1. Did promotions significantly impact sales quantity?
SELECT 
    p.promotions,
    SUM(s.sales_quantity) AS total_units_sold,
    ROUND(AVG(s.sales_quantity), 2) AS avg_units_per_sale,
    COUNT(*) AS total_transactions
FROM sales s
JOIN product_information p ON s.product_id = p.product_id
GROUP BY p.promotions
ORDER BY total_units_sold DESC;

-- 2. Average sales quantity per category + promotion breakdown
SELECT 
    p.product_category,
    ROUND(AVG(s.sales_quantity), 2) AS avg_sales_quantity,
    COUNT(CASE WHEN p.promotions = 'Yes' THEN 1 END) AS promoted_products
FROM sales s
JOIN product_information p ON s.product_id = p.product_id
GROUP BY p.product_category
ORDER BY avg_sales_quantity DESC;

-- 3. Sales performance comparison: promoted vs non-promoted by category
SELECT 
    p.product_category,
    p.promotions,
    SUM(s.sales_quantity) AS total_sold,
    ROUND(AVG(s.sales_quantity), 2) AS avg_sold
FROM sales s
JOIN product_information p ON s.product_id = p.product_id
GROUP BY p.product_category, p.promotions
ORDER BY p.product_category, total_sold DESC;
