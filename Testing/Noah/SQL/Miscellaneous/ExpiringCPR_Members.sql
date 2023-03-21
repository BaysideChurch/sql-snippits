/*
Finds all people with "CPR Certificate Expires" Attribute(Id: 35639)
where the expiration date is within 90 days from today.
*/
SELECT
    x.[PersonId]
FROM
(SELECT
    p.Id As [PersonId]
    ,av.[Value]
    ,CASE WHEN DATEADD(dd, -90, CAST(CONVERT(DATETIMEOFFSET, av.Value, 127) AS DATETIME)) <= GETDATE() THEN 1 ELSE 0 END as [WillExpireSoon]
FROM
    [AttributeValue] av
    INNER JOIN [GroupMember] gm ON gm.Id = av.EntityId
    INNER JOIN [Person] p ON p.Id = gm.PersonId
WHERE
    av.AttributeId = 35639
) x
WHERE
    x.[WillExpireSoon] = 1