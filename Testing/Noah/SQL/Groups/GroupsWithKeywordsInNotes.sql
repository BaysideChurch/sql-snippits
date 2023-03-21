WITH attendanceNotes AS (
SELECT
    ao.[GroupId]
    ,ao.[Notes]
    ,ao.[DidNotOccur]
    ,ao.[CreatedDateTime]
    ,g.[IsActive]
    ,g.Name AS [GroupName]
    ,g.[IsArchived]
    ,g.ParentGroupId
FROM
    [AttendanceOccurrence] ao
    RIGHT JOIN [Group] g ON g.[Id] = ao.[GroupId]
        AND g.[IsActive] = 1 AND g.[IsArchived] != 1
WHERE
    ao.[Notes] IS NOT NULL
    AND (
        (ao.[Notes] LIKE '%No longer%')
        OR (ao.[Notes] LIKE '%stop%')
        OR (ao.[Notes] LIKE '%messag%')
        OR (ao.[Notes] LIKE '%unsubscribe%')
        OR (ao.[Notes] LIKe '%email%')
        OR (ao.[Notes] LIKE '%add%')
        )
)

SELECT
    an.GroupId
    ,an.GroupName
    ,an.ParentGroupId
    ,STRING_AGG(an.Notes, ';') AS [Notes]
FROM
    [attendanceNotes] an
GROUP BY
    an.GroupId, an.GroupName, an.ParentGroupId