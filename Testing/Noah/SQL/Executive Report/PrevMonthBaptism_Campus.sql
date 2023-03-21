DECLARE @realtoday DATETIME = CAST(GETDATE() AS DATE);
DECLARE @today DATETIME = DATEADD(day, -27, @realtoday);
DECLARE @oneMonthAgo DATETIME = DATEADD(MONTH, -1, @today);
DECLARE @baptismCampus INT = 10180;
DECLARE @baptismDate INT = 174;

SELECT @today;

WITH cte_person_ids AS (
    SELECT
        p.Id AS [PersonId]
    FROM
        [Person] p
    WHERE
        IsDeceased = 0
        AND EXISTS (
            SELECT 1
            FROM [AttributeValue] av
            WHERE av.EntityId = p.Id
                AND av.AttributeId = @baptismDate
                AND av.ValueAsDateTime IS NOT NULL
                AND av.ValueAsDateTime BETWEEN @oneMonthAgo AND @today
        )
), cte_person_attributes AS (
    SELECT
        p.PersonId
        ,av.Value AS [CampusGuid]
    FROM
        cte_person_ids p
    CROSS APPLY (
        SELECT TOP 1 av.[Value]
        FROM [AttributeValue] av
        WHERE
            av.EntityId = p.PersonId
            AND av.AttributeId = @baptismCampus
    ) av
)
SELECT
    ISNULL(COUNT(copa.Campusguid), 0) AS [BaptismCount]
    ,c.Id AS [CampusId]
    ,MAX(c.Name) AS [Campus]
FROM
    [Campus] c
    LEFT JOIN cte_person_attributes copa ON CAST(c.Guid AS VARCHAR(50)) = copa.[CampusGuid]
WHERE
    c.IsActive = 1
GROUP BY
    c.Id
