SELECT distinct
    TOP 10000
    --gmh.*
    g.*
FROM
    [GroupMemberHistorical] gmh
    INNER JOIN [Group] g ON g.Id = gmh.GroupId
    INNER JOIN [GroupType] gt ON gt.Id = g.GroupTypeId
WHERE
    gt.EnableGroupHistory = 0