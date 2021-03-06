WITH AgeData AS ( 
    SELECT
        TOP 10000000
        p.[Gender],
        DATEDIFF(YEAR, p.[BirthDate], GETDATE()) AS [Age]
    FROM
        [Person] p
    WHERE
        [BirthDate] IS NOT NULL
        AND p.[BirthYear] < YEAR(GETDATE()+1)
        AND p.[BirthYear] > 1908
        AND p.[IsDeceased] = 0
        AND p.[PrimaryCampusId] NOT IN (6,9)
        AND p.[PrimaryCampusId] IS NOT NULL
),
GroupAge AS
(
    SELECT
        [Age],
        CASE
            WHEN AGE < 5 THEN '0 - 4'
            WHEN AGE BETWEEN 5 AND 9 THEN '05 - 9'
            WHEN AGE BETWEEN 10 AND 14 THEN '10 - 14'
            WHEN AGE BETWEEN 15 AND 19 THEN '15 - 19'
            WHEN AGE BETWEEN 20 AND 24 THEN '20 - 24'
            WHEN AGE BETWEEN 25 AND 29 THEN '25 - 29'
            WHEN AGE BETWEEN 30 AND 34 THEN '30 - 34'
            WHEN AGE BETWEEN 35 AND 39 THEN '35 - 39'
            WHEN AGE BETWEEN 40 AND 44 THEN '40 - 44'
            WHEN AGE BETWEEN 45 AND 49 THEN '45 - 49'
            WHEN AGE BETWEEN 50 AND 54 THEN '50 - 54'
            WHEN AGE BETWEEN 55 AND 59 THEN '55 - 59'
            WHEN AGE BETWEEN 60 AND 64 THEN '60 - 64'
            WHEN AGE BETWEEN 65 AND 69 THEN '65 - 69'
            WHEN AGE BETWEEN 70 AND 74 THEN '70 - 74'
            WHEN AGE BETWEEN 75 AND 79 THEN '75 - 79'
            WHEN AGE BETWEEN 80 AND 84 THEN '80 - 84'
            WHEN AGE BETWEEN 85 AND 89 THEN '85 - 89'
            WHEN AGE BETWEEN 90 AND 99 THEN '90 - 99'
            WHEN AGE > 99 THEN '99+'
            ELSE 'Invalid Birthdate'
        END AS [Age Groups]
    FROM
        AgeData
)

SELECT
    COUNT(*) AS 'Age Range Count',
    [Age Groups]
FROM
    GroupAge
GROUP BY
    [Age Groups]
ORDER BY
    [Age Groups] desc
    