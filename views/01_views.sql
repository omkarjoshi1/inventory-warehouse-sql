
-- 01_views.sql
USE inventory_db;

-- Per-warehouse stock view
CREATE OR REPLACE VIEW vw_stock_levels AS
SELECT
  p.product_id, p.sku, p.name,
  w.warehouse_id, w.name AS warehouse_name,
  s.quantity, s.reserved_qty,
  (s.quantity - s.reserved_qty) AS available_qty,
  s.minimum_level,
  p.reorder_level, p.reorder_qty
FROM products p
JOIN stock s      ON s.product_id = p.product_id
JOIN warehouses w ON w.warehouse_id = s.warehouse_id;

-- Reorder suggestions (total stock across warehouses < product.reorder_level)
CREATE OR REPLACE VIEW vw_reorder_suggestions AS
SELECT
  p.product_id, p.sku, p.name,
  SUM(COALESCE(s.quantity,0)) AS total_qty,
  p.reorder_level, p.reorder_qty
FROM products p
LEFT JOIN stock s ON s.product_id = p.product_id
GROUP BY p.product_id, p.sku, p.name, p.reorder_level, p.reorder_qty
HAVING SUM(COALESCE(s.quantity,0)) < p.reorder_level;
