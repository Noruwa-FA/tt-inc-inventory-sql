-- ============================================================
-- T.T Inc. Inventory Optimisation - Economic Indicators
-- Author: Success Noruwa
-- Description: GDP, inflation and seasonal factor correlation
-- with sales volume
-- ============================================================

-- 1. Monthly sales volume with economic indicators
SELECT 
    s.sales_month,
    SUM(s.sales_quantity) AS total_units_sold,
    e.gdp,
    e.inflation_rate,
    e.seasonal_factor
FROM sales s
JOIN external_information e ON s.sales_month = e.sales_month
GROUP BY s.sales_month, e.gdp, e.inflation_rate, e.seasonal_factor
ORDER BY s.sales_month;

-- 2. How does inflation rate correlate with sales volume monthly?
SELECT 
    s.sales_month,
    SUM(s.sales_quantity) AS total_units,
    e.inflation_rate,
    ROUND(SUM(s.sales_quantity) / NULLIF(e.inflation_rate, 0), 2) AS units_per_inflation_point
FROM sales s
JOIN external_information e ON s.sales_month = e.sales_month
GROUP BY s.sales_month, e.inflation_rate
ORDER BY s.sales_month;

-- 3. How does GDP affect total sales volume?
SELECT 
    s.sales_month,
    SUM(s.sales_quantity) AS total_units_sold,
    e.gdp,
    CASE
        WHEN e.gdp > (SELECT AVG(gdp) FROM external_information) THEN 'Above Average GDP'
        ELSE 'Below Average GDP'
    END AS gdp_period
FROM sales s
JOIN external_information e ON s.sales_month = e.sales_month
GROUP BY s.sales_month, e.gdp
ORDER BY s.sales_month;

-- 4. Seasonal factors influence on sales per product category
SELECT 
    p.product_category,
    e.seasonal_factor,
    SUM(s.sales_quantity) AS total_units_sold,
    ROUND(AVG(s.sales_quantity), 2) AS avg_units
FROM sales s
JOIN product_information p ON s.product_id = p.product_id
JOIN external_information e ON s.sales_month = e.sales_month
GROUP BY p.product_category, e.seasonal_factor
ORDER BY e.seasonal_factor DESC, total_units_sold DESC;
