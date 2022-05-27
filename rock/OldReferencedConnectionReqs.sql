DECLARE @KeyValueListFieldType INT = 34;
DECLARE @WorkflowTypeFieldType INT = 36;
DECLARE @WorkflowAttributeFieldType INT = 61;
DECLARE @ConnectionOpportunityFieldType INT = 94;

DECLARE @WorkflowEntityType INT = 113;
DECLARE @WorkflowActionTypeEntityType INT = 115;
DECLARE @ActivateWorkflowEntityType INT = 415;
DECLARE @CreateConnectionRequestEntityType INT = 423;

DECLARE @ImNewConnectionType INT = 6;
DECLARE @VolunteerConnectionType INT = 12;
DECLARE @NextStepsConnectionType INT = 23
DECLARE @MinistryInfoConnectionType INT = 24;

SELECT
	[Extent1].[Id]
	,[Extent1].[Name]
	,[Extent1].[ModifiedDateTime]
	,[Project1].*
FROM
(
	SELECT TOP 10000
		wfType.[Id] As [WorkflowTypeId]
		,wfType.[Name] As [WorkflowTypeName]
		,wfActionType.[Id] As [WorkflowActionTypeId]
		,wfActionType.[EntityTypeId]
		,wfActionType.[Name] As [workflowActionName]
		,val.[AttributeName]
		,CAST(val.[Value] as varchar(100)) AS [WorkflowToActivate_Guid]
	FROM
		[WorkflowActionType] wfActionType
		RIGHT JOIN [WorkflowActivityType] wfActivityType On wfActivityType.[Id] = wfActionType.[ActivityTypeId]
		RIGHT JOIN [WorkflowType] wfType ON wfType.[Id] = wfActivityType.[WorkflowTypeId]
		OUTER APPLY (
			SELECT
				TOP 100000
				a.[Name] AS [AttributeName]
				,a.[EntityTypeQualifierValue]
				,av.[Value]
			FROM
				[Attribute] a
				INNER JOIN [AttributeValue] av ON av.[AttributeId] = a.[Id]
			WHERE
				a.[FieldTypeId] = @WorkflowTypeFieldType
				AND a.[EntityTypeId] = @WorkflowActionTypeEntityType
				AND av.[EntityId] = wfActionType.[Id]
		) val
	WHERE
		wfActionType.[EntityTypeId] = @ActivateWorkflowEntityType
		) [Project1]
	RIGHT JOIN [WorkflowType] [Extent1] ON CAST([Extent1].[Guid] as varchar(100)) LIKE [Project1].[WorkflowToActivate_Guid]
	WHERE
		[Extent1].[Id] IN (
			SELECT
				val.[ReferencedWorkflowType]
			FROM
				[ConnectionOpportunity] co
				OUTER APPLY(
					SELECT
        				TOP 10000
        				a.[entityTypeQualifierValue] As [ReferencedWorkflowType]
						,a.[DefaultValue]
						,a.[Name]
						,a.[FieldTypeId]
						,a.[EntityTypeId]
					FROM
        				[Attribute] a
					WHERE
        				a.[EntityTypeId] = @WorkflowEntityType
        				AND a.[FieldTypeId] = @ConnectionOpportunityFieldType
        				AND a.[DefaultValue] LIKE CAST(co.[Guid] as varchar(100))
				) val
			WHERE
				co.[ConnectionTypeId] NOT IN (@ImNewConnectionType,
					@VolunteerConnectionType,@MinistryInfoConnectionType, @NextStepsConnectionType)
		)
ORDER BY
	[Project1].[WorkflowTypeId] ASC, [Extent1].[Id] ASC, [Extent1].[ModifiedDateTime]