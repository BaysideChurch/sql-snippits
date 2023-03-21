DECLARE @today DATETIME = DATEADD(day, -60, CAST(GETDATE() AS DATE)); -- Always going to be Monday via the Metrics
DECLARE @yesterday DATETIME = DATEADD(day, -1, @today); -- Always going to be Sunday
DECLARE @firstOfYear DATETIME = DATEADD(year, DATEDIFF(year, 0, @today), 0);
DECLARE @currentYear INT = DATEPART(year, @today);

WITH weekly_givers AS (
    SELECT
        pa.PersonId
        ,fa.CampusId
        ,ft.SundayDate
    FROM
        FinancialTransaction ft
        INNER JOIN FinancialTransactionDetail ftd ON ft.Id = ftd.TransactionId
        INNER JOIN [FinancialAccount] fa ON fa.Id = ftd.AccountId
        INNER JOIN PersonAlias pa ON ft.AuthorizedPersonAliasId = pa.Id
    WHERE
        ft.TransactionDateTime <= @today
        AND DATEPART(year, ft.TransactionDateTime) = @currentYear
        --AND ft.SundayDate = @yesterday
        AND ft.TransactionTypeValueId = 53
        AND fa.CampusId IS NOT NULL
        AND fa.CampusId NOT IN (3,6,9,10) -- Auburn, Elk Grove, Midtown, Global Online
)

SELECT
    COUNT(*) AS [Givers]
    --,@yesterday As [MetricValueDateTime]
    ,wg.SundayDate
    ,CASE wg.CampusId WHEN 2 tHEN 'AD' WHEN 4 THEN 'BO' wHEN 5 THEN 'DA' WHEN 7 THEN 'FO' WHEN 8 THEN 'GB' WHEN 11 tHEN 'OC' WHEN 12 tHEN 'SR' ELSE NULL END AS [Campus]
    ,wg.CampusId
FROM
    weekly_givers wg
GROUP BY
    wg.CampusId, wg.SundayDate
ORDER BY
    wg.SundayDate DESC