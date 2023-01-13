SELECT
    TOP 1000*
FROM
    [Person] p
WHERE
    p.Email IS NOT NULL
    AND (p.Email LIKE '%baysideonline.com') --(p.Email LIKE '%baysideonine.com' OR p.Email LIKE '%baysideonlin.com')
ORDER BY
    p.Id