# Employee-Attrition-Analysis-SQL-
SQL | Data Analysis | HR Analytics

## Overview
This project analyzes employee attrition using SQL, focusing on workforce trends, turnover drivers, and employee lifecycle metrics.

## Objectives
- Calculate attrition rate and headcount trends over time
- Identify departments with the highest turnover
- Analyze attrition by tenure and performance
- Evaluate year-over-year changes in attrition
- 
## Techniques Used
- SQL (CTEs, JOINs, aggregations)
- Window functions:
  - LAG() – year-over-year analysis
  - RANK() – ranking business units
  - SUM() OVER() – percentage contribution
- Data cleaning and validation logic
  
## Key Analyses
1. Data Cleaning
Identified inconsistencies in employee status vs exit dates
Created a cleaned view with standardized employment status

2. Headcount & Attrition
Calculated historical and current headcount
Built attrition rate using exits and workforce size

3. Attrition by Business Unit
Compared turnover across departments
Ranked business units by attrition rate

4. Tenure Analysis
Segmented employees into tenure buckets
Identified early attrition patterns

5. Performance vs Attrition
Analyzed whether high-performing employees are more likely to leave
Measured contribution of each performance group to total attrition

6. Year-over-Year Trend
Used LAG() to calculate:
YoY change (percentage points)
YoY growth (%)
