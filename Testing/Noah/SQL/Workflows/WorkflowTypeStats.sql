SELECT
    COUNT(wft.[Id]) AS [CountWorkflows]
    ,MAX(wft.[Name]) AS [WorkflowType]
    ,MIN(wf.[CreatedDateTime]) AS [Oldest]
    ,MAX(wf.[CreatedDateTime]) AS [Most Recent]
    ,wft.[Id] As [WorkflowTypeId]
FROM
    [Workflow] wf
    INNER JOIN [WorkflowType] wft ON wft.[Id] = wf.[WorkflowTypeId]
--WHERE
--    wft.[Id] != 711 -- Way too big, skews data
GROUP BY
    wft.[Id]
ORDER BY
    MIN(wf.[CreatedDateTime]) ASC,COUNT(wft.[Id]) DESC