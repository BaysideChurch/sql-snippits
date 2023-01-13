DECLARE @campusId INT = 8;

SELECT
    COUNT(filteredPeopleWithAge.[Age]) AS [PopCount]
	,CAST(COUNT(*) * 100.00 / SUM(COUNT(*)) over () AS DECIMAL(18,1)) AS [Percentage]
	,filteredPeopleWithAge.[Age] AS [Age]
	/*COUNT(filteredPeopleWithAge.[AgeRange]) AS [PopCount]
	,CAST(COUNT(*) * 100.00 / SUM(COUNT(*)) over () AS DECIMAL(18,1)) AS [Percentage]
	,filteredPeopleWithAge.[AgeRange] AS [AgeRange]
    */
FROM
	(
	SELECT
		personWithAge.[Id]
		,personWithAge.[BirthYear]
		,personWithAge.[Age]
		,CASE
			WHEN personWithAge.[Age] BETWEEN 13 AND 17 THEN '13-17 years'
			WHEN personWithAge.[Age] BETWEEN 18 AND 24 THEN '18-24 years'
			WHEN personWithAge.[Age] BETWEEN 25 AND 34 THEN '25-34 years'
			WHEN personWithAge.[Age] BETWEEN 35 AND 44 THEN '35-44 years'
			WHEN personWithAge.[Age] BETWEEN 45 AND 54 THEN '45-54 years'
			WHEN personWithAge.[Age] BETWEEN 55 AND 64 THEN '55-64 years'
			WHEN personWithAge.[Age] >= 65 THEN '65+ years'
			ELSE NULL
		END AS [AgeRange]
	FROM
	(
		SELECT
			p.[Id]
			,p.[BirthYear]
			--,[dbo].[ufnCrm_GetAge](p.[BirthDate]) AS [Age]
            ,DATEPART(YEAR, GETDATE()) - p.[BirthYear] AS [Age]
		--	,DATEDIFF(day, p.[BirthDate], GETDATE()) / 364.2425 AS [AgeDiff]
		FROM
			[Person] p
		WHERE
			p.[IsDeceased] = 0
			AND p.[RecordTypeValueId] = 1
			AND p.[RecordStatusValueId] != 4
			AND p.[BirthYear] IS NOT NULL
			AND p.[BirthYear] > 1910
			--AND ((@campusId IS NULL OR @campusId = '') OR (@campusId IS NOT NULL AND p.[PrimaryCampusId] = @campusId))
			--AND DATEDIFF(day, p.[BirthDate], GETDATE()) / 364.2425 >= 13
		) personWithAge
		--WHERE
	--		personWithAge.[Age] > 12
	) filteredPeopleWithAge
GROUP BY
    filteredPeopleWithAge.[Age]
	--filteredPeopleWithAge.[AgeRange]
ORDER BY
    [Age]
--    [AgeRange]