/*
---
-- Contributions YTD
---
SELECT
    SUM(TransactionAmount) AS [Received YTD]
    ,YTD Date
FROM
    [FinancialTransactionDetail] ftd
WHERE
    ftd.CreatedDate or TransactionDate is up to today from this year.
*/

WITH ytd_contributions AS (
    SELECT
        ROW_NUMBER() OVER (PARTITION BY ftd.Id ORDER BY ft.TransactionDateTime) AS [RowId]
        ,ftd.Id
        ,ftd.Amount
        ,ftd.FeeAmount
        ,ftd.FeeCoverageAmount
        ,fa.CampusId
        ,CAST(ft.TransactionDateTime AS DATE) AS [TransactionDate]
        ,DATEPART(week, ft.TransactionDateTime) AS WeekInYear
        ,DATEDIFF(dd, '01/01/2023', ft.TransactionDateTime) AS DayInYear
    FROM
        FinancialTransaction ft
        INNER JOIN FinancialTransactionDetail ftd ON ft.Id = ftd.TransactionId
        INNER JOIN [FinancialAccount] fa ON fa.Id = ftd.AccountId
    WHERE
        ft.TransactionDateTime >= DATEADD(year, DATEDIFF(year, 0, GETDATE()), 0)
        AND ft.TransactionTypeValueId = 53
)

SELECT
    x.DayInYear
    ,x.TransactionDate
  --  ,x.CampusId
    ,COUNT(x.Id) AS [UniqueTransactionCount]
    ,SUM(x.Amount) AS [UniqueTransAmount]
    ,SUM(SUM(x.Amount)) OVER (ORDER BY x.TransactionDate) AS [CumulTransCount]
    ,SUM(COUNT(x.Id)) OVER (ORDER BY x.TransactionDate) AS [CumulativeUniqueTransCount]
FROM
    (SELECT
        ytd.TransactionDate
        ,ytd.Id
        ,ytd.DayInYear
        ,ytd.Amount
     --   ,ytd.CampusId
    FROM
        ytd_contributions ytd
    WHERE
        ytd.RowId = 1
    GROUP BY
        ytd.TransactionDate, ytd.Id, ytd.DayInYear, ytd.Amount--, ytd.CampusId
    ) x
GROUP BY
    x.DayInYear, x.TransactionDate--, x.CampusId
ORDER BY
    x.DayInYear DESC