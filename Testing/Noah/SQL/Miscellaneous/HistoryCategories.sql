SELECT
    COUNT(*) AS [HistoryCount]
    ,x.Name
    ,x.CategoryId
    ,x.Verb
FROM
    (SELECT
        c.Name
        ,c.Id AS [CategoryId]
        ,h.Verb
        ,h.RelatedData
        ,h.ChangeType
        ,h.Caption
        ,h.ValueName
        ,h.SourceOfChange
        ,h.OldRawValue
        ,h.NewRawValue
        ,h.OldValue
        ,h.NewValue
        ,h.EntityId
        ,CAST(h.CreatedDateTime AS DATE) AS [CreatedDate]
    FROM
        [History] h
        LEFT JOIN [Category] c ON c.Id = h.CategoryId
    WHERE
        h.EntityTypeId = 15
        AND CAST(h.CreatedDateTime AS DATE) >= '01/01/2023'
        --AND c.Id IN (132, 133)
    ) x
GROUP BY
    x.CategoryId,x.Name,x.Verb