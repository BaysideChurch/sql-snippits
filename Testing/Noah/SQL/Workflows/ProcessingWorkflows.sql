WITH workflows AS (
SELECT
    TOP 10000
    wf.Id
    ,wf.WorkflowTypeId
    ,wft.Name AS [WorkflowTypeName]
    ,(wft.ProcessingIntervalSeconds / 60 ) AS [ProcessingIntervalMinutes]
    ,wf.Name
    ,wf.Status
    ,wf.LastProcessedDateTime
    ,DATEADD(minute, DATEDIFF(minute, 0, wf.LastProcessedDateTime) / 1 * 1, 0) AS [RoundedProcessedTime]
    ,p.NickName + ' ' + p.LastName AS [FullName]
    ,pa.PersonId
FROM
    [Workflow] wf
    INNER JOIn [WorkflowType] wft ON wft.Id = wf.WorkflowTypeId
    LEFT JOIN [PersonAlias] pa ON pa.Id = wf.InitiatorPersonAliasId
    LEFT JOIN [Person] p ON p.Id = pa.PersonId
WHERE
    CAST(wf.LastProcessedDateTime AS DATE) = '01-11-2023'--CAST(GETDATE() AS DATE)
), jobHistory AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY sjh.CreatedDateTime) AS [RowNum]
        ,sjh.ServiceJobId
        ,sj.Name
        --  ,sj.IsActive
        ,sj.CronExpression
        --sql row_ umber
        ,sjh.ServiceWorker
        ,sjh.StartDateTime
        ,sjh.StopDateTime
        ,sjh.Status
        ,sjh.StatusMessage
        ,sjh.CreatedDateTime
        ,DATEDIFF(s, sjh.StartDateTime, sjh.StopDateTime) AS [Seconds]
        ,DATEADD(minute, DATEDIFF(minute, 0, sjh.CreatedDateTime) / 1 * 1, 0) AS [RoundedJobCreatedTime]
    FROM
        [ServiceJob] sj
        INNER JOIN [ServiceJobHistory] sjh ON sjh.ServiceJobId = sj.Id
    WHERE
        CAST(sjh.CreatedDatetime AS DATE) = '01-11-2023'--CAST(GETDATE() AS DATE)
        AND sj.Id = 8
)

SELECT
    --x.*
    COUNT(*) AS [TypeCount]
    ,x.WorkflowTypeName
    ,x.WorkflowTypeId
    ,x.ProcessingTime
FROM
    (SELECT
        jh.RowNum
        ,wf.PersonId
        ,wf.FullName
        ,jh.Seconds
        ,jh.Status AS [JobStatus]
        ,jh.StatusMessage
        ,wf.Id
        ,wf.WorkflowTypeId
        ,wf.WorkflowTypeName
        ,wf.Name
        ,wf.Status AS [WorkflowStatus]
        ,wf.LastProcessedDateTime
        ,CONVERT(NUMERIC(18, 2), wf.ProcessingIntervalMinutes / 60 + (wf.ProcessingIntervalMinutes % 60) / 100.0) AS [ProcessingTime]
        ,COUNT(*) OVER (PARTITION BY wf.WorkflowTypeId ORDER BY wf.WorkflowTypeId) As [TypeCount]
        ,jh.CreatedDateTime
        ,wf.RoundedProcessedTime
        ,jh.RoundedJobCreatedTime
        ,jh.StartDateTime
        ,jh.StopDateTime
    FROM
        jobHistory jh
        ,workflows wf
    WHERE
        wf.LastProcessedDateTime >= jh.StartDateTime
        AND wf.LastProcessedDateTime <= jh.StopDateTime
        AND wf.Status != 'Completed'
    ) x
GROUP BY
    x.WorkflowTypeName, x.WorkflowTypeId, x.ProcessingTime
ORDER BY
    [TypeCount] DESC
/*ORDER BY
    x.LastProcessedDateTime, x.WorkflowTypeName
    */