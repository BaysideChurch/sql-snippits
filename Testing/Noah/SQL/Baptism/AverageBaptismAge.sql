DECLARE @realtoday DATETIME = CAST(GETDATE() AS DATE);
DECLARE @today DATETIME = DATEADD(day, -27, @realtoday);
DECLARE @oneMonthAgo DATETIME = DATEADD(MONTH, -1, @today);
DECLARE @baptismCampus INT = 10180;
DECLARE @baptismDate INT = 174;

WITH cte_person_ids AS (
    SELECT
        p.Id AS [PersonId]
        ,[dbo].[ufnCrm_GetAge](p.BirthDate) AS [CurrentAge]
        ,p.CreatedDateTime
        ,p.BirthDate
        ,val.ValueAsDateTime AS [BaptismDate]
    FROM
        [Person] p
        CROSS APPLY (
            SELECT av.ValueAsDateTime
            FROM [AttributeValue] av
            WHERE av.EntityId = p.Id
                AND av.AttributeId = @baptismDate
                AND av.ValueAsDateTime IS NOT NULL
                --AND av.ValueAsDateTime >= p.CreatedDateTime--BETWEEN @oneMonthAgo AND @today
        ) val
    WHERE
        IsDeceased = 0
)

SELECT
    x.*
    ,x.CurrentAge - x.BaptismAge AS [DiffBaptism]
FROM
(SELECT
    cpi.*
    ,CASE
        -- Year 0001 is a special year, which denotes no year selected therefore we shouldn't calculate the age.
        WHEN cpi.BirthDate IS NOT NULL AND DATEPART(year, cpi.[BirthDate]) > 1
            THEN DATEDIFF(year, cpi.[BirthDate], cpi.BaptismDate)
                 - CASE
                       WHEN MONTH(cpi.[BirthDate]) > MONTH(cpi.BaptismDate) OR (MONTH(cpi.[BirthDate]) = MONTH(cpi.BaptismDate) AND DAY(cpi.[BirthDate]) > DAY(cpi.BaptismDate))
                           THEN 1
                       ELSE 0
                   END
        ELSE NULL
    END AS [BaptismAge]
FROM
    cte_person_ids cpi
WHERE
    cpi.CreatedDateTime <= cpi.BaptismDate
    AND cpi.CurrentAge IS NOT NULL
) x
ORDER BY
    [DiffBaptism] DESC