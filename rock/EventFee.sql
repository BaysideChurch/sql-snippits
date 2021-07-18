DECLARE @regInstId INT = 314;

--cte to select fees from a specific registrationInstance
WITH fee_cte AS (
    SELECT
        rrf.[Option] AS [Name],
        rrf.[Cost] AS [Cost],
        COUNT(rrf.[Quantity]) AS [Count]
    FROM
        [RegistrationRegistrantFee] rrf
        INNER JOIN [RegistrationRegistrant] rr ON rr.[Id] = rrf.[RegistrationRegistrantId]
        INNER JOIN [Registration] r ON r.[Id] = rr.[RegistrationId]
        INNER JOIN [RegistrationInstance] ri ON ri.[Id] = r.[RegistrationInstanceId]
    WHERE
        ri.[Id] = @regInstId
    GROUP BY
        rrf.[Option], rrf.[Cost]
)
--List of Fee Items, their count, and their total cost
SELECT
    f.[Name],
    f.[Count],
    FORMAT(f.[Cost] * f.[Count], 'C') AS 'Total'
FROM
    [fee_cte] f

--Total Fee Items
SELECT
    SUM(f.[Count])
FROM
    [fee_cte] f