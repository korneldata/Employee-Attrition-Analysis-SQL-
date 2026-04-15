-- Attrition by tenure buckets
-- I analyzed attrition distribution across tenure buckets and 
-- used window functions to calculate percentage contribution of each segment.

WITH emp_tenure AS(
SELECT  
	DATEDIFF(day, StartDate, ExitDate)/365.0 AS tenure
	FROM employee_clean_vw
WHERE 
	DataQuality = 'OK'
	AND ExitDate IS NOT NULL
),
buckets AS(
SELECT
	CASE 
		WHEN tenure < 1 THEN '0-1'
		WHEN tenure < 3 THEN '1-3'
		WHEN tenure < 5 THEN '3-5'
		ELSE '5+'
		END AS tenure_bucket,
	CASE 
		WHEN tenure < 1 THEN 1
		WHEN tenure < 3 THEN 2
		WHEN tenure < 5 THEN 3
		ELSE 4
		END AS bucket_order		
FROM emp_tenure
)
SELECT
	tenure_bucket,
	COUNT(*) AS exits,
	ROUND(COUNT(*) * 100.0/SUM(COUNT(*)) OVER (),2) AS attrition_pct
FROM buckets
GROUP BY tenure_bucket, bucket_order
ORDER BY bucket_order;

