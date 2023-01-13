DECLARE @MexicoStart2023 DATETIME = '3/31/2023';

SELECT
    COUNT(*) AS [RegistrantCount]
    ,x.[WeeksUntilStart]
    ,x.[WeekCreated]
    ,x.[YearCreated]
    ,MAX(x.[CreatedDateTime]) AS [MaxCreated]
    ,MIN(x.[CreatedDateTime]) AS [MinCreated]
    ,x.[CampusName]
    ,x.[PrimaryCampusId]
    ,x.[RegistrationInstanceId]
    ,x.[RegistrationInstanceName]
FROM
    (SELECT
    	rr.[Id] AS [RegistrantId]
    	,DATEPART(week, rr.[CreatedDateTime]) AS [WeekCreated]
    	,DATEPART(year, rr.[CreatedDateTime]) AS [YearCreated]
    	,rr.[CreatedDateTime]
    	,DATEDIFF(week, rr.[CreatedDateTime], @MexicoStart2023) AS [WeeksUntilStart]
    	,p.[PrimaryCampusId]
    	,c.[Name] As [CampusName]
    	,ri.[Id] As [RegistrationInstanceId]
    	,ri.[Name] AS [RegistrationInstanceName]
    FROM
    	[RegistrationRegistrant] rr
    	INNER JOIN [Registration] r ON r.[Id] = rr.[RegistrationId]
    	INNER JOIn [RegistrationInstance] ri ON ri.[Id] = r.[RegistrationInstanceId]
    	INNER JOIN [PersonAlias] pa ON pa.[Id] = rr.[PersonAliasId]
    	INNER JOIN [Person] p ON p.[Id] = pa.[PersonId]
    	INNER JOIN [Campus] c ON c.[Id] = p.[PrimaryCampusId]
    WHERE
    	r.[RegistrationInstanceId] IN (1222, 1223, 1232) -- HS, College, Adults
    ) x
GROUP BY
    x.[WeekCreated], x.[YearCreated], x.[WeeksUntilStart]
    ,x.[PrimaryCampusId], x.[CampusName]
    ,x.[RegistrationInstanceId], x.[RegistrationInstanceName]
ORDER BY
    x.[YearCreated] ASC, x.[WeekCreated]