SELECT
    MAX(x.AttributeCount) AS [High]
    ,MIN(x.AttributeCount) AS [Low]
    ,AVG(x.AttributeCount) As [Average]
FROM
    (SELECT
        av.EntityId As [PersonId]
        ,COUNT(*) AS [AttributeCount]
    FROM
        [Attribute] a
        INNER JOIN [Attributevalue] av On av.AttributeId = a.Id
    WHERE
        a.EntityTypeId = 15
    GROUP BY
        av.EntityId
    ) x