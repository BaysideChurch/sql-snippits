/*
This query takes mimics the DataFilter "Attendance in Group Type(s)".
It is assembled from the SQL generated via LINQ through Rock, but with 
    modifications for readability.
The main portions are separated out as CTEs.
1. Attendance Query: Grabs the basic attendance records
2. Attendance Count: Grabs the atendance of people within a range for group type(s)
3. Person query: Joins the attendance count to person records

There are two person queries because 1 uses an EXISTS, while the other joins on an Id.
Personally, I think the join query works better and is more readable.

The final selection of these CTEs groups the count by their Primary Campus for Metrics
*/


DECLARE @startDate datetime2(7),@endDate datetime2(7),@servingTeamGT int,@volunteerCheckin int,@attendance int;
--2/20/2023 12:00 AM to 2/26/2023 11:59 PM
SET @startDate='2021-01-01 00:00:00';
SET @endDate='2023-03-26 23:59:59.9990000';
SET @servingTeamGT=23;
SET @volunteerCheckin = 30;
DECLARE @smallGroupGT INT = 25;
SET @attendance=1;


WITH attendanceQry AS (
    SELECT
        a.[PersonAliasId] AS [PersonAliasId]
        ,ao.[OccurrenceDate] AS [OccurrenceDate]
        ,g.[GroupTypeId] AS [GroupTypeId]
        ,g.CampusId
    FROM
        [Attendance] AS a
        INNER JOIN [dbo].[AttendanceOccurrence] AS ao ON a.[OccurrenceId] = ao.[Id]
        INNER JOIN [dbo].[Group] AS g ON ao.[GroupId] = g.[Id]
    WHERE
        (a.[DidAttend] IS NOT NULL) AND (a.[DidAttend] = 1)
), attendanceCount As (
    SELECT 
        COUNT(1) AS [A1]
        ,[Filter2].OccurrenceDate
        ,pa.PersonId
    FROM
        attendanceQry AS [Filter2]
        INNER JOIN [PersonAlias] AS pa ON [Filter2].[PersonAliasId] = pa.[Id]
    WHERE
        ([Filter2].[OccurrenceDate] >= @startDate)
        AND ([Filter2].[OccurrenceDate] < @endDate)
        AND ([Filter2].[GroupTypeId] IN (@smallGroupGT))--(@servingTeamGT, @volunteerCheckin))
    GROUP BY
        pa.PersonId, [Filter2].[OccurrenceDate]
    HAVING
        COUNT(1) >= @attendance
), personOptimizeV2 As (
    SELECT
        p.[Id] AS [PersonId],
        p.[BirthDay] AS [BirthDay], 
        p.[BirthMonth] AS [BirthMonth], 
        p.[BirthYear] AS [BirthYear], 
        p.[Gender] AS [Gender], 
        p.[AgeClassification] AS [AgeClassification], 
        p.[PrimaryFamilyId] AS [PrimaryFamilyId], 
        p.[PrimaryCampusId] AS [PrimaryCampusId],
        p.[BirthDate] AS [BirthDate], 
        p.[CreatedDateTime] AS [CreatedDateTime], 
        p.[Guid] AS [Guid]
        ,ac.[A1]
        ,ac.OccurrenceDate
        ,ROW_NUMBER() OVER (PARTITION BY p.Id, asd.CalendarYearMonth ORDER BY p.Id) AS [RN]
        ,asd.CalendarYearMonth
        FROM
            [Person] AS p
            INNER JOIN attendanceCount ac ON ac.PersonId = p.Id
            INNER JOIN [AnalyticsSourceDate] asd ON asd.[Date] = ac.OccurrenceDate
        WHERE
            (p.[RecordTypeValueId] = 1) -- Person Record
            AND (p.[IsDeceased] = 0)
)

--SELECt * FROM personOptimizeV2 pov2 ORDER BY pov2.PersonId;


SELECT
    pov2.PrimaryCampusId
    ,MAX(pov2.OccurrenceDate) AS [MaxDate]
    ,MIN(pov2.OccurrenceDate) AS [MinDate]
    ,pov2.CalendarYearMonth
    ,COUNT(*) AS [CampusCount]
FROM
    [personOptimizeV2] pov2
   -- INNER JOIN [AnalyticsSourceDate] asd ON asd.[Date] = pov2.OccurrenceDate
WHERE
    pov2.[RN] = 1
GROUP BY
    pov2.PrimaryCampusId
    --,pov2.OccurrenceDate
    ,pov2.CalendarYearMonth
  --  ,asd.CalendarYear
ORDER BY
    pov2.CalendarYearMonth DESC
 --   ,asd.CalendarMonth DESC
    ,pov2.PrimaryCampusId