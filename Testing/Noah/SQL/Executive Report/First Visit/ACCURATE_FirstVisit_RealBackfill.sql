WITH firstVisits AS (
SELECT
    av.[ValueAsDateTime]
    ,CAST(av.ValueAsDateTime AS DATE) AS [ValueDate]
    ,[dbo].[ufnUtility_GetSundayDate](av.ValueAsDateTime) AS [SundayDate]
    ,av.Value
    ,av.EntityId As [PersonId]
    ,p.PrimaryCampusId
FROM
    [AttributeValue] av
    INNER JOIN [Person] p ON p.Id = av.EntityId
WHERE
    av.AttributeId = 717
    AND (av.ValueAsDateTime IS NOT NULL)
    AND p.RecordTypeValueId = 1
    AND p.PrimaryCampusId IS NOT NULL
), groupedVisits AS (
SELECT
    COALESCE(COUNT(*), 0) AS [FirstVisitCount]
    ,x.SundayDate
    ,x.PrimaryCampusId
   -- ,ROW_NUMBER() OVER (PARTITION BY x.SundayDate ORDER BY x.SundayDate DESC) AS [RN]
FROM
    firstVisits x
WHERE
    x.SundayDate >= '2021-01-01'
    AND x.SundayDate <= '2023-03-20'
GROUP BY
    x.SundayDate
    ,x.PrimaryCampusId
), campusTimes AS (
    SELECT
        dates.[Date]
        ,c.Id As [CampusId]
        ,c.Name AS [CampusName]
    FROM
        [Campus] c
        OUTER APPLY (SELECT asd.[Date], asd.[SundayDate] FROM [AnalyticsSourceDate] asd
            WHERE
                asd.[DayOfWeek] = 0
                AND asd.[Date] BETWEEN '2021-01-01' AND '2023-03-25'
            ) dates
    WHERE
        c.IsActive = 1
)

SELECT
    --gv.*
    COALESCE(gv.FirstVisitCount, 0) AS [Real]
    ,ct.[Date]
    ,ct.CampusName
    ,ct.CampusId
FROM
    groupedVisits gv
    RIGHT JOIN [campusTimes] ct ON ct.CampusId = gv.PrimaryCampusId
        AND ct.[Date] = gv.SundayDate
ORDER BY
    ct.[Date] DESC
    ,ct.CampusId ASC


/*
first visit count | SundayDate | PrimaryCampusId | <= JOIN => | CampusId | analytics Source Date
29|	2023-03-19|	2|	2023-03-19|	Adventure	 |2
0|	NULL|	NULL|	2023-03-19|	Davis|	5
*/