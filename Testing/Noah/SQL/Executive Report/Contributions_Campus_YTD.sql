DECLARE @today DATETIME = GETDATE();
DECLARE @firstOfYear DATETIME = DATEADD(year, DATEDIFF(year, 0, @today), 0);
DECLARE @yesterdaySunday DATETIME = DATEADD(day, -1, CAST(@today AS DATE));

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
        AND ft.TransactionDateTime <= DATEADD(day, -1, @today)
        --DATEPART(year, ft.TransactionDateTime) = 2023
        AND ft.TransactionTypeValueId = 53
        AND fa.CampusId IS NOT NULL
        AND fa.CampusId NOT IN (3,6,9,10) -- Auburn, Elk Grove, Midtown, Global Online
)

--SELECt * FROM campus_contributions ORDER BY campus_contributions.TransactionDate ASC;

SELECT
    SUM(x.Amount) AS [TotalAmount]
    ,x.CampusId
    ,MAX(x.CampusName) AS [CampusName]
    ,@today AS [MetricValueDateTime]
FROM
    campus_contributions x
GROUP BY
    x.CampusId