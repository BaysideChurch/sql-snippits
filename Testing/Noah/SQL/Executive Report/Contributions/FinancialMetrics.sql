DECLARE @today DATETIME = CAST(GETDATE() AS DATE);
DECLARE @twoWeeksAgo DATETIME = DATEADD(week, -2, @today);
DECLARE @oneWeekAgo DATETIME = DATEADD(week, -1, @today);
DECLARE @sundayDate DATETIME = [dbo].[ufnUtility_GetSundayDate](@oneWeekAgo);

WITH financeMetrics AS (
SELECT
    m.Id
    ,m.Title
    ,m.DataViewId
FROM
    [Metric] m
WHERE
    m.Id IN (552, 648, 550) -- Weekly Contributions, YTD Contributions, Weekly Budget
), metricValues AS (
SELECT
    TOP 200
    fm.Title
    ,fm.Id AS [MetricId]
    ,mv.YValue
    ,mv.MetricValueDateTime
    ,DATEPART(week, mv.MetricValueDateTime) AS [WeekOfYear]
    ,mvp.EntityId AS [CampusId]
    ,ROW_NUMBER() OVER (PARTITION BY fm.Id, mv.MetricValueDateTime ORDER BY mv.MetricValueDateTime DESC) AS [RowNum]
FROM
    financeMetrics fm
    INNER JOIN [MetricValue] mv ON mv.MetricId = fm.Id
    INNER JOIN [MetricValuePartition] mvp ON mvp.MetricValueId = mv.Id
WHERE
    mvp.EntityId IS NOT NULL
    AND mvp.EntityId IN (2,4,5,7,8,11,12) -- Active campuses
    AND mv.MetricValueDateTime >= @twoWeeksAgo
), budgetsMV AS (
SELECT
    mv.*
    ,SUM(CASE WHEN mv.Title = 'Weekly Budget' THEN YValue END) 
            OVER (PARTITION BY mv.CampusId, YEAR(mv.MetricValueDateTime) ORDER BY mv.MetricValueDateTime) 
            AS [RunningTotalWeeklyBudget]
FROM
    metricValues mv
), groupings AS (
SELECT
    mv.CampusId
    ,MAX(c.Name) AS [Campus]
    ,mv.MetricValueDateTime
    ,MAX(mv.WeekOfYear) AS [WeekOfYear]
    ,MAX(mv.RunningTotalWeeklyBudget) AS [YtdBudget]
    ,MAX(CASE WHEN mv.Title = 'Weekly Budget' THEN mv.YValue END) AS [WeeklyBudget]
    ,MAX(CASE WHEN mv.Title = 'YTD Contributions Per Campus' THEN mv.YValue END) AS [YtdContributions]
    ,MAX(CASE WHEN mv.Title = 'Weekly Contributions Per Campus' THEN mv.YValue END) AS [WeeklyContributions]
FROM
    budgetsMV mv
    INNER JOIN [Campus] c ON c.Id = mv.CampusId
WHERE
    CAST(mv.MetricValueDateTime AS DATE) = @sundayDate
GROUP BY
    mv.CampusId, mv.MetricValueDateTime
)

SELECT
    g.*
FROM
    groupings g;