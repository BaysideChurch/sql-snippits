DECLARE @farInPast DATE = DATEADD(YEAR, -20, GETDATE());
DECLARE @farinFuture DATE = DATEADD(YEAR, 20, GETDATE());

SELECT
  TOP 1000
  ri.[Name] AS [InstanceName],
  --'<a href="~/web/event-registrations?RegistrationTemplateId=' + rt.[Id] + '">' + rt.[Name] + '</a> 'AS [TemplateName],
  ri.[Id] AS Id,
  ri.[StartDateTime] AS RegistrationStart,
  ri.[EndDateTime] AS RegistrationClose,
  s.[EffectiveStartDate] AS EventStart,
  COALESCE(s.[EffectiveEndDate], s.[EffectiveStartDate]) AS EventEnd
FROM
  [RegistrationInstance] ri
  INNER JOIN [RegistrationTemplate] rt ON ri.[RegistrationTemplateId] = rt.[Id]
  LEFT JOIN [AttributeValue] riMinistryAv ON riMinistryAv.[EntityId] = ri.[Id] AND riMinistryAv.[AttributeId] = 42056
  LEFT JOIN [AttributeValue] riCampusesAv ON riCampusesAv.[EntityId] = ri.[Id] AND riCampusesAv.[AttributeId] = 42057
  LEFT JOIN [Campus] c ON c.[Guid] = TRY_CONVERT(UNIQUEIDENTIFIER, @campus)
  LEFT JOIN [EventItemOccurrenceGroupMap] eicgm ON ri.[Id] = eicgm.[RegistrationInstanceId]
  LEFT JOIN [EventItemOccurrence] eic ON eic.[Id] = eicgm.[EventItemOccurrenceId]
  LEFT JOIN [Schedule] s ON eic.[ScheduleId] = s.[Id]
  LEFT JOIN [AttributeValue] eicMinistryAv ON eicMinistryAv.[EntityId] = eic.[Id] AND eicMinistryAv.[AttributeId] = 17906
WHERE
  -- filter based on ministry
  (
    (
      @ministry = '' OR
      @ministry = eicMinistryAv.[Value]
    ) OR
    (
      @ministry = '' OR
      @ministry = riMinistryAv.[Value]
    )
  ) AND

  -- filter based on template name
  (
    @templateName = '' OR
    rt.[Name] LIKE (
      '%' + @templateName + '%' -- match in middle of word
    ) OR
    rt.[Name] LIKE (
      @templateName + '%' -- match prefix
    )
  ) AND

  -- filter based on instance name
  (
    @instanceName = '' OR
    ri.[Name] LIKE (
      '%' + @instanceName + '%' -- match in middle of word
    ) OR
    ri.[Name] LIKE (
      @instanceName + '%' -- match prefix
    )
  ) AND

  -- filter based on end date
  DATEDIFF(
    day, 
    COALESCE(s.[EffectiveEndDate], s.[EffectiveStartDate]),
    (
      CASE
      WHEN (@startDate = '') THEN @farInPast
      WHEN (@startDate != '') THEN CONVERT(DATE, @startDate)
      END
    )
  ) <= 0 AND

  -- filter based on start date
  DATEDIFF(
    day, 
    s.[EffectiveStartDate],
    (
      CASE
      WHEN (@endDate = '') THEN @farInFuture
      WHEN (@endDate != '') THEN CONVERT(DATE, @endDate)
      END
    )
  ) >= 0 AND

  (
    -- filter based on campus (RegistrationInstance attribute)
    (
      @campus = '' OR
      @campus IN (SELECT value FROM STRING_SPLIT(riCampusesAv.[Value], ','))
    ) OR

    -- filter based on campus (EventItemOccurrence CampusId)
    (
      @campus = '' OR
      c.[Id] = eic.[CampusId]
    )
  )

ORDER BY
  s.[EffectiveStartDate] DESC,
  ri.[EndDateTime] DESC
