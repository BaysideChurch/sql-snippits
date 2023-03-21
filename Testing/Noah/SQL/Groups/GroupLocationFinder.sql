SELECT
    g.Id AS [GroupId]
    ,g.Name
    ,gl.LocationId
    ,gt.Name AS [GroupType]
FROM
    [GroupLocation] gl
    INNER JOIN [Group] g ON g.Id = gl.GroupId
    INNER JOIN [GroupType] gt On gt.Id = g.GroupTypeId
WHERE
    gl.LocationId IN (135, 157087) -- Put LocationIds here