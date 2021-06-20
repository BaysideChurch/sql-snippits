SELECT
    ri.[Name] as Name,
    ri.[Id] as Id,
    ri.[StartDateTime],
    ri.[EndDateTime]
FROM
    [EventItemOccurrence] eic
    INNER JOIN [Schedule] s ON eic.[ScheduleId] = s.[Id]
    INNER JOIN [AttributeValue] av ON [av].[EntityId] = eic.[Id] AND av.[AttributeId] = 17906
    INNER JOIN [EventItemOccurrenceGroupMap] eicgm ON eic.[Id] = eicgm.[EventItemOccurrenceId]
    INNER JOIN [RegistrationInstance] ri ON ri.[Id] = eicgm.[RegistrationInstanceId]
WHERE
    eic.[Id] = 169 AND
    av.[Value] = 'dada98dc-984a-412a-86cd-cf9c7f691a38' AND
    DATEDIFF(day, s.[EffectiveEndDate], GETDATE()) > 0