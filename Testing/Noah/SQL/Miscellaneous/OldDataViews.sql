SELECT
    dv.Id
    ,dv.Name
    ,dv.Description
    ,dv.EntityTypeId
    ,dv.CategoryId
    ,dv.LastRunDateTime
FROM
    [DataView] dv
WHERE
    dv.EntityTypeId = 15
    AND dv.LastRunDateTime <= DATEADD(day, -120, GETDATE())
    AND dv.CategoryId NOT IN (542,729,567,454,533,845)
ORDER BY
    dv.LastRunDateTime