SELECT
    42056 AS [EntityId],
    existingAv.[Value],
    GETDATE() AS [CreatedDateTime],
    NEWID() AS [Guid],
    dv.[Value] AS [PersistedValueText],
    dv.[Value] AS [PersistedHtmlValue],
    dv.[Value] AS [PersistedCondensedTextValue],
    dv.[Value] AS [PersistedCondensedHtmlValue],
    existingAv.[ValueChecksum]
FROM
    [AttributeValue] existingAv
    INNER JOIN [EventItemOccurrence] eic ON eic.[Id] = existingAv.[EntityId]
    INNER JOIN [EventItemOccurrenceGroupMap] eicgm ON eic.[Id] = eicgm.[EventItemOccurrenceId]
    INNER JOIN [RegistrationInstance] ri ON ri.[Id] = eicgm.[RegistrationInstanceId]
    INNER JOIN [DefinedValue] dv ON existingAv.[Value] = dv.[Guid]
WHERE
    existingAv.[AttributeId] = 17906