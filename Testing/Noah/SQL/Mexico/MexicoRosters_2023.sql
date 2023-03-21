DECLARE @test VARCHAR(100) = '865223, 865224, 865225, 865222';

SELECT z.PersonId, COUNt(*) FROM (SELECT
    pivoted.PersonId
    ,pivoted.FirstName
    ,pivoted.LastName
    ,pivoted.Gender
    ,pn.NumberFormatted AS [Phone Number]
    ,pivoted.Email
    ,CASE pivoted.RegistrationInstanceId
        WHEN 1222 THEN 'High School'
        WHEN 1223 THEN 'College'
        WHEN 1232 THEN 'Adults'
    END AS [Instance Name]
    ,pivoted.[PassportStatus] AS [Passport Status]
    ,pivoted.LegalDocument AS [Liability Release Document]
    ,pivoted.[LiveScanDate] AS [Live Scan Date]
    ,pivoted.DMV AS [DMV Status]
    ,pivoted.Role
    ,y.Name AS [Team]
    ,y.ParentGroup
    ,pivoted.Spartan
FROM
    (SELECT
        reg.PersonId
        ,reg.FirstName
        ,reg.LastName
        ,reg.GenderValue AS [Gender]
        ,reg.Email
        ,reg.BirthDate
        ,reg.AttributeKey
        ,reg.ValueFormatted
        ,reg.RegistrationInstanceId
    FROM
        [bcc_mexico_2023_reports_production] reg
    WHERE
        reg.AttributeKey LIKE 'PassportStatus%'
        OR reg.AttributeKey LIKE 'DMV'
        OR reg.AttributeKey LIKE 'Spartan'
        OR reg.AttributeKey LIKE 'Role'
        OR reg.AttributeKey LIKE 'LegalDocument'
        OR reg.AttributeKey LIKE 'LiveScanDate'
    ) x
    PIVOT (
        MAX(x.ValueFormatted)
        FOR AttributeKey IN (
            [PassportStatus]
            ,[DMV]
            ,[Role]
            ,[LegalDocument]
            ,[Spartan]
            ,[LiveScanDate]
        )
    ) as pivoted
    LEFT JOIN [PhoneNumber] pn On pn.NumberTypeValueId = 12 AND pn.PersonId = pivoted.PersonId
    LEFT JOIN (
        SELECT
            g.Name
            ,gm.PersonId
            ,CASE g.ParentGroupId
                WHEN 865222 THEN 'Spartans'
                WHEN 865225 THEN 'Vehicles'
                WHEN 865224 THEN 'Tents'
                WHEN 865223 THEN 'Teams'
            END AS [ParentGroup]
        FROM
            [Group] g
            INNER JOIN [GroupMember] gm ON gm.GroupId = g.Id
        WHERE
           -- '|865223|865224|865225|865222|' LIKE '%|' + CAST(g.ParentGroupId AS VARCHAR(10)) + '|%'
            g.ParentGroupId IN (865223, 865224, 865225, 865222)
    ) y ON y.PersonId = pivoted.PersonId
) z
GROUP BY
    z.PersonId
HAVING COUNt(*) > 1


/*
Include phone number in view
Include group in view (Id, Name)
Include original Registration Id and name
*/