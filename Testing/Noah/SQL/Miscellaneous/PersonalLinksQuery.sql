SELECT [Project15].[SectionId] AS [SectionId]
	,[Project15].[SectionId1] AS [SectionId1]
	,[Project15].[Id] AS [Id]
	,[Project15].[PersonAliasId] AS [PersonAliasId]
	,[Project15].[Name] AS [Name]
	,[Project15].[IsShared] AS [IsShared]
	,[Project15].[IconCssClass] AS [IconCssClass]
	,[Project15].[CreatedDateTime] AS [CreatedDateTime]
	,[Project15].[ModifiedDateTime] AS [ModifiedDateTime]
	,[Project15].[CreatedByPersonAliasId] AS [CreatedByPersonAliasId]
	,[Project15].[ModifiedByPersonAliasId] AS [ModifiedByPersonAliasId]
	,[Project15].[Guid] AS [Guid]
	,[Project15].[ForeignId] AS [ForeignId]
	,[Project15].[ForeignGuid] AS [ForeignGuid]
	,[Project15].[ForeignKey] AS [ForeignKey]
	,[Project15].[Id1] AS [Id1]
	,[Project15].[Name1] AS [Name1]
	,[Project15].[PersonId] AS [PersonId]
	,[Project15].[AliasPersonId] AS [AliasPersonId]
	,[Project15].[AliasPersonGuid] AS [AliasPersonGuid]
	,[Project15].[Guid1] AS [Guid1]
	,[Project15].[ForeignId1] AS [ForeignId1]
	,[Project15].[ForeignGuid1] AS [ForeignGuid1]
	,[Project15].[ForeignKey1] AS [ForeignKey1]
	,[Project15].[Id4] AS [Id2]
	,[Project15].[Id5] AS [Id3]
	,[Project15].[C2] AS [C1]
	,[Project15].[Id2] AS [Id4]
	,[Project15].[PersonAliasId1] AS [PersonAliasId1]
	,[Project15].[Name2] AS [Name2]
	,[Project15].[Url] AS [Url]
	,[Project15].[SectionId2] AS [SectionId2]
	,[Project15].[Order] AS [Order]
	,[Project15].[CreatedDateTime1] AS [CreatedDateTime1]
	,[Project15].[ModifiedDateTime1] AS [ModifiedDateTime1]
	,[Project15].[CreatedByPersonAliasId1] AS [CreatedByPersonAliasId1]
	,[Project15].[ModifiedByPersonAliasId1] AS [ModifiedByPersonAliasId1]
	,[Project15].[Guid2] AS [Guid2]
	,[Project15].[ForeignId2] AS [ForeignId2]
	,[Project15].[ForeignGuid2] AS [ForeignGuid2]
	,[Project15].[ForeignKey2] AS [ForeignKey2]
	,[Project15].[Id3] AS [Id5]
	,[Project15].[Name3] AS [Name3]
	,[Project15].[PersonId1] AS [PersonId1]
	,[Project15].[AliasPersonId1] AS [AliasPersonId1]
	,[Project15].[AliasPersonGuid1] AS [AliasPersonGuid1]
	,[Project15].[Guid3] AS [Guid3]
	,[Project15].[ForeignId3] AS [ForeignId3]
	,[Project15].[ForeignGuid3] AS [ForeignGuid3]
	,[Project15].[ForeignKey3] AS [ForeignKey3]
FROM (
	SELECT CASE 
			WHEN ([Project8].[Order] IS NULL)
				THEN 0
			ELSE [Limit4].[Order]
			END AS [C1]
		,[Project8].[Id] AS [Id]
		,[Project8].[PersonAliasId] AS [PersonAliasId]
		,[Project8].[Name] AS [Name]
		,[Project8].[IsShared] AS [IsShared]
		,[Project8].[IconCssClass] AS [IconCssClass]
		,[Project8].[CreatedDateTime] AS [CreatedDateTime]
		,[Project8].[ModifiedDateTime] AS [ModifiedDateTime]
		,[Project8].[CreatedByPersonAliasId] AS [CreatedByPersonAliasId]
		,[Project8].[ModifiedByPersonAliasId] AS [ModifiedByPersonAliasId]
		,[Project8].[Guid] AS [Guid]
		,[Project8].[ForeignId] AS [ForeignId]
		,[Project8].[ForeignGuid] AS [ForeignGuid]
		,[Project8].[ForeignKey] AS [ForeignKey]
		,[Project8].[SectionId] AS [SectionId]
		,[Limit4].[SectionId] AS [SectionId1]
		,[Extent11].[Id] AS [Id1]
		,[Extent11].[Name] AS [Name1]
		,[Extent11].[PersonId] AS [PersonId]
		,[Extent11].[AliasPersonId] AS [AliasPersonId]
		,[Extent11].[AliasPersonGuid] AS [AliasPersonGuid]
		,[Extent11].[Guid] AS [Guid1]
		,[Extent11].[ForeignId] AS [ForeignId1]
		,[Extent11].[ForeignGuid] AS [ForeignGuid1]
		,[Extent11].[ForeignKey] AS [ForeignKey1]
		,[Join2].[Id1] AS [Id2]
		,[Join2].[PersonAliasId] AS [PersonAliasId1]
		,[Join2].[Name1] AS [Name2]
		,[Join2].[Url] AS [Url]
		,[Join2].[SectionId] AS [SectionId2]
		,[Join2].[Order] AS [Order]
		,[Join2].[CreatedDateTime] AS [CreatedDateTime1]
		,[Join2].[ModifiedDateTime] AS [ModifiedDateTime1]
		,[Join2].[CreatedByPersonAliasId] AS [CreatedByPersonAliasId1]
		,[Join2].[ModifiedByPersonAliasId] AS [ModifiedByPersonAliasId1]
		,[Join2].[Guid1] AS [Guid2]
		,[Join2].[ForeignId1] AS [ForeignId2]
		,[Join2].[ForeignGuid1] AS [ForeignGuid2]
		,[Join2].[ForeignKey1] AS [ForeignKey2]
		,[Join2].[Id2] AS [Id3]
		,[Join2].[Name2] AS [Name3]
		,[Join2].[PersonId] AS [PersonId1]
		,[Join2].[AliasPersonId] AS [AliasPersonId1]
		,[Join2].[AliasPersonGuid] AS [AliasPersonGuid1]
		,[Join2].[Guid2] AS [Guid3]
		,[Join2].[ForeignId2] AS [ForeignId3]
		,[Join2].[ForeignGuid2] AS [ForeignGuid3]
		,[Join2].[ForeignKey2] AS [ForeignKey3]
		,[Project8].[Id1] AS [Id4]
		,[Limit4].[Id] AS [Id5]
		,CASE 
			WHEN ([Join2].[Id1] IS NULL)
				THEN CAST(NULL AS INT)
			ELSE 1
			END AS [C2]
	FROM (
		SELECT [Filter2].[Id] AS [Id]
			,[Filter2].[PersonAliasId] AS [PersonAliasId]
			,[Filter2].[Name] AS [Name]
			,[Filter2].[IsShared] AS [IsShared]
			,[Filter2].[IconCssClass] AS [IconCssClass]
			,[Filter2].[CreatedDateTime] AS [CreatedDateTime]
			,[Filter2].[ModifiedDateTime] AS [ModifiedDateTime]
			,[Filter2].[CreatedByPersonAliasId] AS [CreatedByPersonAliasId]
			,[Filter2].[ModifiedByPersonAliasId] AS [ModifiedByPersonAliasId]
			,[Filter2].[Guid] AS [Guid]
			,[Filter2].[ForeignId] AS [ForeignId]
			,[Filter2].[ForeignGuid] AS [ForeignGuid]
			,[Filter2].[ForeignKey] AS [ForeignKey]
			,[Limit2].[SectionId] AS [SectionId]
			,[Limit2].[Id] AS [Id1]
			,[Limit2].[Order] AS [Order]
		FROM (
			SELECT [Extent1].[Id] AS [Id]
				,[Extent1].[PersonAliasId] AS [PersonAliasId]
				,[Extent1].[Name] AS [Name]
				,[Extent1].[IsShared] AS [IsShared]
				,[Extent1].[IconCssClass] AS [IconCssClass]
				,[Extent1].[CreatedDateTime] AS [CreatedDateTime]
				,[Extent1].[ModifiedDateTime] AS [ModifiedDateTime]
				,[Extent1].[CreatedByPersonAliasId] AS [CreatedByPersonAliasId]
				,[Extent1].[ModifiedByPersonAliasId] AS [ModifiedByPersonAliasId]
				,[Extent1].[Guid] AS [Guid]
				,[Extent1].[ForeignId] AS [ForeignId]
				,[Extent1].[ForeignGuid] AS [ForeignGuid]
				,[Extent1].[ForeignKey] AS [ForeignKey]
			FROM [dbo].[PersonalLinkSection] AS [Extent1]
			WHERE ([Extent1].[IsShared] = 1)
				OR (
					([Extent1].[PersonAliasId] IS NOT NULL)
					AND (
						EXISTS (
							SELECT 1 AS [C1]
							FROM [dbo].[PersonAlias] AS [Extent2]
							WHERE ([Extent2].[PersonId] = 135445)
								AND ([Extent2].[Id] = [Extent1].[PersonAliasId])
							)
						)
					)
			) AS [Filter2]
		OUTER APPLY (
			SELECT TOP (1) [Project7].[SectionId] AS [SectionId]
				,[Project7].[Id] AS [Id]
				,[Project7].[Order] AS [Order]
			FROM (
				SELECT [Project4].[SectionId] AS [SectionId]
					,[Limit1].[Id] AS [Id]
					,[Limit1].[Order] AS [Order]
				FROM (
					SELECT 135445 AS [p__linq__1]
						,[Distinct1].[SectionId] AS [SectionId]
					FROM (
						SELECT DISTINCT [Extent3].[SectionId] AS [SectionId]
						FROM [dbo].[PersonalLinkSectionOrder] AS [Extent3]
						WHERE EXISTS (
								SELECT 1 AS [C1]
								FROM [dbo].[PersonAlias] AS [Extent4]
								WHERE ([Extent4].[PersonId] = 135445)
									AND ([Extent4].[Id] = [Extent3].[PersonAliasId])
								)
						) AS [Distinct1]
					) AS [Project4]
				CROSS APPLY (
					SELECT TOP (1) [Project6].[Id] AS [Id]
						,[Project6].[SectionId] AS [SectionId]
						,[Project6].[Order] AS [Order]
					FROM (
						SELECT [Extent5].[Id] AS [Id]
							,[Extent5].[SectionId] AS [SectionId]
							,[Extent5].[Order] AS [Order]
							,[Extent5].[ModifiedDateTime] AS [ModifiedDateTime]
						FROM [dbo].[PersonalLinkSectionOrder] AS [Extent5]
						WHERE (
								EXISTS (
									SELECT 1 AS [C1]
									FROM [dbo].[PersonAlias] AS [Extent6]
									WHERE ([Extent6].[PersonId] = 135445)
										AND ([Extent6].[Id] = [Extent5].[PersonAliasId])
									)
								)
							AND ([Project4].[SectionId] = [Extent5].[SectionId])
						) AS [Project6]
					ORDER BY [Project6].[Order] ASC
						,[Project6].[ModifiedDateTime] DESC
					) AS [Limit1]
				WHERE [Limit1].[SectionId] = [Filter2].[Id]
				) AS [Project7]
			ORDER BY [Project7].[Order] ASC
			) AS [Limit2]
		) AS [Project8]
	OUTER APPLY (
		SELECT TOP (1) [Project14].[SectionId] AS [SectionId]
			,[Project14].[Id] AS [Id]
			,[Project14].[Order] AS [Order]
		FROM (
			SELECT [Project11].[SectionId] AS [SectionId]
				,[Limit3].[Id] AS [Id]
				,[Limit3].[Order] AS [Order]
			FROM (
				SELECT 135445 AS [p__linq__1]
					,[Distinct2].[SectionId] AS [SectionId]
				FROM (
					SELECT DISTINCT [Extent7].[SectionId] AS [SectionId]
					FROM [dbo].[PersonalLinkSectionOrder] AS [Extent7]
					WHERE EXISTS (
							SELECT 1 AS [C1]
							FROM [dbo].[PersonAlias] AS [Extent8]
							WHERE ([Extent8].[PersonId] = 135445)
								AND ([Extent8].[Id] = [Extent7].[PersonAliasId])
							)
					) AS [Distinct2]
				) AS [Project11]
			CROSS APPLY (
				SELECT TOP (1) [Project13].[Id] AS [Id]
					,[Project13].[SectionId] AS [SectionId]
					,[Project13].[Order] AS [Order]
				FROM (
					SELECT [Extent9].[Id] AS [Id]
						,[Extent9].[SectionId] AS [SectionId]
						,[Extent9].[Order] AS [Order]
						,[Extent9].[ModifiedDateTime] AS [ModifiedDateTime]
					FROM [dbo].[PersonalLinkSectionOrder] AS [Extent9]
					WHERE (
							EXISTS (
								SELECT 1 AS [C1]
								FROM [dbo].[PersonAlias] AS [Extent10]
								WHERE ([Extent10].[PersonId] = 135445)
									AND ([Extent10].[Id] = [Extent9].[PersonAliasId])
								)
							)
						AND ([Project11].[SectionId] = [Extent9].[SectionId])
					) AS [Project13]
				ORDER BY [Project13].[Order] ASC
					,[Project13].[ModifiedDateTime] DESC
				) AS [Limit3]
			WHERE [Limit3].[SectionId] = [Project8].[Id]
			) AS [Project14]
		ORDER BY [Project14].[Order] ASC
		) AS [Limit4]
	LEFT OUTER JOIN [dbo].[PersonAlias] AS [Extent11] ON [Project8].[PersonAliasId] = [Extent11].[Id]
	LEFT OUTER JOIN (
		SELECT [Extent12].[Id] AS [Id1]
			,[Extent12].[PersonAliasId] AS [PersonAliasId]
			,[Extent12].[Name] AS [Name1]
			,[Extent12].[Url] AS [Url]
			,[Extent12].[SectionId] AS [SectionId]
			,[Extent12].[Order] AS [Order]
			,[Extent12].[CreatedDateTime] AS [CreatedDateTime]
			,[Extent12].[ModifiedDateTime] AS [ModifiedDateTime]
			,[Extent12].[CreatedByPersonAliasId] AS [CreatedByPersonAliasId]
			,[Extent12].[ModifiedByPersonAliasId] AS [ModifiedByPersonAliasId]
			,[Extent12].[Guid] AS [Guid1]
			,[Extent12].[ForeignId] AS [ForeignId1]
			,[Extent12].[ForeignGuid] AS [ForeignGuid1]
			,[Extent12].[ForeignKey] AS [ForeignKey1]
			,[Extent13].[Id] AS [Id2]
			,[Extent13].[Name] AS [Name2]
			,[Extent13].[PersonId] AS [PersonId]
			,[Extent13].[AliasPersonId] AS [AliasPersonId]
			,[Extent13].[AliasPersonGuid] AS [AliasPersonGuid]
			,[Extent13].[Guid] AS [Guid2]
			,[Extent13].[ForeignId] AS [ForeignId2]
			,[Extent13].[ForeignGuid] AS [ForeignGuid2]
			,[Extent13].[ForeignKey] AS [ForeignKey2]
		FROM [dbo].[PersonalLink] AS [Extent12]
		LEFT OUTER JOIN [dbo].[PersonAlias] AS [Extent13] ON [Extent12].[PersonAliasId] = [Extent13].[Id]
		) AS [Join2] ON [Project8].[Id] = [Join2].[SectionId]
	) AS [Project15]
ORDER BY [Project15].[C1] ASC
	,[Project15].[Name] ASC
	,[Project15].[SectionId] ASC
	,[Project15].[SectionId1] ASC
	,[Project15].[Id] ASC
	,[Project15].[Id1] ASC
	,[Project15].[Id4] ASC
	,[Project15].[Id5] ASC
	,[Project15].[C2] ASC