SET STATISTICS IO, TIME ON

WITH all_people_by_birthyear_maritalstatus AS (
    SELECT TOP 1000000
        p.[Id]
        ,p.[BirthYear]
        ,p.[MaritalStatusValueId]
        ,MAX(p.[AgeClassification]) As [AgeClassification]
        ,MAX(p.[Gender]) AS [Gender]
        ,CASE WHEN MAX(cr.[Id]) IS NOT NULL THEN 1 ELSE 0 END AS [HasRequests]
        ,CASE WHEN MAX(ft.[Id]) IS NOT NULL THEN 1 ELSE 0 END AS [HasTransactions]
        ,CASE WHEN MAX(wf.[Id]) IS NOT NULL THEN 1 ELSE 0 END AS [HasWorkflows]
        ,CASE WHEN MAX(gm.[Id]) IS NOT NULL THEN 1 ELSE 0 END AS [InGroups]
    FROM
        [Person] p
        INNER JOIN [PersonAlias] pa ON pa.[PersonId] = p.[Id]
        LEFT JOIN [Workflow] wf ON wf.[InitiatorPersonAliasId] = pa.[Id]
            AND DATEPART(YEAR, wf.[CreatedDateTime]) = 2022
        LEFT JOIN [ConnectionRequest] cr ON cr.[PersonAliasId] = pa.[Id]
            AND DATEPART(YEAR, cr.[CreatedDateTime]) = 2022
        LEFT JOIN [FinancialTransaction] ft ON ft.[AuthorizedPersonAliasId] = pa.[Id]
            AND DATEPART(YEAR, ft.[CreatedDateTime]) = 2022
        LEFT JOIN [GroupMember] gm ON gm.[PersonId] = p.[Id]
            AND gm.[GroupRoleId] NOT IN (3, 4, 5, 6, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 21, 25,  26, 29, 64, 65, 66, 67, 68, 100, 101, 121, 128)
    --        AND gm.[GroupRoleId] IN (46, 23, 255, 62, 71, 114, 24) -- Comm List Recipient, SG member, ST member, Class/Program, MS member, YSG member, SG leader
    WHERE
        p.[BirthYear] BETWEEN 1914 AND 2023
        AND p.[IsDeceased] != 1
        --AND p.[AgeClassification] != 2 -- Child
        AND p.[RecordTypeValueId] = 1 -- Person
        AND p.[RecordStatusValueId] != 4
        AND p.[MaritalStatusValueId] IS NOT NULL
        AND p.[PrimaryCampusId] NOT IN (3, 6, 9, 10, 27, 28) -- Auburn, Elk Grove, Midtown, Global Online, Lincoln, Folsom Prison
    GROUP BY
        p.[Id], p.[BirthYear], p.[MaritalStatusValueId]
),
agg_person_info AS (
    SELECT
        x.[BirthYear]
        ,x.[MaritalStatusValueId]
        ,CASE x.[MaritalStatusValueId]
            WHEN 143 THEN 'Married'
            WHEN 144 THEN 'Single'
            WHEN 674 THEN 'Divorced'
            WHEN 1010 THEN 'Widowed'
        END AS [MaritalStatus]
    /* ,x.[AgeClassification]
        ,CASE x.[AgeClassification]
            WHEN 0 THEN 'Unknown'
            WHEN 1 THEN 'Adult'
            WHEN 2 THEN 'Child'
        END AS [AgeClass]*/
        /*,x.[Gender]
        ,CASE x.[Gender]
            WHEN 1 THEN 'Male'
            WHEN 2 THEN 'Female'
        END AS [GenderName]*/
        ,COUNT(x.[Id]) As [TotalPeople]
        ,SUM(x.[HasRequests]) AS [HasRequests]
        ,SUM(x.[HasTransactions]) AS [HasTransactions]
        ,SUM(x.[HasWorkflows]) AS [HasWorkflows]
        ,SUM(x.[InGroups]) As [InGroups]
        ,SUM(CASE WHEN x.[HasWorkflows] = 1 OR x.[HasRequests] = 1 OR x.[HasTransactions] = 1 OR x.[InGroups] = 1 THEN 1 ELSE 0 END) AS [HasAnything]
        ,SUM(CASE WHEN x.[Gender] = 1 THEN 1 ELSE 0 END ) AS [TotalMales]
        ,SUM(CASE WHEN x.[Gender] = 2 THEN 1 ELSe 0 END ) As [TotalFemales]
        ,SUM(CASE WHEN x.[Gender] = 1 THEN x.[HasRequests] ELSE 0 END) As [M_HasRequests]
        ,SUM(CASE WHEN x.[Gender] = 1 THEN x.[HasTransactions] ELSE 0 END) As [M_HasTransactions]
        ,SUM(CASE WHEN x.[Gender] = 1 THEN x.[HasWorkflows] ELSE 0 END) As [M_HasWorkflows]
        ,SUM(CASE WHEN x.[Gender] = 1 THEN x.[InGroups] ELSE 0 END) As [M_InGroups]
        ,SUM(CASE WHEN x.[Gender] = 2 THEN x.[HasRequests] ELSE 0 END) As [F_HasRequests]
        ,SUM(CASE WHEN x.[Gender] = 2 THEN x.[HasTransactions] ELSE 0 END) As [F_HasTransactions]
        ,SUM(CASE WHEN x.[Gender] = 2 THEN x.[HasWorkflows] ELSE 0 END) As [F_HasWorkflows]
        ,SUM(CASE WHEN x.[Gender] = 2 THEN x.[InGroups] ELSE 0 END) As [F_InGroups]
    FROM
        all_people_by_birthyear_maritalstatus x
    GROUP BY
        x.[BirthYear], x.[MaritalStatusValueId]--, x.[AgeClassification]--, x.[Gender]
)

SELECT
    y.*
    ,y.[HasAnything] * 100 / y.[TotalPeople] As [PercentAnything]
    ,y.[HasTransactions] * 100 / y.[TotalPeople] AS [PercentTransactions]
    ,y.[HasRequests] * 100 / y.[TotalPeople] As [PercentRequest]
    ,y.[HasWorkflows] * 100 / y.[TotalPeople] AS [PercentWorkflows]
    ,y.[InGroups] * 100 / y.[TotalPeople] AS [PercentGroups]
    ,y.[TotalMales] * 100 / y.[TotalPeople] AS [PercentMales]
    ,y.[TotalFemales] * 100 / y.[TotalPeople] As [PercentFemales]
    ,COALESCE(y.[F_InGroups] * 100 / NULLIF(y.[TotalFemales], 0), 0) As [F_PercentGroups]
    ,COALESCE(y.[M_InGroups] * 100 / NULLIF(y.[TotalMales], 0), 0) AS [M_PercentGroups]
    ,COALESCE(y.[F_HasTransactions] * 100 / NULLIF(y.[TotalFemales], 0), 0) AS [F_PercentTransactions]
    ,COALESCE(y.[M_HasTransactions] * 100 / NULLIF(y.[TotalMales], 0), 0) AS [M_PercentTransactions]
FROM
    agg_person_info y
ORDER BY
    y.[BirthYear] DESC, y.[MaritalStatusValueId]

SET STATISTICS IO, TIME OFF