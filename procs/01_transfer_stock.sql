
-- 01_transfer_stock.sql
USE inventory_db;
DELIMITER //

CREATE PROCEDURE transfer_stock(
  IN p_product_id INT,
  IN p_from_wh INT,
  IN p_to_wh   INT,
  IN p_qty     INT
)
BEGIN
  DECLARE v_from_qty INT;

  IF p_from_wh = p_to_wh THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'From and To warehouse cannot be same';
  END IF;

  START TRANSACTION;

  SELECT quantity INTO v_from_qty
  FROM stock
  WHERE warehouse_id = p_from_wh AND product_id = p_product_id
  FOR UPDATE;

  IF v_from_qty IS NULL OR v_from_qty < p_qty THEN
    ROLLBACK;
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient stock in source warehouse';
  END IF;

  UPDATE stock
  SET quantity = quantity - p_qty
  WHERE warehouse_id = p_from_wh AND product_id = p_product_id;

  INSERT INTO stock (warehouse_id, product_id, quantity)
  VALUES (p_to_wh, p_product_id, p_qty)
  ON DUPLICATE KEY UPDATE quantity = quantity + VALUES(quantity);

  INSERT INTO stock_movements (product_id, from_warehouse_id, to_warehouse_id, quantity, reason)
  VALUES (p_product_id, p_from_wh, p_to_wh, p_qty, 'TRANSFER');

  COMMIT;
END//

DELIMITER ;
