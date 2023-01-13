SELECT
    AVG(y.[CountTrans]) AS [AverageTransPerAge]
    ,MAX(y.[CountTrans]) AS [MaxTransPerAge]
    ,MIN(y.[CountTrans]) AS [MinTransPerAge]
    ,AVG(y.[TotalAmount]) As [AvgTotalAmountPerAge]
    ,MAX(y.[TotalAmount]) As [MaxTotalAmountPerAge]
    ,MIN(y.[TotalAmount]) As [MinTotalAmountPerAge]
    ,y.[Age]
    --,y.[AgeTens]
FROM
    (SELECT
        COUNT(x.[TransactionDetailId]) As [CountTrans]
        ,SUM(x.[Amount]) AS [TotalAmount]
        ,x.[PersonId]
        ,x.[Age]
        ,x.[Age] / 10 As [AgeTens]
    FROM
        (SELECT
            ftd.[Id] AS [TransactionDetailId]
            ,ftd.[Amount]
            ,ft.[Id] As [TransactionId]
            ,ft.[AuthorizedPersonAliasId]
            ,p.[Id] As [PersonId]
            ,[dbo].[ufnCrm_GetAge](p.[BirthDate]) AS [Age]
            ,ft.[TransactionDateTime]
            ,ftd.[AccountId]
            ,ft.[SundayDate]
        FROM
            [FinancialTransactionDetail] ftd
            INNER JOIN [FinancialTransaction] ft ON ft.[Id] = ftd.[TransactionId]
            INNER JOIN [PersonAlias] pa ON pa.[Id] = ft.[AuthorizedPersonAliasId]
            INNER JOIN [Person] p ON p.[Id] = pa.[PersonId]
        WHERE
            YEAR(ft.[TransactionDateTime]) = 2022
            OR YEAR(ft.[CreatedDateTime]) = 2022
        ) x
    GROUP BY
        x.[PersonId], x.[Age]
    ) y
GROUP BY
    y.[Age]
ORDER BY
    y.[Age] ASC