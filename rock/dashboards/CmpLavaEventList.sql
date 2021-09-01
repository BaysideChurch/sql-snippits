DECLARE @cmpRegInstAttrId INT
SET @cmpRegInstAttrId = 16806

SELECT
    TOP 1000
    [EventName],
    [EventCampus],
    [EventOccurrenceId],
    [EventStart],
    [EventEnd],
    [CmpRegistrationInstanceId],
    SUM([Registrants]) AS CmpRegistrants
FROM
    (
        SELECT
            TOP 10000
            ei.[Name] AS EventName,
            eic.[Id] AS EventOccurrenceId,
            s.[EffectiveStartDate] AS EventStart,
            s.[EffectiveEndDate] AS EventEnd,
            cmpri.[Id] AS CmpRegistrationInstanceId,
            r.[Id] AS RegistrationId,
            c.[Name] AS EventCampus,
            COUNT(rr.[Id]) AS Registrants
        FROM
            [EventItemOccurrence] eic
            INNER JOIN [EventItem] ei ON eic.[EventItemId] = ei.[Id]
            INNER JOIN [Schedule] s ON eic.[ScheduleId] = s.[Id]
            INNER JOIN [EventItemOccurrenceGroupMap] gm ON gm.[EventItemOccurrenceId] = eic.[Id]
            INNER JOIN [RegistrationInstance] ri on gm.[RegistrationInstanceId] = ri.[Id]
            INNER JOIN [AttributeValue] av ON av.[AttributeId] = @cmpRegInstAttrId AND av.[EntityId] = ri.[Id]
            LEFT JOIN [RegistrationInstance] cmpri on av.[Value] = cmpri.[Guid]
            LEFT JOIN [Registration] r ON r.[RegistrationInstanceId] = cmpri.[Id]
            LEFT JOIN [RegistrationRegistrant] rr on rr.[RegistrationId] = r.[Id]
            LEFT JOIN [Campus] c ON eic.[CampusId] = c.[Id]
        WHERE
            (
                (
                    DATEDIFF(day, s.[EffectiveStartDate], @date) = 0 AND
                    s.[EffectiveEndDate] IS NULL
                )
                OR
                (
                    s.[EffectiveEndDate] IS NOT NULL AND
                    DATEDIFF(day, s.[EffectiveEndDate], @date) <= 0 AND
                    DATEDIFF(day, s.[EffectiveStartDate], @date) >= 0
                )
            )
            AND
            (
                TRY_CONVERT(UNIQUEIDENTIFIER, @campus) IS NULL OR
                (
                    eic.[CampusId] IS NOT NULL AND
                    eic.[CampusId] IN (SELECT TOP 1 Id FROM Campus WHERE Guid = TRY_CONVERT(UNIQUEIDENTIFIER, @campus))
                )
            )
        GROUP BY
            ei.[Name],
            s.[EffectiveStartDate],
            s.[EffectiveEndDate],
            cmpri.[Id],
            r.[Id],
            eic.[Id],
            c.[Name]
        ORDER BY
            s.[EffectiveStartDate] DESC
    ) [table]
GROUP BY
    [EventName],
    [EventStart],
    [EventEnd],
    [CmpRegistrationInstanceId],
    [EventOccurrenceId],
    [EventCampus]
