# Βλεπουμε τα δεδομενα του πινακα layoffs
Select * From layoffs;

# Φτιαχνουμε εναν πινακα με ονομα layoffs_staging οπου θα εχει τα
# ιδια δεδομενα, αλλα θα μπορουμε να κανουμε διαφορες ενεργειες
# χωρις να φοβομαστε για λαθη
Create Table layoffs_staging
Like layoffs;

# Αντιγραφουμε τα δεδομενα του πινακα layoffs
Insert layoffs_staging
Select * From layoffs;

# Βλεπουμε αν ολα πηγαν καλα -- Ολα πηγαν καλα
Select * From layoffs_staging;

# Αρχικα θελουμε να βρουμε αν υπαρχουν εγγραφες ιδιες πολλαπλες φορες
With dublicate_cte As (
Select* ,
Row_Number() Over(
partition by company, location, industry, total_laid_off,`date`,
stage,country,funds_raised_millions) As row_num
From layoffs_staging
)

Select *
From dublicate_cte 
Where row_num>1;

# Βλεπουμε οτι υπαρχουν δυο εγγραφες της εταιρειας E Inc.
# οι δυο εγγραφες εχουν τα ιδια ακριβως στοιχεια 
# αυτο σημαινει οτι θα πρεπει η μια απο τις δυο να διαγραφει.
# Αυτο ειναι ενα απο τα παραδειγματα 
Select * From layoffs_staging Where company Like '%E Inc.%';

# Φτιαχνουμε εναν καινουργιο πινακα με μια παραπανω στηλη 
# Αυτη θα ειναι η στηλη row_num και αυτη θα δειχνει τις διπλες ή παραπανω εγγραφες
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` bigint DEFAULT NULL,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` Int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

# Εισαγωγη η δεδομενων στον πινακα layoff_staging2
# απο τον πινακα layoff_staging
Insert into layoffs_staging2
Select *,
row_number() over(
partition by company, location, industry, total_laid_off,`date`,
stage,country,funds_raised_millions) As row_num
From layoffs_staging;

# Βλεπουμε οτι η εισαγωγη των δεδομενων ηταν επιτυχης 
Select * From layoffs_staging2 ;

# Ψαχνουμε να βρουμε τις εγγραφες που εμφανιζονται 2+ φορες
Select * From layoffs_staging2 where row_num=1;

# Διαγραφη των εγγραφων που εμφανιζονται 2+ φορες
DELETE FROM `world_layoffs`.`layoffs_staging2`
WHERE row_num>1;

# Κανονικοποιηση Δεδομενων
Select Distinct(Trim(company))
From layoffs_staging2;

# Επειδη μπορει τα ονοματα των εταιρειων να εχουν γραφτει με διαφορετικο τροπο 
# πχ Ea games Ea games__
# Θα τριμαρουμε (κοψουμε) τα κενα
Update layoffs_staging2 Set company = Trim(company);
Select * from layoffs_staging2;

# Εδω αν κανουμε μια εξεταση στην βιομηχανια θα δουμε οτι 
# υπαρχουν διαφορετικοι τροποι με τους οποιους γραφουν οι εταιρειες crypto
# θα τα κανουμε ολα να εχουν την απλη ονομασια crypto
# θα γινουν αλλαγες και τυπου crypto industry = crypto
Update layoffs_staging2 Set industry = 'crypto' Where industry Like '%c%r%y%p%t%o%';  
Select * from layoffs_staging2;

# Βλεπουμε οτι οι εγγραφες της χωρας United States γραφονται με δυο τροπους
Select Distinct country from layoffs_staging2;

# Αλλαζουμε αυτα που μοιαζουν με United States σε αυτο ακριβως
# πλεον θα εχουμε μονο μια ξεχωριστη χωρα στις εγγραφες
Update layoffs_staging2 Set country = 'United States' Where country Like '%United%States%'; 
Select Distinct country From layoffs_staging2;

# Μπορουμε να αλλαξουμε την μορφη των ημερομηνιων
Select `date`, STR_TO_DATE(`date`,'%m/%d/%Y') From layoffs_staging2;

# Κανοντας update τον πινακα πλεον θα εχουμε ημερομηνιες τυπου YYYYY-DD-MM  
Update layoffs_staging2 Set `date`= STR_TO_DATE(`date`,'%m/%d/%Y');
Select * from layoffs_staging2;

# Βρισκοντας τις Null ή Ελλειπεις τιμες
Select * From layoffs_staging2 where company Is Null Or location Is Null Or industry Is Null Or total_laid_off Is Null Or `date` Is Null Or
stage Is Null Or country Is Null Or funds_raised_millions Is Null ;

# Ειδαμε οτι στο industry υπαρχουν Null και Ελλειπεις τιμες
Select * From layoffs_staging2 where industry Is Null Or industry = '';

# Θα ψαξουμε αν υπαρχουν οι ιδιες εταιρειες με εγγραφες που να περιλαμβανεται το industry
# Αρχικα θα αλλαξουμε τις τιμες ' ' σε Null
Update layoffs_staging2 Set industry = Null 
Where industry = '';

Update layoffs_staging2 t1 Join layoffs_staging2 t2 
On t1.company = t2.company
Set t1.industry = t2.industry  
Where t1.industry Is Null And t2.industry Is Not Null ;

# Ψαχνουμε ξανα στο industry αν υπαρχουν Null και Ελλειπεις τιμες
Select * From layoffs_staging2 where industry Is Null Or industry = '';

# Βλεπουμε οτι υπαρχει η εταιρεια Bally's Interactive 
# η οποια εχει industry = Null σε τεσσερεις εγγραφες
 Select * From layoffs_staging2 where company Like 'Amazon%';

 # Βλεπουμε οτι ολες οι εγγραφες της εταιρειας ειναι στο industry και
 # στο total_laid_off ισες με Null
 # Αυτο σημαινει οτι ειναι μια εγγραφη που δεν μπορουμε να χρησιμοποιησουμε
 # Οποτε θα διαγραψουμε τις εγγραφες της εταιρειας 'Bally''s Interactive'
 Delete From layoffs_staging2 where company Like 'Bally%';

# Βλεπουμε αν υπαρχουν εταιρειες που εχουν NULL στο total_laid_off και στο percentage_laid_off
# Ψαχνουμε επισης την περιπτωση κενων τιμων ' ' 
Select * From layoffs_staging2 
where (
(total_laid_off = ' ' And percentage_laid_off = ' ' ) 
Or 
(total_laid_off Is Null And percentage_laid_off Is Null )
);

# Βλεπουμε οτι υπαρχlayoffsουν εταιρειες που εχουν NULL στο total_laid_off και στο percentage_laid_off
# Οποτε θα διαγραψουμε αυτες τις εγγραφες
Delete From layoffs_staging2 
where (
(total_laid_off = ' ' And percentage_laid_off = ' ' ) 
Or 
(total_laid_off Is Null And percentage_laid_off Is Null )
);

# Διαγραφουμε την πλεον αχρεαιστη στηλη row_num
Alter Table layoffs_staging2
Drop Column row_num ;

# Βλεπουμε τα καθαρισμενα πλεον δεδομενα τα οποια μπορουμε να χρησιμοποιησουμε
Select * From layoffs_staging2;

# Εδώ βρίσκουμε την ελάχιστη και μέγιστη ημερομηνία των καταγραφών, 
# για να δούμε τη χρονική διάρκεια των δεδομένων.
Select Min(`date`),Max(`date`) From layoffs_staging2;

# Το query αυτό υπολογίζει τον συνολικό αριθμό των απολύσεων για 
# κάθε εταιρεία και τις αντίστοιχες ημερομηνίες της πρώτης και 
# τελευταίας απόλυσης. 
# Τα αποτελέσματα ταξινομούνται με βάση τον συνολικό αριθμό απολύσεων
# σε φθίνουσα σειρά.
Select company, Sum(total_laid_off), Min(`date`),Max(`date`)
From layoffs_staging2  
Group By company
Order By 2 Desc;

# Αυτό το query συγκεντρώνει τις απολύσεις ανά βιομηχανία και εμφανίζει
# τις ημερομηνίες της πρώτης και τελευταίας απόλυσης για κάθε βιομηχανία.
# Ταξινόμηση γίνεται επίσης βάσει του συνολικού αριθμού απολύσεων.
Select industry, Sum(total_laid_off), Min(`date`),Max(`date`)
From layoffs_staging2  
Group By industry
Order By 2 Desc;

#Το query αυτό συγκεντρώνει τις απολύσεις για κάθε εταιρεία 
# ανά έτος και τις ταξινομεί με βάση το έτος σε φθίνουσα σειρά.
Select company, Sum(total_laid_off), Year(`date`)
From layoffs_staging2  
Group By company,Year(`date`)
Order By 3 Desc;

# Χρησιμοποιούμε μια CTE (Common Table Expression) για να συγκεντρώσουμε τα δεδομένα απολύσεων
# για κάθε εταιρεία ανά έτος. Η CTE ονομάζεται Company_Year και επιστρέφει τρεις στήλες:
# το όνομα της εταιρείας, το έτος των απολύσεων και το συνολικό αριθμό απολύσεων για κάθε έτος.

# Στην επόμενη CTE, που ονομάζεται Company_Year_Rank, χρησιμοποιούμε τη συνάρτηση
# Dense_Rank() για να κατατάξουμε κάθε εταιρεία με βάση τον αριθμό απολύσεων για κάθε έτος.
# Η κατάταξη αυτή γίνεται για κάθε έτος ξεχωριστά (Partition By years), και η ταξινόμηση
# γίνεται κατά φθίνουσα σειρά των απολύσεων (Order By total_laid_off Desc).
WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_staging2
  GROUP BY company, YEAR(date)
)
, Company_Year_Rank AS (
  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 5
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;
# Στο τελικό ερώτημα, επιλέγουμε όλες τις εταιρείες από το Company_Year_Rank
# που ανήκουν στις 5 εταιρείες με τις περισσότερες απολύσεις για κάθε έτος 
# (Ranking <= 5).

# Επειδη υπαρχουν Null ημερομηνιες 
# θα διαγραψουμε αυτες τις εγγραφες
Select * From layoffs_staging2 Where date Is Null;
Delete From layoffs_staging2 Where date Is Null;

# Βήμα 1: Προσθέτουμε τη νέα στήλη `year` στον πίνακα cleaned_table
# Η στήλη αυτή θα αποθηκεύει το έτος που εξάγεται από την ημερομηνία (date)
ALTER TABLE layoffs_staging2
ADD COLUMN year INT;

# Βήμα 2: Ενημερώνουμε τη στήλη `year` ώστε να περιέχει μόνο το έτος από την στήλη date
# Χρησιμοποιούμε τη συνάρτηση STR_TO_DATE για να μετατρέψουμε τη στήλη `date` σε format ημερομηνίας
# και στη συνέχεια εξάγουμε το έτος χρησιμοποιώντας τη συνάρτηση YEAR.
UPDATE layoffs_staging2
SET year = YEAR(STR_TO_DATE(date, '%Y-%m-%d'));
