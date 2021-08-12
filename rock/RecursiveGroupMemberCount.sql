WITH group_cte ([Id], [Name], [ParentGroupId])
AS
(
    SELECT
        [Id],
        [Name],
        [ParentGroupId]
    FROM
        [Group]
    WHERE
        [Id] = 764527
    UNION ALL
    SELECT
        g.[Id],
        g.[Name],
        g.[ParentGroupId]
    FROM
        group_cte
        INNER JOIN [Group] g ON group_cte.[Id] = g.[ParentGroupIdId]
)
SELECT TOP 1000 *
FROM   group_cte