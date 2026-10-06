-- ============================================================
-- Amsterdam Airbnb Market Analysis
-- Tableau Data Preparation
-- ============================================================

-- This file contains queries used to prepare datasets
-- for the Tableau dashboard.


-- ============================================================
-- 1. LISTING-LEVEL DATA
-- ============================================================

-- Prepare listing-level dataset and convert price to numeric format.

SELECT
    id,
    host_id,
    neighbourhood_cleansed,
    room_type,
    accommodates,
    CASE
        WHEN price = '' THEN NULL
        ELSE CAST(
            REPLACE(REPLACE(price, '$', ''), ',', '')
            AS REAL
        )
    END AS price_numeric
FROM listings;


-- ============================================================
-- 2. MONTHLY AVAILABILITY BY NEIGHBOURHOOD
-- ============================================================

-- Prepare monthly availability rates for each neighbourhood.

SELECT
    strftime('%Y-%m', c.date) AS month,
    l.neighbourhood_cleansed,
    COUNT(*) AS total_listing_days,
    SUM(
        CASE
            WHEN c.available = 't' THEN 1
            ELSE 0
        END
    ) AS available_listing_days,
    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN c.available = 't' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS availability_rate
FROM calendar c
JOIN listings l
    ON c.listing_id = l.id
GROUP BY
    month,
    l.neighbourhood_cleansed
ORDER BY
    month,
    l.neighbourhood_cleansed;


-- ============================================================
-- 3. MONTHLY REVIEW ACTIVITY
-- ============================================================

-- Prepare monthly review activity for the 2023-2025 period.

SELECT
    strftime('%Y-%m', date) AS month,
    COUNT(*) AS reviews_count
FROM reviews
WHERE date >= '2023-01-01'
  AND date < '2026-01-01'
GROUP BY month
ORDER BY month;
