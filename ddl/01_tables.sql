
-- 01_tables.sql
-- Create DB and core schema
DROP DATABASE IF EXISTS inventory_db;
CREATE DATABASE inventory_db;
USE inventory_db;

-- Suppliers
CREATE TABLE suppliers (
  supplier_id INT AUTO_INCREMENT PRIMARY KEY,
  name           VARCHAR(100) NOT NULL,
  contact_email  VARCHAR(100),
  phone          VARCHAR(20),
  gstin          VARCHAR(20),
  is_active      TINYINT(1) DEFAULT 1,
  created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Warehouses
CREATE TABLE warehouses (
  warehouse_id INT AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(100) NOT NULL,
  address     VARCHAR(255),
  city        VARCHAR(100),
  state       VARCHAR(100),
  pincode     VARCHAR(10),
  is_active   TINYINT(1) DEFAULT 1
);

-- Products
CREATE TABLE products (
  product_id     INT AUTO_INCREMENT PRIMARY KEY,
  sku            VARCHAR(50)  NOT NULL UNIQUE,
  name           VARCHAR(150) NOT NULL,
  category       VARCHAR(100),
  unit_price     DECIMAL(10,2) NOT NULL DEFAULT 0,
  reorder_level  INT NOT NULL DEFAULT 10,     -- total stock threshold across warehouses
  reorder_qty    INT NOT NULL DEFAULT 50,     -- how much to order when below threshold
  is_active      TINYINT(1) DEFAULT 1
);

-- Stock (per warehouse per product)
CREATE TABLE stock (
  warehouse_id  INT NOT NULL,
  product_id    INT NOT NULL,
  quantity      INT NOT NULL DEFAULT 0,
  reserved_qty  INT NOT NULL DEFAULT 0,
  minimum_level INT NOT NULL DEFAULT 5,     -- local (warehouse) threshold
  updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                 ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (warehouse_id, product_id),
  CONSTRAINT fk_stock_wh   FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id),
  CONSTRAINT fk_stock_prod FOREIGN KEY (product_id)   REFERENCES products(product_id),
  CHECK (quantity >= 0),
  CHECK (reserved_qty >= 0)
);

-- Movement log & reorder notifications
CREATE TABLE stock_movements (
  movement_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  product_id  INT NOT NULL,
  from_warehouse_id INT NULL,
  to_warehouse_id   INT NULL,
  quantity    INT NOT NULL,
  reason      ENUM('TRANSFER','PURCHASE_RECEIPT','SALES_ISSUE','ADJUSTMENT') NOT NULL,
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_move_prod FOREIGN KEY (product_id) REFERENCES products(product_id),
  CONSTRAINT fk_move_from FOREIGN KEY (from_warehouse_id) REFERENCES warehouses(warehouse_id),
  CONSTRAINT fk_move_to   FOREIGN KEY (to_warehouse_id)   REFERENCES warehouses(warehouse_id),
  CHECK (quantity > 0),
  CHECK (
    (reason='TRANSFER' AND from_warehouse_id IS NOT NULL AND to_warehouse_id IS NOT NULL)
    OR (reason<>'TRANSFER')
  )
);

CREATE TABLE reorder_notifications (
  notif_id      BIGINT AUTO_INCREMENT PRIMARY KEY,
  warehouse_id  INT NOT NULL,
  product_id    INT NOT NULL,
  quantity      INT NOT NULL,
  minimum_level INT NOT NULL,
  created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  is_sent       TINYINT(1) DEFAULT 0,
  CONSTRAINT fk_notif_wh   FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id),
  CONSTRAINT fk_notif_prod FOREIGN KEY (product_id)   REFERENCES products(product_id)
);

-- Indexes
CREATE INDEX idx_stock_product ON stock(product_id);
CREATE INDEX idx_stock_wh      ON stock(warehouse_id);
CREATE INDEX idx_mov_prod_time ON stock_movements(product_id, created_at);
