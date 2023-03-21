DECLARE @StartDate DATETIME2 ='2020-02-14 00:00:00';
DECLARE @EndDate DATETIME2 ='2023-02-26 23:59:59.9990000';

WITH Attendance_CTE AS (
    SELECT 
        a.Id AS AttendanceId 
        ,a.PersonAliasId
        ,ao.OccurrenceDate
        ,p.BirthDate
        ,p.PrimaryCampusId
        ,p.GraduationYear
        ,pa.PersonId
        ,a.CampusId
    FROM
        Attendance a
        INNER JOIN AttendanceOccurrence ao ON a.OccurrenceId = ao.Id
        INNER JOIN PersonAlias pa ON a.PersonAliasId = pa.Id
        INNER JOIN Person p ON pa.PersonId = p.Id
        INNER JOIN Campus c ON c.Id = a.CampusId
    WHERE
        ao.OccurrenceDate BETWEEN @StartDate AND @EndDate
        AND p.GraduationYear IS NOT NULL
        AND p.BirthDate IS NOT NULL
),
Age_CTE AS (
    SELECT 
        AttendanceId,
        BirthDate,
        OccurrenceDate,
        (CASE
            -- Year 0001 is a special year, which denotes no year selected therefore we shouldn't calculate the age.
            WHEN BirthDate IS NOT NULL AND DATEPART(year, BirthDate) > 1
                THEN DATEDIFF(year, BirthDate, OccurrenceDate)
                     - CASE
                           WHEN MONTH(BirthDate) > MONTH(OccurrenceDate) OR (MONTH(BirthDate) = MONTH(OccurrenceDate) AND DAY(BirthDate) > DAY(OccurrenceDate))
                               THEN 1
                           ELSE 0
                       END
            ELSE NULL
        END) AS AgeAtOccurrence,
        [dbo].[ufnCrm_GetAge]([BirthDate]) AS CurrentAge
    FROM Attendance_CTE
), attendanceData AS (
SELECT 
    a.PersonId 
    ,a.CampusId
    --,ac.OccurrenceDate
    ,ac.AgeAtOccurrence
    ,ac.CurrentAge
    ,a.GraduationYear
    ,MAX(a.BirthDate) AS [BirthDate]
    ,MAX(a.PrimaryCampusId) As [PrimaryCampusId]
    ,asd.[SundayDate]
    ,COUNT(*) AS [AttendanceInWeek]
FROM
    Age_CTE ac
    INNER JOIN Attendance_CTE a ON ac.AttendanceId = a.AttendanceId
    INNER JOIN [AnalyticsSourceDate] asd ON asd.[Date] = a.OccurrenceDate
WHERE
    ac.AgeAtOccurrence < 10-- AND p.GradeOffset < 5
GROUP BY
    a.PersonId, a.CampusId, asd.SundayDate
    ,ac.AgeAtOccurrence, ac.CurrentAge, a.GraduationYear
)

--SELECt * FROM [attendanceData] ad ORDER BY [SundayDate] DESC, ad.CampusId ASC


SELECT
    COUNT(*) AS [AttendanceNumbers]
    ,ad.[SundayDate]
    ,ad.CampusId
FROM
    [attendanceData] ad
GROUP BY
    ad.CampusId, ad.SundayDate
ORDER BY
    ad.SundayDate DESC
    ,ad.CampusId