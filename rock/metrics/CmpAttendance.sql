-- gets the individuals who checked into a cmp group at specified campus prev week
-- meant to be run monday @midnight

------------------------------------------
-- edit these fields
DECLARE @campusId INT = 8; -- granite bay
------------------------------------------

DECLARE @cmpGroupTypeId INT = 146;
DECLARE @lastSunday DATETIME = [dbo].ufnUtility_GetPreviousSundayDate();
DECLARE @weekBeforeLastSunday DATETIME = DATEADD(day, -7, [dbo].ufnUtility_GetPreviousSundayDate());

SELECT
    pa.[PersonId]
FROM
    [AttendanceOccurrence] ao
    INNER JOIN [Group] g ON ao.[GroupId] = g.[Id]
    INNER JOIN [Attendance] a ON a.[OccurrenceId] = ao.[Id]
    INNER JOIN [PersonAlias] pa ON pa.[Id] = a.[PersonAliasId]
WHERE
    g.[GroupTypeId] = 146 AND
    g.[CampusId] = @campusId AND
    ao.[OccurrenceDate] > @weekBeforeLastSunday AND
    ao.[OccurrenceDate] <= @lastSunday