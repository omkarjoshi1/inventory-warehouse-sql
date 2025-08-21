
# Report (1–2 pages)

## Introduction
This SQL project implements an **Inventory & Warehouse Management System** that tracks stock per warehouse, raises low‑stock alerts, and supports stock transfers.

## Abstract
We designed a normalized schema (Suppliers, Warehouses, Products, Stock), implemented **views** for stock and reorder insights, **triggers** for low‑stock notifications, and a **stored procedure** to transfer stock transactionally. Testing covered edge cases like insufficient stock.

## Tools Used
- MySQL 8.x
- DBeaver / MySQL Workbench
- Git & GitHub (for version control)

## Steps Involved
1. Schema design and DDL creation
2. Sample data seeding
3. Views for stock levels and reorder suggestions
4. Triggers for low‑stock notifications
5. Stored procedure for inter‑warehouse transfer
6. Testing with sample scenarios

## Conclusion
The system successfully identifies low stock, records movements, and ensures safe stock transfers. Future work: purchase/sales order tables, user roles, API/ETL integration, and dashboards.
