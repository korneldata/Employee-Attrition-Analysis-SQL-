-- 01_data_cleaning.sql
-- Purpose: Clean and standardize employee dataset
-- Description: Creates a cleaned view with consistent employment status and data quality flags

-- DATA EXPLORATION
-- To validate the integrity of the dataset, I verified that EmployeeID values are unique, 
-- explored the distribution of key categorical fields such as EmployeeStatus, BusinessUnit, Title
-- and checked date ranges for StartDate and ExitDate columns.

--1. Checking number of records in the dataset

SELECT 
	COUNT(*) AS records
FROM employee_data;

-- There are 3000 records in this dataset

--2. Checking number of distinct values in 'EmpID' column

SELECT
	DISTINCT COUNT(EmpID)
FROM employee_data;

--There are 3000 unique employee IDs in the dataset which equals number of total records in the table.
-- No duplicates found.

-- 3. Values distribution

SELECT
	EmployeeStatus,
	COUNT(*) AS records_count
FROM employee_data
GROUP BY EmployeeStatus
ORDER BY COUNT(*) DESC;

SELECT
	BusinessUnit,
	COUNT(*) AS records_count
FROM employee_data
GROUP BY BusinessUnit
ORDER BY COUNT(*) DESC;

SELECT
	Title,
	COUNT(*) AS records_count
FROM employee_data
GROUP BY Title
ORDER BY COUNT(*) DESC;

-- 4. Checking date ranges  

SELECT 
	MIN(StartDate) AS min_start_date,
	MAX(StartDate) AS max_start_date,
	MIN(ExitDate) AS min_exit_date,
	MAX(ExitDate) AS max_exit_date
FROM employee_data;

-- DATA QUALITY CHECKS 

-- 1. This query identifies records with inconsistent employment status,
-- missing critical dates, or logically invalid date ranges.

SELECT 
	EmpID,
	StartDate,
	ExitDate,
	EmployeeStatus
FROM employee_data
WHERE 
	(ExitDate IS NOT NULL AND EmployeeStatus IN ('Active', 'Future Start', 'Leave of Absence'))
	OR (ExitDate IS NULL AND EmployeeStatus IN ('Voluntarily Terminated', 'Terminated for Cause'))
	OR (StartDate IS NULL)
	OR (EmployeeStatus IS NULL)
	OR ExitDate < StartDate;

-- 1146 rows contain incosistent data which is over 30% of total records in the dataset.

-- 2. A SQL view was created to standardize employment status and flag data quality issues. 
-- All downstream analyses were performed exclusively on this cleaned layer.

CREATE VIEW employee_clean_vw AS
SELECT
	EmpID,
	FirstName,
	LastName,
	StartDate,
	ExitDate,
	Title,
	Supervisor,
	ADEmail,
	BusinessUnit,
	EmployeeStatus,
	EmployeeType,
	PayZone,
	EmployeeClassificationType,
	TerminationType,
	TerminationDescription,
	DepartmentType,
	Division,
	DOB,
	State, 
	JobFunctionDescription,
	GenderCode,
	LocationCode,
	RaceDesc,
	MaritalDesc,
	Performance_Score,
	Current_Employee_Rating,
	CASE 
		WHEN ExitDate IS NOT NULL THEN 'Exited' 
		WHEN ExitDate IS NULL AND EmployeeStatus = 'Future Start' THEN 'Future' 
		WHEN ExitDate IS NULL AND EmployeeStatus IN ('Active', 'Leave of Absence') THEN 'Active'
		ELSE 'Unknown'
	END AS EmploymentStatus,
	CASE 
		WHEN ExitDate < StartDate THEN 'Exit Before Start'
		WHEN StartDate IS NULL THEN 'No Start Date'
		WHEN EmployeeStatus IS NULL THEN 'No Employee Status'
		WHEN (
				(ExitDate IS NOT NULL AND EmployeeStatus IN ('Active', 'Future Start', 'Leave of Absence'))
				OR 
				(ExitDate IS NULL AND EmployeeStatus IN ('Voluntarily Terminated', 'Terminated for Cause'))
			)
			THEN 'Status Conflict'
		WHEN EmployeeStatus NOT IN 
		('Active','Leave of Absence','Future Start','Voluntarily Terminated','Terminated for Cause')
		THEN 'Invalid Status Value'
	ELSE 'OK'
	END AS DataQuality
FROM employee_data;

SELECT 
	*
FROM employee_clean_vw;

