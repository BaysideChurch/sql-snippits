DECLARE @AD_Kids INT = 269;
DECLARE @BO_Kids INT = 271;
DECLARE @DA_Kids INT = 325; -- No data
DECLARE @FO_Kids INT = 275;
DECLARE @GB_Kids INT = 255; -- Broken down by service (Will have to change to select data)
DECLARE @OC_Kids INT = 277; -- Partitioned by service
DECLARE @SR_Kids INT = 279;

WITH GB_Kids_Metric AS (
SELECT
    MAX(m.Id) AS [MetricId]
    ,MAX(m.Title) AS [Title]
    ,SUM(mv.YValue) AS [YValue]
    ,mv.MetricValueDateTime
FROM
    [MetricValue] mv
    INNER JOIN [Metric] m ON mv.MetricId = m.Id
WHERE
    mv.MetricId = @GB_Kids
GROUP BY
    mv.MetricValueDateTime
), OC_Kids_Metric AS (
SELECT
    MAX(m.Id) AS [MetricId]
    ,MAX(m.Title) AS [Title]
    ,SUM(mv.YValue) AS [YValue]
    ,mv.MetricValueDateTime
FROM
    [MetricValue] mv
    INNER JOIN [Metric] m ON m.Id = mv.MetricId
WHERE
    mv.MetricId = @OC_Kids
GROUP BY
    mv.MetricValueDateTime
), otherMetrics As (
SELECT
    m.Id AS [MetricId]
    ,m.Title
    ,mv.YValue
    ,mv.MetricValueDateTime
FROM
    [Metric] m
    INNER JOIN [MetricValue] mv ON mv.MetricId = m.Id
WHERE
    m.Id IN (
        @AD_Kids, @BO_Kids,
         --@DA_Kids,
          @FO_Kids, @SR_Kids
    )
)

SELECT
    y.Campus
    ,y.YValue
    ,asd.SundayDate
    ,y.MetricValueDate
    ,y.MetricValueDateTime
    ,y.[RN]
    ,asd.[Date]
    ,asd.[DayOfWeek]
    ,asd.[WeekCounter]
FROM
    (SELECT
        x.MetricId
        ,x.Title
        ,x.YValue
        ,x.MetricValueDateTime
        ,CAST(x.MetricValueDateTime AS DATE) AS [MetricValueDate]
        ,CASE x.MetricId
            WHEN 269 THEN 'Adventure'
            WHEN 271 THEN 'Blue Oaks'
            WHEN 325 THEN 'Davis'
            WHEN 275 THEN 'Folsom'
            WHEN 255 THEN 'Granite Bay'
            WHEN 277 THEN 'Orange County'
            WHEN 279 THEN 'Santa Rosa'
        END AS [Campus]
        ,ROW_NUMBER() OVER (PARTITION BY x.MetricValueDateTime ORDER BY x.MetricValueDateTime ASC) AS [RN]
    FROM
    (
        SELECT om.MetricId, om.Title, om.YValue, DATEADD(day, -1, om.MetricValueDateTime) AS [MetricValueDateTime] FROM otherMetrics om
        UNION ALL
        SELECT * FROM GB_Kids_Metric
        UNION ALL
        SELECT * FROM OC_Kids_Metric
    ) x
) y
INNER JOIN [AnalyticsSourceDate] asd ON asd.[Date] = y.MetricValueDate
WHERE
    asd.Date BETWEEN '2022-04-10' AND '2022-07-03'
    AND ((asd.DayOfWeek < 2) OR (asd.DayOfWeek = 2 AND y.MetricValueDate = '2022-06-21'))
ORDER BY
    asd.[SundayDate] DESC,
    --y.MetricValueDateTime ASC, 
    y.Campus ASC


/*
INSRT INTO [MetricValue]
*/