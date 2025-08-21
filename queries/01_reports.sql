
-- 01_reports.sql
USE inventory_db;

-- Low stock at any warehouse
SELECT w.name AS warehouse, p.sku, p.name, s.quantity, s.minimum_level
FROM stock s
JOIN warehouses w ON w.warehouse_id = s.warehouse_id
JOIN products p   ON p.product_id   = s.product_id
WHERE s.quantity < s.minimum_level
ORDER BY w.name, p.sku;

-- Reorder suggestions across all warehouses
SELECT * FROM vw_reorder_suggestions ORDER BY sku;

-- Current stock per warehouse
SELECT * FROM vw_stock_levels ORDER BY warehouse_name, sku;

-- Movement log (latest first)
SELECT * FROM stock_movements ORDER BY created_at DESC;
