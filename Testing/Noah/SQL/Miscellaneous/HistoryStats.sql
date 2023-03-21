WITH metricHistory As (
    SELECT
        p.*
    FROM (
        SELECT pvt.Id
        ,cast(pvt.MetricValueDateTime AS DATE) AS [MetricValueDateTime]
        ,pvt.YValue
        ,pvt.IsGoal
        FROM (
            SELECT 
            mv.Id
            ,mv.YValue
            ,mv.MetricValueDateTime
            ,case when MetricValueType = 1 then 1 else 0 end as IsGoal
            FROM MetricValue mv
            WHERE mv.MetricId = 548
            ) pvt
    ) p
)

SELECT
    x.*
    ,CASE
        WHEN x.YValue < x.AverageValue THEN 'Below Average'
        ELSE 'Above or at Average'
    END As [Stats]
FROM
    (SELECT
        *
        ,MAX(YValue) OVER () As [MaxValue]
        ,MIN(YValue) OVER () AS [MinValue]
        ,AVG(YValue) OVER () AS [AverageValue]
        ,STDEV(YValue) OVER () AS [StdDev]
    FROM
        metricHistory mh
    ) x