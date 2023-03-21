SELECT
    g.Id AS [GroupId]
    ,g.Name AS [GroupName]
    ,g.Description
    ,COUNT(*) AS [MemberCount]
    ,g.IsActive
FROM
    [Group] g
    LEFT JOIN [GroupMember] gm ON gm.GroupId = g.Id
        AND gm.IsArchived != 1 -- Not Archived
        AND gm.GroupMemberStatus != 2 -- Not Pending
WHERE
    g.GroupTypeId = 32 -- Communication List
    AND g.IsArchived = 0
GROUP BY
    g.Id, g.Name, g.Description, g.IsActive
ORDER BY
    g.Name ASC
