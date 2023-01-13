DECLARE @registrationInstanceId INT = 1232;

-- Registrant Fields
WITH registrant_fields AS (
SELECT
    TOP 100
    rtf.Id As [RegistrationTemplateFormId]
    ,rtf.Name As [RegistrationTemplateFormName]
    ,rtf.RegistrationTemplateId
    ,rtf.[Order]
    ,rtff.Id As [FormFieldId]
    ,rtff.FieldSource
    ,CASE rtff.FieldSource
        WHEN 0 THEN 'PersonField'
        WHEN 1 THEN 'PersonAttribute'
        WHEN 2 THEN 'GroupMemberAttribute'
        WHEN 4 THEN 'RegistrantAttribute'
    END AS [FieldSourceName]
    ,rtff.IsGridField
    ,rtff.AttributeId
    ,rtff.PersonFieldType
    ,CASE rtff.PersonFieldType
        WHEN 0 THEN 'FirstName'
        WHEN 1 THEN 'LastName'
        WHEN 2 THEN 'Campus'
        WHEN 3 THEN 'Address'
        WHEN 4 THEN 'Email'
        WHEN 5 THEN 'Birthdate'
        WHEN 6 THEN 'Gender'
        WHEN 7 THEN 'MaritalStatus'
        WHEN 8 THEN 'MobilePhone'
        WHEN 9 THEN 'HomePhone'
        WHEN 10 THEN 'WorkPhone'
        WHEN 11 THEN 'Grade'
        WHEN 12 THEN 'ConnectionStatus'
        WHEN 13 THEN 'MiddleName'
        WHEN 14 THEN 'AnniversaryDate'
    END As [PersonFieldTypeName]
FROM
    [RegistrationTemplateForm] rtf
    INNER JOIN [RegistrationInstance] ri ON ri.RegistrationTemplateId = rtf.RegistrationTemplateId
    INNER JOIN [RegistrationTemplateFormField] rtff ON rtff.RegistrationTemplateFormId = rtf.Id
WHERE
    ri.Id = @registrationInstanceId
), registrants AS (
SELECT
    TOP 1000
    p.FirstName
    ,p.LastName
    ,p.[Id] As [PersonId]
    ,rr.[Id] As [RegistrantId]
    ,rr.[OnWaitList]
    ,rr.[RegistrationId]
    ,rr.[PersonAliasId]
    ,rr.[CreatedDateTime]
FROM
    [RegistrationRegistrant] rr
    INNER JOIN [PersonAlias] pa ON pa.Id = rr.PersonAliasId
    INNER JOIN [Person] p ON p.Id = pa.PersonId
WHERE
    rr.PersonAliasId IS NOT NULL
    AND pa.PersonId IS NOT NULL
    AND rr.OnWaitList = 0
    AND rr.RegistrationId IN (
        SELECT
            r.Id
        FROM
            [Registration] r
        WHERE
            r.RegistrationInstanceId = @registrationInstanceId
    )
), attribute_values AS (
SELECT
    av.[Value]
    ,av.EntityId
    ,a.Name AS [AttributeName]
    ,a.FieldTypeId
    ,a.[EntityTypeId]
    ,a.IsRequired
    ,rf.*
FROM
    [AttributeValue] av
    RIGHT JOIN [Attribute] a ON a.Id = av.AttributeId
    RIGHT JOIN [registrant_fields] rf ON rf.AttributeId = av.AttributeId
), registrant_values AS (
    SELECT
        a.[Name] As [AttributeName]
        ,av.[Value]
        ,r.*
    FROM
        [registrant_fields] rf
        LEFT JOIN [AttributeValue] av ON av.[AttributeId] = rf.[AttributeId]
        LEFT JOIN [Attribute] a ON a.[Id] = av.[AttributeId]
        LEFT JOIN [registrants] r ON r.RegistrantId = av.[EntityId]
    WHERE
        rf.FieldSource = 4 -- Registrant Attribute;
), people_values AS (
    SELECT
        a.[Name] As [AttributeName]
        ,av.[Value]
        ,r.*
    FROM
        [registrant_fields] rf
        LEFT JOIN [AttributeValue] av ON av.[AttributeId] = rf.[AttributeId]
        LEFT JOIN [Attribute] a ON a.[Id] = av.[AttributeId]
        LEFT JOIN [registrants] r ON r.PersonId = av.[EntityId]
    WHERE
        rf.FieldSource = 1 -- Person Attribute;
), pivot_registants AS (
    SELECT
        *
    FROM
        (SELECT * FROM [registrant_values] ) t
    PIVOT (
        MAX(Value)
            FOR [AttributeName] IN (
                [Is Your Spouse going on the trip?]
                ,[Have you been finger printed at Bayside?]
                ,[Emergency Person is on the Trip]
                ,[Do you know the date of your last Tetanus shot?]
                ,[Will you be 25 or older by March 30, 2023?]
                ,[Understand Recommendations]
                ,[Friend or Family Request #1]
                ,[Friend or Family Request #2]
                ,[Family Member(s) Going on the Trip?]
                ,[Would you like to be on the same team as your child?]
                ,[Team Choice #1]
                ,[Team Choice #2]
                ,[Bayside Reference Name]
                ,[What campus will you be traveling with?]
                ,[Passport Status]
                ,[Is there a reason you should not drive, or were asked not to drive last year?]
                ,[1. Have you been at fault for any accidents?]
                ,[2. Have you had any moving traffic violations?]
                ,[3. Have you had any insurance company cancel or refuse to provide you with auto insurance?]
                ,[4. Have you ever had your driver's license revoked, suspended, or restricted?]
                ,[5. Have you had any physical impairments other than corrective glasses?]
                ,[6. Have you ever been charged with or convicted of "driving while intoxicated" or "driving under the influence"?]
                ,[7. Are you able to provide a DMV printout of driving record if requested?]
               -- ,[If any question(s) 1-6 have been answered with "yes," please provide full details below: (dates, descriptions, amounts, or other explanation)]
                ,[By checking this box, I certify that I have reviewed the above information, and it is true and accurate.]
                ,[Would you be willing to drive your own minivan, truck, or SUV?]
                ,[Driver's Name (as shown on license)]
                ,[Date of Birth]
                ,[License State]
                ,[Bayside Reference Phone]
                ,[Other Reference Name]
                ,[Other Reference Phone]
                ,[Relationship With Jesus]
                ,[Participation]
                ,[Serving Ministry]
                ,[How many years have you participated in Mexico Outreach?]
                ,[Do you currently have a Bayside Mexico duffle bag?]
                ,[Team Choice #3]
                ,[Passport]
                ,[DMV]
                ,[Legal Document]
                ,[Is this a commercial license?]
            )
    ) as pivoted
), pivot_people AS (
    SELECT
        *
    FROM
        (SELECT * FROM [people_values] ) t
        PIVOT (
            MAX(Value)
                FOR [AttributeName] IN (
                    [Passport Number]
                    ,[Passport Acknowledgement]
                    ,[Has Allergy]
                    ,[Are you fluent in Spanish?]
                    ,[Passport Image]
                    ,[Understand Recommendations]
                    ,[Had Chickenpox]
                    ,[Vaccinations Are Up To Date]
                    ,[Tetnus Shot Date]
                    ,[Medications Details]
                    ,[Medical Conditions Details]
                    ,[Medical Conditions]
                    ,[Dietary Restrictions Details]
                    ,[Has Dietary Restrictions]
                    ,[Secondary Emergency Contact Phone]
                    ,[Secondary Emergency Contact]
                    ,[Passport Issuing Country]
                    ,[Passport Expiration Date]
                    ,[SurName (As Written on Passport)]
                    ,[Given Name (As Written on Passport)]
                    ,[Do you use an epi-pen?]
                    ,[Primary Emergency Contact Phone]
                    ,[Primary Emergency Contact]
                    ,[T-Shirt Size]
                    ,[Allergy Details]
                )
        ) as pivoted
)


SELECT
    pp.*
    ,[Passport Number]
    ,[Passport Acknowledgement]
    ,[Has Allergy]
    ,[Are you fluent in Spanish?]
    ,[Passport Image]
    ,pr.[Understand Recommendations]
    ,[Had Chickenpox]
    ,[Vaccinations Are Up To Date]
    ,[Tetnus Shot Date]
    ,[Medications Details]
    ,[Medical Conditions Details]
    ,[Medical Conditions]
    ,[Dietary Restrictions Details]
    ,[Has Dietary Restrictions]
    ,[Secondary Emergency Contact Phone]
    ,[Secondary Emergency Contact]
    ,[Passport Issuing Country]
    ,[Passport Expiration Date]
    ,[SurName (As Written on Passport)]
    ,[Given Name (As Written on Passport)]
    ,[Do you use an epi-pen?]
    ,[Primary Emergency Contact Phone]
    ,[Primary Emergency Contact]
    ,[T-Shirt Size]
    ,[Allergy Details]
FROM
    [pivot_people] pp
    INNER JOIN [pivot_registants] pr ON pr.PersonId = pp.PersonId



