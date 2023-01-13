WITH people_contributors AS (
    SELECT
        MAX(p.[BirthYear]) AS BirthYear
        ,p.[Id]
        ,MAX(ftd.[Amount]) AS [MaxAmount]
        ,COUNT(ftd.[Id]) AS [TransactionCount]
        ,MIN(ftd.[Amount]) AS [MinAmount]
        ,SUM(ftd.[Amount]) AS [TotalAmount]
        ,AVG(ftd.[Amount]) AS [AvgAmount]
        ,MAX(p.[MaritalStatusValueId]) AS [MaritalStatusValueId]
    FROM
        [Person] p
        INNER JOIN [PersonAlias] pa ON pa.[PersonId] = p.[Id]
        LEFT JOIN [FinancialTransaction] ft ON ft.[AuthorizedPersonAliasId] = pa.[Id]
        LEFT JOIN [FinancialTransactionDetail] ftd ON ftd.[TransactionId] = ft.[Id]
            AND DATEPART(YEAR, ftd.[CreatedDateTime]) = 2022 
            --AND DATEPART(MONTH, ftd.[CreatedDateTime]) = 12
        LEFT JOIN [FinancialAccount] fa ON fa.[Id] = ftd.[AccountId] AND fa.[AccountTypeValueId] = 1474
    WHERE
        p.[BirthYear] BETWEEN 1914 AND 2004
        AND p.[IsDeceased] != 1
        AND p.[AgeClassification] != 2 -- Child
        AND p.[RecordTypeValueId] = 1 -- Person
        AND p.[RecordStatusValueId] != 4
        AND p.[MaritalStatusValueId] IS NOT NULL
        AND p.[PrimaryCampusId] NOT IN (3, 6, 9, 10, 27, 28) -- Auburn, Elk Grove, Midtown, Global Online, Lincoln, Folsom Prison
        --AND p.[MaritalStatusValueId] NOT IN (674, 1010) -- Divorced or widowed
        --AND DATEPART(YEAR, p.[CreatedDateTime]) < 2022
    GROUP BY
        p.[Id]
)

SELECT
    y.*
    ,y.[Contributors] * 100 / y.[Population] AS [PercentageContributors]
    ,COALESCE(y.[ContributingMarriedPopulation] * 100 / NULLIF(y.[MarriedPopulation], 0), 0) AS [ContributingMarriedPercentToSelf]
    ,COALESCE(y.[ContributingSinglePopulation] * 100 / NULLIF(y.[SinglePopulation], 0), 0) AS [ContributingSinglePercentToSelf]
    ,y.[ContributingMarriedPopulation] * 100 / y.[Population] AS [ContributingMarriedToWhole]
    ,y.[ContributingSinglePopulation] * 100 / y.[Population] AS [ContributingSingleToWhole]
    
FROM
    (SELECT
        x.[BirthYear]
        ,COUNT(x.[Id]) As [Population]
        ,COUNT(CASE WHEN x.[MaritalStatusValueId] = 143 THEN x.[Id] ELSE NULL END) AS [MarriedPopulation]
        ,COUNT(CASE WHEN x.[MaritalStatusValueId] = 144 THEN x.[Id] ELSE NULL END) AS [SinglePopulation]
       -- ,COUNT(CASE WHEN x.[MaritalStatusValueId] = 1674 THEN x.[Id] ELSE NULL END) AS [WidowedPopulation]
        --,COUNT(CASE WHEN x.[MaritalStatusValueId] = 1010 THEN x.[Id] ELSE NULL END) AS [DivorcedPopulation]
        ,COUNT(CASE WHEN x.[MaritalStatusValueId] = 143 AND x.[TransactionCount] > 0 THEN x.[Id] ELSE NULL END) AS [ContributingMarriedPopulation]
        ,COUNT(CASE WHEN x.[MaritalStatusValueId] = 144 AND x.[TransactionCount] > 0 THEN x.[Id] ELSE NULL END) AS [ContributingSinglePopulation]
        ,COUNT(CASE WHEN x.[TransactionCount] > 0 THEN x.[Id] ELSE NULL END) As [Contributors]
        --,MIN(x.[MinAmount]) AS [MinAmount]
        --,MAX(x.[MaxAmount]) As [MaxAmount]
        --,AVG(x.[AvgAmount]) As [AverageOfAverages]
        ,COALESCE(SUM(x.[TotalAmount]), 0) As [SummedTotal]
        ,COALESCE(SUM(x.[TotalAmount]) / SUM(x.[TransactionCount]), 0) AS [AvgTransactionAmount]
        ,SUM(x.[TransactionCount]) AS [TotalTransactions]
        ,COALESCE(AVG(NULLIF(x.[TransactionCount], 0)), 0) As [AverageTransactionPerPerson]
       -- ,x.[MaritalStatusValueId] AS [MaritalStatusValueId]
        ,MAX(CASE x.[MaritalStatusValueId]
            WHEN 143 THEN 'Married'
            WHEN 144 THEN 'Single'
            WHEN 674 THEN 'Divorced'
            WHEN 1010 THEN 'Widowed'
        END) As [MaritalStatus]
    FROM
        people_contributors x
    GROUP BY
        x.[BirthYear]--, x.[MaritalStatusValueId]
    ) y
ORDER BY
    y.[BirthYear] DESC