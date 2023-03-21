DECLARE @today DATETIME = GETDATE();
DECLARE @endofYear DATETIME = CAST('12/31/2022' AS DATETIME);
DECLARE @currentYear INT = DATEPART(year, @today);

WITH x AS (
    SELECT
        ROW_NUMBER() OVER (PARTITION BY p.Id ORDER BY ft.CreatedDateTime) AS [RowId]
        ,p.Id AS [PersonId]
        ,CAST(ft.TransactionDateTime AS DATE) AS [TransactionDate]
        ,DATEDIFF(dd, '01/01/2022', ft.TransactionDateTime) AS [DayInYear]
    FROM
        FinancialTransaction ft
        INNER JOIN FinancialTransactionDetail ftd ON ft.Id = ftd.TransactionId
        INNER JOIN PersonAlias pa ON ft.AuthorizedPersonAliasId = pa.Id
        INNER JOIN Person p ON pa.PersonId = p.Id
    WHERE
        DATEPART(year, ft.TransactionDateTime) = (@currentYear - 1)
        AND ft.TransactionDateTime <= @endOfYear --@today
        AND ft.TransactionTypeValueId = 53
),y AS (
    SELECT
        ROW_NUMBER() OVER (PARTITION BY p.Id ORDER BY ft.CreatedDateTime) AS [RowId]
        ,p.Id AS [PersonId]
        ,CAST(ft.TransactionDateTime AS DATE) AS [TransactionDate]
        ,DATEDIFF(dd, '01/01/2023', ft.TransactionDateTime) AS [DayInYear]
    FROM
        FinancialTransaction ft
        INNER JOIN FinancialTransactionDetail ftd ON ft.Id = ftd.TransactionId
        INNER JOIN PersonAlias pa ON ft.AuthorizedPersonAliasId = pa.Id
        INNER JOIN Person p ON pa.PersonId = p.Id
    WHERE
        DATEPART(year, ft.TransactionDateTime) = (@currentYear)
        AND ft.TransactionDateTime <= @today
        AND ft.TransactionTypeValueId = 53
), prevYear AS (
    SELECT
        COUNT(x.PersonId) AS [UniquePersonCount]
        ,SUM(COUNT(x.PersonId)) OVER (ORDER BY x.TransactionDate) AS [CumulativeUniquePersonCount]
        ,x.TransactionDate
        ,x.DayInYear
    FROM
        (
            SELECT PersonId, TransactionDate, DayInYear
            FROM x
            WHERE x.RowId = 1
            GROUP BY TransactionDate, PersonId, DayInYear
        ) x
    GROUP BY
        x.TransactionDate, x.DayInYear
), currentYTD AS (
    SELECT
        COUNT(x.PersonId) AS [UniquePersonCount]
        ,SUM(COUNT(x.PersonId)) OVER (ORDER BY x.TransactionDate) AS [CumulativeUniquePersonCount]
        ,x.TransactionDate
        ,x.DayInYear
    FROM
        (
            SELECT PersonId, TransactionDate, DayInYear
            FROM y
            WHERE y.RowId = 1
            GROUP BY TransactionDate, PersonId, DayInYear
        ) x
    GROUP BY
        x.TransactionDate, x.DayInYear
)

--SELECt * FROM x WHERE x.RowId = 1 ORDER BY x.DayInYear;

SELECT
    COALESCE(cytd.[DayInYear], prev.DayInYear) AS [DayInYear]
    ,prev.CumulativeUniquePersonCount AS [prevCumulative]
    ,(CAST(prev.CumulativeUniquePersonCount AS decimal) / 10371) AS [prevPercent]
    ,COALESCE((CAST(cytd.CumulativeUniquePersonCount AS decimal) / 10371), 0) AS [cytdPercent]
    ,cytd.CumulativeUniquePersonCount AS [CurrentCumulative]
    ,cytd.CumulativeUniquePersonCount - prev.CumulativeUniquePersonCount AS [DifferenceYtoY]
    ,cytd.[TransactionDate]
    ,prev.TransactionDate
FROM
    [currentYTD] cytd
    RIGHT JOIN [prevYear] prev ON prev.DayInYear = cytd.DayInYear
ORDER BY
    COALESCE(cytd.[DayInYear], prev.DayInYear)
--    prev.DayInYear

-- new 0.0210045
-- old 0.0198042