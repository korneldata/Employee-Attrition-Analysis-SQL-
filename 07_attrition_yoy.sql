-- YoY attrition trend
-- I calculated year-over-year changes in attrition using LAG to identify trends in employee turnover.

WITH years AS (
	SELECT 
		2019 AS year,
		DATEFROMPARTS(2019,1,1) AS year_start,
		DATEFROMPARTS(2019,12,31) AS year_end
	UNION ALL
	SELECT 
		2020,
		DATEFROMPARTS(2020,1,1),
		DATEFROMPARTS(2020,12,31)
	UNION ALL
	SELECT 
		2021,
		DATEFROMPARTS(2021,1,1),
		DATEFROMPARTS(2021,12,31)
	UNION ALL
	SELECT 
		2022,
		DATEFROMPARTS(2022,1,1),
		DATEFROMPARTS(2022,12,31)
),
headcounts AS (
		SELECT 
		y.year,
		COUNT(*) AS headcount
	FROM
		years y
		CROSS JOIN employee_clean_vw e
	WHERE 
		e.DataQuality = 'OK'
		AND e.EmploymentStatus <> 'Future'
		AND e.StartDate <= y.year_end
		AND (e.ExitDate IS NULL OR e.ExitDate > y.year_end)
	GROUP BY 
		y.year
),
exits_cte AS (
	SELECT
		y.year,
		COUNT(*) AS exits
	FROM years y
	CROSS JOIN employee_clean_vw e
	WHERE
		e.DataQuality = 'OK'
		AND e.ExitDate IS NOT NULL
		AND e.ExitDate BETWEEN y.year_start AND y.year_end
	GROUP BY 
		y.year
),
yearly_attrition AS(
SELECT 
	hc.year,
	hc.headcount,
	COALESCE(e.exits,0) AS exits,
	COALESCE(e.exits,0) * 1.0 / NULLIF(hc.headcount,0) AS attrition_rate
	FROM headcounts hc
	LEFT JOIN exits_cte e 
		ON hc.year = e.year
)
SELECT
	year,
	headcount,
	exits,
	ROUND(attrition_rate * 100.0, 2) AS attrition_pct,
	ROUND(LAG(attrition_rate) OVER (ORDER BY year) * 100.0, 2) AS prev_year_attrition,
	ROUND(
			(attrition_rate - LAG(attrition_rate) OVER (ORDER BY year)) * 100.0 / LAG(attrition_rate) OVER (ORDER BY year) , 
			2) AS yoy_pct_change
FROM yearly_attrition
ORDER BY year;