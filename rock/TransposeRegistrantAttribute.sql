INSERT TOP (330)
INTO [AttributeValue] 
(
    [IsSystem],
    [AttributeId],
    [EntityId],
    [Value],
    [Guid],
    [CreatedDateTime],
    [CreatedByPersonAliasId]
)
SELECT
    0 AS IsSystem,
    18974 AS AttributeId,
    p.[Id] AS Id,
    av.[Value] AS Value,
    NEWID() AS Guid,
    GETDATE() AS CreatedDateTime,
    10 AS CreatedByPersonAliasId
FROM
    [Registration] r
    INNER JOIN [RegistrationRegistrant] rr ON rr.[RegistrationId] = r.[Id] 
    INNER JOIN [PersonAlias] pa ON rr.[PersonAliasId] = pa.[Id]
    INNER JOIN [Person] p ON pa.[PersonId] = p.[Id]
    INNER JOIN [AttributeValue] av ON av.[EntityId] = rr.[Id]
WHERE
    r.[RegistrationInstanceId] = 338 AND
    av.[AttributeId] = 16749
