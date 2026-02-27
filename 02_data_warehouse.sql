-- PART 1: DUPLICATION FILTER IN TRANSACTIONS
CREATE OR REPLACE VIEW clean_transactions AS
SELECT DISTINCT tx_id, sub_id, tx_date, status
FROM raw_transactions;

-- PART 2: DATA QUALITY CHECKS
CREATE OR REPLACE VIEW dq_check_missing_customers AS
SELECT s.sub_id, s.customer_id
FROM raw_subscriptions s
LEFT JOIN raw_customers c ON s.customer_id = c.customer_id
WHERE c.customer_id IS NULL; -- Flags subscriptions linked to non-existent customers

CREATE OR REPLACE VIEW dq_check_invalid_dates AS
SELECT sub_id, start_date, end_date
FROM raw_subscriptions
WHERE end_date < start_date
OR start_date IS NULL;

-- PART 3: DWH REPORTING LAYER (dm_sales_performance)
-- This is the final Data Mart structured for BI tools and end-users.
CREATE OR REPLACE VIEW dm_sales_performance AS
SELECT
    s.sub_id,
    c.company_name,
    c.country,
    s.plan_type,

    -- DURATION CALCULATION:
    COALESCE(s.end_date, CURRENT_DATE) - s.start_date AS duration_days,

    -- PAYMENT CALCULATION (Conditional Aggregation):
    -- Count only the transactions where the status is 'Success'
    COUNT(CASE WHEN tx.status = 'Success' THEN tx.tx_id END) AS successful_tx_count,
    COUNT(CASE WHEN tx.status = 'Success' THEN tx.tx_id END) * s.amount AS total_revenue_collected

FROM raw_subscriptions s
LEFT JOIN raw_customers c ON s.customer_id = c.customer_id
LEFT JOIN clean_transactions tx ON s.sub_id = tx.sub_id
-- Because we are using COUNT(), we must GROUP BY every other column we are selecting
GROUP BY
    s.sub_id,
    c.company_name,
    c.country,
    s.plan_type,
    s.start_date,
    s.end_date,
    s.amount;