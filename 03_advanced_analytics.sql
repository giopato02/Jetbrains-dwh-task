-- PART 1: MRR (Monthly Recurring Revenue)
WITH calendar_months AS (
    -- Generates a list of the 1st of every month, from the oldest subscription to today
    SELECT generate_series(
        DATE_TRUNC('month', MIN(start_date)),
        DATE_TRUNC('month', CURRENT_DATE),
        '1 month'::interval
    )::date AS report_month
    FROM raw_subscriptions
)
SELECT
    m.report_month,
    c.company_name,
    s.plan_type,

    -- If it is an annual plan, divide the amount by 12.
    -- Otherwise, take the standard monthly amount. ROUND it to 2 decimals.
    ROUND(
        CASE
            WHEN s.plan_type = 'Annual' THEN s.amount / 12.0
            ELSE s.amount
            END, 2
    ) AS mrr_amount

FROM calendar_months m
-- Join where the generated month falls between the start and end of the subscription
JOIN raw_subscriptions s
    ON DATE_TRUNC('month', s.start_date) <= m.report_month
    AND DATE_TRUNC('month', COALESCE(s.end_date, CURRENT_DATE)) >= m.report_month
LEFT JOIN raw_customers c ON s.customer_id = c.customer_id;

-- PART 2: Cumulative LTV (Lifetime Value)
WITH monthly_revenue AS (
    -- group all successful transactions into monthly buckets per customer
    SELECT
        c.customer_id,
        c.company_name,
        c.signup_date,
        DATE_TRUNC('month', tx.tx_date)::date AS revenue_month,
        SUM(s.amount) AS monthly_spend
    FROM clean_transactions tx
             JOIN raw_subscriptions s ON tx.sub_id = s.sub_id
             JOIN raw_customers c ON s.customer_id = c.customer_id
    WHERE tx.status = 'Success'
    GROUP BY
        c.customer_id,
        c.company_name,
        c.signup_date,
        DATE_TRUNC('month', tx.tx_date)::date
)
SELECT
    company_name,
    signup_date,
    revenue_month,
    monthly_spend,

    -- window function:
    SUM(monthly_spend) OVER (
        -- restart the running total for each new company
        PARTITION BY customer_id
        -- add the money up chronologically
        ORDER BY revenue_month
    ) AS cumulative_ltv

FROM monthly_revenue
ORDER BY company_name, revenue_month;