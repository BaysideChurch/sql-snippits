SELECT
    p.[Id]
/*    ,ul.UserName
    ,ul.CreatedDateTime
   ,(SELECT MAX(ul1.CreatedDateTime)
        FROM UserLogin ul1
        WHERE PersonId = p.Id
        AND EntityTypeId != 902) As [OtherLoginCreated]
        */
FROM
    Person p
    INNER JOIN UserLogin ul ON p.Id = ul.PersonId
WHERE
    ul.EntityTypeId = 902
    AND ul.CreatedDateTime > (
        SELECT MAX(ul1.CreatedDateTime)
        FROM UserLogin ul1
        WHERE PersonId = p.Id
        AND EntityTypeId != 902
    )
GROUP BY
    p.Id
HAVING
    COUNT(*) > 0;