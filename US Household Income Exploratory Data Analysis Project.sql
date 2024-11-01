# Exploratory Analysis of US Household Income Data
# This analysis examines household income data across various dimensions, including state, county, 
# and city levels, as well as by household type.


# First we have two Interesting columns about land and water distribution
# Lets see what the top 10 states in terms of land are

SELECT 
	State_Name,
    SUM(ALand),
    SUM(AWater)
FROM 
	us_household_income
GROUP BY 
	State_Name
ORDER BY 
	2  DESC
LIMIT 10
;

# As expected, Texas has the highest total land area, followed by California

# Now, let's analyze the water data to identify the top 10 states with the largest water areas

SELECT 
	State_Name,
    SUM(ALand),
    SUM(AWater)
FROM 
	us_household_income
GROUP BY 
	State_Name
ORDER BY 
	3  DESC
LIMIT 10
;

# Interestingly, Michigan, Texas, and Florida rank as the top three states with the largest water areas

# Now, we will join the Household Income Statistics table with our income data
# This integration will enrich our analysis by providing additional statistical insights such as Mean, and Median Income
# Exclude rows where the mean income is 0 to maintain the integrity of our aggregations
# This ensures that our analysis focuses only on valid income data

SELECT
	*
FROM
	us_household_income u
    JOIN us_household_income_statistics us ON u.id = us.id
WHERE 
	mean <> 0
;

# Next we will retrieve state names, counties, household types, primary designation, 
# mean, and median income values from the combined household income and statistics data
# Exclude entries with a mean income of 0 to ensure data accuracy for analysis

SELECT
	u.State_Name,
    County,
    Type,
    `Primary`,
    Mean,
    Median
FROM
	us_household_income u
    JOIN us_household_income_statistics us ON u.id = us.id
WHERE 
	mean <> 0
;

# Now, we will identify the top 10 states based on average median income
# The median income values will be rounded for improved readability and conciseness

SELECT
	u.State_Name,
    ROUND(AVG(Mean),1),
    ROUND(AVG(Median),1)
FROM
	us_household_income u
    JOIN us_household_income_statistics us ON u.id = us.id
WHERE 
	mean <> 0
GROUP BY
	u.State_Name
ORDER BY
	3 DESC
LIMIT 10
;

# Surprisingly, Wyoming, Alaska, and Connecticut have the highest median incomes

SELECT
	u.State_Name,
    ROUND(AVG(Mean),1),
    ROUND(AVG(Median),1)
FROM
	us_household_income u
    JOIN us_household_income_statistics us ON u.id = us.id
WHERE 
	mean <> 0
GROUP BY
	u.State_Name
ORDER BY
	3 ASC
LIMIT 10
;

# Puerto Rico, Arkansas, and Mississippi have the lowest median incomes.
# This suggests that land or water area has little to no impact on income levels.

# Next we analyze household income by type, counting the number of entries and calculating
# the average mean and median incomes. The results are grouped by household type,
# filtered to include only types with more than 100 entries, and sorted to show 
# the top 10 types by count.

SELECT
    Type,
    COUNT(Type),
    ROUND(AVG(Mean),1),
    ROUND(AVG(Median),1)
FROM
	us_household_income u
    JOIN us_household_income_statistics us ON u.id = us.id
WHERE 
	mean <> 0
GROUP BY
	Type
HAVING 
	COUNT(Type) > 100
ORDER BY 2 DESC
LIMIT 10
;

# Track is significantly the highest type, exceeding City by more than 27,000 entries.
# In terms of mean income, Borough ranks the highest despite having the lowest count of entries.
# However, the median income tells a different story, with CDP showing the highest median value.


# Identify the top 10 cities with the highest average mean income across each state.
# Group by state and city, count the number of entries per city, and calculate the 
# average mean income, rounded for readability. Exclude cities with a mean income of 0.
# Results are ordered by average mean income in descending order.


SELECT
	u.State_Name,
    City,
    COUNT(City),
    ROUND(AVG(Mean),1)
FROM
	us_household_income u
    JOIN us_household_income_statistics us ON u.id = us.id
WHERE 
	mean <> 0
GROUP BY
	u.State_Name,
    City
ORDER BY 4 DESC
LIMIT 10;

# Notably, Delta Junction, Alaska, shows a very high average mean income, but this is based on a single entry.
# Let's investigate further by searching for other entries with "Delta" in their names using the LIKE operator.

SELECT
	u.State_Name,
    City,
    Mean
FROM
	us_household_income u
    JOIN us_household_income_statistics us ON u.id = us.id
WHERE 
	mean <> 0
    AND City LIKE '%Delta%'
;

# It appears that Delta Junction, Alaska, has only one entry in the dataset.
# This may suggest that its high mean income is not representative of broader trends in the area.

#Summary:

# Integrated household income data with statistics table, excluding entries with mean income of 0 for accuracy.

# Analyzed average mean and median incomes by state to identify highest and lowest income states.
# Findings show Wyoming, Alaska, and Connecticut have the highest medians, while Puerto Rico, Arkansas, and Mississippi are lowest.
# Results suggest limited correlation between income levels and geographic size.

# Grouped data by household type to examine entry counts and average incomes.
# Track has the most entries, while Borough shows the highest mean income. CDP ranks highest in median income, indicating income distribution variation across types.

# Identify top 10 cities by average mean income, with results highlighting Delta Junction, Alaska, as an outlier due to a single high-income entry.
# This may indicate limitations in data representation for smaller regions.



