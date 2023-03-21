SELECT
    x.*
    ,(x.PartialCount * 100) / (x.BirthYearCount) AS [PercentageCount]
    ,x.[SummedAmount] / x.[PartialCount] As [AvgAmountPerPerson]
FROM
(SELECT
    TOP 100
    p.[BirthYear]
    ,COUNT(p.[BirthYear]) As [BirthYearCount]
    ,COUNT(CASE WHEN ft.[Id] IS NOT NULL THEN p.[BirthYear] ELSE NULL END) AS [PartialCount]
    ,AVG(NULLIF(ftd.Amount, 0)) As [AvgTransactionAmount]
    ,MIN(ftd.[Amount]) AS [MinTransactionAmount]
    ,MAX(ftd.[Amount]) AS [MaxTransactionAmount]
    ,COUNT(ftd.[Id]) AS [CountTransactions]
    ,SUM(ftd.[Amount]) As [SummedAmount]
FROM
    [Person] p
    INNER JOIN [PersonAlias] pa ON pa.[PersonId] = p.[Id]
    LEFT JOIN [FinancialTransaction] ft ON ft.[AuthorizedPersonAliasId] = pa.[Id]
    LEFT JOIN [FinancialTransactionDetail] ftd ON ftd.[TransactionId] = ft.[Id] AND DATEPART(YEAR, ftd.[CreatedDateTime]) = 2022 --AND DATEPART(MONTH, ftd.[CreatedDateTime])
    LEFT JOIN [FinancialAccount] fa ON fa.[Id] = ftd.[AccountId] AND fa.[AccountTypeValueId] = 1474
WHERE
    p.[BirthYear] BETWEEN 1914 AND 2023
    AND p.[IsDeceased] != 1
    --AND DATEPART(YEAR, p.[CreatedDateTime]) < 2022
GROUP BY
    p.[BirthYear]
ORDER BY
    p.[BirthYear] DESC
) x