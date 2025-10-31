# MYSQL : Data Cleaning
#### Table Of Contents
- [Project Overview](project-overview)
- [Data Source](Data-source)
- [Tools](Tools)
- [Data Cleaning](Data-cleaning)
- [Data Analysis](Data-analysis)
- [Results](Results)
- [Recommendations](Recommendations)
- [Limitations](Limitations)


  ### Project Overview

   A data analysis project that involes data filtering & cleaning and also data standardization. This data concerns world layoffs from 2020 - 2023.

  ### Data Source

   Layoffs : The dataset used for this analysis is the 'layoffs.csv' file, providing information about layoffs from each company per year & location.

  ### Tools

  MYSQL Server (https://mysql.com)

  ### Data Cleaning

  During the data claning stage, i did the following :
  
  - Filtered and removed duplicates
  - Standardized the data (trimming spaces, checking capitalization)
  - Inspected null/blank values
  - Removed unnecessary rows/colums
 
  ### Data Analysis

  The following are steps taken in "cleaning" the data :
  
  - I created a staging version & inserted data into layoffs_staging. A staging version acts as a mirror of the primary dataset, providing a secure backup to safeguard the      data against accidental data loss or unforeseen change.
  ```
     CREATE TABLE layoffs_staging
     LIKE layoffs;

     INSERT layoffs_staging
     SELECT *
     FROM layoffs;
  ```

  - I needed to identify duplicate records so i assigned row numbers. By assigning a unique row number to each record, I was able to distinguish between original and            duplicate rows.
    ```
    SELECT *,
    ROW_NUMBER() 
    OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
    FROM layoffs_staging;
  

  - Following the creation of the row_num column generated to identify duplicate entries, I created a CTE to isolate only the rows where row_num > 1.
   ```
    WITH DUPLICATE_CTE as 
    (
    SELECT *,
    ROW_NUMBER()
    OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country,  funds_raised_millions) as row_num
    FROM layoffs_staging
    )
    SELECT *
    FROM DUPLICATE_CTE 
    WHERE row_num > 1;
   ```

  - After filtering and displaying the duplicate records using the row_num column, duplicates needed to be removed to ensure a clean and accurate dataset. To actualize          that, I proceeded to create another staging table.
    NOTE : The query below is a default CREATE statement.
 ```
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
```
- Once the staging table was created, i followed the same process in (step 1) to input data & (step 3) to look for duplicates then proceeded to delete duplicate enteries.
  ```
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
  ```
    ### Results
  
  During the data cleaning process, I found duplicate records, different date formats & missing/blank fields. Cleaning the data helped fix all of these issues. Duplicates     were removed, names and formats were made consistent, and missing data was handled carefully. After cleaning, the data was better and could be worked with.

   ### Recommendations
  
  When cleaning a dataset, always create a staging or backup table first. This allows safe experimentation and ensures that raw data is preserved. Check for duplicates on     time using "distint" statement or give each row a "row number". Also, validate data types and ensure that each column uses the correct data type (e.g., dates should not     be stored as text). Convert where necessary to support accurate filtering and analysis.

  ### Limitations
  
  Due to data sourcing at different times and differnt countries, the data isn't accurate as to the number of layoffs around the globe during the said years.
  
  
  

  
