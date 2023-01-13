DECLARE @KeyValueListFieldType INT = 34;
DECLARE @WorkflowTypeFieldType INT = 36;
DECLARE @WorkflowAttributeFieldType INT = 61;
DECLARE @ConnectionOpportunityFieldType INT = 94;

DECLARE @WorkflowEntityType INT = 113;
DECLARE @WorkflowActionTypeEntityType INT = 115;
DECLARE @ActivateWorkflowEntityType INT = 415;
DECLARE @CreateConnectionRequestEntityType INT = 423;

DECLARE @ImNewConnectionType INT = 6;
DECLARE @GroupsConnectionType INT = 8;
DECLARE @CareConnectionType INT = 9;
DECLARE @VolunteerConnectionType INT = 12;
DECLARE @NextStepsConnectionType INT = 23;
DECLARE @MinistryInfoConnectionType INT = 24;

SELECT * 
	FROM
(SELECT
	[Project1].[WorkflowTypeId]
	,[Project1].[WorkflowTypeName]
	,[Project1].[IsActiveWorkflow]
	,[Project1].[ModifiedDateTime]
	,'Count: ' + CAST([Project1].[Workflow_Count] AS varchar(6)) AS [Workflow Count]
	,[Project1].[EntityTypeQualifierValue]
	,[Project1].[workflowActionName]
	,[Project1].[WorkflowToActivate_Guid]
	,[Extent1].[Id] AS [WorkflowId]
	,[Extent1].[Name]
	,[Extent1].[IsActive]
	,[Extent1].[ModifiedDateTime] AS [WF_ModifiedDateTime]
	,'Count: ' + CAST((SELECT COUNT(*) FROM [Workflow] wf
		WHERE wf.[WorkflowTypeId] = [Extent1].[Id]
		AND wf.[Status] NOT LIKE 'Completed') as varchar(6)) AS [Active Workflows Left]
	,[Extent3].[Name] As [connection Opportunity Name]
	,(SELECT TOP 1 ct.[Name] FROm [ConnectionType] ct WHERE ct.[Id] = [Extent3].[ConnectionTypeId]) AS [ConnectionType Name]
	,[Extent3].[IsActive] As [Active CO]
	,CASE WHEN EXISTS 
		(SELECT  co.[Id]
		FROM [ConnectionOpportunity] co
		WHERE
			co.[Id] = [Extent3].[Id]
			AND co.[ConnectionTypeId] IN (@NextStepsConnectionType, @ImNewConnectionType,
			@VolunteerConnectionType, @MinistryInfoConnectionType, @CareConnectionType,
			@GroupsConnectionType))
		THEN 1
		ELSE 0 
	 END AS [In Correct CO Type]
	,'Count: ' + CAST((SELECT COUNT(*) FROM [ConnectionRequest] cr
		WHERE cr.[ConnectionOpportunityId] = [Extent3].[Id]
		AND [Extent2].[EntityTypeQualifierValue] = [Extent1].[Id]) as varchar(6)) AS [Count CRs Left]
FROM
(
	SELECT TOP 10000
		wfType.[Id] As [WorkflowTypeId]
		,wfType.[Name] As [WorkflowTypeName]
		,wfType.[ModifiedDateTime]
		,wfType.[IsActive] As [IsActiveWorkflow]
		,(SELECT COUNT(*) FROM [Workflow] wf WHERE wf.[WorkflowTypeId] = wfType.[Id] AND wf.[Status] NOT LIKE 'Completed') AS [Workflow_Count]
		,wfActionType.[Name] As [workflowActionName]
		,a.[EntityTypeQualifierValue]
		,CAST(av.[Value] as varchar(100)) AS [WorkflowToActivate_Guid]
	FROM
		[WorkflowActionType] wfActionType
		RIGHT JOIN [WorkflowActivityType] wfActivityType On wfActivityType.[Id] = wfActionType.[ActivityTypeId]
		RIGHT JOIN [WorkflowType] wfType ON wfType.[Id] = wfActivityType.[WorkflowTypeId]
		LEFT JOIN [AttributeValue] av ON av.[EntityId] = wfActionType.[Id]
		INNER JOIN [Attribute] a ON a.[Id] = av.[AttributeId]
	WHERE
		a.[FieldTypeId] = @WorkflowTypeFieldType
		AND a.[EntityTypeId] = @WorkflowActionTypeEntityType
		AND wfActionType.[EntityTypeId] = @ActivateWorkflowEntityType
		--This line will only show wf types if they are active or missing)
		AND (wfType.[IsActive] = 1 OR wfType.[IsActive] IS NULL)
	) [Project1]
	RIGHT JOIN [WorkflowType] [Extent1] ON CAST([Extent1].[Guid] as varchar(100)) LIKE [Project1].[WorkflowToActivate_Guid]
	LEFT JOIN [Attribute] [Extent2] ON [Extent2].[EntityTypeQualifierValue] = [Extent1].[Id]
	LEFT JOIN [ConnectionOpportunity] [Extent3] ON CAST([Extent3].[Guid] as varchar(100)) LIKE [Extent2].[DefaultValue]
    WHERE	
		[Extent2].[EntityTypeId] = @WorkflowEntityType
        AND [Extent2].[EntityTypeQualifierValue] = [Extent1].[Id]
		AND [Extent2].[FieldTypeId] = @ConnectionOpportunityFieldType
			) [Project2]
ORDER BY
	[Project2].IsActiveWorkflow, [Project2].[In Correct CO Type], [Project2].IsActive