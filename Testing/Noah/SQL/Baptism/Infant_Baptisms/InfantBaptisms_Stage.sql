SELECT
    y.*
FROM
(SELECT
    x.[PersonId]
    --STRING_AGG(x.PersonId, ',') AS [ConcatPersonIds]
    ,CASE x.AgeClassification
        WHEN 0 THEN 'Unknown'
        WHEN 1 THEN 'Adult'
        WHEN 2 THEN 'Child'
    END AS [AgeClass]
    ,x.[Age]
    ,(CASE WHEN [DayOfWeek] = 1 THEN x.[CreatedDate] ELSE x.[SundayDate] END) AS [Occurrence]
FROM
    (SELECT
        a.[Key]
        ,a.[FieldTypeId]
        ,ft.Name As [FieldTypeName]
        ,av.EntityId
        ,p.Id AS [PersonId]
        ,[dbo].[ufnCrm_GetAge](p.BirthDate) AS [Age]
        ,p.AgeClassification
        ,av.Value
        ,DATEADD(day, -7, [dbo].[ufnUtility_GetSundayDate](av.CreatedDateTime)) AS [SundayDate]
        ,DATEPART(weekday, av.CreatedDateTime) AS [DayOfWeek]
        ,av.CreatedDateTime
        ,CAST(av.CreatedDateTime AS DATE) AS [CreatedDate]
        ,av.ModifiedDateTime
        ,av.CreatedByPersonAliasId
    FROM
        [AttributeValue] av
        INNER JOIN [Attribute] a ON a.Id = av.AttributeId
        INNER JOIN [FieldType] ft ON ft.Id = a.FieldTypeId
        INNER JOIN [Person] p ON p.Id = av.EntityId
    WHERE
        av.AttributeId = 11895
    ) x )y
ORDER BY
    y.Occurrence, y.AgeClass, y.Age