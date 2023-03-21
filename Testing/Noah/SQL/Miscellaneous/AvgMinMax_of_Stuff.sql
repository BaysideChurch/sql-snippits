-- Groups
WITH avg_min_max_groups AS (
    SELECT
        AVG(x.GroupMemberPersonCount)
        ,MAX(x.GroupMemberPersonCount)
        ,MIN(x.GroupMemberPersonCount)
    FROM
    ( SELECT
        COUNT(*) As [GroupMemberPersonCount]
    FROM
        [GroupMember] gm
        INNER JOIn [Group] g ON g.Id = gm.GroupId
    WHERE
        gm.IsArchived = 0
        AND gm.GroupMemberStatus != 0
        AND g.IsActive = 1
        AND g.IsArchived = 0
    GROUP BY
        gm.PersonId
    ) x
),
--Events
avg_min_max_events AS (
    SELECT
        AVG(x.RegistrantCount)
        ,MAX(x.RegistrantCount)
        ,MIN(x.RegistrantCount)
    FROM
    ( SELECT
        COUNT(*) As [RegistrantCount]
    FROM
        [RegistrationRegistrant] rr
        INNER JOIN [PersonAlias] pa On pa.Id = rr.PersonAliasId
        INNER JOIn [Registration] r ON r.Id = rr.RegistrationId
        INNER JOIn [RegistrationInstance] ri ON ri.Id = r.RegistrationInstanceId
    WHERE
        ri.EndDateTime >= GETDATE()
        ANd ri.IsActive = 1
    GROUP BY
        pa.PersonId
    ) x
),
-- Family Members
avg_min_max_family AS (
    SELECT
        AVG(x.FamilyMemberCount)
        ,MAX(x.FamilyMemberCount)
        ,MIN(x.FamilyMemberCount)
    FROM
    (SELECT
        COUNT(*) AS [FamilyMemberCount]
        ,g.Id
    FROM
        [GroupMember] gm
        INNER JOIN [Group] g ON g.Id = gm.GroupId
        INNER JOIN [GroupType] gt ON gt.Id = g.GroupTypeId
    WHERE
        g.GroupTypeId = 10
    GROUP BY
        g.Id
    HAVING
        COUNT(*) < 55
    ) x
),
-- Communication Lists
-- Groups
avg_min_max_communicationLists AS (
    SELECT
        AVG(x.GroupMemberPersonCount)
        ,MAX(x.GroupMemberPersonCount)
        ,MIN(x.GroupMemberPersonCount)
    FROM
    ( SELECT
        COUNT(*) As [GroupMemberPersonCount]
    FROM
        [GroupMember] gm
        INNER JOIn [Group] g ON g.Id = gm.GroupId
    WHERE
        gm.IsArchived = 0
        AND gm.GroupMemberStatus != 0
        AND g.IsActive = 1
        AND g.IsArchived = 0
        AND g.GroupTypeId = 32
    GROUP BY
        gm.PersonId
    ) x
)

SELECT 1;