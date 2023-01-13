SELECT
	COUNT(*) AS [RegistrantCount]
	,p.[PrimaryCampusId]
	,MAX(c.[Name]) AS [CampusName]
FROM
	[RegistrationRegistrant] rr
	INNER JOIN [Registration] r ON r.[Id] = rr.[RegistrationId]
	INNER JOIN [PersonAlias] pa ON pa.[Id] = rr.[PersonAliasId]
	INNER JOIN [Person] p ON p.[Id] = pa.[PersonId]
	INNER JOIN [Campus] c ON c.[Id] = p.[PrimaryCampusId]
WHERE
	r.[RegistrationInstanceId] = 1222
	AND rr.[OnWaitlist] = 0
GROUP BY
	p.[PrimaryCampusId]
ORDER BY
    MAX(c.[Name]) ASC