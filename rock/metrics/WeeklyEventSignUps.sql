-- counts the total registrants created for reg instances attached to an event item occurence set to the right campus id and the right ministry attribute value
-- only counts registrants lastMon - lastSun
-- meant to be run mon at midnight for a metric data view

------------------------------------------
-- edit these fields
DECLARE @campusId INT = 2; -- adventure
DECLARE @ministryGuid UNIQUEIDENTIFIER = '2213da0a-cbea-4d8d-8234-8ad46d372d2d'; -- childrens
------------------------------------------

DECLARE @lastSunday DATETIME = [dbo].ufnUtility_GetPreviousSundayDate();
DECLARE @weekBeforeLastSunday DATETIME = DATEADD(day, -7, [dbo].ufnUtility_GetPreviousSundayDate());
DECLARE @ministryAttributeId INT = 17906;

SELECT
    pa.[PersonId]
FROM
    [EventItemOccurrence] eic
    INNER JOIN [AttributeValue] av ON [av].[EntityId] = eic.[Id] AND av.[AttributeId] = @ministryAttributeId
    INNER JOIN [EventItemOccurrenceGroupMap] eicgm ON eic.[Id] = eicgm.[EventItemOccurrenceId]
    INNER JOIN [RegistrationInstance] ri ON ri.[Id] = eicgm.[RegistrationInstanceId]
    INNER JOIN [Registration] r ON r.[RegistrationInstanceId] = ri.[Id]
    INNER JOIN [RegistrationRegistrant] rr ON rr.[RegistrationId] = r.[Id]
    INNER JOIN [PersonAlias] pa ON rr.[PersonAliasId] = pa.[Id]
WHERE
    eic.[CampusId] = @campusId AND
    rr.[CreatedDateTime] > @weekBeforeLastSunday AND 
    rr.[CreatedDateTime] <= @lastSunday AND
    av.[Value] = @ministryGuid