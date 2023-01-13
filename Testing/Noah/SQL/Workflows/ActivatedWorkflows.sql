SELECT
    y.*
    ,wt.Name As [WorkflowTypeName]
    ,wt.Id AS [WorkflowTypeId]
    ,wt.CategoryId
FROM
    (SELECT
        x.ActionTypeId
        ,x.ActionTypeName
        ,MAX(CASE WHEN x.IsActivityCompletedOnSuccess = 1 THEN 1 ELSE 0 END) As [IsActivityCompletedOnSuccess]
        --,x.AttributeKey
        --,x.FieldTypeName
        ,MAX(x.MatchingKeys) As [MatchingKeys]
        ,MAX(x.WorkflowToActivateGuid) As [WorkflowToActivateGuid]
    FROM
        (SELECT
            a.[Key] As [AttributeKey]
            ,ft.Name As [FieldTypeName]
            ,av.Value
            ,CASE WHEN ft.Name LIKE 'Key Value List' THEN av.Value END As [MatchingKeys]
            ,CASE WHEN ft.Name LIKE 'Workflow Type' THEN av.Value END As [WorkflowToActivateGuid]
            ,wat.Id As [ActionTypeId]
            ,wat.Name As [ActionTypeName]
            ,wat.[Order]
            ,wat.IsActivityCompletedOnSuccess
        FROM
            [WorkflowActionType] wat
            INNER JOIN [AttributeValue] av ON av.EntityId = wat.Id
            INNER JOIN [Attribute] a ON a.EntityTypeId = 115 AND av.AttributeId = a.Id
            INNER JOIN [FieldType] ft ON ft.Id = a.FieldTypeId
        WHERE
            wat.EntityTypeId = 415
            AND (ft.Name LIKE 'Workflow Type' OR ft.Name LIKE 'Key Value List')
        ) x
    GROUP BY
        x.ActionTypeId, x.ActionTypeName
) y
INNER JOIN [WorkflowType] wt ON CAST(wt.Guid AS VARCHAR(50)) = y.WorkflowToActivateGuid
ORDER BY
    y.ActionTypeName DESC