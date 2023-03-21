DECLARE @today DATETIME = DATEADD(day, 0,CAST(GETDATE() AS DATE)); -- Typically always going to be a Monday
DECLARE @yesterdaySunday DATETIME = DATEADD(day, -1, @today); -- Typically always going to be a Sunday
DECLARE @firstOfYear DATETIME = DATEADD(year, DATEDIFF(year, 0, @today), 0);

WITH campus_contributions AS (
    SELECT
        ftd.Id
        ,ftd.Amount
        ,ftd.FeeAmount
        ,ftd.FeeCoverageAmount
        ,fa.CampusId
        ,ft.[TransactionDateTime]
        ,ft.[SundayDate]
        ,@yesterdaySunday AS [YesterdaySunday]
        ,DATEADD( day, -( DATEPART( day, ft.SundayDate ) ) + 1, ft.SundayDate ) AS [MonthDate]
        ,DATEADD( day, -( DATEPART( dayofyear, ft.SundayDate ) ) + 1, ft.SundayDate ) AS [YearDate]
        ,fa.Id AS [AccountId]
        ,CAST(ft.TransactionDateTime AS DATE) AS [TransactionDate]
        ,DATEPART(week, ft.TransactionDateTime) AS WeekInYear
        ,DATEDIFF(dd, @firstOfYear, ft.TransactionDateTime) AS DayInYear
        ,fa.Name AS [AccountName]
        ,c.Name AS [CampusName]
        ,fa.GlCode AS [GLCode]
    FROM
        FinancialTransaction ft
        INNER JOIN FinancialTransactionDetail ftd ON ft.Id = ftd.TransactionId
        INNER JOIN [FinancialAccount] fa ON fa.Id = ftd.AccountId
        INNER JOIN [Campus] c ON c.Id = fa.CampusId
    WHERE
        ft.TransactionDateTime >= @firstOfYear
        AND DATEPART(year, ft.TransactionDateTime) = DATEPART(year, @today)
        AND ft.TransactionDateTime <= @today
        AND ft.TransactionTypeValueId = 53
        AND fa.CampusId IS NOT NULL
        AND fa.CampusId NOT IN (3,6,9,10) -- Auburn, Elk Grove, Midtown, Global Online
)

--SELECT * FROm campus_contributions ORDER BY [TransactionDate];


SELECT
    SUM(x.Amount) AS [TotalAmount]
    ,x.CampusId
    ,x.CampusName
    ,x.SundayDate AS [MetricValueDateTime]
FROM
    campus_contributions x
WHERE
   -- x.CampusId = 4
    x.SundayDate = @yesterdaySunday
GROUP BY
    x.CampusId, x.CampusName, x.SundayDate
ORDER BY
    x.SundayDate DESC, x.CampusId