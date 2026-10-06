-- ============================================================
-- Amsterdam Airbnb Market Analysis
-- Market Analysis
-- ============================================================


-- ============================================================
-- 1. MARKET STRUCTURE
-- ============================================================

-- 1.1 Distribution of listings by property type
SELECT
    property_type,
    COUNT(*) AS listings_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS listings_share
FROM listings
GROUP BY property_type
ORDER BY listings_count DESC;


-- 1.2 Distribution of listings by room type
SELECT
    room_type,
    COUNT(*) AS listings_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS listings_share
FROM listings
GROUP BY room_type
ORDER BY listings_count DESC;


-- 1.3 Host portfolio segmentation
WITH host_listings AS (
    SELECT
        host_id,
        COUNT(*) AS listings_count
    FROM listings
    GROUP BY host_id
)
SELECT
    CASE
        WHEN listings_count = 1 THEN '1 listing'
        WHEN listings_count = 2 THEN '2 listings'
        WHEN listings_count BETWEEN 3 AND 10 THEN '3-10 listings'
        ELSE '11+ listings'
    END AS host_segment,
    COUNT(*) AS hosts_count,
    SUM(listings_count) AS listings_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS hosts_share,
    ROUND(
        100.0 * SUM(listings_count) / SUM(SUM(listings_count)) OVER (),
        2
    ) AS listings_share
FROM host_listings
GROUP BY host_segment
ORDER BY MIN(listings_count);


-- ============================================================
-- 2. GEOGRAPHIC SUPPLY
-- ============================================================

-- 2.1 Listings by neighbourhood
SELECT
    neighbourhood_cleansed,
    COUNT(*) AS listings_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS listings_share
FROM listings
GROUP BY neighbourhood_cleansed
ORDER BY listings_count DESC;


-- 2.2 Room type mix by neighbourhood
SELECT
    neighbourhood_cleansed,
    room_type,
    COUNT(*) AS listings_count,
    ROUND(
        100.0 * COUNT(*)
        / SUM(COUNT(*)) OVER (PARTITION BY neighbourhood_cleansed),
        2
    ) AS room_type_share
FROM listings
GROUP BY neighbourhood_cleansed, room_type
ORDER BY neighbourhood_cleansed, listings_count DESC;


-- ============================================================
-- 3. PRICE ANALYSIS
-- ============================================================

-- 3.1 Average price by neighbourhood
SELECT
    neighbourhood_cleansed,
    COUNT(*) AS listings_with_price,
    ROUND(
        AVG(CAST(REPLACE(REPLACE(price, '$', ''), ',', '') AS REAL)),
        2
    ) AS avg_price
FROM listings
WHERE price <> ''
GROUP BY neighbourhood_cleansed
ORDER BY avg_price DESC;


-- 3.2 Average price by room type
SELECT
    room_type,
    COUNT(*) AS listings_with_price,
    ROUND(
        AVG(CAST(REPLACE(REPLACE(price, '$', ''), ',', '') AS REAL)),
        2
    ) AS avg_price
FROM listings
WHERE price <> ''
GROUP BY room_type
ORDER BY avg_price DESC;


-- 3.3 Average price by guest capacity
SELECT
    CAST(accommodates AS INTEGER) AS accommodates,
    COUNT(*) AS listings_with_price,
    ROUND(
        AVG(CAST(REPLACE(REPLACE(price, '$', ''), ',', '') AS REAL)),
        2
    ) AS avg_price
FROM listings
WHERE price <> ''
GROUP BY accommodates
ORDER BY CAST(accommodates AS INTEGER);


-- ============================================================
-- 4. AVAILABILITY ANALYSIS
-- ============================================================

-- 4.1 Monthly availability rate
SELECT
    strftime('%Y-%m', date) AS month,
    COUNT(*) AS total_listing_days,
    SUM(CASE WHEN available = 't' THEN 1 ELSE 0 END)
        AS available_listing_days,
    ROUND(
        100.0 * SUM(CASE WHEN available = 't' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS availability_rate
FROM calendar
GROUP BY month
ORDER BY month;


-- 4.2 Availability rate by neighbourhood
SELECT
    l.neighbourhood_cleansed,
    COUNT(*) AS total_listing_days,
    SUM(CASE WHEN c.available = 't' THEN 1 ELSE 0 END)
        AS available_listing_days,
    ROUND(
        100.0 * SUM(CASE WHEN c.available = 't' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS availability_rate
FROM calendar c
JOIN listings l
    ON c.listing_id = l.id
GROUP BY l.neighbourhood_cleansed
ORDER BY availability_rate DESC;


-- 4.3 Monthly availability by neighbourhood
SELECT
    strftime('%Y-%m', c.date) AS month,
    l.neighbourhood_cleansed,
    COUNT(*) AS total_listing_days,
    SUM(CASE WHEN c.available = 't' THEN 1 ELSE 0 END)
        AS available_listing_days,
    ROUND(
        100.0 * SUM(CASE WHEN c.available = 't' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS availability_rate
FROM calendar c
JOIN listings l
    ON c.listing_id = l.id
GROUP BY month, l.neighbourhood_cleansed
ORDER BY month, l.neighbourhood_cleansed;


-- ============================================================
-- 5. REVIEW ACTIVITY
-- ============================================================

-- 5.1 Monthly review activity, 2023-2025
SELECT
    strftime('%Y-%m', date) AS month,
    COUNT(*) AS reviews_count
FROM reviews
WHERE date >= '2023-01-01'
  AND date < '2026-01-01'
GROUP BY month
ORDER BY month;


-- 5.2 Review activity by neighbourhood
SELECT
    l.neighbourhood_cleansed,
    COUNT(DISTINCT l.id) AS listings_count,
    COUNT(r.reviewer_id) AS reviews_count,
    ROUND(
        1.0 * COUNT(r.reviewer_id) / COUNT(DISTINCT l.id),
        2
    ) AS reviews_per_listing
FROM reviews r
JOIN listings l
    ON r.listing_id = l.id
WHERE r.date >= '2023-01-01'
  AND r.date < '2026-01-01'
GROUP BY l.neighbourhood_cleansed
ORDER BY reviews_per_listing DESC;


-- 5.3 Review activity by room type
SELECT
    l.room_type,
    COUNT(DISTINCT l.id) AS listings_count,
    COUNT(r.reviewer_id) AS reviews_count,
    ROUND(
        1.0 * COUNT(r.reviewer_id) / COUNT(DISTINCT l.id),
        2
    ) AS reviews_per_listing
FROM reviews r
JOIN listings l
    ON r.listing_id = l.id
WHERE r.date >= '2023-01-01'
  AND r.date < '2026-01-01'
GROUP BY l.room_type
ORDER BY reviews_per_listing DESC;
