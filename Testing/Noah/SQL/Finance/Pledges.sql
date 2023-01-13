SELECT
    x.*
    ,x.[AmountGiven] / NULLIF(x.[TotalAmountPledged], 0) AS [PercentGiven]
    ,x.[TotalAmountPledged] - x.[AmountGiven] As [AmountRemaining]
FROM
    (SELECT
        TOP 1000
        pledge.[Id] As [PledgeId]
        ,pledge.[AccountId]
        ,account.[Name] As [AccountName]
        ,pledge.[TotalAmount] As [TotalAmountPledged]
        ,pledge.[PledgeFrequencyValueId]
        ,frequency.[Value] AS [Frequency]
        ,pledge.[StartDate]
        ,pledge.[EndDate]
        ,pledge.[PersonAliasId]
        ,p.[Id] AS [PersonId]
        ,pledge.[CreatedDateTime]
        ,SUM(ftd.[Amount]) AS [AmountGiven]
    FROM
        [FinancialPledge] pledge
        INNER JOIN [FinancialAccount] account ON account.[Id] = pledge.[AccountId]
        INNER JOIN [DefinedValue] frequency ON frequency.[Id] = pledge.[PledgeFrequencyValueId]
        INNER JOIN [FinancialTransactionDetail] ftd ON ftd.[AccountId] = account.[Id]
        INNER JOIN [FinancialTransaction] ft ON ft.[Id] = ftd.[TransactionId]
        INNER JOIN [PersonAlias] pa ON pa.[Id] = pledge.[PersonAliasId]
        INNER JOIN [Person] p ON p.[Id] = pa.[PersonId]
    WHERE
        ftd.[Amount] IS NOT NULL
        AND ft.[TransactionTypeValueId] = 53
        AND ft.[TransactionDateTime] BETWEEN pledge.[StartDate] AND pledge.[EndDate]
        AND ft.[AuthorizedPersonAliasId] = pledge.[PersonAliasId]
        AND ft.[AuthorizedPersonAliasId] IS NOT NULL
        --AND p.[Id] = {{ CurrentPerson.Id }}
    GROUP BY
        pledge.[Id],pledge.[AccountId],account.[Name],pledge.[TotalAmount],pledge.[PledgeFrequencyValueId]
        ,pledge.[StartDate],pledge.[EndDate],pledge.[PersonAliasId],pledge.[CreatedDateTime],frequency.[Value],p.[Id]
    ) x
ORDER BY
    x.[EndDate] DESC
    ,x.[StartDate] DESC
    ,x.[PledgeId]