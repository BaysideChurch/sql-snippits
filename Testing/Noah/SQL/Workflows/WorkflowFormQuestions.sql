SELECT
    et.FriendlyName
    ,wat.Name As [ActionTypeName]
    ,wat.IsActionCompletedOnSuccess
    ,wat.IsActivityCompletedOnSuccess
    ,wat.ActivityTypeId
    ,a.[Key]
    ,a.[Name]
    ,a.[FieldTypeId]
    ,ft.Name As [FieldTypeName]
FROM
    [WorkflowActionType] wat
    INNER JOIN [EntityType] et ON et.Id = wat.EntityTypeId
    INNER JOIN [WorkflowActionForm] waf ON waf.Id = wat.WorkflowFormId
    INNER JOIN [WorkflowActionFormAttribute] wafa ON wafa.WorkflowActionFormId = waf.Id
    INNER JOIN [Attribute] a ON a.Id = wafa.AttributeId
    INNER JOIN [FieldType] ft ON ft.Id = a.FieldTypeId
WHERE
    wat.EntityTypeId = 199

SELECT 
	OBJECT_SCHEMA_NAME(v.object_id) schema_name,
	v.name
FROM 
	sys.views as v;