SELECT
   -- x.ActivatedYear
    COUNT(*) As [CountWorkflows]
    ,x.Name
FROM
(SELECT
    DATEPART(YEAR, wf.ActivatedDateTime) As ActivatedYear
    ,wf.WorkflowTypeId
    ,wft.Name
    ,wf.ActivatedDateTime
FROM
    [Workflow] wf
    INNER JOIn [WorkflowType] wft ON wft.Id = wf.WorkflowTypeId
WHERE
    wf.ActivatedDateTime IS NOT NULL
    AND wf.CompletedDateTime IS NULL
    AND wft.IsActive = 1
    AND DATEDIFF(dd, wf.ActivatedDateTime, GETDATE()) > 90
) x
GROUP BY
    --x.ActivatedYear, 
    x.Name
ORDER BY
    x.Name--, x.ActivatedYear ASC