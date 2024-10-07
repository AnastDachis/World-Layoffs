# World-Layoffs
Analyzed &amp; cleaned layoff data from layoffs.csv, then visualized insights using Power BI for interactive trend analysis and reporting.

## Data Cleaning & Normalization:

The raw layoffs.csv dataset contained inconsistencies such as extra spaces, inconsistent company and country names, and missing values.
Using SQL queries, I standardized the dataset by:
- Trimming spaces in company names and ensuring consistent country formats.
- Replacing null and missing industry fields.
- Removing duplicate and irrelevant rows (e.g., records with missing values for key fields like total layoffs).
- Normalizing date formats and extracting useful fields such as the year.

## Data Aggregation:

Grouped the cleaned data by year, company, industry, and country.
Calculated total layoffs for each group to identify trends and rankings.

## Data Visualization with Power BI:

Developed an interactive Power BI dashboard to present key insights from the cleaned dataset.
