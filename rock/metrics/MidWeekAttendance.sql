-- counts the total attendance on prev or THIS mon-fri for a given set of group type ids
-- meant to be run thurs at midnight for a metric data view

------------------------------------------
-- edit these fields
DECLARE @groupTypeIds TABLE ([Id] INT);
INSERT INTO @groupTypeIds ([Id]) VALUES (108), (109), (110); -- GB - Nursery, GB - Preschool, GB - Elementary
------------------------------------------

DECLARE @lastSunday DATETIME = [dbo].ufnUtility_GetPreviousSundayDate();
DECLARE @thisFriday DATETIME = DATEADD(day, 5, [dbo].ufnUtility_GetPreviousSundayDate());

SELECT
    pa.[PersonId]
FROM
    [AttendanceOccurrence] ao
    INNER JOIN [Group] g ON ao.[GroupId] = g.[Id]
    INNER JOIN [Attendance] a ON a.[OccurrenceId] = ao.[Id]
    INNER JOIN [PersonAlias] pa ON pa.[Id] = a.[PersonAliasId]
WHERE
    g.[GroupTypeId] IN (SELECT * FROM @groupTypeIds) AND
    (
        ao.[OccurrenceDate] > @lastSunday AND
        ao.[OccurrenceDate] <= @thisFriday
    )