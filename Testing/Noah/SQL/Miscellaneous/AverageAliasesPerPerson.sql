-- The value is magnified by 10000 so that more place values appear in the Metric.

SELECT
    ROUND(AVG(CAST(x.AliasCount AS FLOAT)), 10) * 10000 AS [AverageAliasCount]
FROM
    (SELECT
        COUNT(*) AS [AliasCount]
        ,p.Id
    FROM
        [Person] p
        LEFT JOIN [PersonAlias] pa ON pa.PersonId = p.Id
    WHERE
        p.IsDeceased = 0
    GROUP BY
        p.Id
    HAVING
        COUNT(*) > 1
    ) x

-- 2.4 ADAPTIVE JOIN
-- 5.2 HASH JOIN
-- 52.7 LOOP JOIN