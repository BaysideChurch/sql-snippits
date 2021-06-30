WITH AgeData AS ( 
    SELECT
        TOP 10000000
        DATEDIFF(YEAR, p.[BirthDate], GETDATE()) AS [Age]--,
        --COUNT(case when p.[Gender]=1 then 1 end) AS 'Male Count',
        --COUNT(case when p.[Gender]=2 then 1 end) AS 'Female Count'
        --COUNT([Age])
    FROM
        [Person] p
    WHERE
        [BirthDate] IS NOT NULL AND
        --p.[BirthYear] < DATEPART(YEAR, GETDATE()+1) AND
        p.[BirthYear] < YEAR(GETDATE()+1) AND
        p.[BirthYear] > 1908 AND
        p.[IsDeceased] = 0 --AND
        --p.[PrimaryCampusId] IS NOT NULL
    --GROUP BY
      --  p.[Gender]
),
GroupAge AS
(
    SELECT
        [Age],--, 'Male Count', 'Female Count',
        CASE
            WHEN AGE < 10 THEN '0 - 9'
            WHEN AGE BETWEEN 10 AND 19 THEN '10 - 19'
            WHEN AGE BETWEEN 20 AND 29 THEN '20 - 29'
            WHEN AGE BETWEEN 30 AND 39 THEN '30 - 39'
            WHEN AGE BETWEEN 40 AND 49 THEN '40 - 49'
            WHEN AGE BETWEEN 50 AND 59 THEN '50 - 59'
            WHEN AGE BETWEEN 60 AND 69 THEN '60 - 69'
            WHEN AGE BETWEEN 70 AND 79 THEN '70 - 79'
            WHEN AGE BETWEEN 80 AND 89 THEN '80 - 89'
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
    