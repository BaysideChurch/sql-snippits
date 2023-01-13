SELECT
    g.[Id]
    ,g.Name
    ,g.GroupTypeId
    ,gt.Name As [GroupTypeName]
    ,g.ScheduleId
    ,g.SchedulingMustMeetRequirements
    ,g.CampusId
    ,CASE gl.GroupLocationTypeValueId
        WHEN 19 THEN 'Home'
        WHEN 832 THEN 'Other'
        WHEN 20 THEN 'Work'
        WHEN 1016 THEN 'College Address'
        WHEN 137 THEN 'Previous'
        WHEN 209 THEN 'Meeting Location'
        WHEN 572 THEN 'Geographic Area'
    END AS [GroupLocationTypeValue]
    ,gl.Id AS [GroupLocationId]
    ,CASE
        WHEN CONVERT(DATE, s.EffectiveEndDate, 126) <= GETDATE() THEN 1
        ELSE 0
    END As [IsEventOld]
    ,s.EffectiveEndDate
    ,s.*
    --,l.*
    
FROM
    [Group] g
    INNER JOIN [GroupLocation] gl ON gl.GroupId = g.Id
    --INNER JOIN [Location] l ON l.Id = gl.LocationId
    INNER JOIN [GroupLocationSchedule] gsl ON gsl.GroupLocationId = gl.Id
    INNER JOIN [Schedule] s ON s.Id = gsl.ScheduleId
    INNER JOIN [GroupType] gt ON gt.Id = g.GroupTypeId
WHERE
    s.IsActive = 0
    AND CONVERT(DATE, s.EffectiveEndDate, 126) <= GETDATE()
    AND g.IsActive = 1
    AND g.IsArchived != 1
ORDER BY
    g.Id ASC, s.EffectiveEndDate DESC