WITH primary_owners AS (
    SELECT
        p.Id AS [PersonId]
        ,p.FirstName + ' ' + p.LastName As [PersonFullName]
        ,g.Id As [GroupId]
    FROM
        [Person] p
        INNER JOIN [GroupMember] gm ON gm.PersonId = p.Id
        INNER JOIN [Group] g ON g.[Id] = gm.[GroupId]
    WHERE
        g.GroupTypeId = 11
        AND p.RecordTypeValueId = 1
        AND p.RecordStatusValueId != 4
        AND gm.GroupRoleId = 5 --Owner
)

SELECT
    x.PersonId
    ,x.PersonFullName
    ,gtr.Name As [Relation]
    ,gtr.Id As [RoleId]
    ,p1.Id As [RelationPersonId]
    ,p1.FirstName + ' ' + p1.LastName As [RelationPerson]
FROM
    primary_owners x
    INNER JOIN [GroupMember] gm1 ON gm1.GroupId = x.GroupId AND gm1.PersonId != x.PersonId
    INNER JOIN [GroupTypeRole] gtr ON gtr.Id = gm1.GroupRoleId
    INNER JOIN [Person] p1 On p1.Id = gm1.PersonId
WHERE
    p1.RecordTypeValueId = 1
    AND p1.RecordStatusValueId != 4
    AND gtr.Id != 26 -- Business
   -- ANd gtr.Id NOT IN (18,17, 26)
ORDER BY
    x.PersonId, gtr.Id