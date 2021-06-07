-- Gets a csv string with all groups of a specific type that a given person is a member of

-- parameters
-- @GroupTypeId - Id of the group type
-- @PersonId - Id of the person that is given


SELECT
    STRING_AGG(g.[Name], ', ') AS Groups
FROM
    [GroupMember] gm
    INNER JOIN [Group] g on g.[Id] = gm.[GroupId] AND g.[GroupTypeId] = @GroupTypeId
WHERE
    gm.[PersonId] = @PersonId