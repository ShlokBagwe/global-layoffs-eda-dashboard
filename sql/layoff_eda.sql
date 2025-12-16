SELECT COUNT(*) AS total_records
FROM layoffs;

SELECT MIN(`date`), MAX(`date`) 
FROM layoffs;

SELECT COUNT(DISTINCT(company))
FROM layoffs;


SELECT COUNT(DISTINCT industry) AS total_industries
FROM layoffs;

SELECT COUNT(DISTINCT location) AS total_industries
FROM layoffs;

SELECT COUNT(DISTINCT country) AS total_industries
FROM layoffs;

SELECT COUNT(DISTINCT stage) AS total_industries
FROM layoffs;

SELECT 
    stage,
    COUNT(*) AS records
FROM layoffs
GROUP BY stage
ORDER BY records DESC;

SELECT country, stage, SUM(total_laid_off) AS total_layoff
FROM layoffs
GROUP BY country,stage
ORDER BY total_layoff DESC, country;


-- Univariate Analysis 

-- Numerical Columns 

-- total_laid_off
WITH ranked AS (
SELECT 
	total_laid_off,
	COUNT(total_laid_off) OVER() AS count,
	MIN(total_laid_off) OVER() AS min,
    MAX(total_laid_off) OVER() AS max,
    AVG(total_laid_off) OVER() AS mean,
    STDDEV(total_laid_off) OVER() AS stddev,
    PERCENT_RANK() OVER(ORDER BY total_laid_off) AS pr
FROM layoffs
WHERE total_laid_off IS NOT NULL
)
SELECT 
		count,
        min,
        max,
        mean,
        stddev,
        (SELECT total_laid_off FROM ranked WHERE pr>=0.25 ORDER BY pr LIMIT 1) AS 'Q1',
        (SELECT total_laid_off FROM ranked WHERE pr>=0.50 ORDER BY pr LIMIT 1) AS 'median',
        (SELECT total_laid_off FROM ranked WHERE pr>=0.75 ORDER BY pr LIMIT 1) AS 'Q3'
FROM ranked
LIMIT 1;

WITH ranked AS (
SELECT 
	total_laid_off,
    PERCENT_RANK() OVER(ORDER BY total_laid_off) AS pr
FROM layoffs
WHERE total_laid_off IS NOT NULL
),
quan AS (
    SELECT 
        (SELECT total_laid_off FROM ranked WHERE pr >= 0.25 ORDER BY pr LIMIT 1) AS Q1,
        (SELECT total_laid_off FROM ranked WHERE pr >= 0.75 ORDER BY pr LIMIT 1) AS Q3
)

SELECT r.total_laid_off
FROM ranked r
CROSS JOIN quan q
WHERE r.total_laid_off < q.Q1 - 1.5*(q.Q3-q.Q1)
	OR 
    r.total_laid_off > q.Q1 + 1.5*(q.Q3-q.Q1)
ORDER BY r.total_laid_off;


SELECT 
    SUM(CASE WHEN total_laid_off < 10 THEN 1 ELSE 0 END) AS '1-9',
    SUM(CASE WHEN total_laid_off BETWEEN 10 AND 100 THEN 1 ELSE 0 END) AS '10-100',
    SUM(CASE WHEN total_laid_off BETWEEN 101 AND 500 THEN 1 ELSE 0 END) AS '101-500',
    SUM(CASE WHEN total_laid_off BETWEEN 501 AND 1000 THEN 1 ELSE 0 END) AS '501-1000',
    SUM(CASE WHEN total_laid_off > 1000 THEN 1 ELSE 0 END) AS '>1000'
FROM layoffs;

SELECT COUNT(total_laid_off) FROM layoffs
WHERE total_laid_off IS NULL;


-- percentage_laid_off


WITH ranked AS (
SELECT 
	percentage_laid_off,
	COUNT(percentage_laid_off) OVER() AS count,
	MIN(percentage_laid_off) OVER() AS min,
    MAX(percentage_laid_off) OVER() AS max,
    AVG(percentage_laid_off) OVER() AS mean,
    STDDEV(percentage_laid_off) OVER() AS stddev,
    PERCENT_RANK() OVER(ORDER BY percentage_laid_off) AS pr
FROM layoffs
WHERE percentage_laid_off IS NOT NULL
)
SELECT 
		count,
        min,
        max,
        mean,
        stddev,
        (SELECT percentage_laid_off FROM ranked WHERE pr>=0.25 ORDER BY pr LIMIT 1) AS 'Q1',
        (SELECT percentage_laid_off FROM ranked WHERE pr>=0.50 ORDER BY pr LIMIT 1) AS 'median',
        (SELECT percentage_laid_off FROM ranked WHERE pr>=0.75 ORDER BY pr LIMIT 1) AS 'Q3'
FROM ranked
LIMIT 1;
	
SELECT 
	COUNT(percentage_laid_off) AS total_count,
    SUM(CASE WHEN percentage_laid_off BETWEEN 0 AND 0.10 THEN 1 ELSE 0 END) AS '0-10%',
    SUM(CASE WHEN percentage_laid_off > 0.10 AND percentage_laid_off <= 0.25 THEN 1 ELSE 0 END) AS '11-25%',
    SUM(CASE WHEN percentage_laid_off > 0.25 AND percentage_laid_off <= 0.50 THEN 1 ELSE 0 END) AS '26-50%',
    SUM(CASE WHEN percentage_laid_off > 0.50 AND percentage_laid_off < 1 THEN 1 ELSE 0 END) AS '51-99%',
    SUM(CASE WHEN percentage_laid_off = 1 THEN 1 ELSE 0 END) AS '100%',
    SUM(CASE WHEN percentage_laid_off IS NULL THEN 1 ELSE 0 END) AS 'NULL'
FROM layoffs;


-- fund_raised_million


WITH ranked AS (
SELECT 
	funds_raised_millions,
	COUNT(funds_raised_millions) OVER() AS count,
	MIN(funds_raised_millions) OVER() AS min,
    MAX(funds_raised_millions) OVER() AS max,
    AVG(funds_raised_millions) OVER() AS mean,
    STDDEV(funds_raised_millions) OVER() AS stddev,
    PERCENT_RANK() OVER(ORDER BY funds_raised_millions) AS pr
FROM layoffs
WHERE funds_raised_millions IS NOT NULL
)
SELECT 
		count,
        min,
        max,
        mean,
        stddev,
        (SELECT funds_raised_millions FROM ranked WHERE pr>=0.25 ORDER BY pr LIMIT 1) AS 'Q1',
        (SELECT funds_raised_millions FROM ranked WHERE pr>=0.50 ORDER BY pr LIMIT 1) AS 'median',
        (SELECT funds_raised_millions FROM ranked WHERE pr>=0.75 ORDER BY pr LIMIT 1) AS 'Q3'
FROM ranked
LIMIT 1;

SELECT * FROM layoffs
WHERE funds_raised_millions = 0;

SELECT 
    SUM(funds_raised_millions IS NULL)/COUNT(*) * 100 AS null_percent
FROM layoffs;

SELECT
    SUM(CASE WHEN funds_raised_millions BETWEEN 0 AND 10 THEN 1 ELSE 0 END) AS '0-10M',
    SUM(CASE WHEN funds_raised_millions BETWEEN 11 AND 50 THEN 1 ELSE 0 END) AS '11-50M',
    SUM(CASE WHEN funds_raised_millions BETWEEN 51 AND 200 THEN 1 ELSE 0 END) AS '51-200M',
    SUM(CASE WHEN funds_raised_millions BETWEEN 201 AND 500 THEN 1 ELSE 0 END) AS '201-500M',
    SUM(CASE WHEN funds_raised_millions > 500 THEN 1 ELSE 0 END) AS '>500M',
    SUM(CASE WHEN funds_raised_millions IS NULL THEN 1 ELSE 0 END) AS 'NULL'
FROM layoffs;

WITH ranked AS (
SELECT 
	funds_raised_millions,
    PERCENT_RANK() OVER(ORDER BY funds_raised_millions) AS pr
FROM layoffs
WHERE funds_raised_millions IS NOT NULL
),
quan AS (
    SELECT 
        (SELECT funds_raised_millions FROM ranked WHERE pr >= 0.25 ORDER BY pr LIMIT 1) AS Q1,
        (SELECT funds_raised_millions FROM ranked WHERE pr >= 0.75 ORDER BY pr LIMIT 1) AS Q3
)

SELECT r.funds_raised_millions
FROM ranked r
CROSS JOIN quan q
WHERE r.funds_raised_millions < q.Q1 - 1.5*(q.Q3-q.Q1)
	OR 
    r.funds_raised_millions > q.Q1 + 1.5*(q.Q3-q.Q1)
ORDER BY r.funds_raised_millions;


-- industry
SELECT industry
FROM layoffs
WHERE industry IS NULL;

SELECT 
    industry,
    COUNT(*) AS layoff_events
FROM layoffs
GROUP BY industry
ORDER BY layoff_events DESC
LIMIT 10;

SELECT COUNT(DISTINCT(industry))
FROM layoffs;


-- stage


SELECT industry
FROM layoffs
WHERE industry IS NULL;

SELECT 
    stage,
    COUNT(*) AS layoff_events
FROM layoffs
GROUP BY stage
ORDER BY layoff_events DESC
LIMIT 10;

SELECT COUNT(DISTINCT(stage))
FROM layoffs;


-- country


SELECT country
FROM layoffs
WHERE country IS NULL;

SELECT 
    country,
    COUNT(*) AS layoff_events
FROM layoffs
GROUP BY country
ORDER BY layoff_events DESC
LIMIT 10;

SELECT COUNT(DISTINCT(country))
FROM layoffs;



-- Bivariate Analysis

-- industry vs total_laid_off
SELECT 
    industry,
    SUM(total_laid_off) AS total_laid_off_sum,
    COUNT(*) AS layoff_events
FROM layoffs
WHERE total_laid_off IS NOT NULL
GROUP BY industry
ORDER BY total_laid_off_sum DESC
LIMIT 10;

SELECT stage,
	SUM(total_laid_off) AS total_laid_off_sum,
    COUNT(*) AS layoff_events
FROM layoffs
GROUP BY stage
ORDER BY total_laid_off_sum DESC
LIMIT 10;


-- 	 country vs total_laid_off

SELECT 
    country,
    SUM(total_laid_off) AS total_laid_off_sum,
    COUNT(*) AS layoff_events
FROM layoffs
GROUP BY country
ORDER BY total_laid_off_sum DESC;


-- funding x percentage_laid_off

SELECT
    CASE
		WHEN funds_raised_millions < 10 THEN '0–10M'
		WHEN funds_raised_millions < 50 THEN '11–50M'
		WHEN funds_raised_millions < 200 THEN '51–200M'
		WHEN funds_raised_millions < 500 THEN '201–500M'
		WHEN funds_raised_millions >= 500 THEN '>500M'
        ELSE 'Unknown'
    END AS funding_bucket,
    AVG(percentage_laid_off) AS avg_percentage_laid_off,
    COUNT(*) AS records
FROM layoffs
WHERE percentage_laid_off IS NOT NULL
GROUP BY funding_bucket
ORDER BY avg_percentage_laid_off DESC;


-- date x total_laid_off
SELECT YEAR(`date`),
		SUM(total_laid_off) AS layoff_sum,
        COUNT(*) AS layoff_events
FROM layoffs
GROUP BY YEAR(`date`)
ORDER BY YEAR(`date`);


SELECT SUBSTRING(`date`,1,7) AS `date`,
		SUM(total_laid_off) AS layoff_sum,
        COUNT(*) AS layoff_events
FROM layoffs
WHERE `date` IS NOT NULL
GROUP BY SUBSTRING(`date`,1,7)
ORDER BY SUBSTRING(`date`,1,7);


-- Multivariate Analysis

-- industry, stage, total_laid_off
SELECT
    industry,
    stage,
    SUM(total_laid_off) AS total_laid_off_sum,
    COUNT(*) AS events
FROM layoffs
GROUP BY industry, stage
ORDER BY total_laid_off_sum DESC
LIMIT 15;

-- stage, funding, percentage_laid_off

SELECT
	stage,
	CASE
		WHEN funds_raised_millions < 10 THEN '0–10M'
		WHEN funds_raised_millions < 50 THEN '11–50M'
		WHEN funds_raised_millions < 200 THEN '51–200M'
		WHEN funds_raised_millions < 500 THEN '201–500M'
		WHEN funds_raised_millions >= 500 THEN '>500M'
        ELSE 'Unknown'
		END AS funding_bucket,
	AVG(percentage_laid_off) AS avg_percent_laid_off,
    COUNT(*) AS layoff_events
    FROM layoffs
    WHERE percentage_laid_off IS NOT NULL
    GROUP BY stage, funding_bucket
    ORDER BY avg_percent_laid_off DESC;
	
    








