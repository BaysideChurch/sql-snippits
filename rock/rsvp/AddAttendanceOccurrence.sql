DECLARE @groupId INT = 781049 -- GB - Service RSVP GroupId
DECLARE @locationId INT = 21 -- Granite Bay Campus LocationId

INSERT INTO [dbo].[AttendanceOccurrence]
    (
        [GroupId],
        [LocationId],
        [OccurrenceDate],
        [Guid],
        [ShowDeclineReasons]
    )
OUTPUT
    Inserted.[Id]
VALUES
    (
        @groupId,
        @locationId,
        GETDATE(),
        NEWID(),
        0
    );
