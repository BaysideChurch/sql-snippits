DECLARE @oneYearAgo DATETIME = DATEADD(year, -1, GETDATE());

SELECT
--    TOP 1000000
    --y.*

    COUNT(y.PrimaryCampusId) AS [CampusCount]
    ,y.PrimaryCampusId
    ,y.CampusName
  --  COUNT(*) As [PersonCount]
 --   COUNT(y.ConnectionStatusValueId) As [ConnectionStatusCount]
 --   ,y.ConnectionStatusValueId
FROM
    (SELECT
        --x.*
        x.[PersonId]
        ,x.ConnectionStatusValueId
        ,x.BirthDate
        ,x.BirthYear
        ,x.[PersonCreated]
        --,x.RegistrantCreated
        ,x.PrimaryCampusId
        ,x.[CampusName]
    FROM
        (SELECT
            p.Id As [PersonId]
            ,p.ConnectionStatusValueId
            ,p.BirthDate
            ,p.BirthYear
            ,p.CreatedDateTime As [PersonCreated]
            ,rr.Id As [RegistrantId]
            ,rr.CreatedDateTime AS [RegistrantCreated]
            ,r.Id As [RegistrationId]
            ,r.CreatedDateTime AS [RegistrationCreated]
            ,p.PrimaryCampusId
            ,c.Name AS [CampusName]
            ,ROW_NUMBER() OVER (PARTITION BY p.Id ORDER BY GREATEST(rr.CreatedDateTime, r.CreatedDateTime) DESC) AS [MostRecentRegistration]
        FROM
            [Person] p
            INNER JOIN [PersonAlias] pa ON pa.PersonId = p.Id
            INNER JOIN [Campus] c On c.Id = p.PrimaryCampusId
            LEFT JOIN [RegistrationRegistrant] rr ON rr.PersonAliasId = pa.Id -- Find all Registrants
            LEFT JOIN [Registration] r ON r.PersonAliasId = pa.Id -- Find all Registrars
        WHERE
            p.[IsDeceased] = 0
            AND p.[RecordTypeValueId] = 1
            --AND p.[BirthYear] IS NOT NULL
            --AND p.[BirthYear] > 1910
        ) x
    WHERE
        x.MostRecentRegistration = 1
        AND ((x.PersonCreated >= @oneYearAgo) OR (x.RegistrantCreated >= @oneYearAgo) OR (x.RegistrationCreated >= @oneYearAgo))
        --(x.RegistrantCreated IS NOT NULL OR x.RegistrationCreated IS NOT NULL)
    GROUP BY
        x.[PersonId]
        ,x.ConnectionStatusValueId
        ,x.BirthDate
        ,x.BirthYear
        ,x.[PersonCreated]
        --,x.RegistrantCreated
        ,x.PrimaryCampusId
        ,x.[CampusName]
) y
GROUP BY
    y.PrimaryCampusId, y.CampusName
    --y.ConnectionStatusValueId