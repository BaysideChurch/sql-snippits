SELECT
    y.*
    ,CASE
        WHEN y.[LastStatus] = 'Exception' THEN 'Broke'
        WHEN y.[FasterThanAverage] = 1 AND (y.[LastRunDurationSeconds] <= y.[Lower3rdBound]) THEN 'Below -3rd'
        WHEN (y.[FasterThanAverage] = 1) AND (y.[LastRunDurationSeconds] BETWEEN y.[Lower3rdBound] AND y.[Lower2ndBound]) THEN 'Lower 3rd to 2nd'
        WHEN (y.[FasterThanAverage] = 1) AND (y.[LastRunDurationSeconds] BETWEEN y.[Lower2ndBound] AND y.[Lower1stBound]) THEN 'Lower 2nd to 1st'
        WHEN (y.[LastRunDurationSeconds] BETWEEN y.[Lower1stBound] AND y.[Upper1stBound]) THEN 'Lower 1st to Upper 1st'
        WHEN (y.[FasterThanAverage] = 0) AND (y.[LastRunDurationSeconds] BETWEEN y.[Lower1stBound] AND y.[Upper2ndBound]) THEN 'Upper 1st to 2nd'
        WHEN (y.[FasterThanAverage] = 0) AND (y.[LastRunDurationSeconds] BETWEEN y.[Upper2ndBound] AND y.[Upper3rdBound]) THEN 'Upper 2nd to 3rd'
        WHEN y.[FasterThanAverage] = 0 AND (y.[LastRunDurationSeconds] >= y.[Upper3rdBound]) THEN 'Above 3rd'
        ELSE '0 or something'
    END AS [Boundaries]
    ,CASE
        WHEN y.[LastStatus] = 'Exception' THEN 'Broke'
        WHEN (y.[LastRunDurationSeconds] <= y.[Lower3rdBound]) OR (y.[LastRunDurationSeconds] >= y.[Upper3rdBound]) THEN 'Beyond 3rd'
        WHEN (y.[LastRunDurationSeconds] BETWEEN y.[Lower3rdBound] AND y.[Lower2ndBound])
         OR (y.[LastRunDurationSeconds] BETWEEN y.[Upper2ndBound] AND y.[Upper3rdBound]) THEN '2nd to 3rd'
        WHEN (y.[LastRunDurationSeconds] BETWEEN y.[Lower1stBound] AND y.[Upper1stBound]) THEN '1st to 1st'
        ELSE '0 or nothing'
    END As [Bounds]    
FROM
(SELECT
    x.*
    ,CASE WHEN x.[AvgTimeElapsed] - x.[LastRunDurationSeconds] > 0 THEN 1 ELSE 0 END AS [FasterThanAverage]
    ,ABS(x.[LastRunDurationSeconds] - x.[AvgTimeElapsed]) As [DiffSecondsAbs]
    ,(-3 * x.[StdDevTimeElapsed]) + x.[AvgTimeElapsed] AS [Lower3rdBound]
    ,(-2 * x.[StdDevTimeElapsed]) + x.[AvgTimeElapsed] AS [Lower2ndBound]
    ,(-1 * x.[StdDevTimeElapsed]) + x.[AvgTimeElapsed] AS [Lower1stBound]
    ,(1 * x.[StdDevTimeElapsed]) + x.[AvgTimeElapsed] AS [Upper1stBound]
    ,(2 * x.[StdDevTimeElapsed]) + x.[AvgTimeElapsed] AS [Upper2ndBound]
    ,(3 * x.[StdDevTimeElapsed]) + x.[AvgTimeElapsed] AS [Upper3rdBound]
FROM
(SELECT
    TOP 10000
    sj.[Id]
    ,sj.[Name]
    ,sj.CronExpression
    ,sj.[LastSuccessfulRunDateTime]
    ,sj.[LastRunDurationSeconds]
    ,CAST(sj.[LastRunDurationSeconds] AS DECIMAL(10,2)) / 60  As [LastRunDurationMinutes]
    ,sj.[LastStatus]
    ,AVG(DATEDIFF(s, sjh.[StartDateTime], sjh.[StopDateTime])) AS [AvgTimeElapsed]
    ,MIN(DATEDIFF(s, sjh.[StartDateTime], sjh.[StopDateTime])) AS [MinTimeElapsed]
    ,MAX(DATEDIFF(s, sjh.[StartDateTime], sjh.[StopDateTime])) AS [MaxTimeElapsed]
    ,STDEVP(DATEDIFF(s, sjh.[StartDateTime], sjh.[StopDateTime])) As [StdDevTimeElapsed]
    ,COUNT(sjh.[Id]) AS [CountJobs]
FROM
    [ServiceJob] sj
    INNER JOIN [ServiceJobHistory] sjh ON sjh.[ServiceJobId] = sj.[Id]
WHERE
    sj.[IsActive] = 1
    AND sjh.CreatedDateTime >= CAST(GETDATE() AS DATE)
GROUP BY
    sj.[Id], sj.[Name], sj.[CronExpression], sj.[LastRunDurationSeconds], sj.[LastSuccessfulRunDateTime], sj.[LastStatus]
) x
) y
ORDER BY
    --sj.[LastSuccessfulRunDateTime] DESC,
    y.[LastRunDurationSeconds] DESC,
   y.[AvgTimeElapsed] DESC