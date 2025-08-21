
-- 01_smoke_test.sql
USE inventory_db;

-- Ensure views exist
SELECT COUNT(*) AS cnt FROM vw_stock_levels;
SELECT COUNT(*) AS cnt FROM vw_reorder_suggestions;

-- Trigger test: drop quantity below minimum to create a notification
UPDATE stock SET quantity = 3 WHERE warehouse_id=2 AND product_id=3; -- min is 10
SELECT * FROM reorder_notifications ORDER BY created_at DESC LIMIT 3;

-- Procedure test
CALL transfer_stock(1, 1, 2, 5);
SELECT * FROM stock_movements ORDER BY created_at DESC LIMIT 3;
