SELECT
    x.*
    ,CASE WHEN x.Maximum = x.Minimum
        THEN 0
        ELSE (x.YValue - x.Minimum) / (x.Maximum - x.Minimum)
    END AS scaled_value
    ,LOG(x.YValue, 10) As [LogValue]
    ,ROUND(LOG(x.YValue, 10), 0) As [RoundedLogValue]
    ,POWER(10, ROUND(LOG(x.YValue, 10), 0)) AS [ExponentRange]
FROM
(SELECT
    mvp.EntityId AS [CampusId]
    ,mv.MetricValueDateTime
    ,mv.YValue
    ,MAX(mv.YValue) OVER (PARTITION BY mv.MetricValueDateTime) As [Maximum]
    ,MIN(mv.YValue) OVER (PARTITION BY mv.MetricValueDateTime) AS [Minimum]
FROM 
    [MetricValue] mv
    INNER JOIN [MetricValuePartition] mvp ON mvp.MetricValueId = mv.Id
WHERE
    mv.MetricId = 552
) x
ORDER BY
    x.MetricValueDateTime DESC, x.CampusId
