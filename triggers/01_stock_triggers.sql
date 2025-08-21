
-- 01_stock_triggers.sql
USE inventory_db;
DELIMITER //

CREATE TRIGGER trg_stock_low_after_ins
AFTER INSERT ON stock
FOR EACH ROW
BEGIN
  IF NEW.quantity < NEW.minimum_level THEN
    INSERT INTO reorder_notifications (warehouse_id, product_id, quantity, minimum_level)
    VALUES (NEW.warehouse_id, NEW.product_id, NEW.quantity, NEW.minimum_level);
  END IF;
END//

CREATE TRIGGER trg_stock_low_after_upd
AFTER UPDATE ON stock
FOR EACH ROW
BEGIN
  IF NEW.quantity < NEW.minimum_level AND (OLD.quantity IS NULL OR NEW.quantity <> OLD.quantity) THEN
    INSERT INTO reorder_notifications (warehouse_id, product_id, quantity, minimum_level)
    VALUES (NEW.warehouse_id, NEW.product_id, NEW.quantity, NEW.minimum_level);
  END IF;
END//

DELIMITER ;
