SELECT
    TOP 4000
    p.[Id]
    ,pn.[Number]
    ,p.[BirthDate]
    ,p.[BirthYear]
    ,CASE
        WHEN p.[BirthDate] IS NULL THEN 'WHOA!'
        WHEN p.[BirthYear] IS NULL THEN 'Whoa!'
    END AS [NullBirth]
    ,p.[CreatedDateTime] as [PersonCreated]
    ,ul.[CreatedDateTime]
FROM
    [Person] p
    INNER JOIN [PhoneNumber] pn ON pn.[PersonId] = p.[Id] AND pn.[NumberTypeValueId] = 12
    INNER JOIN [UserLogin] ul ON ul.[PersonId] = p.[Id] AND ul.[UserName] = pn.[Number]
WHERE
    --p.[Id] = 135445
    p.[BirthYear] IS NULL--  < 2009
    AND p.[IsDeceased] != 1
    AND EXISTS(
        SELECT
            1
        FROM
            [UserLogin] ul
        WHERE
            ul.[UserName] = pn.[Number]
            AND ul.[EntityTypeId] = 902
    )
ORDER BY
    p.[CreatedDateTime] DESC