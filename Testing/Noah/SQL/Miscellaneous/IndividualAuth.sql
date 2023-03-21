SELECT
    COUNT(*) AS [AuthCount]
    ,SUM(CASE WHEN x.[AllowOrDeny] = 'A' THEN 1 ELSE 0 END) AS [AllowCount]
    ,SUM(CASE WHEN x.[AllowOrDeny] = 'D' THEN 1 ELSE 0 END) AS [DenyCount]
    ,x.[PersonId]
    ,x.[FullName]
FROM
    (SELECT
        auth.[Id]
        ,auth.[EntityTypeId]
        ,et.FriendlyName
        ,auth.[EntityId]
        ,auth.[Action]
        ,auth.[AllowOrDeny]
        ,p.[Id] As [PersonId]
        ,p.[NickName] + ' ' + p.[LastName] AS [FullName]
    FROM
        [Auth] auth
        INNER JOIN [EntityType] et ON et.Id = auth.EntityTypeId
        INNER JOIN [PersonAlias] pa ON pa.Id = auth.PersonAliasId
        INNER JOIN [Person] p ON p.Id = pa.PersonId
    WHERE
        auth.GroupId IS NULL
        AND auth.EntityTypeId != 830
    ) x
GROUP BY
    x.[PersonId], x.[FullName]
ORDER BY
    [AuthCount] DESC
--ORDER BY
--    p.Id, auth.Action