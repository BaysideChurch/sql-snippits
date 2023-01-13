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
            CAST(sjh.CreatedDatetime AS DATE) = '01-11-2023'
        ) x
    ) y
--WHERE
    /*y.NextStatus = 'Exception'
    OR y.PreviousStatus = 'Exception'
    OR y.Status = 'Exception'
    */
ORDER BY
    y.RowNum, y.Status