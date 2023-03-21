SELECT
	--x.*
	JSON_VALUE(x.[Description], '$.LoginInput') As [LoginInput]
    ,JSON_VALUE(x.[Description], '$.PhoneNumber') As [PhoneNumber]
    ,JSON_VALUE(x.[Description], '$.Email') As [Email]
    ,JSON_VALUE(x.[Description], '$.IPAddress') As [IP Address]
    ,JSON_QUERY(x.[Description], '$.Person') As [PersonList]
    ,COALESCE( JSON_VALUE(x.[Description], '$.Person[0][0].PersonId'),COALESCE(JSON_VALUE(x.[Description], '$.Person[0].PersonId'), JSON_VALUE(x.[Description], '$.Person[0][0]'))) As [PersonOne]
    ,JSON_VALUE(x.[Description], '$.MatchCount') As [MatchCount]
    ,JSON_VALUE(x.[Description], '$.Description') As [Description]
    ,JSON_VALUE(x.[Description], '$.Verification') As [Verification]
    ,JSON_VALUE(x.[Description], '$.ReturnUrl') As [ReturnUrl]
    ,JSON_VALUE(x.[Description], '$.DecodedUrl') As [DecodedUrl]
    ,JSON_VALUE(x.[Description], '$.RedirectUrl') As [RedirectUrl]
    ,x.[CreatedDateTime]
FROM
(
	SELECT
		pe.*
	FROM
		[ExceptionLog] pe
		INNER JOIN [ExceptionLog] ce ON ce.[ParentId] = pe.[Id]
	WHERE
		ce.[Description] LIKE 'BccLogin Debug'
		AND ce.[CreatedDateTime] >= '12/5/2022'
		AND ce.[Id] >= 2519445
) x
ORDER BY
    x.[CreatedDateTime] DESC