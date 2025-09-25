CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT layoffs_staging
SELECT *
FROM layoffs;

SELECT *,
ROW_NUMBER() 
OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_staging;

WITH DUPLICATE_CTE as 
(
SELECT *,
ROW_NUMBER()
OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_staging
)
SELECT *
FROM DUPLICATE_CTE 
WHERE row_num > 1;

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER()
OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_staging;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

DELETE
FROM layoffs_staging2;

SELECT company, trim(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = trim(company);

SELECT DISTINCT industry
FROM layoffs_staging2;

SELECT DISTINCT industry
FROM layoffs_staging2
WHERE industry like '%crypto%';

UPDATE layoffs_staging2
SET industry = 'crypto'
WHERE industry like '%crypto%';

SELECT country, trim(trailing '.' from country)
FROM layoffs_staging;

UPDATE layoffs_staging2
SET country = trim(trailing '.' from country)
WHERE country like '%United States%';

SELECT `date`,
str_to_date(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = str_to_date(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
modify column `date` DATE ;

SELECT *
FROM layoffs_staging2
WHERE industry is null
OR industry ='';

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

SELECT lay1.industry, lay2.industry
FROM layoffs_staging2 lay1
JOIN layoffs_staging2 lay2
ON lay1.company = lay2.company
WHERE (lay1.industry IS NULL OR '')
AND lay2.industry IS NOT NULL;

UPDATE layoffs_staging2 lay1
JOIN layoffs_staging2 lay2
ON lay1.company = lay2.company
SET lay1.industry = lay2.industry
WHERE (lay1.industry IS NULL OR '')
AND lay2.industry IS NOT NULL;

DELETE
FROM layoffs_staging2
WHERE percentage_laid_off AND total_laid_off IS NULL;

ALTER TABLE layoffs_staging2
DROP row_num;





 


























