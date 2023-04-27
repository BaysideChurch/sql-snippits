SELECT
    y.*
FROM
    (SELECT
        x.*
        ,COUNT(*) OVER (Partition by x.ServiceJobId ORDER BY x.ServiceJobId) AS [JobCount]
        ,CAST(x.CreatedDateTime AS TIME) AS [TimeCreated]
        ,ROW_NUMBER() OVER (PARTITION BY x.ServiceJobId ORDER BY x.CreatedDateTime) AS [NumberRanForJob]
        ,DATEADD(minute, DATEDIFF(minute, 0, x.CreatedDateTime) / 5 * 5, 0) AS [RoundedTime]
        ,LEAD(x.Status) OVER (ORDER BY x.RowNum) AS [NextStatus]
        ,LAG(x.Status) OVER (ORDER BY x.RowNum) AS [PreviousStatus]
    FROM
        (SELECT
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
        FROM
            [ServiceJob] sj
            INNER JOIN [ServiceJobHistory] sjh ON sjh.ServiceJobId = sj.Id
        WHERE
            CAST(sjh.CreatedDatetime AS DATE) > '2023-03-11'
            --AND CAST(sjh.CreatedDatetime AS DATE) >= '01-18-2023'
        ) x
    ) y
WHERE
    y.TimeCreated BETWEEN '02:00:00.2533333' AND  '03:00:00.2533333'
    --y.ServiceJobId NOT IN (50, 57, 9, 62, 45, 23, 16, 110, 103, 22, 43, 10, 40, 34, 8, 132, 51, 60, 128, 13, 1, 56, 89, 135, 123, 119, 139, 66, 52, 136)
    /*(y.NextStatus = 'Exception'
    OR y.PreviousStatus = 'Exception'
    OR y.Status = 'Exception')*/
ORDER BY
    y.RowNum, y.Status