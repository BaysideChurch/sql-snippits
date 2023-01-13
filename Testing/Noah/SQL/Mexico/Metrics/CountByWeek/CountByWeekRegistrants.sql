SELECT
	COUNT(*) AS [RegistrantCount]
	,DATEPART(week, rr.[CreatedDateTime]) AS [WeekCreated]
	,MAX(DATEPART(year, rr.[CreatedDateTime])) AS [YearCreated]
	,MAX(rr.[CreatedDateTime]) AS [MaxCreated]
	,MIN(rr.[CreatedDateTime]) As [MinCreated]
FROM
	[RegistrationRegistrant] rr
	INNER JOIN [Registration] r ON r.[Id] = rr.[RegistrationId]
	INNER JOIN [PersonAlias] pa ON pa.[Id] = rr.[PersonAliasId]
	INNER JOIN [Person] p ON p.[Id] = pa.[PersonId]
	INNER JOIN [Campus] c ON c.[Id] = p.[PrimaryCampusId]
WHERE
	r.[RegistrationInstanceId] IN (1222, 1223, 1232) -- HS, College, Adults
	AND rr.[OnWaitlist] = 0
GROUP BY
	DATEPART(week, rr.[CreatedDateTime])
ORDER BY
    MAX(DATEPART(year, rr.[CreatedDateTime])) ASC
    ,DATEPART(week, rr.[CreatedDateTime]) ASC