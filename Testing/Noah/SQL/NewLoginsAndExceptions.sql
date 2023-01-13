
WITH exceptions AS(
SELECT
    COUNT(*) AS [NewExceptions]
    ,CAST(e.[CreatedDateTime] AS DATE) AS [CreatedDate]
FROM
    [ExceptionLog] e
WHERE
    e.[Description] LIKE 'BccLogin Debug'
GROUP BY
    CAST(e.[CreatedDateTime] AS DATE)
), logins AS (
SELECT
    COUNT(*) AS [NewLogins]
    ,CAST(ul.[CreatedDateTime] AS DATE) AS [CreatedDate]
FROM
    [UserLogin] ul
WHERE
    ul.[EntityTypeId] = 902
GROUP BY
    CAST(ul.[CreatedDateTime] AS DATE)
)

SELECT
    *
    ,e.[NewExceptions] / l.[NewLogins] AS [ExceptionsPerLogin]
FROM
    exceptions e
    RIGHT JOIN logins l ON l.[CreatedDate] = e.[CreatedDate]
ORDER BY
    l.[CreatedDate] DESC