DECLARE @today DATE = CAST(GETDATE() AS DATE);

SELECT
    CAST(x.FailureCount AS DECIMAL) / x.DeliveredCount As [FailureRatio]
    ,x.OpenedCount
    ,x.CreatedDate
FROM
    (SELECT
        SUM(CASE WHEN cr.Status = 1 THEN 1 ELSE 0 END) AS [DeliveredCount]
        ,SUM(CASE WHEN cr.Status = 2 THEN 1 ELSE 0 END) AS [FailureCount]
        ,SUM(CASE WHEN cr.Status = 4 THEN 1 ELSE 0 END) AS [OpenedCount]
        ,CAST(cr.CreatedDateTime AS DATE) AS [CreatedDate]
    FROM
        [CommunicationRecipient] cr
    WHERE
        cr.[Status] IN (1,2,4)
    GROUP BY
        CAST(cr.CreatedDateTime AS DATE)
    ) x