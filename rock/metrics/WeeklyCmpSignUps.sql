-- counts the registrants who signed up for a registration instance that is linked as a cmp regisration instance to an event at that campus
-- meant to be run monday @midnight

------------------------------------------
-- edit these fields
DECLARE @campusId INT = 8; -- granite bay
------------------------------------------

DECLARE @cmpRegInstAttrId INT = 16806;
DECLARE @lastSunday DATETIME = [dbo].ufnUtility_GetPreviousSundayDate();
DECLARE @weekBeforeLastSunday DATETIME = DATEADD(day, -7, [dbo].ufnUtility_GetPreviousSundayDate());

SELECT
    pa.[PersonId]
FROM
    [EventItemOccurrence] eic
    INNER JOIN [EventItem] ei ON eic.[EventItemId] = ei.[Id]
    INNER JOIN [Schedule] s ON eic.[ScheduleId] = s.[Id]
    INNER JOIN [EventItemOccurrenceGroupMap] gm ON gm.[EventItemOccurrenceId] = eic.[Id]
    INNER JOIN [RegistrationInstance] ri on gm.[RegistrationInstanceId] = ri.[Id]
    INNER JOIN [AttributeValue] av ON av.[AttributeId] = @cmpRegInstAttrId AND av.[EntityId] = ri.[Id]
    LEFT JOIN [RegistrationInstance] cmpri ON TRY_CONVERT(UNIQUEIDENTIFIER, av.[Value])  = cmpri.[Guid]
    LEFT JOIN [Registration] r ON r.[RegistrationInstanceId] = cmpri.[Id]
    LEFT JOIN [RegistrationRegistrant] rr on rr.[RegistrationId] = r.[Id]
    LEFT JOIN [PersonAlias] pa ON rr.[PersonAliasId] = pa.[Id]
WHERE
    eic.[CampusId] = @campusId AND
    rr.[CreatedDateTime] > @weekBeforeLastSunday AND
    rr.[CreatedDateTime] <= @lastSunday