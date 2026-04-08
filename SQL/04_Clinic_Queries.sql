-- ============================================================
-- 04_Clinic_Queries.sql
-- Clinic Management System — Analysis Queries (Part B, Q1–Q5)
-- ============================================================
-- Replace @year  / @month with the desired values as needed.
-- Example: SET @year = 2021; SET @month = 11;
-- ============================================================

SET @year  = 2021;
SET @month = 11;


-- ─────────────────────────────────────────────────────────────
-- Q1. Find the revenue from each sales channel in a given year.
-- ─────────────────────────────────────────────────────────────
-- Approach: Simple GROUP BY sales_channel with SUM(amount),
--           filtered by the target year.

SELECT
    sales_channel,
    SUM(amount) AS total_revenue
FROM clinic_sales
WHERE YEAR(datetime) = @year
GROUP BY sales_channel
ORDER BY total_revenue DESC;


-- ─────────────────────────────────────────────────────────────
-- Q2. Find the top 10 most valuable customers for a given year.
-- ─────────────────────────────────────────────────────────────
-- Approach: Aggregate revenue per customer for the year,
--           then ORDER BY total DESC and LIMIT 10.

SELECT
    cs.uid,
    c.name,
    c.mobile,
    SUM(cs.amount) AS total_spend
FROM clinic_sales cs
JOIN customer c ON c.uid = cs.uid
WHERE YEAR(cs.datetime) = @year
GROUP BY cs.uid, c.name, c.mobile
ORDER BY total_spend DESC
LIMIT 10;


-- ─────────────────────────────────────────────────────────────
-- Q3. Month-wise revenue, expense, profit, and profitability
--     status for a given year.
-- ─────────────────────────────────────────────────────────────
-- Approach:
--   - Aggregate revenue from clinic_sales by month.
--   - Aggregate expenses from expenses table by month.
--   - LEFT JOIN the two result-sets on month.
--   - Compute profit = revenue - expense.
--   - Label status as 'Profitable' / 'Not-Profitable'.

WITH monthly_revenue AS (
    SELECT
        MONTH(datetime) AS txn_month,
        SUM(amount)     AS total_revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = @year
    GROUP BY MONTH(datetime)
),
monthly_expense AS (
    SELECT
        MONTH(datetime) AS txn_month,
        SUM(amount)     AS total_expense
    FROM expenses
    WHERE YEAR(datetime) = @year
    GROUP BY MONTH(datetime)
)
SELECT
    mr.txn_month                                       AS month,
    COALESCE(mr.total_revenue, 0)                      AS revenue,
    COALESCE(me.total_expense, 0)                      AS expense,
    COALESCE(mr.total_revenue, 0)
        - COALESCE(me.total_expense, 0)                AS profit,
    CASE
        WHEN COALESCE(mr.total_revenue, 0)
             - COALESCE(me.total_expense, 0) > 0
        THEN 'Profitable'
        ELSE 'Not-Profitable'
    END                                                AS status
FROM monthly_revenue mr
LEFT JOIN monthly_expense me ON me.txn_month = mr.txn_month
ORDER BY month;


-- ─────────────────────────────────────────────────────────────
-- Q4. For each city, find the most profitable clinic for a
--     given month.
-- ─────────────────────────────────────────────────────────────
-- Approach:
--   Step 1 — Compute per-clinic revenue and expense for the month.
--   Step 2 — Profit = revenue - expense.
--   Step 3 — RANK() by profit DESC within each city.
--   Step 4 — Keep rank = 1.

WITH clinic_revenue AS (
    SELECT
        cid,
        SUM(amount) AS revenue
    FROM clinic_sales
    WHERE YEAR(datetime)  = @year
      AND MONTH(datetime) = @month
    GROUP BY cid
),
clinic_expense AS (
    SELECT
        cid,
        SUM(amount) AS expense
    FROM expenses
    WHERE YEAR(datetime)  = @year
      AND MONTH(datetime) = @month
    GROUP BY cid
),
clinic_profit AS (
    SELECT
        cl.cid,
        cl.clinic_name,
        cl.city,
        cl.state,
        COALESCE(cr.revenue, 0) - COALESCE(ce.expense, 0) AS profit
    FROM clinics cl
    LEFT JOIN clinic_revenue cr ON cr.cid = cl.cid
    LEFT JOIN clinic_expense ce ON ce.cid = cl.cid
),
ranked AS (
    SELECT
        *,
        RANK() OVER (PARTITION BY city ORDER BY profit DESC) AS city_rank
    FROM clinic_profit
)
SELECT
    city,
    cid,
    clinic_name,
    state,
    profit AS highest_profit
FROM ranked
WHERE city_rank = 1
ORDER BY city;


-- ─────────────────────────────────────────────────────────────
-- Q5. For each state, find the second least profitable clinic
--     for a given month.
-- ─────────────────────────────────────────────────────────────
-- Approach: Same as Q4 but rank by profit ASC (least first)
--           using DENSE_RANK to handle ties, then keep rank = 2.

WITH clinic_revenue AS (
    SELECT
        cid,
        SUM(amount) AS revenue
    FROM clinic_sales
    WHERE YEAR(datetime)  = @year
      AND MONTH(datetime) = @month
    GROUP BY cid
),
clinic_expense AS (
    SELECT
        cid,
        SUM(amount) AS expense
    FROM expenses
    WHERE YEAR(datetime)  = @year
      AND MONTH(datetime) = @month
    GROUP BY cid
),
clinic_profit AS (
    SELECT
        cl.cid,
        cl.clinic_name,
        cl.city,
        cl.state,
        COALESCE(cr.revenue, 0) - COALESCE(ce.expense, 0) AS profit
    FROM clinics cl
    LEFT JOIN clinic_revenue cr ON cr.cid = cl.cid
    LEFT JOIN clinic_expense ce ON ce.cid = cl.cid
),
ranked AS (
    SELECT
        *,
        DENSE_RANK() OVER (PARTITION BY state ORDER BY profit ASC) AS state_rank
    FROM clinic_profit
)
SELECT
    state,
    cid,
    clinic_name,
    city,
    profit AS second_least_profit
FROM ranked
WHERE state_rank = 2
ORDER BY state;
