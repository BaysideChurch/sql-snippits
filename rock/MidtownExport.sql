SELECT TOP (10) 
    p.[Id] as PersonId
    ,COALESCE( [FirstName] , '' ) as FirstName
    ,COALESCE([NickName], '') AS NickName
    ,COALESCE([MiddleName], '') AS MiddleName
    ,COALESCE([LastName], '') AS LastName
    ,c.[Name] AS Campus
    ,[BirthDate] as Birthdate     
    ,[AnniversaryDate] as Anniversary
    ,g.Name as FamilyName
    ,CAST(
            CASE 
                WHEN [Gender] = 1
                    THEN 'M'
                WHEN [Gender] = 2
                THEN 'F'
                ELSE
                ''
            END AS varchar) as Gender
    ,CAST(
        CASE
        WHEN [MaritalStatusValueId] = 143
            THEN 'Married'
        WHEN [MaritalStatusValueId] = 144
            THEN 'Single'
        ELSE
            ''
        End as varchar) as MaritalStatus
    ,p.Email as HomeEmail
    ,pn.Number as HomePhoneNumber
    ,dbo.ufnCrm_GetAddress(p.Id, 'Home', 'Street1') as HomeAddressStreetLine1
    ,dbo.ufnCrm_GetAddress(p.Id, 'Home', 'Street2') as HomeAddressStreetLine2
    ,dbo.ufnCrm_GetAddress(p.Id, 'Home', 'City') as HomeAddressCity
    ,dbo.ufnCrm_GetAddress(p.Id, 'Home', 'State') as HomeAddressState
    ,dbo.ufnCrm_GetAddress(p.Id, 'Home', 'PostalCode') as HomeAddressPostalCode

    ,dbo.ufnCrm_GetAddress(p.Id, 'Work', 'Street2') as WorkAddressStreetLine2
    ,dbo.ufnCrm_GetAddress(p.Id, 'Work', 'Street1') as WorkAddressStreetLine1
    ,dbo.ufnCrm_GetAddress(p.Id, 'Work', 'City') as WorkAddressCity
    ,dbo.ufnCrm_GetAddress(p.Id, 'Work', 'State') as WorkAddressState
    ,dbo.ufnCrm_GetAddress(p.Id, 'Work', 'PostalCode') as WorkAddressPostalCode
FROM 
    [dbo].[Person] as p
    LEFT JOIN PhoneNumber as pn on pn.PersonId = p.Id
    LEFT JOIN GroupMember as gm on gm.PersonId = p.Id
    LEFT JOIN [Group] as g on g.Id = gm.GroupId
    LEFT JOIN [Campus] c ON c.[Id] = p.[PrimaryCampusId] 
WHERE 
    g.GroupTypeId = 10 AND
    p.[PrimaryCampusId] IN (6, 9)
ORDER BY 
    HouseholdID