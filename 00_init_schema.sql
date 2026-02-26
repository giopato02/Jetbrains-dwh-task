CREATE TABLE raw_subscriptions(
    sub_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    plan_type VARCHAR(50),
    start_date DATE,
    end_date DATE,
    amount NUMERIC(10, 2)
);
CREATE TABLE raw_customers(
    customer_id VARCHAR(50) PRIMARY KEY,
    company_name VARCHAR(50),
    country Varchar(50),
    signup_date DATE
);

CREATE TYPE transaction_status AS ENUM ('Success','Failed', 'Refunded');

CREATE TABLE raw_transactions(
    -- Intentionally removed Primary Key for duplicates testing
    tx_id VARCHAR(50),
    sub_id VARCHAR(50),
    tx_date DATE,
    status transaction_status
);