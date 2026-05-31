-- ============================================================
-- T.T Inc. Inventory Optimisation - Inventory Calculations
-- Author: Success Noruwa
-- Description: Inventory turnover, reorder levels,
-- and holding cost calculations using industry formulas
-- ============================================================

-- 1. Inventory Turnover Rate per SKU
-- Formula: Total Sales Quantity / Average Inventory Level
SELECT 
    s.product_id,
    p.product_category,
    SUM(s.sales_quantity) AS total_sales_quantity,
    ROUND(AVG(s.sales_quantity), 2) AS avg_inventory_level,
    ROUND(SUM(s.sales_quantity) / NULLIF(AVG(s.sales_quantity), 0), 2) AS inventory_turnover_rate
FROM sales s
JOIN product_information p ON s.product_id = p.product_id
GROUP BY s.product_id, p.product_category
ORDER BY inventory_turnover_rate DESC;

-- 2. Average Daily Sales per SKU (for reorder level calculation)
SELECT 
    product_id,
    SUM(sales_quantity) AS total_sales,
    COUNT(DISTINCT sales_date) AS selling_days,
    ROUND(SUM(sales_quantity)::DECIMAL / NULLIF(COUNT(DISTINCT sales_date), 0), 2) AS avg_daily_sales
FROM sales
GROUP BY product_id
ORDER BY avg_daily_sales DESC;

-- 3. Optimal Reorder Level
-- Formula: (Average Daily Sales * Lead Time) + Safety Stock
-- Assuming Lead Time = 7 days, Safety Stock = 50 units
SELECT 
    product_id,
    ROUND(SUM(sales_quantity)::DECIMAL / NULLIF(COUNT(DISTINCT sales_date), 0), 2) AS avg_daily_sales,
    (ROUND(SUM(sales_quantity)::DECIMAL / NULLIF(COUNT(DISTINCT sales_date), 0), 2) * 7) + 50 AS optimal_reorder_level
FROM sales
GROUP BY product_id
ORDER BY optimal_reorder_level DESC;

-- 4. Overstock and Understock Risk Identification
SELECT 
    s.product_id,
    p.product_category,
    SUM(s.sales_quantity) AS total_sold,
    ROUND(AVG(s.sales_quantity), 2) AS avg_sold,
    CASE
        WHEN AVG(s.sales_quantity) > 100 THEN 'High Demand - Risk of Understock'
        WHEN AVG(s.sales_quantity) < 20 THEN 'Low Demand - Risk of Overstock'
        ELSE 'Stable Demand'
    END AS inventory_risk
FROM sales s
JOIN product_information p ON s.product_id = p.product_id
GROUP BY s.product_id, p.product_category
ORDER BY avg_sold DESC;
