-- 1. Headcount 
-- 1.1 Current headcount

SELECT COUNT(*)
FROM employee_clean_vw
WHERE EmploymentStatus = 'Active';

-- There are 1467 active employees

-- 1.2 Historical headcount
-- Checking date range in the dataset

SELECT 
	MIN(StartDate),
	MAX(StartDate),
	MIN(StartDate),
	MAX(ExitDate)
FROM employee_clean_vw;

-- Historical headcount by the end of each year beetwen 2018-2022

WITH snapshot_dates AS(
	SELECT CAST('2018-12-31' AS DATE) AS snapshot_date
	UNION ALL
	SELECT CAST('2019-12-31' AS DATE)
	UNION ALL
	SELECT CAST('2020-12-31' AS DATE)
	UNION ALL
	SELECT CAST('2021-12-31' AS DATE)
	UNION ALL
	SELECT CAST('2022-12-31' AS DATE)
)
SELECT 
	snapshot_date,
	COUNT(*) AS snapshot_headcount
FROM snapshot_dates
CROSS JOIN employee_clean_vw 
WHERE 
	DataQuality = 'OK'
	AND EmploymentStatus <> 'Future'
	AND StartDate <= snapshot_date
	AND (ExitDate IS NULL OR ExitDate > snapshot_date)
GROUP BY snapshot_date
ORDER BY snapshot_date;

-- Headcount consistently increased YoY between 2018 - 2022
-- Dataset doesn't cover whole 2018 and 2023.

-- 2. Hiring

SELECT 
	YEAR(StartDate) AS hiring_year,
	COUNT(*) AS hires
FROM employee_clean_vw
WHERE DataQuality = 'OK'
GROUP BY YEAR(StartDate)
ORDER BY YEAR(StartDate);

-- Significant growth between 2018-2019; drop in 2020 and then consistent increase YoY up to 2022.
-- Dataset doesn't cover whole 2018 and 2023.

-- 3. Terminations

SELECT 
	YEAR(ExitDate) AS termination_year,
	COUNT(*) AS terminated
FROM employee_clean_vw
WHERE DataQuality = 'OK'
AND ExitDate IS NOT NULL
GROUP BY YEAR(ExitDate)
ORDER BY YEAR(ExitDate);

-- Number of people leaving company increased since 2018, reaching peak in 2023 
-- despite the fact that dataset doesn't cover whole 2023.

