SELECT
    y.*
    ,y.[MarriedPopulation] * 100 / y.[TotalPopulation] AS [PercentMarried]
    ,y.[SinglePopulation] * 100 / y.[TotalPopulation] AS [PercentSingle]
    ,y.[WidowedPopulation] * 100 / y.[TotalPopulation] AS [PercentWidowed]
    ,y.[DivorcedPopulation] * 100 / y.[TotalPopulation] AS [PercentDivorced]
FROM
    (SELECT
        x.[BirthYear]
        ,COUNT(x.[Id]) AS [TotalPopulation]
        ,COUNT(CASE WHEN x.[MaritalStatusValueId] = 143 THEN x.[Id] ELSE NULL END) AS [MarriedPopulation]
        ,COUNT(CASE WHEN x.[MaritalStatusValueId] = 144 THEN x.[Id] ELSE NULL END) AS [SinglePopulation]
        ,COUNT(CASE WHEN x.[MaritalStatusValueId] = 1674 THEN x.[Id] ELSE NULL END) AS [WidowedPopulation]
        ,COUNT(CASE WHEN x.[MaritalStatusValueId] = 1010 THEN x.[Id] ELSE NULL END) AS [DivorcedPopulation]
        ,SUM(x.[NumberOfChildren]) As [TotalChildren]
        ,AVG(CAST(x.[NumberOfChildren] AS DECIMAL(10,2))) As [AverageChildren]
        ,SUM(CASE WHEN x.[MaritalStatusValueId] = 143 THEN x.[NumberOfChildren] ELSE 0 END) As [ChildrenOfMarried]
    FROM
        (SELECT
            p.[Id]
            ,p.[BirthYear]
            ,p.[MaritalStatusValueId]
            ,COALESCE((SELECT
                COUNT(gm.[Id]) AS [ChildCount]
            FROM
                [Group] g
                INNER JOIN [GroupMember] gm ON gm.[GroupId] = g.[Id]
            WHERE
                g.[GroupTypeId] = 10
                AND gm.[GroupRoleId] = 4 -- Child
                AND g.[Id] IN (
                    SELECT TOP 1
                        gm1.[GroupId]
                    FROM
                        [GroupMember] gm1
                    WHERE
                        gm1.[PersonId] = p.[Id]
                        AND gm1.[GroupRoleId] = 3 -- Adult
                )
            GROUP BY
                g.[Id]
            ), 0) AS [NumberOfChildren]
        FROM
            [Person] p
        WHERE
            p.[BirthYear] BETWEEN 1914 AND 2004
            AND p.[IsDeceased] != 1
            AND p.[AgeClassification] != 2 -- Child
            AND p.[RecordTypeValueId] = 1 -- Person
            AND p.[RecordStatusValueId] != 4
            AND p.[MaritalStatusValueId] IS NOT NULL
            AND p.[PrimaryCampusId] NOT IN (3, 6, 9, 10, 27, 28) -- Auburn, Elk Grove, Midtown, Global Online, Lincoln, Folsom Prison
            --AND p.[MaritalStatusValueId] NOT IN (674, 1010) -- Divorced or widowed
            --AND DATEPART(YEAR, p.[CreatedDateTime]) < 2022
        ) x
    GROUP BY
        x.[BirthYear]
    ) y
ORDER BY
    y.[BirthYear] DESC