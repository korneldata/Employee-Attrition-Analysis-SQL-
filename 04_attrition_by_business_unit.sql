-- Attrition per Business Unit
-- Attrition was analyzed at the business unit level using year-end headcount and 
-- ranked using window functions to identify departments with the highest turnover.

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
		e.BusinessUnit,
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
		y.year, 
		e.BusinessUnit
	),
exits_per_bu AS (
	SELECT
		y.year,
		e.BusinessUnit,
		COUNT(*) AS exits
	FROM years y
	CROSS JOIN employee_clean_vw e
	WHERE
		e.DataQuality = 'OK'
		AND e.ExitDate IS NOT NULL
		AND e.ExitDate BETWEEN y.year_start AND y.year_end
	GROUP BY 
		y.year,
		e.BusinessUnit
)
SELECT 
	hc.year,
	hc.BusinessUnit,
	hc.headcount,
	COALESCE(e.exits,0) AS exits,
	ROUND(
		COALESCE(e.exits,0) * 100.0 / NULLIF(hc.headcount,0), 2
		) AS attrition_rate,
	RANK () OVER (
		PARTITION BY hc.year
		ORDER BY COALESCE(e.exits,0) * 100.0 / NULLIF(hc.headcount,0) DESC
		) AS rank_per_year
	FROM headcounts hc
	LEFT JOIN exits_per_bu e 
		ON hc.year = e.year
		AND hc.BusinessUnit = e.BusinessUnit
	ORDER BY hc.year, rank_per_year;
	
