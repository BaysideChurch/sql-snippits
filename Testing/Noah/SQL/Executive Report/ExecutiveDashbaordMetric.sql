WITH weekly_giving AS (
SELECT
    ROW_NUMBER() OVER (ORDER BY mv.MetricValueDateTime DESC) aS [RowNum]
    ,mv.Id AS [MetricValueId]
    ,m.Title
    ,mv.YValue
    ,CAST(mv.MetricValueDateTime AS DATE) AS [MetricValueDate]
FROM
    [MetricValue] mv
    INNER JOIN [MetricValuePartition] mvp ON mvp.MetricValueId = mv.Id
    INNER JOIn [Metric] m ON m.Id = mv.MetricId
WHERE
    m.Id = 552 -- Metric to look for
    AND mvp.EntityId = 2 -- Campus to look for
), weekly_givers_lead AS (
SELECT
    wg.*
    ,LEAD(wg.YValue) OVER (ORDER BY wg.MetricValueDate DESC) AS [PreviousWeekYValue]
    ,LEAD(wg.YValue, 10) OVER (ORDER BY wg.MetricValueDate DESC) AS [SameWeekPrevYearYValue]
FROM
    weekly_giving wg
)

SELECT
    wg.*
    ,wg.YValue - wg.PreviousWeekYValue AS [DifferenceFromPrevWeek]
FROM
    weekly_givers_lead wg

  --  6/26/22