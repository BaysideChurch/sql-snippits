SELECT
    COUNT(x.[BirthYearRange]) AS [BirthYearRangeCount]
    ,x.[BirthYearRange] AS [DataViewId]
FROM
    (
    SELECT
		p.[BirthYear]
		,CASE
			WHEN p.[BirthYear] BETWEEN 1920 AND 1930 THEN 1744 -- '1920-1930'
			WHEN p.[BirthYear] BETWEEN 1930 AND 1930 THEN 1745 -- '1930-1940'
			WHEN p.[BirthYear] BETWEEN 1940 AND 1940 THEN 1746 -- '1940-1950'
			WHEN p.[BirthYear] BETWEEN 1950 AND 1960 THEN 1747 -- '1950-1960'
			WHEN p.[BirthYear] BETWEEN 1960 AND 1970 THEN 1748 -- '1960-1970'
			WHEN p.[BirthYear] BETWEEN 1970 AND 1980 THEN 1749 -- '1970-1980'
			WHEN p.[BirthYear] BETWEEN 1980 AND 1990 THEN 1750 -- '1980-1990'
			WHEN p.[BirthYear] BETWEEN 1990 AND 2000 THEN 1751 -- '1990-2000'
			WHEN p.[BirthYear] BETWEEN 2000 AND 2010 THEN 1752 -- '2000-2010'
			WHEN p.[BirthYear] BETWEEN 2010 AND 2020 THEN 1753 -- '2010-2020'
			WHEN p.[BirthYear] BETWEEN 2020 AND 2030 THEN 1754 -- '2020-2030'
			ELSE NULL
		END AS [BirthYearRange]
    FROM
        [Person] p
        INNER JOIN [Campus] c ON c.Id = p.PrimaryCampusId
    WHERE
        p.[IsDeceased] = 0
        AND p.[RecordTypeValueId] = 1
		AND p.[BirthYear] IS NOT NULL
		AND p.[BirthYear] > 1910
        AND c.IsActive = 1
    )x
GROUP BY
    x.[BirthYearRange]
HAVING
    x.[BirthYearRange] IS NOT NULL