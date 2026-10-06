-- ============================================================
-- Amsterdam Airbnb Market Analysis
-- Data Quality Checks
-- ============================================================


-- 1. LISTINGS DATA QUALITY
-- ------------------------------------------------------------

-- Check total rows, unique listing IDs and duplicate IDs
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT id) AS unique_listing_ids,
    COUNT(*) - COUNT(DISTINCT id) AS duplicate_ids
FROM listings;


-- Check missing values in key analytical fields
SELECT
    SUM(CASE WHEN accommodates = '' THEN 1 ELSE 0 END) AS missing_accommodates,
    SUM(CASE WHEN bedrooms = '' THEN 1 ELSE 0 END) AS missing_bedrooms,
    SUM(CASE WHEN beds = '' THEN 1 ELSE 0 END) AS missing_beds,
    SUM(CASE WHEN price = '' THEN 1 ELSE 0 END) AS missing_price,
    SUM(CASE WHEN minimum_nights = '' THEN 1 ELSE 0 END) AS missing_minimum_nights,
    SUM(CASE WHEN number_of_reviews = '' THEN 1 ELSE 0 END) AS missing_number_of_reviews,
    SUM(CASE WHEN reviews_per_month = '' THEN 1 ELSE 0 END) AS missing_reviews_per_month
FROM listings;


-- Check numeric ranges
SELECT
    MIN(CAST(accommodates AS INTEGER)) AS min_accommodates,
    MAX(CAST(accommodates AS INTEGER)) AS max_accommodates,
    MIN(CAST(minimum_nights AS INTEGER)) AS min_minimum_nights,
    MAX(CAST(minimum_nights AS INTEGER)) AS max_minimum_nights,
    MIN(CAST(availability_365 AS INTEGER)) AS min_availability,
    MAX(CAST(availability_365 AS INTEGER)) AS max_availability
FROM listings;


-- Clean price field and validate numeric values
SELECT
    id,
    price,
    CAST(
        REPLACE(REPLACE(price, '$', ''), ',', '')
        AS REAL
    ) AS price_numeric
FROM listings
WHERE price <> '';


-- Investigate unusual minimum_nights values
SELECT
    id,
    minimum_nights
FROM listings
WHERE CAST(minimum_nights AS INTEGER) = 0
   OR CAST(minimum_nights AS INTEGER) > 365
ORDER BY CAST(minimum_nights AS INTEGER) DESC;


-- 2. CALENDAR DATA QUALITY
-- ------------------------------------------------------------

-- Check total rows and uniqueness of listing_id + date
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT listing_id || '|' || date) AS unique_listing_dates,
    COUNT(*) - COUNT(DISTINCT listing_id || '|' || date) AS duplicate_listing_dates
FROM calendar;


-- Check calendar date range
SELECT
    MIN(date) AS min_date,
    MAX(date) AS max_date
FROM calendar;


-- Check availability categories
SELECT
    available,
    COUNT(*) AS rows_count
FROM calendar
GROUP BY available
ORDER BY rows_count DESC;


-- Check minimum and maximum stay ranges
SELECT
    MIN(CAST(minimum_nights AS INTEGER)) AS min_minimum_nights,
    MAX(CAST(minimum_nights AS INTEGER)) AS max_minimum_nights,
    MIN(CAST(maximum_nights AS INTEGER)) AS min_maximum_nights,
    MAX(CAST(maximum_nights AS INTEGER)) AS max_maximum_nights
FROM calendar;


-- 3. REVIEWS DATA QUALITY
-- ------------------------------------------------------------

-- Check total rows and unique review IDs
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT id) AS unique_review_ids,
    COUNT(*) - COUNT(DISTINCT id) AS duplicate_review_ids
FROM reviews;


-- Check review date range
SELECT
    MIN(date) AS min_review_date,
    MAX(date) AS max_review_date
FROM reviews;


-- Check missing values in key review fields
SELECT
    SUM(CASE WHEN listing_id = '' THEN 1 ELSE 0 END) AS missing_listing_id,
    SUM(CASE WHEN id = '' THEN 1 ELSE 0 END) AS missing_review_id,
    SUM(CASE WHEN date = '' THEN 1 ELSE 0 END) AS missing_date,
    SUM(CASE WHEN reviewer_id = '' THEN 1 ELSE 0 END) AS missing_reviewer_id,
    SUM(CASE WHEN reviewer_name = '' THEN 1 ELSE 0 END) AS missing_reviewer_name
FROM reviews;
