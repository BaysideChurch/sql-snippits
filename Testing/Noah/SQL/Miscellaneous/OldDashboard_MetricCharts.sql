{% sql metricId:'261'%}
    SELECT
        valPartitions.[Value]
        ,valPartitions.[PreviousValue]
        ,valPartitions.[Value] - valPartitions.[PreviousValue] AS [DeltaValue]
        ,valPartitions.[MetricValueDateTime]
        ,valPartitions.[Title]
        ,valPartitions.[IconCssClass]
        ,valPartitions.[PartitionName]
        ,valPartitions.[RN]
        ,valPartitions.[RelatedReportId]
        ,AVG(valPartitions.[Value]) over (partition by valPartitions.[PartitionName] ORDER BY valPartitions.[MetricValueDateTime]
            ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) as weeklyMA
        ,AVG(valPartitions.[Value]) over (partition by valPartitions.[PartitionName] ORDER BY valPartitions.[MetricValueDateTime]
            ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) as monthlyMA
    FROM
    (
    	SELECT
			mv.[YValue] AS [Value]
			,LEAD(mv.[YValue]) OVER (partition by mvp.[EntityId] ORDER BY mv.[MetricValueDateTime] DESC) AS [PreviousValue]
			,mv.[MetricValueDateTime]
			,m.[Title] as [Title]
			,m.[IconCssClass] AS [IconCssClass]
			,mp.[Id]
			,mp.[Label]
			,mp.[EntityTypeId]
			,mvp.[EntityId]
			,et.[FriendlyName] As [PartitionType]
			,(CASE et.[Id]
				WHEN 3 THEN 'Site'
				WHEN 15 THEN 'Person'
				WHEN 16 THEN 'Group'
				WHEN 31 THEN 'Defined Value'
				WHEN 32 THEN 'Workflow Type'
				WHEN 34 THEN 'Data View'
				WHEN 50 THEN 'Group Type Role'
				WHEN 54 THEN 'Schedule'
				WHEN 57 THEN 'Entity Type'
				WHEN 67 THEN 'Campus'
				WHEN 68 THEN 'Category'
				WHEN 344 THEN 'Defined Type'
				WHEN 348 THEN 'Financial Account'
				WHEN 350 THEN 'Group Type'
				WHEN 353 THEN 'Location'
				WHEN 354 THEN 'Metric'
				WHEN 355 THEN 'Note Type'
				WHEN 356 THEN 'Report'
				WHEN 341 THEN 'Content Channel'
				WHEN 337 THEN 'Connection Activity Type'
				WHEN 338 THEN 'Connection Opportunity'
				WHEN 339 THEN 'Connection Status'
				WHEN 340 THEN 'Connection Type'
				WHEN 342 THEN 'Content Channel Type'
				WHEN 347 THEN 'Event Calendar'
				WHEN 352 THEN 'Interaction Channel'
				END
			) AS [Partition Friendly Name]
			,(CASE et.[Id]
				WHEN 3 THEN (SELECT TOP 1 s.[Name] FROM [Site] s WHERE s.[Id] = mvp.[EntityId])
				WHEN 15 THEN (SELECT TOP 1 p.[FirstName] + ' ' + p.[LastName] FROM [Person] p WHERE p.[Id] = mvp.[EntityId])
				WHEN 16 THEN (SELECT TOP 1 g.[Name] FROM [Group] g WHERE g.[Id] = mvp.[EntityId])
				WHEN 31 THEN (SELECT TOP 1 dv.[Value] FROM [DefinedValue] dv WHERE dv.[Id] = mvp.[EntityId] AND dv.[DefinedTypeId] = mp.[EntityTypeQualifierValue])
				WHEN 32 THEN (SELECT TOP 1 wft.[Name] FROM [WorkflowType] wft WHERE wft.[Id] = mvp.[EntityId])
				WHEN 34 THEN (SELECT TOP 1 dv.[Name] FROM [DataView] dv WHERE dv.[Id] = mvp.[EntityId])
				WHEN 50 THEN (SELECT TOP 1 gtr.[Name] FROM [GroupTypeRole] gtr WHERE gtr.[Id] = mvp.[EntityId])
				WHEN 54 THEN (SELECT TOP 1 s.[Name] FROM [Schedule] s WHERE s.[Id] = mvp.[EntityId])
				WHEN 57 THEN (SELECT TOP 1 et.[FriendlyName] FROM [EntityType] et WHERE et.[Id] = mvp.[EntityId])
				WHEN 67 THEN (SELECT TOP 1 c.[Name] FROM [Campus] c WHERE c.[Id] = mvp.[EntityId])
				WHEN 68 THEN (SELECT TOP 1 c.[Name] FROM [Category] c WHERE c.[Id] = mvp.[EntityId])
				WHEN 344 THEN (SELECT TOP 1 dt.[Name] FROM [DefinedType] dt WHERE dt.[Id] = mvp.[EntityId])
				WHEN 348 THEN (SELECT TOP 1 fa.[Name] FROM [FinancialAccount] fa WHERE fa.[Id] = mvp.[EntityId])
				WHEN 350 THEN (SELECT TOP 1 gt.[Name] FROM [GroupType] gt WHERE gt.[Id] = mvp.[EntityId])
				WHEN 353 THEN (SELECT TOP 1 l.[Name] FROM [Location] l WHERE l.[Id] = mvp.[EntityId])
				WHEN 354 THEN (SELECT TOP 1 m.[Title] FROM [Metric] m WHERE m.[Id] = mvp.[EntityId])
				WHEN 355 THEN (SELECT TOP 1 nt.[Name] FROM [NoteType] nt WHERE nt.[Id] = mvp.[EntityId])
				WHEN 356 THEN (SELECT TOP 1 r.[Name] FROM [Report] r WHERE r.[Id] = mvp.[EntityId])
				WHEN 341 THEN (SELECT TOP 1 cc.[Name] FROM [ContentChannel] cc WHERE cc.[Id] = mvp.[EntityId])
				WHEN 337 THEN (SELECT TOP 1 cat.[Name] FROM [ConnectionActivityType] cat WHERE cat.[Id] = mvp.[EntityId])
				WHEN 338 THEN (SELECT TOP 1 co.[Name] FROM [ConnectionOpportunity] co WHERE co.[Id] = mvp.[EntityId])
				WHEN 339 THEN (SELECT TOP 1 cs.[Name] FROM [ConnectionStatus] cs WHERE cs.[Id] = mvp.[EntityId])
				WHEN 340 THEN (SELECT TOP 1 ct.[Name] FROM [ConnectionType] ct WHERE ct.[Id] = mvp.[EntityId])
				WHEN 342 THEN (SELECT TOP 1 cct.[Name] FROM [ContentChannelType] cct WHERE cct.[Id] = mvp.[EntityId])
				WHEN 347 THEN (SELECT TOP 1 ec.[Name] FROM [EventCalendar] ec WHERE ec.[Id] = mvp.[EntityId])
				WHEN 352 THEN (SELECT TOP 1 ic.[Name] FROM [InteractionChannel] ic WHERE ic.[Id] = mvp.[EntityId])
				END
			) AS [PartitionName]
			,ROW_NUMBER() over (partition by mvp.[EntityId] order by mv.[MetricValueDateTime] DESC) AS [RN]
			,r.[Id] AS [RelatedReportId]
		FROM
			[Metric] m
			INNER JOIN [MetricValue] mv ON mv.[MetricId] = m.[Id]
			LEFT JOIN [MetricValuePartition] mvp ON mvp.[MetricValueId] = mv.[Id]
			LEFT JOIN [MetricPartition] mp ON mp.[MetricId] = m.[Id] AND mvp.[MetricPartitionId] = mp.[Id]
			LEFT JOIN [EntityType] et On et.[Id] = mp.[EntityTypeId]
			LEFT JOIN [AttributeValue] av ON av.[EntityId] = @metricId AND av.[AttributeId] = 19694
			LEFT JOIN [Report] r ON r.[Guid] = TRY_CONVERT(UNIQUEIDENTIFIER, av.[Value])
		WHERE
			m.[Id] = @metricId
		--	AND mv.[CreatedDateTime] >= DATEADD(m, -5, GETDATE()) -- This number can change depending on how far they want to grab partitions
    ) valPartitions
    ORDER BY
        valPartitions.MetricValueDateTime
{% endsql %}

{% assign cumulValue = 0 %}
{% assign prevValue = 0 %}
{% for result in results %}
    {% assign currentValue = currentValue | Append: ',' | Append: result.Value %}
    {% assign cumulValue = cumulValue | Plus: result.Value %}
    {% assign cumulValues = cumulValues | Append: ',' | Append: cumulValue %}
    {% assign values = values | Append: ',' | Append: result.DeltaValue %}
    {% assign prevValues = prevValues | Append: ',' | Append: result.PreviousValue %}
    {% assign labels = labels | Append: ',' | Append: result.MetricValueDateTime %}
    {% assign weeklyMA = weeklyMA | Append: ',' | Append: result.weeklyMA %}
    {% assign monthlyMA = monthlyMA | Append: ',' | Append: result.monthlyMA %}
    {% assign setLabel = result.Title %}
{% endfor %}
//-{{ cumulValues }}
<br/>
//-{{ labels }}


{[ chart type:'bar' labels:'{{ labels }}' xaxistype:'time' ]}
    [[ dataset label:'{{ setLabel }}' data:'{{ values }}' fillcolor:'#059BFF' ]] [[ enddataset ]]
{[ endchart ]}

{[ chart type:'line' labels:'{{ labels }}' xaxistype:'time' ]}
    [[ dataset label:'{{ setLabel }}' data:'{{ cumulValues }}' fillcolor:'#059BFF' ]] [[ enddataset ]]
{[ endchart ]}

{[ chart type:'line' labels:'{{ labels }}' xaxistype:'time' ]}
    [[ dataset label:'Current Value' data:'{{ currentValue }}' pointcolor:'#059BFF' ]] [[ enddataset ]]
    [[ dataset label:'Weekly MA' data:'{{ weeklyMA }}' pointcolor:'#090909' ]] [[ enddataset ]]
    [[ dataset label:'Monthly MA' data:'{{ monthlyMA }}' pointcolor:'#303030' ]] [[ enddataset ]]
{[ endchart ]}
