DECLARE @hsInstanceId INT = 1222;
DECLARE @collegeInstanceId INT = 1223;
DECLARE @adultInstanceId INT = 1232;

-- Registrant Fields
WITH registrant_fields AS (
SELECT
    TOP 1000
    ri.[Id] AS [InstanceId]
    ,ri.[Name] AS [InstanceName]
    ,rtf.Id AS [RegistrationTemplateFormId]
    ,rtf.Name AS [RegistrationTemplateFormName]
    ,rtf.RegistrationTemplateId
    ,rtf.[Order]
    ,rtff.Id AS [FormFieldId]
    ,rtff.FieldSource
    ,CASE rtff.FieldSource
        WHEN 0 THEN 'PersonField'
        WHEN 1 THEN 'PersonAttribute'
        WHEN 2 THEN 'GroupMemberAttribute'
        WHEN 4 THEN 'RegistrantAttribute'
    END AS [FieldSourceName]
    ,rtff.IsGridField
    ,rtff.AttributeId
    ,a.[Name] AS [AttributeName]
    ,a.[Key] AS [AttributeKey]
    ,a.[FieldTypeId]
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
    END AS [PersonFieldTypeName]
FROM
    [RegistrationTemplateForm] rtf
    INNER JOIN [RegistrationInstance] ri ON ri.RegistrationTemplateId = rtf.RegistrationTemplateId
    INNER JOIN [RegistrationTemplateFormField] rtff ON rtff.RegistrationTemplateFormId = rtf.Id
    LEFT JOIN [Attribute] a ON a.[Id] = rtff.[AttributeId]
WHERE
    ri.Id IN (@hsInstanceId, @collegeInstanceId, @adultInstanceId)--@registrationInstanceId
), registrants AS (
SELECT
    TOP 1000
    p.[Id] As [PersonId]
    ,p.FirstName
    ,p.LastName
    ,p.[Email]
    ,p.[BirthDate]
    ,p.[Gender]
    ,CASE p.[Gender]
        WHEN 0 THEN 'Unknown'
        WHEN 1 THEN 'Male'
        WHEN 2 THEN 'Female'
    END AS [GenderValue]
    ,rr.[Id] As [RegistrantId]
    ,rr.[OnWaitList]
    ,rr.[RegistrationId]
    ,rr.[PersonAliasId]
    ,rr.[CreatedDateTime] As [RegistrantCreated]
    ,r.[RegistrationInstanceId]
FROM
    [RegistrationRegistrant] rr
    INNER JOIN [PersonAlias] pa ON pa.Id = rr.PersonAliasId
    INNER JOIN [Person] p ON p.Id = pa.PersonId
    INNER JOIN [Registration] r ON r.[Id] = rr.[RegistrationId]
WHERE
    rr.PersonAliasId IS NOT NULL
    AND pa.PersonId IS NOT NULL
    AND rr.OnWaitList = 0
    AND r.RegistrationInstanceId IN (@hsInstanceId, @collegeInstanceId, @adultInstanceId)
), registrant_values AS (
    SELECT
        rf.[AttributeName]
        ,rf.[AttributeKey]
        ,rf.[AttributeId]
        ,rf.[FieldTypeId]
        ,av.[Value]
        ,r.*
    FROM
        [registrant_fields] rf
        INNER JOIN [AttributeValue] av ON av.[AttributeId] = rf.[AttributeId]
        INNER JOIN [registrants] r ON r.RegistrantId = av.[EntityId]
            AND rf.[InstanceId] = r.[RegistrationInstanceId]
    WHERE
        rf.FieldSource = 4 -- Registrant Attribute;
), people_values AS (
    SELECT
        rf.[AttributeName]
        ,rf.[AttributeKey]
        ,rf.[AttributeId]
        ,rf.[FieldTypeId]
        ,av.[Value]
        ,r.*
    FROM
        [registrant_fields] rf
        INNER JOIN [AttributeValue] av ON av.[AttributeId] = rf.[AttributeId]
        INNER JOIN [registrants] r ON r.PersonId = av.[EntityId]
            AND rf.[InstanceId] = r.[RegistrationInstanceId]
    WHERE
        rf.FieldSource = 1 -- Person Attribute;
), everyone as (
    SELECT
        t.[AttributeKey]
        ,t.[PersonId]
        ,t.[FirstName]
        ,t.[LastName]
        ,t.[Email]
        ,t.[BirthDate]
        ,t.[Gender]
        ,t.[GenderValue]
        ,t.[RegistrantCreated]
        ,t.[RegistrationInstanceId]
     --   ,ft.[Name] AS [FieldTypeName]
        ,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(t.[Value],
            '527025a9-7fb7-4b41-9204-b8e03679df95', 'Measles')
            ,'35203014-d390-41b5-8f7a-f3eb68d29ea4', 'Pertussis')
            ,'50c36c1e-f202-4f1c-8600-7f644bd008dd', 'Chickenpox')
            ,'11768f8c-f8bb-40b8-a226-b55a70c38a6c', 'Epi-Pen Statement:  We recommend bringing a second Epi-Pen and turning it into the First-Aid Team for safe keeping.')
            ,'fb1bb4fd-7c31-418d-86b3-4eea7c1d62d8', 'Inhaler Statement:  If you have ever been prescribed an inhaler for any reason we recommend that you bring one.')
            ,'3eb0998d-5fde-44d8-bc4f-fd21519066a9', 'Insulin Statement:  Please bring a cooler to Mexicali with you.  We can provide ice during the day and store your meds in a fridge at night.')
            ,'2e558d3c-5ad5-447f-bbd5-0b34212db639', 'By checking this box, I am showing my understanding...') AS [ValueFormatted]
    FROM
        (SELECT
            pv.*
        FROM
            [people_values] pv
        UNION ALL
        SELECT
            rv.*
        FROM
            [registrant_values] rv
        ) t
        INNER JOIN [FieldType] ft ON ft.[Id] = t.[FieldTypeId]
),pivot_info AS (
    SELECT
        *
    FROM
        (SELECT * FROM [everyone] ) t
        PIVOT (
            MAX(ValueFormatted)
            FOR [AttributeKey] IN (
                [T-ShirtSize]
                ,[FluentSpanish]
                ,[SpouseOnTrip]
                ,[SpousesName]
                ,[Whatcampuswillyoubetravelingwith]
                ,[HaveyoubeenfingerprintedatBayside]
                ,[PassportAcknowledgement]
                ,[PassportStatus]
                ,[PassportFirstName]
                ,[PassportLastName]
                ,[PassportNumber]
                ,[PassportIssuingCountry]
                ,[PassportExpirationDate]
                ,[PassportCopy]
                ,[PassportReceiptImage]
                ,[HasDietaryRestrictions]
                ,[DietaryRestrictionDetails]
                ,[MedicalConditions]
                ,[MedicalConditionsDetails]
                ,[HasAllergy]
                ,[Allergy]
                ,[EpiPen]
                ,[MedicationsDetails]
                ,[TetanusKnown]
                ,[TetnusShotDate]
                ,[HadChickenpox]
                ,[VaccinationsAreUpToDate]
                ,[UnderstandRecommendations]
                ,[DriversName]
                ,[25orolder]
                ,[NoDrive]
                ,[DrivingExemption]
                ,[WouldyoubewillingtodriveyourownminivantruckorSUV]
                ,[DriversLicensePhoto]
                ,[DateofBirth]
                ,[LicenseState]
                ,[com.sparkdevnetwork.DLNumber]
                ,[CommercialLicense]
                ,[DMVQ1]
                ,[DMVQ2]
                ,[DMVQ3]
                ,[DMVQ4]
                ,[DMVQ5]
                ,[DMVQ6]
                ,[DMVQ7]
                ,[ExplainYes]
                ,[ConfirmCheck]
                ,[Over18]
                ,[Participation]
                ,[CheckConfirm]
                ,[DoyouknowthedateofyourlastTetanusshot]
                ,[RelationshipWithJesus]
                ,[PrimaryEmergencyContact]
                ,[PrimaryEmergencyContactPhone]
                ,[SecondaryEmergencyContact]
                ,[SecondaryEmergencyContactPhone]
                ,[EmergencyPersonisontheTrip]
                ,[NameofPrimaryParentGuardian]
                ,[EmailofPrimaryParentGuardian]
                ,[PhoneNumberofPrimaryParentGuardian]
                ,[NameofSecondParentGuardian]
                ,[EmailofSecondParentGuardian]
                ,[ReferencePhone]
                ,[Grade]
                ,[School]
                ,[Ref]
                ,[SmallGroupLeaderRequest]
                ,[FamilyorFriendRequest1]
                ,[FamilyorFriendRequest2]
                ,[FriendRequest1]
                ,[FriendRequest2]
                ,[FamilyOnTrip]
                ,[SameTeamAsParent]
                ,[TeamChoice1]
                ,[TeamChoice2]
                ,[TeamChoice3]
                ,[BaysideReferenceName]
                ,[BaysideReferencePhone]
                ,[OtherReferenceName]
                ,[OtherReferencePhone]
                ,[HowmanyyearshaveyouparticipatedinMexicoOutreach]
                ,[mexicoyears]
                ,[ServingMinistry]
                ,[dufflebag]
                ,[Passport]
                ,[LegalDocument]
                ,[DMV]
                ,[DMVMVR]
                ,[Role]
                ,[TeamLeader]
                ,[Driver]
                ,[Translator]
                ,[Spartan]
                ,[MexicoCar]
                ,[SpartanCar]
                ,[Gascard]
                ,[InternalComments]
            )
        ) as pivoted
)

SELECT
    *
FROM
    [everyone] pi


/*
Attribute
AttributeValue
FieldType --
Registration
RegistrationInstance
RegistrationRegistrant
RegistrationTemplate
RegistrationTemplateForm
RegistrationTemplateFormField
Person
PersonAlias
*/
