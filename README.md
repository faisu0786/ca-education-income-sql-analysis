# California Education & Income Analytics

## 📌 Project Overview

**California Education & Income Analytics** is a SQL-based data analysis project focused on understanding population patterns in California from **2008 to 2014**.

The analysis explores population distribution across **age, gender, educational attainment, and personal income groups**. SQL techniques were used to compare different years, identify population trends, and extract meaningful insights from the dataset.

---

## 🎯 Project Objectives

* Analyze population trends from 2008 to 2014.
* Study population distribution across different educational attainment levels.
* Analyze population across different personal income groups.
* Compare male and female population across age and education categories.
* Identify year-over-year population changes.
* Compare population patterns between 2008 and 2014.
* Identify highly populated age, gender, education, and income segments.
* Generate meaningful insights using SQL.

---

## 📊 Dataset

The dataset contains **1,060 records** covering the period from **2008 to 2014**.

### Columns

| Column                   | Description                                |
| ------------------------ | ------------------------------------------ |
| `year`                   | Year of the data                           |
| `age`                    | Age group                                  |
| `gender`                 | Gender category                            |
| `educational_attainment` | Education level/category                   |
| `personal_income`        | Personal income category                   |
| `population_count`       | Population count for the given combination |

---

## 🗄️ Database Details

**Database Name:** `california_education_income`

**Table Name:** `ca_education_income`

The project was analyzed using **MySQL**.

---

## 🛠️ Tools & Technologies

* MySQL
* MySQL Workbench
* SQL
* GitHub

---

## 🧠 SQL Concepts Used

The project covers several important SQL concepts:

* SELECT
* WHERE
* GROUP BY
* HAVING
* ORDER BY
* Aggregate Functions
* CASE WHEN
* INNER JOIN
* SELF JOIN
* Window Functions
* `RANK()`
* `DENSE_RANK()`
* `ROW_NUMBER()`
* `LAG()`
* `SUM() OVER()`
* CTEs
* Subqueries
* Date/String Functions
* `SUBSTRING_INDEX()`

---

## 🔍 Analysis Performed

### 1. Year Comparison

Compared population between different years, especially **2008 vs 2014**, to identify population increases and decreases.

### 2. Education Analysis

Analyzed population distribution across educational attainment categories and identified education categories with significant population changes.

### 3. Income Analysis

Studied the population distribution across personal income groups and calculated their percentage share within each year.

### 4. Gender Analysis

Compared male and female population across different years, age groups, education levels, and income categories.

### 5. Age Analysis

Analyzed population distribution across different age groups and identified highly populated age segments.

### 6. Year-over-Year Analysis

Used window functions such as `LAG()` to compare population with the previous year and identify annual changes.

### 7. Ranking Analysis

Used `RANK()`, `DENSE_RANK()`, and `ROW_NUMBER()` to identify top population categories within each year.

### 8. Advanced SQL Analysis

Used CTEs and subqueries to identify:

* Education categories with above-average population.
* Income groups with significant population shares.
* Age and gender combinations with higher average populations.
* Education categories whose 2014 population was above their 2008–2014 average.

---

## 📈 Key Insights

The analysis was used to identify:

* Changes in population distribution between 2008 and 2014.
* Differences in population across education categories.
* Changes in personal income group distribution.
* Population differences between males and females.
* Highly populated age and gender segments.
* Education categories showing consistent increases across multiple years.
* Income categories with a significant share of the population.

> **Note:** Specific numerical insights can be added after finalizing the SQL outputs and validating the results.

---

## 📂 Project Structure

```text
California-Education-Income-Analytics/
│
├── dataset/
│   └── cleaned_CA_Educational_Attainment_Personal_Income_2008-2014.csv
│
├── sql/
│   └── mysql_ca_education_income_questions.sql
│
├── README.md
│
└── presentation/
    └── California_Education_Income_Analytics.pptx
```

---

## 🚀 Project Workflow

```text
Raw Dataset
     ↓
Data Cleaning & Validation
     ↓
MySQL Database
     ↓
SQL Analysis
     ↓
Year / Age / Gender / Education / Income Analysis
     ↓
Insights & Findings
     ↓
Presentation
```

---

## 💡 Conclusion

This project demonstrates how SQL can be used to analyze a multidimensional dataset and identify meaningful patterns in population, education, and income categories.

The project also demonstrates practical use of **JOINs, Window Functions, CTEs, Subqueries, Aggregations, and Conditional Logic** for real-world data analysis.

---

## 👨‍💻 Author

**Md Shah Faishal**
B.Tech – Computer Science & Engineering
Data Analytics Practice Project

