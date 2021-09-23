
DECLARE @attendanceOccurrenceId INT = 151686; -- from lava, previously inserted AttendanceOccurrenceId
DECLARE @campusId INT = 8;
DECLARE @personAliasId = 127873;

INSERT INTO [dbo].[Attendance]
    (
        [StartDateTime],
        [DidAttend],
        [Note],
        [Guid],
        [CampusId],
        [PersonAliasId],
        [OccurrenceId]
    )
OUTPUT
    Inserted.[Id]
VALUES
    (
        GETDATE(),
        1,
        'Checked in with the RSVP system on the staff portal',
        NEWID(),
        @campusId,
        @personAliasId,
        @attendanceOccurrenceId
    );