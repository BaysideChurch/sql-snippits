SELECT
    COUNT(*) AS [RegistrantCount]
    ,x.DefinedValueId
FROM
    (SELECT
        rr.[Id] AS [RegistrantId]
        ,p.[Id] As [PersonId]
        ,r.[RegistrationInstanceId]
        ,av.[Value]
        ,dv.Id As [DefinedValueId]
        ,dv.[Value] As [ShirtSize]
        ,dv.[Order] AS [ShirtOrder]
    FROM
        [RegistrationRegistrant] rr
        INNER JOIN [PersonAlias] pa On pa.[Id] = rr.[PersonAliasId]
        INNER JOIN [Person] p ON p.[Id] = pa.[PersonId]
        INNER JOIN [Registration] r On r.[Id] = rr.[RegistrationId]
        INNER JOIN [AttributeValue] av ON av.[EntityId] = p.[Id]
            AND av.[AttributeId] = 7426
        INNER JOIN [DefinedValue] dv ON CONVERT(VARCHAR(50), dv.[Guid]) = av.[Value]
            AND dv.[DefinedTypeId] = 95
    WHERE
        r.[RegistrationInstanceId] IN (1222, 1223, 1232)
    ) x
GROUP BY
    x.DefinedValueId
ORDER BY
    MAX(x.[ShirtOrder])