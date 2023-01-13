SELECT
    x.*
FROM
(SELECT
    TOP 10000
    p.[Id] As [PersonId]
    ,p.[FirstName] + ' ' + p.[LastName] AS [FullName]
    ,p.[BirthDate]
    ,[dbo].[ufnCrm_GetAge](p.[BirthDate]) AS [Age]
    ,p.[PrimaryFamilyId]
  --  ,pn.[Number] As [PersonPhoneNumber]
   -- ,pn.[NumberFormatted] AS [PersonFormattedPhoneNumber]
    ,av.[Value] as [AttributePhoneNumber]
    ,CASE av.[AttributeId]
        WHEN 12953 THEN 'Primary Parent'
        WHEN 15719 THEN 'Primary Contact'
        WHEN 15725 THEN 'Secondary Parent'
        WHEN 14455 THEN 'Secondary Contact'
    END AS [Attribute]
    ,av.[ModifiedDateTime] AS [AttributeLastModifiedAt]
    ,e1.[PersonId] AS [ParentPersonId]
    ,e2.[FirstName] + ' ' + e2.[LastName] As [PrimaryParentFullName]
    ,e2.[PrimaryFamilyId] AS [ParentPrimaryFamilyId]
    ,CASE WHEN e2.[PrimaryFamilyId] != p.[PrimaryFamilyId] THEN 'Not in Same Family' ELSE '' END AS [InSameFamily]
FROM
    [Person] p
    INNER JOIN [AttributeValue] av ON av.[EntityId] = p.[Id] AND av.[AttributeId] IN (12953, 15719, 15725, 14455)
    --LEFT JOIN [PhoneNumber] pn ON pn.[PersonId] = p.[Id] AND pn.[NumberTypeValueId] = 12
    LEFT JOIN [PhoneNumber] e1 ON e1.[NumberFormatted] = av.[Value] AND e1.[NumberTypeValueId] = 12
    LEFT JOIN [Person] e2 ON e2.[Id] = e1.[PersonId]
WHERE
    [dbo].[ufnCrm_GetAge](p.[BirthDate]) BETWEEN 12 AND 18
    AND p.[IsDeceased] != 1
    AND e2.[IsDeceased] != 1
    AND p.[RecordStatusValueId] != 4
    AND e2.[RecordStatusValueId] != 4
) x
ORDER BY
    x.[InSameFamily] DESC, x.[Age] ASC, x.[FullName], x.[Attribute]