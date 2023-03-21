DECLARE @today DATETIME = CAST(GETDATE() AS DATE);
DECLARE @currentYear INT = DATEPART(year, @today);

WITH Givers AS (
    SELECT
        pa.PersonId AS [PersonId],
        ft.TransactionDateTime
    FROM
        FinancialTransaction ft
        INNER JOIN PersonAlias pa ON ft.AuthorizedPersonAliasId = pa.Id
        INNER JOIN FinancialTransactionDetail ftd ON ft.Id = ftd.TransactionId
      --  INNER JOIN Person p ON pa.PersonId = p.Id
    WHERE
        DATEPART(year, ft.TransactionDateTime) = @currentYear
        AND ft.TransactionTypeValueId = 53
)
SELECT
    COUNT(DISTINCT Givers.PersonId) AS [NewGivers]
FROM
    Givers
WHERE
    Givers.PersonId NOT IN (
        SELECT 
            pa.PersonId AS [PersonId]
        FROM
            FinancialTransaction ft
            INNER JOIN PersonAlias pa ON ft.AuthorizedPersonAliasId = pa.Id
            INNER JOIN FinancialTransactionDetail ftd ON ft.Id = ftd.TransactionId
            --INNER JOIN Person p ON pa.PersonId = p.Id
        WHERE
            DATEPART(year, ft.TransactionDateTime) = @currentYear - 1
            AND ft.TransactionTypeValueId = 53
    )