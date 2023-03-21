SELECT  
      W.[Id]
    , W.[Name] AS [Workflow]
    , T.[Name] AS [Activity]
    , A.[Name] AS [Action]
    , SS3.[Buttons] AS [Button (Type)]
FROM [WorkflowActionForm] F
INNER JOIN [WorkflowActionType] A ON A.[WorkflowFormId] = F.[Id]
INNER JOIN [WorkflowActivityType]  T ON T.[Id] = A.[ActivityTypeId]
INNER JOIN [WorkflowType] W ON W.[Id] = T.[WorkflowTypeId]
OUTER APPLY (
    SELECT STRING_AGG([Buttons],'; ') AS [Buttons]
    FROM string_split(F.[Actions],'|') SS
    OUTER APPLY (
        SELECT 
            STRING_AGG(SS1.[Value],':') AS [Buttons]
        FROM (
            SELECT TOP 1 BV.[Value] 
            FROM STRING_SPLIT( SS.[Value],'^') BV
            UNION ALL
            SELECT TOP 1 '(' + DV.[Value] + ')'
            FROM STRING_SPLIT( SS.[Value],'^') BV
            INNER JOIN [DefinedValue] DV ON DV.[Guid] = TRY_CAST(BV.[Value] AS [uniqueidentifier])
        ) SS1
    ) SS2
    WHERE ISNULL(SS.[Value],'') <> ''
    AND SS2.[Buttons] <> 'Cancel:(Cancel)'
) SS3
WHERE F.[Actions] LIKE '%5683e775-b9f3-408c-80ac-94de0e51cf3a%'
AND SS3.[Buttons] LIKE '%(Cancel)%'
ORDER BY W.[Order], W.[Name], T.[Order], A.[Order]