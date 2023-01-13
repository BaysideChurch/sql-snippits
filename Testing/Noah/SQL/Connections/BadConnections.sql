
--Find all opportunities per connection type, and the statuses
WITH all_opportunities AS (
	SELECT
		TOP 25
		ct.[Id] AS [Connection Type Id]
		,MAX(ct.[Name]) AS [Connection Type]
		,STRING_AGG(co.[Name] + '[' + CONVERT(NVARCHAR(max), co.[Id]) + ']', ',') AS [Connection Opportunities]
		,(SELECT TOP 1
			STRING_AGG(cs.[Name] + '(' + CONVERT(NVARCHAR(max), cs.[Id]) + ')', ',') 
			FROM
				[ConnectionStatus] cs
			WHERE
				cs.[ConnectionTypeId] = ct.[Id]
			)AS [Connection Statuses]
	FROM
		[ConnectionOpportunity] co
		INNER JOIN [ConnectionType] ct On ct.[Id] = co.[ConnectionTypeId]
	GROUP BY
		ct.[Id]
),
--Find the connection requests that have incorrect statuses
requests_with_bad_status AS (
	SELECT
		TOP 100
		cr.*
	FROM
		[ConnectionRequest] cr
		INNER JOIN [ConnectionStatus] cs ON cs.[Id] = cr.[ConnectionStatusId]
	WHERE
		NOT EXISTS (
			SELECT 1
			FROM
				[ConnectionOpportunity] co
				INNER JOIN [ConnectionType] ct ON ct.[Id] = co.[ConnectionTypeId]
			WHERE
				cs.[ConnectionTypeId] = ct.[Id]
				AND cr.[ConnectionOpportunityId] = co.[Id]
			)
),
--Find the activity of the records that have incorrect statuses
activities_with_bad_status AS (
	SELECT
		TOP 100
		cat.[Name]
		,cra.*
	FROM
		[ConnectionRequestActivity] cra
		INNER JOIN [ConnectionActivityType] cat ON cra.[ConnectionActivityTypeId] = cat.[Id]
	WHERE
		cra.[ConnectionActivityTypeId] = 5
		AND cra.[ConnectionRequestId] IN (
		SELECT
		TOP 100 cr.[Id]
	FROM
		[ConnectionRequest] cr
		INNER JOIN [ConnectionStatus] cs ON cs.[Id] = cr.[ConnectionStatusId]
	WHERE
		NOT EXISTS (
			SELECT 1
			FROM
				[ConnectionOpportunity] co
				INNER JOIN [ConnectionType] ct ON ct.[Id] = co.[ConnectionTypeId]
			WHERE
				cs.[ConnectionTypeId] = ct.[Id]
				AND cr.[ConnectionOpportunityId] = co.[Id]
			)
		)
)

SELECT
	cra.[Id]
	,cr.[ConnectionOpportunityId]
	,cra.[ConnectionOpportunityId]
FROM
	[ConnectionRequestActivity] cra
	INNER JOIN [ConnectionRequest] cr ON cr.[Id] = cra.[ConnectionRequestId]
	INNER JOIN [ConnectionOpportunity] co ON co.[Id] = cra.[ConnectionOpportunityId]
WHERE
	cr.[ConnectionOpportunityId] <> cra.[ConnectionOpportunityId]