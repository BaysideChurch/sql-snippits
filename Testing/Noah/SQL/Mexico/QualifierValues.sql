WITH list_items AS (
    SELECT
        x.QualifierId
        ,JSON_VALUE(x.Config1, '$.Key') AS [ConfigKey1]
        ,JSON_VALUE(x.Config1, '$.Value') AS [ConfigValue1]
        ,JSON_VALUE(x.Config2, '$.Key') AS [ConfigKey2]
        ,JSON_VALUE(x.Config2, '$.Value') AS [ConfigValue2]
        ,JSON_VALUE(x.Config3, '$.Key') AS [ConfigKey3]
        ,JSON_VALUE(x.Config3, '$.Value') AS [ConfigValue3]
    FROM
        (SELECT
            aq.Id AS [QualifierId]
        ,JSON_QUERY(aq.Value, '$[0]') As [Config1]
        ,JSON_QUERY(aq.Value, '$[1]') As [Config2]
        ,JSON_QUERY(aq.Value, '$[2]') As [Config3]
        FROM
            [AttributeQualifier] aq
        WHERE
            aq.AttributeId IN (14468, 14466, 20943)
            AND aq.[Key] = 'listItems'
        ) x
), qualifierValues AS (
    SELECT
        z.*
    FROM
        (SELECT
            y.[QualifierId]
            ,y.[ConfigKey1] As [Key]
            ,y.[ConfigValue1] As [Value]
            ,1 As [Order]
        FROM
            list_items y
        UNION ALL
        SELECT
            y.[QualifierId]
            ,y.[ConfigKey2] As [Key]
            ,y.[ConfigValue2] As [Value]
            ,2 As [Order]
        FROM
            list_items y
        UNION ALL
        SELECT
            y.[QualifierId]
            ,y.[ConfigKey3] As [Key]
            ,y.[ConfigValue3] As [Value]
            ,3 As [Order]
        FROM
            list_items y
        ) z
    WHERE
        z.Value IS NOT NULL
)

SELECT * FROM qualifierValues;