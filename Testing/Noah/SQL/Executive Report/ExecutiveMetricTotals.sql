WITH selectedMetrics AS (
    SELECT
        mc.MetricId
        ,c.Name
        ,c.Id AS [CategoryId]
    FROM
        [MetricCategory] mc
        INNER JOIN [Category] c ON c.Id = mc.CategoryId
    WHERE
        c.ParentCategoryId = 1819
), metricValues AS (
SELECT
    sm.Name As [CategoryName]
    ,sm.MetricId
    ,m.Title
    ,mv.YValue
    ,mv.MetricValueDateTime
    ,ROW_NUMBER() OVER (PARTITION BY m.Id ORDER BY mv.MetricValueDateTime DESC) As [RowNum]
FROM
    [MetricValue] mv
    INNER JOIN [Metric] m ON m.Id = mv.MetricId
    INNER JOIN selectedMetrics sm ON sm.MetricId = mv.MetricId
), metricWithPrevious As (
SELECT
    mv.*
    ,LEAD(mv.YValue, 1) OVER (PARTITION BY mv.Title ORDER BY mv.RowNum) As [PreviousValue]
    ,SUM(mv.YValue) OVER (PARTITION BY mv.Title, mv.RowNum ORDER BY mv.RowNum) AS [TotalAmount]
FROM
    metricValues mv
WHERE
    mv.RowNum < 3
), metricGroupTotal AS (
SELECT
    mwp.Title
    ,MAX(mwp.TotalAmount) AS [TotalAmount]
    ,mwp.MetricValueDateTime
    ,mwp.RowNum
FROM
    metricWithPrevious mwp
GROUP BY
    mwp.Title, mwp.MetricValueDateTime, mwp.RowNum
), metricTotalWithDelta AS (
SELECT
    mgt.*
    ,LEAD(mgt.TotalAmount, 1) OVER (PARTITION BY mgt.Title ORDER BY mgt.RowNum) AS [PreviousTotalAmount]
    ,mgt.TotalAmount - LEAD(mgt.TotalAmount, 1) OVER (PARTITION BY mgt.Title ORDER BY mgt.RowNum) As [Difference]
    ,(mgt.TotalAmount - LEAD(mgt.TotalAmount, 1) OVER (PARTITION BY mgt.Title ORDER BY mgt.RowNum)) * 100 / NULLIF(mgt.TotalAmount, 0) AS [Percent]
FROM
    metricGroupTotal mgt
)

SELECT
    mtwd.*
FROM
    metricTotalWithDelta mtwd
WHERE
    mtwd.RowNum = 1
ORDER BY
    mtwd.[Percent] DESC