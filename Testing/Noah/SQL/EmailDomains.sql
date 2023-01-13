SELECT
    COUNT(x.[Domain]) As [Count of Domain]
    ,x.[Domain]
FROM
(SELECT
    p.[Email],
    SUBSTRING(p.[Email], CHARINDEX('@', p.[Email]) + 1, 255) AS [Domain]
FROM
    [Person] p
WHERE
    p.[Email] != ''
    AND p.[ConnectionStatusValueId] NOT IN (833, 835)
    AND p.[RecordStatusValueId] IN (3, 5)
    AND p.[PrimaryCampusId] NOT IN (6,9)
) x
GROUP BY x.[Domain]
ORDER BY COUNT(x.[Domain]) DESC