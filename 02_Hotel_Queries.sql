-- ============================================================
-- 02_Hotel_Queries.sql
-- Hotel Management System — Analysis Queries (Part A, Q1–Q5)
-- ============================================================


-- ─────────────────────────────────────────────────────────────
-- Q1. For every user in the system, get the user_id and the
--     last (most recent) booked room_no.
-- ─────────────────────────────────────────────────────────────
-- Approach: Rank bookings per user by booking_date descending.
-- Pick rank = 1 (latest booking) for each user.

SELECT
    u.user_id,
    u.name,
    b.room_no  AS last_booked_room
FROM users u
JOIN (
    SELECT
        user_id,
        room_no,
        ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY booking_date DESC
        ) AS rn
    FROM bookings
) b ON b.user_id = u.user_id AND b.rn = 1;


-- ─────────────────────────────────────────────────────────────
-- Q2. Get booking_id and total billing amount of every booking
--     created in November 2021.
-- ─────────────────────────────────────────────────────────────
-- Approach: Join bookings → booking_commercials → items.
-- Filter by November 2021 booking date.
-- Total amount = SUM(item_quantity * item_rate).

SELECT
    bk.booking_id,
    SUM(bc.item_quantity * it.item_rate) AS total_billing_amount
FROM bookings bk
JOIN booking_commercials bc ON bc.booking_id = bk.booking_id
JOIN items it               ON it.item_id     = bc.item_id
WHERE YEAR(bk.booking_date)  = 2021
  AND MONTH(bk.booking_date) = 11          -- November
GROUP BY bk.booking_id;


-- ─────────────────────────────────────────────────────────────
-- Q3. Get bill_id and bill amount of all bills raised in
--     October 2021 that have a bill amount > 1000.
-- ─────────────────────────────────────────────────────────────
-- Approach: Group by bill_id, filter bill_date to Oct 2021,
-- and use HAVING to keep only totals > 1000.

SELECT
    bc.bill_id,
    SUM(bc.item_quantity * it.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items it ON it.item_id = bc.item_id
WHERE YEAR(bc.bill_date)  = 2021
  AND MONTH(bc.bill_date) = 10             -- October
GROUP BY bc.bill_id
HAVING SUM(bc.item_quantity * it.item_rate) > 1000;


-- ─────────────────────────────────────────────────────────────
-- Q4. Determine the most-ordered and least-ordered item
--     for each month of year 2021.
-- ─────────────────────────────────────────────────────────────
-- Approach:
--   Step 1 — Aggregate total quantity per (month, item).
--   Step 2 — Rank items within each month both ascending and
--             descending using RANK() to handle ties.
--   Step 3 — Pull rank=1 from each direction as most/least.

WITH monthly_item_qty AS (
    SELECT
        MONTH(bc.bill_date)       AS order_month,
        it.item_id,
        it.item_name,
        SUM(bc.item_quantity)     AS total_qty_ordered
    FROM booking_commercials bc
    JOIN items it ON it.item_id = bc.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY MONTH(bc.bill_date), it.item_id, it.item_name
),
ranked AS (
    SELECT
        order_month,
        item_name,
        total_qty_ordered,
        RANK() OVER (PARTITION BY order_month ORDER BY total_qty_ordered DESC) AS rank_most,
        RANK() OVER (PARTITION BY order_month ORDER BY total_qty_ordered ASC)  AS rank_least
    FROM monthly_item_qty
)
SELECT
    order_month,
    MAX(CASE WHEN rank_most  = 1 THEN item_name END) AS most_ordered_item,
    MAX(CASE WHEN rank_least = 1 THEN item_name END) AS least_ordered_item
FROM ranked
GROUP BY order_month
ORDER BY order_month;


-- ─────────────────────────────────────────────────────────────
-- Q5. Find the customers with the 2nd-highest bill value
--     for each month of year 2021.
-- ─────────────────────────────────────────────────────────────
-- Approach:
--   Step 1 — Compute total bill per (user, month).
--   Step 2 — DENSE_RANK() users within each month by bill desc.
--   Step 3 — Filter rank = 2.
-- Note: DENSE_RANK avoids skipping rank 2 when multiple users
--       share the highest bill.

WITH user_monthly_bill AS (
    SELECT
        MONTH(bc.bill_date)           AS bill_month,
        bk.user_id,
        SUM(bc.item_quantity * it.item_rate) AS total_bill
    FROM booking_commercials bc
    JOIN bookings bk ON bk.booking_id = bc.booking_id
    JOIN items it    ON it.item_id    = bc.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY MONTH(bc.bill_date), bk.user_id
),
ranked AS (
    SELECT
        bill_month,
        user_id,
        total_bill,
        DENSE_RANK() OVER (
            PARTITION BY bill_month
            ORDER BY total_bill DESC
        ) AS bill_rank
    FROM user_monthly_bill
)
SELECT
    r.bill_month,
    u.user_id,
    u.name,
    r.total_bill AS second_highest_bill
FROM ranked r
JOIN users u ON u.user_id = r.user_id
WHERE r.bill_rank = 2
ORDER BY r.bill_month;
