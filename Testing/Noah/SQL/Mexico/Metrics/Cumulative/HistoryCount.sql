SELECT
    COUNT(*) AS [HistoryCount]
    ,x.CreatedDate
  --  ,x.CreatedWeek
   -- ,x.CreatedYear
  --  ,MAX(x.CreatedDate) As [MaxDateInWeek]
   -- ,CAST(x.CreatedYear AS VARCHAR)+ '/' + CAST(x.CreatedWeek AS VARCHAR) AS [CreatedChunk]
FROM
    (SELECT
        TOP 100000000
        h.Id
       -- ,h.*
        ,CAST(h.CreatedDateTime AS DATE) AS [CreatedDate]
       -- ,DATEPART(year, h.CreatedDateTime) AS [CreatedYear]
      --  ,DATEPART(week, h.CreatedDateTime) AS [CreatedWeek]
    FROM
        [History] h
    WHERE
        h.EntityTypeId = 15
        --AND CAST(h.CreatedDateTime AS DATE) = '2022-01-23'
    ORDER BY
        h.CreatedDateTime DESC
    ) x
GROUP BY
    CreatedDate--CreatedWeek, CreatedYear
HAVING
    COUNT(*) > 20000
--ORDER BY
--    COUNT(*) DESC


DECLARE @today DATETIME = GETDATE();
DECLARE @yesterday DATE = DATEADD(day, -1, @today);

SELECT
    COUNT(*)
FROM
    [History] h
WHERE
    h.[EntityTypeId] = 15
    AND CAST(h.[CreatedDateTime] AS DATE) = CAST(@yesterday AS DATE)


/*
29391	2022-11-30
17915	2022-11-29
10562	2022-11-28
17165	2022-11-27
4992	2022-11-26
5393	2022-11-25
2000	2022-11-24
14156	2022-11-23
14311	2022-11-22
7503	2022-11-21
14791	2022-11-20
4131	2022-11-19
4993	2022-11-18
16928	2022-11-17
6307	2022-11-16
18668	2022-11-15
21435	2022-11-14
12309	2022-11-13
3499	2022-11-12
5040	2022-11-11
19715	2022-11-10
7992	2022-11-09
38455	2022-11-08
12131	2022-11-07
18187	2022-11-06
7360	2022-11-05
10763	2022-11-04
51021	2022-11-03
15309	2022-11-02
43273	2022-11-01