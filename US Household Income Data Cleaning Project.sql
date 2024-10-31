# Data Cleaning Section of the US Household Income Project
# The following steps will clean and prepare the data for accurate and efficient analysis

SELECT
	*
FROM 
	us_household_income;
    
#First we check for duplicate IDs to ensure each entry represents a unique household
    
 SELECT
	id,
    COUNT(id)
FROM 
	us_household_income
GROUP BY
	id
HAVING
	COUNT(id) > 1;  
    
# next we will identify duplicate records by assigning a row number to each occurrence of an ID
# Using ROW_NUMBER() to partition by ID, we order each ID group and flag duplicates
#  Each row with a row_num > 1 is a duplicate entry

    
 SELECT *
 FROM
(SELECT
	row_id,
    id,
    ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num
FROM
	us_household_income) AS bb
WHERE row_num > 1
;

# After ensuring the rows with duplicate IDs are duplicates, we drop them from the table

DELETE FROM us_household_income
WHERE row_id IN (
 SELECT row_id
 FROM
(SELECT
	row_id,
    id,
    ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num
FROM
	us_household_income) AS bb
WHERE row_num > 1);

# Check for inconsistencies in state names by counting each unique entry
# This will help identify any potential spelling irregularities or formatting issues

SELECT
	State_Name,
    COUNT(State_Name)
FROM 
	us_household_income
GROUP BY
	State_Name;
    
# Now we will update the formatting issues we found
 
UPDATE us_household_income
SET State_name = 'Georgia'
WHERE State_Name = 'georia';


UPDATE us_household_income
SET State_name = 'Alabama'
WHERE State_Name = 'alabama';


UPDATE us_household_income
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
AND City = 'Vinemont';


UPDATE us_household_income
SET Type = 'Borough'
WHERE Type = 'Boroughs';

# Data is now cleaned and ready for analysis, ensuring accuracy and consistency across all fields



