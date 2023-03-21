SELECT
    COUNT(*) AS [InteractionCount]
    ,CAST(i.CreatedDateTime AS DATE) AS [CreatedDate]
FROM
    [Interaction] i
WHERE
    YEAR(i.CreatedDateTime) >= 2022
GROUP BY
    CAST(i.CreatedDateTime AS DATE)