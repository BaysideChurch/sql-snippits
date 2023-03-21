/*
 Find all the registrants from baptism registration instances in the past month
 Check if the person has the "Baptism date" attribute set to true, now that the event has passed.
 The registration time needs to be over.
*/ 

DECLARE @today DATETIME = CAST(GETDATE() AS DATE);
DECLARE @oneMonthAgo DATETIME = DATEADD(MONTH, -1, @today);


WITH baptisms AS (
    SELECT
       -- a.[Key] AS [AttributeKey]
        CASE av.AttributeId
            WHEN 174 THEN 'BaptismDate'
            WHEN 10180 THEN 'BaptismCampus'
        END AS [AttributeKey]
        ,av.[Value]
        ,av.[ValueAsDateTime]
        ,av.EntityId
       -- ,av.[CreatedDateTime]
    FROM
        [AttributeValue] av
--        [Attribute] a
 --       INNER JOIN [AttributeValue] av ON av.[AttributeId] = a.[Id]
    WHERE
        --a.Id IN (174, 10180) -- BaptismDate, BaptismCampus
        av.AttributeId IN (174, 10180)
        AND (av.Value IS NOT NULL AND av.Value != '')
        AND av.ModifiedDateTime >= @oneMonthAgo
)

SELECT
    
    baptisms.PersonId
    ,c.Name
    ,baptisms.BaptismDate
    ,baptisms.BaptismCampus
    
    /*
    COUNT(*) AS [BaptismCount]
    ,c.Name
    */
FROM
    (SELECT
        x.EntityId As [PersonId]
        ,x.BaptismCampus
        ,CAST(COALESCE(
            TRY_CAST(x.BaptismDate AS DATETIME),
            TRY_CAST(x.BaptismDate AS DATETIME2),
            TRY_CAST(x.BaptismDate AS DATETIMEOFFSET),
            TRY_CONVERT(DATETIME, x.BaptismDate),
            TRY_CONVERT(DATETIME, x.BaptismDate, 126),
            TRY_CONVERT(DATETIME, x.BaptismDate, 107)
        ) AS DATETIME) AS [BaptismDate]
    FROM
        (SELECT
            b.*
        FROM
            baptisms b
        ) b
        PIVOT(
            MAX(b.Value)
            FOR b.AttributeKey IN ([BaptismCampus], [BaptismDate])
        ) AS x
    ) baptisms
    LEFT JOIN [Campus] c ON CAST(c.Guid AS VARCHAR(50)) = baptisms.BaptismCampus
WHERE
    baptisms.BaptismDate <= @today
    AND baptisms.BaptismDate >= @oneMonthAgo
--GROUP BY
--    c.Name
--ORDER BY
--    baptisms.BaptismDate DESC