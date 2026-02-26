# **Enterprise DWH Reporting Layer (JetBrains Task)**

### Overview

This project focuses on the design and implementation of a structured reporting layer within an enterprise Data Warehouse (DWH). The goal is to transform normalized data from a simulated CRM integration layer into optimized, user-friendly structures tailored for Business Intelligence (BI) tools and end-user consumption.

### Tech Stack

- Database Engine: PostgreSQL
- IDE / Tooling: JetBrains DataGrip

### Project Structure

The project is divided into logical steps, mirroring a standard Data Engineering pipeline:

- 00_init_schema.sql: DDL statements defining the raw schema (raw_customers, raw_subscriptions, raw_transactions) using custom ENUM types and omitting foreign keys for ETL ingestion flexibility.
- 01_insert_dummy_data.sql: (In Progress) DML statements to populate the raw tables with specific edge cases required for testing (e.g., intentional duplicates, refunds, annual vs. monthly plans).
- 02_data_cleaning_and_mart.sql: (In Progress) ETL logic to deduplicate transactions, perform data quality assertions, and build the final dm_sales_performance Data Mart.
- 03_advanced_analytics.sql: (In Progress) Advanced analytical SQL to calculate complex metrics such as Monthly Recurring Revenue (MRR) across expanded dates and Cumulative Lifetime Value (LTV) using Window Functions.

### How to Run

- Execute 00_init_schema.sql to initialize the database schema.
- Execute 01_insert_dummy_data.sql to populate the raw tables.
- Run the subsequent ETL and analytics scripts in numbered order.