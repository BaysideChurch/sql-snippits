SET STATISTICS IO ON;

WITH cte_gm_attr ([PersonId], [AttributeId], [Name], [Value], [FieldTypeId]) AS
(
SELECT
		gm.PersonId AS [PersonId]
		, val.[Id] AS [AttributeId]
		, val.[Name]
		, val.[Value]
		, val.[FieldTypeId]
	FROM
		[GroupMember] gm
		INNER JOIN [Group] g ON gm.[GroupId] = g.[Id]
		CROSS APPLY (
			SELECT
				a.[Id]
				,a.[Name]
				,a.[FieldTypeId]
				,CASE a.[FieldTypeId]
					WHEN 11 THEN av.[ValueAsDateTime]
					WHEN 1 THEN av.[Value]
					ELSE av.[Value]
				END AS [Value]
			FROM
				[Attribute] a
				INNER JOIN [AttributeValue] av ON av.[AttributeId] = a.[Id]
			WHERE
				--a.[EntityTypeId] = 90
				av.[EntityId] = gm.[Id]
				--AND a.[EntityTypeId] = 90
				--AND a.[EntityTypeQualifierValue] = g.[Id]
				AND a.[Id] IN (
					SELECT a.[Id]
					FROM
						[Attribute] a--19948,19949,19950)
					WHERE
						a.[EntityTypeId] = 90
						AND a.[EntityTypeQualifierValue] = g.[Id]
					)
		) val
	WHERE
		g.[Id] = 773164
	)

SELECT
	p.[Id]
	,MAX(p.[FirstName] + ' ' + p.[LastName]) AS [FullName]
	,MAX(PivotTable.[Goal Amount])
	,MAX(PivotTable.[Goal Frequency])
	,MAX(PivotTable.[Goal Total])
FROM (
	(	
	SELECT
		[PersonId]
		, [AttributeId]
		, [Name]
		, [Value]
		, [FieldTypeId]
	FROM
		cte_gm_attr
		) gm_results
	PIVOT (
		MAX(Value)
		FOR gm_results.[Name]
		IN ([Goal Amount], [Goal Frequency], [Goal Total])
	) AS PivotTable
	INNER JOIN [Person] p ON p.[Id] = PivotTable.[PersonId]
	)
GROUP BY
	p.[Id]

	/*

--- Un-pivoted query: Shows Attribute Ids --
SELECT
    gm.PersonId AS 'PersonId'
    , val.[Id] AS [AttributeId]
	, val.[Name]
	, val.[Value]
	, val.[FieldTypeId]
	, p.*
FROM
    [GroupMember] gm
    INNER JOIN [Group] g ON gm.[GroupId] = g.[Id]
    INNER JOIN [Person] p ON p.[Id] = gm.[PersonId]
    OUTER APPLY (
        SELECT
            a.[Id]
			,a.[Name]
			,a.[FieldTypeId]
			,av.[Value]
        FROM
            [Attribute] a
            INNER JOIN [AttributeValue] av ON av.[AttributeId] = a.[Id]
        WHERE
            av.[EntityId] = gm.[Id]
    ) val
WHERE
    g.[Id] = 773164
	*/