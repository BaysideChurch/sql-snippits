SELECT
    TOP 100
    g.Name AS [GroupName]
    ,gtr.Name AS [Role]
    ,cr.*
FROM
    [ConnectionRequest] cr
    INNER JOIN [Group] g ON g.Id = cr.AssignedGroupId
    INNER JOIN [GroupTypeRole] gtr ON gtr.Id = cr.AssignedGroupMemberRoleId
        AND g.GroupTypeId = gtr.GroupTypeId

