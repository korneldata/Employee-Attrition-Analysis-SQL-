-- Depends on: employee_clean_vw (created in 01_data_cleaning.sql)

-- Attrition rate
-- Attrition rate was calculated using yearly employee snapshots and average headcount methodology, 
-- ensuring consistency with standard HR analytics practices.

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
headcount_snapshots AS (
	SELECT 
		y.year,
		'start' AS snapshot_type,
		COUNT(*) AS headcount
	FROM
		years y
		CROSS JOIN employee_clean_vw e
	WHERE 
		e.DataQuality = 'OK'
		AND e.EmploymentStatus <> 'Future'
		AND e.StartDate <= y.year_start
		AND (e.ExitDate IS NULL OR e.ExitDate > y.year_start)
	GROUP BY y.year
	UNION ALL
		SELECT 
		y.year,
		'end' AS snapshot_type,
		COUNT(*) AS headcount
	FROM
		years y
		CROSS JOIN employee_clean_vw e
	WHERE 
		e.DataQuality = 'OK'
		AND e.EmploymentStatus <> 'Future'
		AND e.StartDate <= y.year_end
		AND (e.ExitDate IS NULL OR e.ExitDate > y.year_end)
	GROUP BY y.year
	),
yearly_headcount AS (
	SELECT 
		year,
		MAX (CASE
				WHEN snapshot_type = 'start'
				THEN headcount
				END) AS start_headcount,
		MAX (CASE
				WHEN snapshot_type = 'end'
				THEN headcount
				END) AS end_headcount
		FROM headcount_snapshots
		GROUP BY year
),
exits_per_year AS (
	SELECT
		y.year,
		COUNT(*) AS exits
	FROM years y
	CROSS JOIN employee_clean_vw e
	WHERE
		e.DataQuality = 'OK'
		AND e.ExitDate IS NOT NULL
		AND e.ExitDate BETWEEN y.year_start AND y.year_end
	GROUP BY y.year
)
SELECT 
	y.year,
	yz.start_headcount,
	yz.end_headcount,
	e.exits,
	ROUND((yz.start_headcount + yz.end_headcount) / 2.0, 2) AS avg_headcount,
	ROUND(e.exits * 100.0 / ((yz.start_headcount + yz.end_headcount) / 2.0), 2) AS attrition_rate
	FROM years y
	LEFT JOIN yearly_headcount yz ON y.year = yz.year
	LEFT JOIN exits_per_year e ON y.year = e.year
	ORDER BY y.year;
	
-- Attrition rate rose from over 4% in 2019 to over 9% in 2022

