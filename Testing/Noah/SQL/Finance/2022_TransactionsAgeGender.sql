WITH all_transactions AS (
    SELECT
        ftd.[Id] AS [TransactionDetailId]
        ,ftd.[Amount]
        ,ft.[Id] As [TransactionId]
        ,ft.[AuthorizedPersonAliasId]
        ,p.[Id] As [PersonId]
        ,CASE p.[Gender]
            WHEN 1 THEN 'Male'
            WHEN 2 THEN 'Female'
            ELSE 'N/A'
        END As [Gender]
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
        AND ft.[TransactionTypeValueId] = 53
),
transactions_by_age_gender As (
    SELECT
        COUNT(x.[TransactionDetailId]) As [CountTrans]
        ,SUM(x.[Amount]) AS [TotalAmount]
        ,x.[PersonId]
        ,x.[Gender]
        ,x.[Age]
        ,x.[Age] / 10 As [AgeTens]
    FROM
        all_transactions x
    GROUP BY
        x.[PersonId], x.[Age], x.[Gender]
)

SELECT
    z.*
    --,MAX(z.[AverageTransPerAge]) OVER (Partition by z.[Age]) AS [WhichAgeGivesMore]
FROM
    (SELECT
        SUM(y.[CountTrans]) AS [SummedCountTrans]
        ,AVG(y.[CountTrans]) AS [AverageTransPerAge]
        ,MAX(y.[CountTrans]) AS [MaxTransPerAge]
        ,MIN(y.[CountTrans]) AS [MinTransPerAge]
        ,SUM(y.[TotalAmount]) As [SummedTotalAmount]
        ,AVG(y.[TotalAmount]) As [AvgTotalAmountPerAge]
        ,MAX(y.[TotalAmount]) As [MaxTotalAmountPerAge]
        ,MIN(y.[TotalAmount]) As [MinTotalAmountPerAge]
        ,COUNT(*) As [CountPeople]
        ,y.[Age]
        ,y.[Gender]
        --,y.[AgeTens]
    FROM
        transactions_by_age_gender y
    GROUP BY
        y.[Age], y.[Gender]
    ) z
ORDER BY
    z.[SummedTotalAmount] DESC