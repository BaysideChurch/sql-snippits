SELECT
    x.*
FROM
    (SELECT TOP 10000
        cr.[Id] As [RequestId]
        ,cr.[CreatedDateTime]
        ,cr.[ModifiedDateTime]
        ,cr.[FollowupDate]
        ,CASE cr.[ConnectionState]
            WHEN 0 THEN 'Active'
            WHEN 1 THEN 'Inactive'
            WHEN 2 THEN 'FutureFollowUp'
            WHEN 3 THEN 'Connected'
        END AS [ConnectionState]
        ,DATEDIFF(dd, cr.[CreatedDateTime], GETDATE()) AS [DaysSinceCreated]
        ,co.[Name] AS [OpportunityName]
        ,cr.[ConnectionOpportunityId]
        ,co.[IsActive] AS [IsOpportunityActive]
        ,cs.[Name] AS [StatusName]
        ,cra.[CreatedDateTime] AS [ActivityCreatedDateTime]
        ,DATEDIFF(dd, COALESCE(cra.[CreatedDateTime], cr.[CreatedDateTime]), GETDATE()) AS [DaysSinceActivity]
        ,ROW_NUMBER() OVER (partition by cr.[Id] order by cra.[CreatedDateTime] DESC) AS [RN_Activity]
    FROM
        [ConnectionRequest] cr
        INNER JOIN [ConnectionStatus] cs ON cs.[Id] = cr.[ConnectionStatusId]
        LEFT JOIN [ConnectionRequestActivity] cra ON cra.[ConnectionRequestId] = cr.[Id]
        INNER JOIN [ConnectionOpportunity] co ON co.[Id] = cr.[ConnectionOpportunityId]
    WHERE
        cs.[Name] IN ('No Contact', 'In Progress')
        AND ( cr.[FollowupDate] IS NULL OR cr.[FollowupDate] < GETDATE() )
    ) x
WHERE
    x.[RN_Activity] = 1
    AND x.[DaysSinceActivity] >= 90
    AND x.[IsOpportunityActive] = 1
ORDER BY
    x.[OpportunityName], x.[StatusName], x.[DaysSinceActivity] DESC