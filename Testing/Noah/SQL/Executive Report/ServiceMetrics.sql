DECLARE @today DATETIME = CAST(GETDATE() AS DATE);
DECLARE @today1 DATETIME = DATEADD(day, -4, @today);
DECLARE @sunday DATETIME = DATEADD(day, -7, @today1);


With service as (
SELECT
    mv.YValue
    ,mv.MetricValueDateTime
    ,mp.EntityTypeId
    ,mp.EntityTypeQualifierColumn
    ,mp.EntityTypeQualifierValue
    ,mvp.EntityId
FROM
    [MetricValue] mv
    INNER JOIN [MetricValuePartition] mvp ON mvp.MetricValueId = mv.Id
    INNER JOIN [MetricPartition] mp ON mp.Id = mvp.MetricPartitionId
WHERE
    mv.MetricId = 566
    AND mp.EntityTypeId = 67 -- Campus
    --AND mv.Id = 464095
)

SELECT
    SUM(s.YValue) AS [CampusCount]
    ,s.MetricValueDateTime
    ,s.EntityId AS [CampusId]
    ,@today1
    ,@sunday
FROM
    service s
WHERE
    s.MetricValueDateTime > @sunday
    AND s.MetricValueDateTime <= @today1
GROUP BY
    s.MetricValueDateTime, s.EntityId