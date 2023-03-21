SELECT
    COUNT(DISTINCT p.Id)
FROM
    FinancialTransaction ft
    INNER JOIN FinancialTransactionDetail ftd ON ft.Id = ftd.TransactionId
    INNER JOIN PersonAlias pa ON ft.AuthorizedPersonAliasId = pa.Id
    INNER JOIN Person p ON pa.PersonId = p.Id
WHERE
    ft.TransactionDateTime >= DATEADD(year, DATEDIFF(year, 0, GETDATE()), 0)
    AND ft.TransactionTypeValueId = 53