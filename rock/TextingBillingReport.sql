DECLARE @startTime DATETIME = '07-01-2021'

SELECT
    p.[FirstName] + ' ' + p.[LastName] AS Name,
    COUNT(cr.[Id])
FROM
    [Communication] c
    INNER JOIN [PersonAlias] pa ON c.[SenderPersonAliasId] = pa.[Id]
    INNER JOIN [Person] p ON pa.[PersonId] = p.[Id]
    INNER JOIN [CommunicationRecipient] cr ON cr.[CommunicationId] = c.[Id]
WHERE
    c.[CommunicationType] = 2 AND
    DATEDIFF(day, c.[SendDateTime], @startTime) < 0
GROUP BY
    p.[FirstName] + ' ' + p.[LastName]