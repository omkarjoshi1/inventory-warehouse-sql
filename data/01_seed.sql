
-- 01_seed.sql
USE inventory_db;

INSERT INTO suppliers (name, contact_email, phone, gstin) VALUES
('Acme Supplies','acme@example.com','9876543210','GSTINACME1'),
('Global Traders','global@example.com','9123456780','GSTINGLB2');

INSERT INTO warehouses (name, address, city, state, pincode) VALUES
('Central WH','Plot 12, MIDC','Pune','MH','411001'),
('North WH','NH-6','Nagpur','MH','440001');

INSERT INTO products (sku,name,category,unit_price,reorder_level,reorder_qty) VALUES
('SKU-101','Steel Bolts M6','Fasteners',5.00,100,500),
('SKU-102','Copper Wire 1mm','Electrical',12.50,200,800),
('SKU-103','Packing Tape 2"','Packaging',2.00,50,200);

INSERT INTO stock (warehouse_id, product_id, quantity, reserved_qty, minimum_level) VALUES
(1,1,80, 0,20),
(1,2,150,10,40),
(2,1,40, 5,20),
(2,3,25, 0,10);
