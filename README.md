# Amsterdam Airbnb Market Analysis

An end-to-end data analytics project exploring the Amsterdam Airbnb market using SQL and Tableau.

The analysis focuses on market structure, geographic supply, pricing, availability patterns, and review activity to identify key characteristics and trends in the Amsterdam short-term rental market.

## Project Overview

This project analyzes Airbnb listings in Amsterdam to answer five main business questions:

1. What does the Amsterdam Airbnb market structure look like?
2. How is Airbnb supply distributed across neighbourhoods?
3. How do prices vary by neighbourhood, room type, and guest capacity?
4. How does listing availability change over time and across neighbourhoods?
5. What patterns can be observed in Airbnb review activity?

The project covers the full analytical workflow: data quality validation, SQL-based analysis, data preparation, visualization, and interpretation of results.

## Tools

- **SQLite** — data storage, validation, cleaning, and analysis
- **SQL** — exploratory analysis and preparation of analytical datasets
- **Tableau Public** — interactive dashboard and data visualization
- **GitHub** — project documentation and SQL code

## Dataset

The analysis uses publicly available Airbnb data for Amsterdam, Netherlands, provided by Inside Airbnb.

**Dataset snapshot:** June 15, 2026

The project uses three main datasets:

- `listings.csv` — listing-level information including host, neighbourhood, room type, capacity, and price
- `calendar.csv` — daily listing availability
- `reviews.csv` — individual Airbnb reviews and review dates

### Dataset Size

| Dataset | Rows |
|---|---:|
| Listings | 10,369 |
| Calendar | 3,819,725 |
| Reviews | 545,162 |

The raw datasets are not stored in this repository. SQL scripts contain the data validation, cleaning, analysis, and preparation steps used in the project.

## Data Quality & Preparation

Before the analysis, the datasets were validated to ensure data consistency and reliability.

Key validation and preparation steps included:

- Verified uniqueness of listing IDs and review IDs
- Checked the `listing_id + date` composite key in the calendar dataset
- Reviewed missing values in analytical fields
- Validated numeric ranges and potential outliers
- Cleaned price values by removing currency symbols and thousands separators
- Converted text-based numeric fields to appropriate numeric formats
- Checked calendar date coverage and availability categories
- Preserved valid extreme values rather than removing them automatically
- Prepared aggregated datasets for Tableau visualization

The analysis distinguishes **availability** from **occupancy**: calendar records marked as unavailable were not assumed to represent booked stays.

## Key Insights

### Market Structure
- Entire homes/apartments dominate the Amsterdam Airbnb market, accounting for approximately 82% of listings.
- The market is largely composed of small hosts: 93.5% of hosts manage only one listing, representing 82.1% of all listings.

### Geographic Supply
- De Baarsjes - Oud-West has the largest supply, accounting for 17.5% of all listings.
- The four largest neighbourhoods — De Baarsjes - Oud-West, De Pijp - Rivierenbuurt, Centrum-West, and Centrum-Oost — account for 49.4% of total listings.

### Pricing
- De Pijp - Rivierenbuurt has the highest median listing price among the analysed neighbourhoods.
- Entire homes/apartments have the highest median price among room types (€331), compared with €228 for hotel rooms, €172 for private rooms, and €52 for shared rooms.
- Average prices are consistently higher than median prices, indicating right-skewed price distributions and the presence of high-priced listings.

### Availability
- Overall availability shows a seasonal pattern, increasing during autumn and winter and decreasing during spring and summer.
- Availability varies substantially across neighbourhoods, from approximately 17% in Bos en Lommer to 39% in Bijlmer-Centrum.

### Review Activity
- Review activity shows clear seasonality, with higher volumes during warmer months, alongside year-over-year growth between 2023 and 2025.
- Hotel rooms show the highest reviews per listing, but this result should be interpreted cautiously because the category contains relatively few listings.

## Tableau Dashboard

The final Tableau dashboard provides an interactive overview of the Amsterdam Airbnb market, including:

- Total listings, hosts, and median price
- Listing distribution across neighbourhoods
- Median prices by neighbourhood and room type
- Monthly availability patterns
- Monthly review activity from 2023 to 2025

### View the Dashboard

[View interactive dashboard on Tableau Public](https://public.tableau.com/views/AmsterdamAirbnbMarketAnalysis_17911933743020/AmsterdamAirbnbMarketAnalysis?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

## Repository Structure

```text
amsterdam-airbnb-market-analysis/
│
├── sql/
│   ├── 01_data_quality.sql
│   ├── 02_market_analysis.sql
│   └── 03_tableau_exports.sql
│
└── README.md
```
### SQL Files

- `01_data_quality.sql` — data validation, missing values, duplicates, ranges, and integrity checks
- `02_market_analysis.sql` — market structure, geographic supply, pricing, availability, and review analysis
- `03_tableau_exports.sql` — queries used to prepare datasets for Tableau visualizations
