WITH registrantsFromRegistration AS (
    SELECT
        rr.[RegistrationId]
        ,rr.[Id] AS [RegistrantId]
        ,rr.[OnWaitlist]
        ,rr.[PersonAliasId]
        ,ri.RegistrationTemplateId
        ,pa.[Guid] AS [PersonAliasGuid]
        ,p.[Id] As [PersonId]
        ,p.[Gender] AS [PersonGender]
        ,CASE p.[Gender]
            WHEN 0 THEN 'Unknown'
            WHEN 1 THEN 'Male'
            WHEN 2 THEN 'Female'
        END AS [RealGender]
    FROM
        [RegistrationRegistrant] rr
        INNER JOIN [Registration] r ON r.[Id] = rr.[RegistrationId]
        INNER JOIN [RegistrationInstance] ri ON ri.[Id] = r.[RegistrationInstanceId]
        INNER JOIN [PersonAlias] pa ON pa.[Id] = rr.[PersonAliasId]
        INNER JOIN [Person] p ON p.[Id] = pa.[PersonId]
    WHERE
        r.[Id] = 45747 -- Replace this as needed
), registrantsWithAttributes AS (
    SELECT
        registrants.*
        ,x.*
    FROM
    registrantsFromRegistration registrants
    OUTER APPLY (
        SELECT
        /*    av.AttributeId
            ,a.[Key]
            ,a.EntityTypeId
            ,av.EntityId
            ,a.EntityTypeQualifierColumn
            ,a.EntityTypeQualifierValue
        */    av.Value AS [GradeValue]
        FROM
            [Attribute] a
            INNER JOIN [AttributeValue] av ON av.AttributeId = a.Id
        WHERE
            a.[EntityTypeId] = 313 -- Registration Registrant
            AND (a.[Key] = 'Grade' OR a.[Key] = 'Wherewouldyouliketovolunteer')
            AND a.[EntityTypeQualifierColumn] = 'RegistrationTemplateId'
            --AND a.[EntityTypeQualifierValue] IN (491, 494, 497, 508)
            AND av.EntityId = registrants.RegistrantId
    ) x
)


SELECT
    x.*
    ,CASE
        WHEN (x.[RegisteredMemberCount] + x.[RowNumber]) > x.[GroupCapacity] THEN 'Will Waitlist'
        ELSE 'Will Register'
    END AS [RegisterStatus]
    ,CASE WHEN ((x.[RealGender] = x.[GroupGenderValue]) OR (x.[GroupGenderValue] = 'Both')) THEN 1 ELSE 0
    END As [GenderOK]
FROM
(SELECT
    TOP 20
	--(SELECT TOP 1 rt.[Name] FROM [RegistrationTemplate] rt WHERE rt.[Id] = registrants.[RegistrationTemplateId]) As [TemplateName]
    registrants.*
    ,g.[Id] AS [GroupId]
    ,MAX(g.[Name]) AS [GroupName]
    ,g.[Guid] AS [GroupGuid]
    ,g.[IsActive] As [IsGroupActive]
    ,g.[GroupCapacity]
    ,av.[Value] AS [GroupGenderValue]
    ,COUNT(CASE WHEN gm.[GroupRoleId] = 155 AND gm.[GroupMemberStatus] = 1 THEN 1 ELSE NULL END) AS [RegisteredMemberCount]
    ,COUNT(CASE WHEN gm.[GroupRoleId] != 155 AND gm.[GroupMemberStatus] = 1 THEN 1 ELSE NULL END) AS [WaitlistedMemberCount]
    ,ROW_NUMBER() OVER (PARTITION BY registrants.[RegistrationId], g.[Name] ORDER BY registrants.[RegistrantId]) AS [RowNumber]
FROM
	registrantsWithAttributes registrants
    INNER JOIN [Group] g ON g.[Id] = registrants.[GradeValue] -- GradeValue is a Group Id
    INNER JOIN [GroupMember] gm ON gm.[GroupId] = g.[Id]
	INNER JOIN [AttributeValue] av ON av.[EntityId] = g.[Id] AND av.[AttributeId] = 16503
GROUP BY
    registrants.[RegistrationId], registrants.[RegistrantId], registrants.[OnWaitlist], registrants.[RegistrationTemplateId]
    ,registrants.[PersonAliasId], registrants.[PersonAliasGuid], registrants.[PersonId], registrants.[PersonGender], registrants.[RealGender]
    ,av.[Value], registrants.[GradeValue]
    ,g.[Id], g.[GroupCapacity], g.[Guid], g.[Name], g.[IsActive]
) x