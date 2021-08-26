SELECT
    co.[Name] AS ConnectionOpportunity,
    p.[FirstName] + ' ' + p.[LastName] AS Name,
    p.[Email] AS Email,
    cs.[Name] AS Status,
    cr.[CreatedDateTime] AS Date
FROM
    [ConnectionOpportunity] co
    INNER JOIN [ConnectionRequest] cr ON cr.[ConnectionOpportunityId] = co.[Id] AND cr.[CampusId] = 8
    INNER JOIN [ConnectionStatus] cs ON cr.[ConnectionStatusId] = cs.[Id]
    INNER JOIN [AttributeValue] av ON av.[EntityId] = cr.[Id] AND av.[AttributeId] = 19350
    INNER JOIN [PersonAlias] pa ON cr.[PersonAliasId] = pa.[Id]
    INNER JOIN [Person] p ON p.[Id] = pa.[PersonId]
WHERE
    co.[ConnectionTypeId] = 12 AND
    av.[Value] = 'True'