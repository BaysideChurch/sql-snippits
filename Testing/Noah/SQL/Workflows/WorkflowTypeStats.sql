WITH workflows AS (
    SELECT
        wf.Id
        ,wf.CompletedDateTime
        ,wf.LastProcessedDateTime
        ,wf.Status
        ,wf.CreatedDateTime
        ,wf.WorkflowTypeId
        ,wft.Name As [WorkflowType]
    FROM
        [Workflow] wf
        INNER JOIN [WorkflowType] wft ON wft.Id = wf.WorkflowTypeId
    --WHERE
    --    wft.Id NOT IN (803, 711, 345)
)

SELECT
    x.WorkflowTypeId
    ,x.Status
    ,MAX(x.WorkflowType) As [WorkflowType]
    ,MIN(x.CreatedDateTime) As [EarliestCreated]
    ,MAX(x.CreatedDateTime) AS [LatestCreated]
    ,MAX(x.CountWorkflowsOfType) As [CountWorkflowsOfType]
    ,MAX(x.StatusCount) AS [Count]
FROM
    (SELECT
        w.*
        ,COUNT(w.WorkflowTypeId) OVER (PARTITION BY w.WorkflowTypeId) AS [CountWorkflowsOfType]
        ,COUNT(w.Id) OVER (PARTITION BY w.WorkflowTypeId, w.Status ORDER BY w.WorkflowTypeId) AS [StatusCount]
    FROM
        workflows w
    ) x
GROUP BY
    x.Status, x.WorkflowTypeId


SELECT
    COUNT(wft.[Id]) AS [CountWorkflows]
    ,wft.[Name] AS [WorkflowType]
    ,MIN(wf.[CreatedDateTime]) AS [Oldest]
    ,MAX(wf.[CreatedDateTime]) AS [Most Recent]
    ,wft.[Id] As [WorkflowTypeId]
FROM
    [Workflow] wf
    INNER JOIN [WorkflowType] wft ON wft.[Id] = wf.[WorkflowTypeId]
--WHERE
--    wft.[Id] != 711 -- Way too big, skews data
GROUP BY
    wft.[Id], wft.Name
ORDER BY
    MIN(wf.[CreatedDateTime]) ASC,COUNT(wft.[Id]) DESC