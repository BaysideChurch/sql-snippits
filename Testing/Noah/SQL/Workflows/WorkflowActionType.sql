SELECT
	action.[Id]
    ,MAX(action.[Name])
	--,val.*
	,STRING_AGG(val.[AttributeName], ', ') AS [Attributes]
FROM
	[WorkflowActionType] action
CROSS APPLY
(SELECT TOP 100
    a.[Name] AS [AttributeName],
    av.[EntityId],
    a.[EntityTypeId],
    et.[Name] AS EntityTypeName,
    av.Value
FROM
    [AttributeValue] av
    INNER JOIN [Attribute] a ON av.[AttributeId] = a.[Id]
    INNER JOIN [EntityType] et ON et.[Id] = a.[EntityTypeId]
WHERE
    a.[EntityTypeId] = 115
	AND a.[Name] NOT IN ('Active', 'Order', 'Load All')
	--ANd a.[NAme] = 'Body'
	AND action.[Id] = av.[EntityId]
) as val
GROUP BY
    action.[Id]
--WHERE
    --val.[EntityId] = 10396
    