CREATE TABLE layoffs_backup
LIKE layoffs;

INSERT INTO layoffs_backup
SELECT * FROM layoffs;

SELECT * FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'world_layoff'
AND TABLE_NAME = 'layoffs';

SELECT DATA_LENGTH/1024 FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'world_layoff'
AND TABLE_NAME = 'layoffs';

SELECT * FROM (
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS R_No
FROM layoffs
) duplicates
WHERE R_No>1;

ALTER TABLE world_layoff.layoffs
  ADD COLUMN id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST;

-- Checking Duplicates
SELECT *
FROM (
  SELECT id,
         ROW_NUMBER() OVER (
            PARTITION BY company, location, industry, total_laid_off,
                         percentage_laid_off, `date`, stage, country, funds_raised_millions
            ORDER BY id
         ) AS rn
  FROM world_layoff.layoffs
) x
JOIN world_layoff.layoffs t ON t.id = x.id
WHERE x.rn > 1;

-- Deleting Duplicates
DELETE t
FROM (
  SELECT id,
         ROW_NUMBER() OVER (
           PARTITION BY company, location, industry,
                        total_laid_off, percentage_laid_off, `date`,
                        stage, country, funds_raised_millions
           ORDER BY id
         ) AS rn
  FROM world_layoff.layoffs
) x
JOIN world_layoff.layoffs t ON t.id = x.id
WHERE x.rn > 1;




SELECT DISTINCT(country) FROM layoffs
ORDER BY 1;

-- company
SELECT company, TRIM(company)
FROM layoffs
ORDER BY 1;

UPDATE layoffs
SET company = TRIM(company);



-- industry
SELECT 
    (SUM(industry IS NULL) / COUNT(*)) * 100 AS null_ratio
FROM layoffs;

SELECT * FROM layoffs
WHERE industry IS NULL
OR industry = '';

SELECT * FROM layoffs
WHERE company = 'Airbnb';

SELECT t1.company, t1.industry, t2.industry FROM layoffs t1
JOIN layoffs t2 ON t1.company = t2.company 
				AND t1.location = t2.location
WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;

UPDATE layoffs t1
JOIN layoffs t2 ON t1.company = t2.company 
				AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;

SELECT DISTINCT(industry) FROM layoffs
WHERE industry LIKE 'Crypto%';

UPDATE layoffs
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- total layoffs
SELECT 
    (SUM(total_laid_off IS NULL) / COUNT(*)) * 100 AS null_ratio
FROM layoffs;

-- percent layoffs
SELECT 
    (SUM(percentage_laid_off IS NULL) / COUNT(*)) * 100 AS null_ratio
FROM layoffs;

-- date
UPDATE layoffs
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

SELECT `date` FROM layoffs;

-- country
SELECT DISTINCT(country)  FROM layoffs
WHERE country LIKE 'United States%';

UPDATE layoffs
SET country = 'United States'
WHERE country LIKE 'United States%';

SELECT 
    SUM(
        total_laid_off IS NULL 
        AND percentage_laid_off IS NULL
    ) * 100.0 / COUNT(*) AS null_row_percentage
FROM world_layoff.layoffs;

DELETE
FROM world_layoff.layoffs
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;
  
  

  





