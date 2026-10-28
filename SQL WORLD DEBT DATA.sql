/* =====================================================================
   International-debt-analysis
 
   Questions answered:
     1. Which 5 countries have the highest public external debt (last 5 years)?
     2. Which 5 countries have the highest private external debt (last 5 years)?
     3. How has Colombia's debt evolved over time?
   ===================================================================== */

-- Column names
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'ids_csv_long_raw';

-- Code associated with debt
SELECT
    "Code",
    "Indicator Name",
    "Short definition"
FROM ids_seriesmetadata
WHERE LOWER("Indicator Name") LIKE '%debt%'
ORDER BY "Indicator Name";

-- The only creditor is the World Bank

SELECT DISTINCT "CounterpartAreaName"
FROM ids_csv_long_raw
ORDER BY 1
LIMIT 20;

--Detect the last 5 year
SELECT
    year,
    COUNT(*) AS total_countries,
    COUNT(public_debt_usd) AS countries_with_public_debt,
    COUNT(private_debt_usd) AS countries_with_private_debt,
    COUNT(total_debt_usd) AS countries_with_total_debt
FROM ids_clean
GROUP BY year
ORDER BY year DESC
LIMIT 10;


-- Create table that contain the columns that I need
DROP VIEW IF EXISTS ids_clean;
CREATE OR REPLACE VIEW ids_clean AS
SELECT
    "Country"                           AS country,
    "CountryCode"                       AS country_code,
    "Year"::int                         AS year,
    NULLIF("DTDODDPNGCD", '')::numeric  AS private_debt_usd,
    NULLIF("DTDODDPPGCD", '')::numeric  AS public_debt_usd,
    NULLIF("DTDODDECTCD", '')::numeric  AS total_debt_usd
FROM ids_csv_long_raw
WHERE "CounterpartAreaName" = 'World' AND TRIM("CountryCode")  NOT IN (
    'EAP', 'LMY', 'LIC', 'LMC', 'MIC', 'UMC',
    'ECA', 'LAC', 'MNA', 'SSA', 'IDA', 'IDX', 'LDC', 'SAS'
);

-- Top 5 countries by average public external debt over the last 5 years
SELECT
    country,
    TRIM(country_code) AS country_code,
    ROUND(AVG(public_debt_usd) / 1000000000, 2)
        AS avg_public_debt_billion_usd
FROM ids_clean
WHERE year BETWEEN 2020 AND 2024
  AND public_debt_usd IS NOT NULL
GROUP BY country, TRIM(country_code)
HAVING COUNT(DISTINCT year) = 5
ORDER BY avg_public_debt_billion_usd DESC
LIMIT 5;

-- Top 5 countries by average private nonguaranteed external debt, last 5 years with data

SELECT
    country,
    TRIM(country_code) AS country_code,
    ROUND(AVG(private_debt_usd) / 1000000000, 2)
        AS avg_private_debt_billion_usd
FROM ids_clean
WHERE year BETWEEN 2020 AND 2024
  AND private_debt_usd IS NOT NULL
GROUP BY country, TRIM(country_code)
HAVING COUNT(DISTINCT year) = 5
ORDER BY avg_private_debt_billion_usd DESC
LIMIT 5;

-- Colombia: private debt, last 5 years with data
WITH country_debt AS (
    SELECT
        country,
        TRIM(country_code) AS country_code,
        AVG(public_debt_usd) AS avg_public_debt_usd
    FROM ids_clean
    WHERE year BETWEEN 2020 AND 2024
      AND public_debt_usd IS NOT NULL
    GROUP BY country, TRIM(country_code)
    HAVING COUNT(DISTINCT year) = 5
),
ranked_countries AS (
    SELECT
        country,
        country_code,
        avg_public_debt_usd,
        RANK() OVER (
            ORDER BY avg_public_debt_usd DESC
        ) AS public_debt_rank
    FROM country_debt
)
SELECT
    country,
    country_code,
    public_debt_rank,
    ROUND(avg_public_debt_usd / 1000000000, 2)
        AS avg_public_debt_billion_usd
FROM ranked_countries
WHERE country_code = 'COL';


----
WITH public_debt AS (
    SELECT
        TRIM(country_code) AS country_code,
        country,
        AVG(public_debt_usd) AS avg_public_debt
    FROM ids_clean
    WHERE year BETWEEN 2020 AND 2024
      AND public_debt_usd IS NOT NULL
    GROUP BY TRIM(country_code), country
    HAVING COUNT(DISTINCT year) = 5
),
public_ranking AS (
    SELECT
        *,
        RANK() OVER (
            ORDER BY avg_public_debt DESC
        ) AS public_rank
    FROM public_debt
),
private_debt AS (
    SELECT
        TRIM(country_code) AS country_code,
        AVG(private_debt_usd) AS avg_private_debt
    FROM ids_clean
    WHERE year BETWEEN 2020 AND 2024
      AND private_debt_usd IS NOT NULL
    GROUP BY TRIM(country_code)
    HAVING COUNT(DISTINCT year) = 5
),
private_ranking AS (
    SELECT
        *,
        RANK() OVER (
            ORDER BY avg_private_debt DESC
        ) AS private_rank
    FROM private_debt
)
SELECT
    p.country,
    p.country_code,
    p.public_rank,
    ROUND(p.avg_public_debt / 1e9, 2)
        AS avg_public_debt_billion_usd,
    pr.private_rank,
    ROUND(pr.avg_private_debt / 1e9, 2)
        AS avg_private_debt_billion_usd
FROM public_ranking AS p
JOIN private_ranking AS pr
    ON p.country_code = pr.country_code
WHERE p.country_code = 'COL';



