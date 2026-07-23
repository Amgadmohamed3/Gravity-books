# 📚 Gravity Books — Data Warehouse & OLAP BI Solution

## 📋 Project Overview

A full-cycle data warehousing project: from designing an OLTP database to building a Star Schema data warehouse, orchestrating ETL pipelines via SSIS, constructing an SSAS OLAP cube, and delivering a Power BI dashboard — all on Microsoft SQL Server.

**Tech Stack:** SQL Server, T-SQL, SSIS (ETL), SSAS (OLAP Cube), Power BI

---

## 🎯 Objective

Transform the Gravity Books transactional database (OLTP) into an analytical data warehouse (OLAP) optimized for business intelligence reporting and multi-dimensional analysis.

---

## 🏗️ Architecture

```
┌──────────────┐     ┌──────────────────────┐     ┌──────────────┐     ┌──────────────┐
│  OLTP Source  │────▶│  SSIS ETL Packages   │────▶│  Star Schema │────▶│  SSAS Cube   │
│  (SQL Server) │     │  (5 Data Flows)      │     │     DWH      │     │  (OLAP)      │
└──────────────┘     └──────────────────────┘     └──────────────┘     └──────┬───────┘
                                                                              │
                                                                              ▼
                                                                     ┌──────────────┐
                                                                     │  Power BI    │
                                                                     │  Dashboard   │
                                                                     └──────────────┘
```

---

## 📊 Data Model — Star Schema

### Fact Table
- **sales_fact** — `sales_sk` (surrogate key), `shipping_sk`, `customer_sk`, `date_sk`, `book_sk`, `price`, `shipping_cost`, `source_system_code`

### Dimension Tables

| Dimension | Key Columns | SCD Type |
|-----------|-------------|----------|
| **book_dim** | `book_sk`, `book_id` (BK), title, author, publisher, language, pages | Type 2 (start_date, end_date, is_current) |
| **customer_dim** | `customer_sk`, `customer_id` (BK), name, email, country, city, address_status | Type 2 (start_date, end_date, is_current) |
| **shipping_dim** | `shipping_sk`, method details, cost | Standard |
| **date_dim** | `date_sk`, full date hierarchy | Standard |
| **order_history** | order lifecycle tracking (Received → Pending → In Progress → Delivered/Cancelled/Returned) | Pivoted status dates |

### Key Design Decisions
- **Surrogate Keys**: All dimensions use `IDENTITY(1,1)` surrogate keys
- **SCD Type 2**: `book_dim` and `customer_dim` implement Slowly Changing Dimensions with `start_date`, `end_date`, and `is_current` flags
- **Nonclustered Indexes**: Created on all foreign keys in the fact table and business keys in dimensions for optimized query performance
- **Source System Code**: Audit column added to all tables for data lineage

---

## ⚙️ ETL Pipelines (SSIS)

Five SSIS packages handle the complete data flow from OLTP to DWH:

| Package | Source | Target | Description |
|---------|--------|--------|-------------|
| `book dim.dtsx` | book, book_author, author, publisher, book_language | book_dim | Multi-table join → dimension load |
| `customer dim.dtsx` | customer, customer_address, address, country, address_status | customer_dim | 5-table join → dimension load |
| `Shipping dim.dtsx` | shipping_method | shipping_dim | Direct mapping |
| `order_history dim.dtsx` | order_history, order_status | order_history | Pivot status dates per order |
| `sales fact.dtsx` | book, order_line, cust_order, shipping_method, customer | sales_fact | Fact table population with FK lookups |

---

## 📸 Screenshots

### Source OLTP Schema
![OLTP Schema](My%20gravity%20books/screenshots/oltp.png)

### DWH Schema
![DWH Schema](My%20gravity%20books/screenshots/00-DWH%20schema.png)

### DWH Mapping
![DWH Mapping](My%20gravity%20books/screenshots/0-DWH%20Mapping.png)

### ETL Package Execution
![Book Dimension ETL](My%20gravity%20books/screenshots/1-book%20dim.png)
![Customer Dimension ETL](My%20gravity%20books/screenshots/3-customer%20dim.png)
![Sales Fact ETL](My%20gravity%20books/screenshots/9-sales%20fact.png)

### Final Dashboard
![Power BI Dashboard](My%20gravity%20books/screenshots/12-Dashboard.png)

---

## 📂 Project Structure

```
Gravity-books-main/
└── My gravity books/
    ├── Data Base Code/           # 13 SQL scripts — OLTP schema & data population
    ├── DWH Quieres/              # Star schema DDL (customer_dim, book_dim, sales_fact, etc.)
    ├── DWH Integration/          # SSIS project (.dtproj, .dtsx packages)
    ├── SSAS/                     # SSAS multidimensional cube project
    ├── screenshots/              # 15 annotated screenshots
    ├── dashboard.pbix            # Power BI report file
    └── SQLQuery5.sql             # Exploratory join queries
```

---

## 🎓 Skills Demonstrated

| Category | Details |
|----------|---------|
| **Data Modeling** | Star schema design, surrogate keys, SCD Type 2, nonclustered indexes |
| **SQL (T-SQL)** | DDL, DML, multi-table joins, view creation, date pivoting |
| **ETL (SSIS)** | 5 data flow packages, lookup transformations, derived columns |
| **OLAP (SSAS)** | Cube design, dimension configuration, data source views |
| **BI (Power BI)** | Dashboard design connected to the SSAS cube |

---

## 👤 Author

**Amgad Mohamed Abdelghfar**  
📧 amgadabdelghfar3@gmail.com  
🔗 [LinkedIn](https://www.linkedin.com/in/amgadabdelghfar/)
