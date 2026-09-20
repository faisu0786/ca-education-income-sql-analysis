/*
======================================================================
MYSQL DATA ANALYTICS PROJECT — QUESTIONS ONLY
California Educational Attainment & Personal Income (2008-2014)
======================================================================*/

/*
======================================================================
Table: ca_education_income

Columns:
`Year`, `Age`, `Gender`, `Educational Attainment`,
`Personal Income`, `Population Count`

MySQL 8.0+
Focus: JOINs / SELF JOINs, Window Functions, CTEs, Subqueries
Measure: Population Count
======================================================================

/*
======================================================================
Q1. Compare 2008 and 2014 population for every combination of Age,
Gender, Educational Attainment and Personal Income. Show population
in both years and the change.
======================================================================*/
SELECT
    a.age,
    a.gender,
    a.educational_attainment,
    a.personal_income,
    a.population_count AS population_2008,
    b.population_count AS population_2014,
    b.population_count - a.population_count AS population_change
FROM ca_education_income a
JOIN ca_education_income b
    ON a.age = b.age
    AND a.gender = b.gender
    AND a.educational_attainment = b.educational_attainment
    AND a.personal_income = b.personal_income
WHERE SUBSTRING_INDEX(a.year, '/', -1) = '2008'
    AND SUBSTRING_INDEX(b.year, '/', -1) = '2014';
    
/*
======================================================================    
Q2. Find demographic segments whose population increased by more than
10,000 people between 2008 and 2014. Use a SELF JOIN.
======================================================================*/
SELECT
    a.age,
    a.gender,
    a.educational_attainment,
    a.personal_income,
    a.population_count AS population_2008,
    b.population_count AS population_2014,
    b.population_count - a.population_count AS population_increase
FROM ca_education_income a
JOIN ca_education_income b
    ON a.age = b.age
    AND a.gender = b.gender
    AND a.educational_attainment = b.educational_attainment
    AND a.personal_income = b.personal_income
WHERE SUBSTRING_INDEX(a.year, '/', -1) = '2008'
    AND SUBSTRING_INDEX(b.year, '/', -1) = '2014'
    AND b.population_count - a.population_count > 10000;

/*
======================================================================
Q3. Compare the population for each Gender + Educational Attainment
combination between 2008 and 2014, aggregating across Age and
Personal Income.
======================================================================*/
SELECT
    a.gender,
    a.educational_attainment,
    SUM(a.population_count) AS population_2008,
    SUM(b.population_count) AS population_2014,
    SUM(b.population_count) - SUM(a.population_count) AS population_change
FROM ca_education_income a
JOIN ca_education_income b
    ON a.age = b.age
    AND a.gender = b.gender
    AND a.educational_attainment = b.educational_attainment
    AND a.personal_income = b.personal_income
WHERE SUBSTRING_INDEX(a.year, '/', -1) = '2008'
    AND SUBSTRING_INDEX(b.year, '/', -1) = '2014'
GROUP BY
    a.gender,
    a.educational_attainment;

/*
======================================================================
Q4. Compare Male and Female population for each Educational Attainment
and Personal Income combination in 2014. Show the gender difference.
======================================================================*/
SELECT
    a.educational_attainment,
    a.personal_income,
    a.population_count AS male_population,
    b.population_count AS female_population,
    a.population_count - b.population_count AS gender_difference
FROM ca_education_income a
JOIN ca_education_income b
    ON a.educational_attainment = b.educational_attainment
    AND a.personal_income = b.personal_income
WHERE SUBSTRING_INDEX(a.year, '/', -1) = '2014'
    AND SUBSTRING_INDEX(b.year, '/', -1) = '2014'
    AND a.gender = 'Male'
    AND b.gender = 'Female';
/*
======================================================================
Q5. Compare 2013 and 2014 population for every Age + Gender segment,
aggregating across Education and Income. Find segments that declined.
======================================================================*/
SELECT
    a.age,
    a.gender,
    SUM(a.population_count) AS population_2013,
    SUM(b.population_count) AS population_2014,
    SUM(b.population_count) - SUM(a.population_count) AS population_change
FROM ca_education_income a
JOIN ca_education_income b
    ON a.age = b.age
    AND a.gender = b.gender
    AND a.educational_attainment = b.educational_attainment
    AND a.personal_income = b.personal_income
WHERE SUBSTRING_INDEX(a.year, '/', -1) = '2013'
    AND SUBSTRING_INDEX(b.year, '/', -1) = '2014'
GROUP BY
    a.age,
    a.gender
HAVING SUM(b.population_count) < SUM(a.population_count);
/*
======================================================================
Q6. For each Personal Income band, compare total population in 2008
versus 2014, aggregating across Age, Gender and Education.
======================================================================*/
SELECT
    a.personal_income,
    SUM(a.population_count) AS population_2008,
    SUM(b.population_count) AS population_2014,
    SUM(b.population_count) - SUM(a.population_count) AS population_change
FROM ca_education_income a
JOIN ca_education_income b
    ON a.age = b.age
    AND a.gender = b.gender
    AND a.educational_attainment = b.educational_attainment
    AND a.personal_income = b.personal_income
WHERE SUBSTRING_INDEX(a.year, '/', -1) = '2008'
    AND SUBSTRING_INDEX(b.year, '/', -1) = '2014'
GROUP BY
    a.personal_income;
/*
======================================================================
Q7. Rank Educational Attainment categories by total population within
each year using RANK().
======================================================================*/
SELECT
    SUBSTRING_INDEX(year, '/', -1) AS year,
    educational_attainment,
    SUM(population_count) AS total_population,
    RANK() OVER (
        PARTITION BY SUBSTRING_INDEX(year, '/', -1)
        ORDER BY SUM(population_count) DESC
    ) AS population_rank
FROM ca_education_income
GROUP BY
    SUBSTRING_INDEX(year, '/', -1),
    educational_attainment;
/*
======================================================================
Q8. Rank Personal Income bands by population within each year using
DENSE_RANK().
======================================================================*/
SELECT
    SUBSTRING_INDEX(year, '/', -1) AS year,
    personal_income,
    SUM(population_count) AS total_population,
    DENSE_RANK() OVER (
        PARTITION BY SUBSTRING_INDEX(year, '/', -1)
        ORDER BY SUM(population_count) DESC
    ) AS population_rank
FROM ca_education_income
GROUP BY
    SUBSTRING_INDEX(year, '/', -1),
    personal_income;
/*
======================================================================
Q9. Find the top 3 Educational Attainment categories by population
for every year using ROW_NUMBER().
======================================================================*/
SELECT
    year,
    educational_attainment,
    total_population,
    population_rank
FROM (
    SELECT
        SUBSTRING_INDEX(year, '/', -1) AS year,
        educational_attainment,
        SUM(population_count) AS total_population,
        ROW_NUMBER() OVER (
            PARTITION BY SUBSTRING_INDEX(year, '/', -1)
            ORDER BY SUM(population_count) DESC
        ) AS population_rank
    FROM ca_education_income
    GROUP BY
        SUBSTRING_INDEX(year, '/', -1),
        educational_attainment
) a
WHERE population_rank <= 3;
/*
======================================================================
Q10. Calculate previous-year population for every Gender +
Educational Attainment combination using LAG(), and calculate the
population change.
======================================================================*/
SELECT
    year,
    gender,
    educational_attainment,
    total_population,
    LAG(total_population) OVER (
        PARTITION BY gender, educational_attainment
        ORDER BY year
    ) AS previous_population,
    total_population - LAG(total_population) OVER (
        PARTITION BY gender, educational_attainment
        ORDER BY year
    ) AS population_change
FROM (
    SELECT
        SUBSTRING_INDEX(year, '/', -1) AS year,
        gender,
        educational_attainment,
        SUM(population_count) AS total_population
    FROM ca_education_income
    GROUP BY
        SUBSTRING_INDEX(year, '/', -1),
        gender,
        educational_attainment
) a;
/*
======================================================================
Q11. Calculate year-over-year population growth percentage for every
Age + Gender combination using LAG().
======================================================================*/
SELECT
    year,
    age,
    gender,
    total_population,
    LAG(total_population) OVER (
        PARTITION BY age, gender
        ORDER BY year
    ) AS previous_population,
    ROUND(
        (total_population - LAG(total_population) OVER (
            PARTITION BY age, gender
            ORDER BY year
        )) / LAG(total_population) OVER (
            PARTITION BY age, gender
            ORDER BY year
        ) * 100,
        2
    ) AS growth_percentage
FROM (
    SELECT
        SUBSTRING_INDEX(year, '/', -1) AS year,
        age,
        gender,
        SUM(population_count) AS total_population
    FROM ca_education_income
    GROUP BY
        SUBSTRING_INDEX(year, '/', -1),
        age,
        gender
) a;
/*
======================================================================
Q12. Calculate cumulative population for each Educational Attainment
category from 2008 through 2014.
======================================================================*/
SELECT
    year,
    educational_attainment,
    total_population,
    SUM(total_population) OVER (
        PARTITION BY educational_attainment
        ORDER BY year
    ) AS cumulative_population
FROM (
    SELECT
        SUBSTRING_INDEX(year, '/', -1) AS year,
        educational_attainment,
        SUM(population_count) AS total_population
    FROM ca_education_income
    GROUP BY
        SUBSTRING_INDEX(year, '/', -1),
        educational_attainment
) a;
/*
======================================================================
Q13. Calculate each Personal Income band's percentage share of total
population within each year.
======================================================================*/
SELECT
    year,
    personal_income,
    total_population,
    ROUND(
        total_population /
        SUM(total_population) OVER (PARTITION BY year) * 100,
        2
    ) AS percentage_share
FROM (
    SELECT
        SUBSTRING_INDEX(year, '/', -1) AS year,
        personal_income,
        SUM(population_count) AS total_population
    FROM ca_education_income
    GROUP BY
        SUBSTRING_INDEX(year, '/', -1),
        personal_income
) a;
/*
======================================================================
Q14. For every year, identify the most populated Gender + Age segment
using ROW_NUMBER().
======================================================================*/
SELECT
    year,
    gender,
    age,
    total_population
FROM (
    SELECT
        SUBSTRING_INDEX(year, '/', -1) AS year,
        gender,
        age,
        SUM(population_count) AS total_population,
        ROW_NUMBER() OVER (
            PARTITION BY SUBSTRING_INDEX(year, '/', -1)
            ORDER BY SUM(population_count) DESC
        ) AS population_rank
    FROM ca_education_income
    GROUP BY
        SUBSTRING_INDEX(year, '/', -1),
        gender,
        age
) a
WHERE population_rank = 1;
/*
======================================================================
Q15. Find the year in which each Educational Attainment category had
its highest population.
======================================================================*/
SELECT
    year,
    educational_attainment,
    total_population
FROM (
    SELECT
        SUBSTRING_INDEX(year, '/', -1) AS year,
        educational_attainment,
        SUM(population_count) AS total_population,
        ROW_NUMBER() OVER (
            PARTITION BY educational_attainment
            ORDER BY SUM(population_count) DESC
        ) AS population_rank
    FROM ca_education_income
    GROUP BY
        SUBSTRING_INDEX(year, '/', -1),
        educational_attainment
) a
WHERE population_rank = 1;
/*
======================================================================
Q16. Compare each year's total population with the previous year using
LAG(), and identify the largest annual increase.
======================================================================*/
SELECT
    year,
    total_population,
    previous_population,
    total_population - previous_population AS population_increase
FROM (
    SELECT
        year,
        total_population,
        LAG(total_population) OVER (
            ORDER BY year
        ) AS previous_population
    FROM (
        SELECT
            SUBSTRING_INDEX(year, '/', -1) AS year,
            SUM(population_count) AS total_population
        FROM ca_education_income
        GROUP BY SUBSTRING_INDEX(year, '/', -1)
    ) a
) b
ORDER BY population_increase DESC
LIMIT 1;
/*
======================================================================
Q17. Using CTEs, calculate total population by year and classify each
year as High Population or Low Population based on the overall average.
======================================================================*/
WITH yearly_population AS (
    SELECT
        SUBSTRING_INDEX(year, '/', -1) AS year,
        SUM(population_count) AS total_population
    FROM ca_education_income
    GROUP BY SUBSTRING_INDEX(year, '/', -1)
),
average_population AS (
    SELECT
        AVG(total_population) AS overall_average
    FROM yearly_population
)
SELECT
    yearly_population.year,
    yearly_population.total_population,
    CASE
        WHEN yearly_population.total_population > average_population.overall_average
            THEN 'High Population'
        ELSE 'Low Population'
    END AS population_category
FROM yearly_population
CROSS JOIN average_population;
/*
======================================================================
Q18. Using CTEs, calculate Educational Attainment population in 2008
and 2014 and return the top 5 categories by absolute change.
======================================================================*/
WITH education_population AS (
    SELECT
        educational_attainment,
        SUBSTRING_INDEX(year, '/', -1) AS year,
        SUM(population_count) AS total_population
    FROM ca_education_income
    WHERE SUBSTRING_INDEX(year, '/', -1) IN ('2008', '2014')
    GROUP BY
        educational_attainment,
        SUBSTRING_INDEX(year, '/', -1)
),
education_change AS (
    SELECT
        educational_attainment,
        SUM(CASE WHEN year = '2008' THEN total_population ELSE 0 END) AS population_2008,
        SUM(CASE WHEN year = '2014' THEN total_population ELSE 0 END) AS population_2014
    FROM education_population
    GROUP BY educational_attainment
)
SELECT
    educational_attainment,
    population_2008,
    population_2014,
    population_2014 - population_2008 AS population_change,
    ABS(population_2014 - population_2008) AS absolute_change
FROM education_change
ORDER BY absolute_change DESC
LIMIT 5;
/*
======================================================================
Q19. Using CTEs, calculate population by Gender and Year and find which
gender had the larger population in each year.
======================================================================*/
WITH gender_population AS (
    SELECT
        SUBSTRING_INDEX(year, '/', -1) AS year,
        gender,
        SUM(population_count) AS total_population
    FROM ca_education_income
    GROUP BY
        SUBSTRING_INDEX(year, '/', -1),
        gender
)
SELECT
    year,
    SUM(CASE WHEN gender = 'Male' THEN total_population ELSE 0 END) AS male_population,
    SUM(CASE WHEN gender = 'Female' THEN total_population ELSE 0 END) AS female_population,
    CASE
        WHEN SUM(CASE WHEN gender = 'Male' THEN total_population ELSE 0 END)
             >
             SUM(CASE WHEN gender = 'Female' THEN total_population ELSE 0 END)
        THEN 'Male'
        ELSE 'Female'
    END AS larger_gender
FROM gender_population
GROUP BY year
ORDER BY year;
/*
======================================================================
Q20. Using CTEs, calculate average annual population for each Age group
and identify the Age group with the highest average.
======================================================================*/
WITH age_population AS (
    SELECT
        age,
        SUM(population_count) AS total_population
    FROM ca_education_income
    GROUP BY age
),
age_average AS (
    SELECT
        age,
        total_population / 7 AS average_population
    FROM age_population
)
SELECT
    age,
    average_population
FROM age_average
ORDER BY average_population DESC
LIMIT 1;
/*
======================================================================
Q21. Using CTEs, identify Educational Attainment categories whose
population increased in at least 4 of the 6 year-to-year transitions.
======================================================================*/
WITH education_population AS (
    SELECT
        SUBSTRING_INDEX(year, '/', -1) AS year,
        educational_attainment,
        SUM(population_count) AS total_population
    FROM ca_education_income
    GROUP BY
        SUBSTRING_INDEX(year, '/', -1),
        educational_attainment
),
yearly_change AS (
    SELECT
        educational_attainment,
        year,
        total_population,
        LAG(total_population) OVER (
            PARTITION BY educational_attainment
            ORDER BY year
        ) AS previous_population
    FROM education_population
),
increase_count AS (
    SELECT
        educational_attainment,
        SUM(
            CASE
                WHEN total_population > previous_population THEN 1
                ELSE 0
            END
        ) AS increase_years
    FROM yearly_change
    GROUP BY educational_attainment
)
SELECT
    educational_attainment,
    increase_years
FROM increase_count
WHERE increase_years >= 4
ORDER BY increase_years DESC;
/*
======================================================================
Q22. Using CTEs, calculate the average yearly population share of each
Personal Income band and find bands whose average share exceeds 10%.
======================================================================*/
WITH income_population AS (
    SELECT
        SUBSTRING_INDEX(year, '/', -1) AS year,
        personal_income,
        SUM(population_count) AS income_population
    FROM ca_education_income
    GROUP BY
        SUBSTRING_INDEX(year, '/', -1),
        personal_income
),
yearly_share AS (
    SELECT
        year,
        personal_income,
        income_population,
        income_population /
        SUM(income_population) OVER (PARTITION BY year) * 100
        AS population_share
    FROM income_population
),
average_share AS (
    SELECT
        personal_income,
        AVG(population_share) AS average_yearly_share
    FROM yearly_share
    GROUP BY personal_income
)
SELECT
    personal_income,
    ROUND(average_yearly_share, 2) AS average_yearly_share
FROM average_share
WHERE average_yearly_share > 10
ORDER BY average_yearly_share DESC;
/*
======================================================================
Q23. Find Educational Attainment categories whose 2014 population was
greater than the average 2014 population across all education categories.
Use a subquery.
======================================================================*/
SELECT
    educational_attainment,
    SUM(population_count) AS population_2014
FROM ca_education_income
WHERE SUBSTRING_INDEX(year, '/', -1) = '2014'
GROUP BY educational_attainment
HAVING SUM(population_count) > (
    SELECT AVG(total_population)
    FROM (
        SELECT
            educational_attainment,
            SUM(population_count) AS total_population
        FROM ca_education_income
        WHERE SUBSTRING_INDEX(year, '/', -1) = '2014'
        GROUP BY educational_attainment
    ) a
)
ORDER BY population_2014 DESC;
/*
======================================================================
Q24. Find Personal Income bands whose 2014 population was greater than
the average income-band population in 2014. Use a subquery.
======================================================================*/
SELECT
    personal_income,
    SUM(population_count) AS population_2014
FROM ca_education_income
WHERE SUBSTRING_INDEX(year, '/', -1) = '2014'
GROUP BY personal_income
HAVING SUM(population_count) > (
    SELECT AVG(total_population)
    FROM (
        SELECT
            personal_income,
            SUM(population_count) AS total_population
        FROM ca_education_income
        WHERE SUBSTRING_INDEX(year, '/', -1) = '2014'
        GROUP BY personal_income
    ) a
)
ORDER BY population_2014 DESC;
/*
======================================================================
Q25. Find the most populated Age + Gender combination in 2014 using
a subquery.
======================================================================*/
SELECT
    age,
    gender,
    SUM(population_count) AS population_2014
FROM ca_education_income
WHERE SUBSTRING_INDEX(year, '/', -1) = '2014'
GROUP BY age, gender
HAVING SUM(population_count) = (
    SELECT MAX(total_population)
    FROM (
        SELECT
            age,
            gender,
            SUM(population_count) AS total_population
        FROM ca_education_income
        WHERE SUBSTRING_INDEX(year, '/', -1) = '2014'
        GROUP BY age, gender
    ) a
);
/*
======================================================================
Q26. Find the second-highest Educational Attainment category by
population in 2014 using subqueries.
======================================================================*/
SELECT
    educational_attainment,
    SUM(population_count) AS population_2014
FROM ca_education_income
WHERE SUBSTRING_INDEX(year, '/', -1) = '2014'
GROUP BY educational_attainment
HAVING SUM(population_count) = (
    SELECT MAX(total_population)
    FROM (
        SELECT
            educational_attainment,
            SUM(population_count) AS total_population
        FROM ca_education_income
        WHERE SUBSTRING_INDEX(year, '/', -1) = '2014'
        GROUP BY educational_attainment
    ) a
    WHERE total_population < (
        SELECT MAX(total_population)
        FROM (
            SELECT
                educational_attainment,
                SUM(population_count) AS total_population
            FROM ca_education_income
            WHERE SUBSTRING_INDEX(year, '/', -1) = '2014'
            GROUP BY educational_attainment
        ) b
    )
);
/*
======================================================================
Q27. Find Age + Gender combinations whose average annual population
from 2008-2014 is above the overall average annual population across
all Age + Gender combinations.
======================================================================*/
SELECT
    age,
    gender,
    AVG(total_population) AS average_annual_population
FROM (
    SELECT
        age,
        gender,
        SUBSTRING_INDEX(year, '/', -1) AS year,
        SUM(population_count) AS total_population
    FROM ca_education_income
    GROUP BY
        age,
        gender,
        SUBSTRING_INDEX(year, '/', -1)
) a
GROUP BY age, gender
HAVING AVG(total_population) > (
    SELECT AVG(total_population)
    FROM (
        SELECT
            age,
            gender,
            SUBSTRING_INDEX(year, '/', -1) AS year,
            SUM(population_count) AS total_population
        FROM ca_education_income
        GROUP BY
            age,
            gender,
            SUBSTRING_INDEX(year, '/', -1)
    ) b
)
ORDER BY average_annual_population DESC;
/*
======================================================================
Q28. Find Educational Attainment categories whose 2014 population was
higher than their own average population across 2008-2014.
======================================================================*/
SELECT
    educational_attainment,
    population_2014,
    average_population
FROM (
    SELECT
        educational_attainment,
        SUM(CASE
            WHEN year = '2014'
            THEN total_population
            ELSE 0
        END) AS population_2014,
        AVG(total_population) AS average_population
    FROM (
        SELECT
            educational_attainment,
            SUBSTRING_INDEX(year, '/', -1) AS year,
            SUM(population_count) AS total_population
        FROM ca_education_income
        GROUP BY
            educational_attainment,
            SUBSTRING_INDEX(year, '/', -1)
    ) a
    GROUP BY educational_attainment
) b
WHERE population_2014 > average_population
ORDER BY population_2014 DESC;