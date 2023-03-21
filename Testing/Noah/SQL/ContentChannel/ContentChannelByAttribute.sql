DECLARE @AttributeKey VARCHAR(50) = 'EmailFromName';
DECLARE @SearchValue VARCHAR(50) = 'Bayside Church';

SELECT
    cci.Id
    ,cci.ContentChannelId
    ,cci.ContentChannelTypeId
    ,cci.Title
    ,cci.Status
FROM
    [ContentChannelItem] cci
WHERE
    cci.ContentChannelId = 39
    AND EXISTS(
        SELECT
            1
        FROM
            [AttributeValue] av
            INNER JOIN [Attribute] a ON a.Id = av.AttributeId
        WHERE
            av.EntityId = cci.Id
            AND a.EntityTypeId = 208
            AND 1 = (CASE WHEN a.[Key] = @AttributeKey AND av.Value LIKE @SearchValue THEN 1 ELSE 0 END)
    )

SELECT
    TOP 100*
FROM
    [EntityType] et
WHERE
    et.Name LIKE '%ContentChannel%'