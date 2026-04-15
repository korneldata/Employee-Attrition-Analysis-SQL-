# Employee-Attrition-Analysis-SQL-
SQL | Data Analysis | HR Analytics

## Project Structure
- `01_data_cleaning.sql` – data cleaning and validation  
- `02_headcount.sql` – headcount calculations  
- `03_attrition_rate.sql` – overall attrition rate  
- `04_attrition_by_business_unit.sql` – attrition by business unit  
- `05_tenure_analysis.sql` – tenure-based attrition  
- `06_performance_attrition.sql` – performance vs attrition  
- `07_attrition_yoy.sql` – year-over-year trend analysis  

## Overview
This project analyzes employee attrition using SQL, focusing on workforce trends, turnover drivers, and employee lifecycle metrics.

## Objectives
- Calculate attrition rate and headcount trends over time
- Identify departments with the highest turnover
- Analyze attrition by tenure and performance
- Evaluate year-over-year changes in attrition
  
## Techniques Used
- SQL (CTEs, JOINs, aggregations)
- Window functions:
  - LAG() – year-over-year analysis
  - RANK() – ranking business units
  - SUM() OVER() – percentage contribution
- Data cleaning and validation logic
  
## Key Analyses
1. Data Cleaning
- Identified inconsistencies in employee status vs exit dates
- Created a cleaned view with standardized employment status
- All analyses are based on a cleaned dataset created in `01_data_cleaning.sql` as a view: `employee_clean_vw`.

2. Headcount & Attrition
- Calculated historical and current headcount
- Built attrition rate using exits and workforce size

3. Attrition by Business Unit
- Compared turnover across departments
- Ranked business units by attrition rate

4. Tenure Analysis
- Segmented employees into tenure buckets
- Identified early attrition patterns

5. Performance vs Attrition
- Analyzed whether high-performing employees are more likely to leave
- Measured contribution of each performance group to total attrition

6. Year-over-Year Trend
- Used LAG() to calculate:
- YoY change (percentage points)
- YoY growth (%)

## Key Insights
1. Early-stage attrition is the highest

Employees with tenure below 1 year show the highest attrition rates, indicating potential issues with onboarding, role expectations, or early engagement.

2. Attrition varies significantly across business units

Certain business units consistently rank higher in attrition, suggesting structural or managerial differences that may require targeted intervention.

3. A large share of exits comes from specific segments

Analysis of exit contribution shows that a disproportionate percentage of total attrition is driven by a small number of segments (e.g., specific performance or tenure groups).

4. Performance-based differences in attrition

Attrition rates differ across performance groups, providing insight into whether high-performing employees are at higher risk of leaving.

5. Attrition trend shows year-over-year changes

Using window functions (LAG()), year-over-year analysis reveals how attrition evolves over time, including relative growth (%)

6. Data quality issues can significantly impact analysis

Initial exploration revealed inconsistencies between employee status and exit dates, highlighting the importance of data validation before analysis.

These findings can support HR teams in improving retention strategies, particularly in early employee lifecycle stages and high-risk departments.
