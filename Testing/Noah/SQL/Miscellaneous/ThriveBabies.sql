SELECT
    p.FirstName + ' ' + p.LastName As [FullName]
    ,p.BirthDate
    ,p.Email
    ,pn.Number
    ,[dbo].[ufnCrm_GetAge](p.BirthDate) As [Age]
    ,p.PrimaryCampusId
FROM
    [Person] p
    INNER JOIN [PhoneNumber] pn ON pn.PersonId = p.Id
WHERE
    pn.NumberTypeValueId = 12 -- Mobile
    AND p.IsDeceased = 0
    AND p.RecordTypeValueId = 1
    AND p.Email IS NOT NULL
    AND p.Email != ''
    AND pn.IsUnlisted = 0
    AND [dbo].[ufnCrm_GetAge](p.BirthDate) BETWEEN 17 AND 22