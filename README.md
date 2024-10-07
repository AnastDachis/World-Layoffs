# World-Layoffs
Analyzed &amp; cleaned layoff data from layoffs.csv, then visualized insights using Power BI for interactive trend analysis and reporting.

### Data Cleaning & Normalization:

The raw layoffs.csv dataset contained inconsistencies such as extra spaces, inconsistent company and country names, and missing values.
Using SQL queries, I standardized the dataset by:
- Trimming spaces in company names and ensuring consistent country formats.
- Replacing null and missing industry fields.
- Removing duplicate and irrelevant rows (e.g., records with missing values for key fields like total layoffs).
- Normalizing date formats and extracting useful fields such as the year.

### Data Aggregation:

Grouped the cleaned data by year, company, industry, and country.
Calculated total layoffs for each group to identify trends and rankings.

### Data Visualization with Power BI:

Developed an interactive Power BI dashboard to present key insights from the cleaned dataset.

### Result

The final result is showcased in the "Layoffs Table Page 1.pdf." Pages 2 and 3 illustrate how the map can be used to select a country, displaying detailed data such as the number of employees laid off, the industries affected, and the specific towns involved.

### Layoffs by country : 

- United States (the highest laid off numbers) :
In 2020, 50,385 employees in industries like transportation, retail, consumer, travel, and real estate were laid off. These numbers illustrate the severe economic challenges brought on by the pandemic. As the pandemic stretched into 2021, the layoff patterns remained consistent, with the real estate, construction, and food sectors showing the highest layoffs, while retail continued to be significantly affected.

- India had significant layoffs as well, with 14,224 in 2022 and 12,932 in 2020.
  
- Other countries like Sweden, the Netherlands, Brazil, and Germany also show notable layoffs, particularly in 2023.


### Layoffs by Industry:
There is a broad distribution of layoffs across various industries. The top sectors with the highest number of layoffs include consumer retail, finance, healthcare, and transportation. These layoffs are directly connected to the impact of the COVID-19 pandemic, which caused significant disruptions in these industries, leading to workforce reductions due to restrictions, shifts in demand, and overall economic uncertainty.

### Layoffs by City:
The San Francisco Bay Area dominates with the highest layoffs among locations, followed by Seattle, New York City, Bengaluru, and Amsterdam.

### Layoffs by Year:
The data for layoffs by year shows that 2022 and 2023 experienced significantly higher layoffs than previous years.
