-- Depends on: employee_clean_vw (created in 01_data_cleaning.sql)

-- Performance vs Attrition
-- I compared attrition rates across performance groups and 
-- identified which segments contribute most to total employee turnover

WITH base_cte AS(
SELECT
	Performance_Score,
	CASE 
		WHEN ExitDate IS NOT NULL THEN 1
		ELSE 0
		END AS is_exited
FROM employee_clean_vw
WHERE DataQuality = 'OK'
AND Performance_Score IS NOT NULL
)
SELECT
	Performance_Score,
	COUNT(*) AS total,
	SUM(is_exited) AS exits,
	ROUND(SUM(is_exited) * 100.0 / COUNT(*), 2) AS attrition_rate,
	ROUND(SUM(is_exited) * 100.0 / SUM(SUM(is_exited)) OVER (), 2) AS pct_total_exits
FROM base_cte
GROUP BY Performance_Score
ORDER BY attrition_rate DESC;

