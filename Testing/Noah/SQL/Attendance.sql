SELECT
    TOP 1000
    mv.[YValue]
    ,mv.MetricValueDateTime
    ,DATEPART(DW, mv.[MetricValueDateTime])
   -- ,CASE WHEN DATEPART(DW, mv.[MetricValueDateTime]) = 1 THEN 1 ELSE 0 END As [IsSunday]
FROM
    [MetricValue] mv
WHERE
    mv.[MetricId] = 242
    AND DATEPART(DW, mv.[MetricValueDateTime]) IN (1,3, 4)