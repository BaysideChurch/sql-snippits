WITH family AS (
    SELECT
    g.Id AS [FamilyId]
    ,p.Id As [PersonId]
    ,p.AgeClassification
FROM
    [Group] g
    INNER JOIN [GroupMember] gm ON gm.GroupId = g.Id
    INNER JOIN [Person] p ON p.Id = gm.PersonId
WHERE
    g.GroupTypeId = 10 -- Family
), singleFamilyMember AS (
SELECT
    COUNT(*) AS [MemberCount]
    ,MAX(f.PersonId) AS [PersonId]
    ,f.FamilyId
FROM
    family f
GROUP BY
    f.FamilyId
HAVING
    COUNT(*) = 1
)

SELECT
--    sfm.*
    f.PersonId
    ,f.AgeClassification
FROM
    singleFamilyMember sfm
    INNER JOIN family f ON f.PersonId = sfm.PersonId
WHERE
    f.AgeClassification = 2
GROUP BY
    f.PersonId, f.AgeClassification