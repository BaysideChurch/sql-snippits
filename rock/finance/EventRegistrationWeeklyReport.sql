WITH batch_entries_CTE (Event,Ministry,Campus,OneTime,Recurring,Amount,Fees,Net,RegistrationInstanceId,StartDate,EndDate)
AS
(
    SELECT
        Event,
        SUM (CASE WHEN ScheduledTransactionId IS NULL THEN Amount ELSE 0 END) [OneTime],
        SUM (CASE WHEN ScheduledTransactionId IS NOT NULL THEN Amount ELSE 0 END) [Recurring],
        SUM (Amount) [Amount],
        SUM (Fees) [Fees],
        SUM (Net) [Net],
        RegistrationInstanceId,
        StartDate,
        EndDate
    FROM 
        (
            SELECT
                ri.Name [Event],
                c.[Name] [Campus],
                ministry.[Value] [Minstry],
                td.Amount [Amount],
                td.FeeAmount [Fees],
                td.Amount-td.FeeAmount [Net],
                t.ScheduledTransactionId,
                ri.Id [RegistrationInstanceId],
                GETDATE() [StartDate],
                GETDATE() [EndDate]
            FROM 
                FinancialTransaction t
                INNER JOIN [FinancialTransactionDetail] td ON t.Id = td.TransactionId
                LEFT JOIN [Registration] re ON re.Id = td.EntityId
                LEFT JOIN [RegistrationInstance] ri ON ri.Id = re.RegistrationInstanceId
                LEFT JOIN [EventItemOccurrenceGroupMap] eicgm ON eicgm.[RegistrationInstanceId] = ri.[Id]
                LEFT JOIN [EventItemOccurrence] eic ON eic.[Id] = eicgm.[EventItemOccurrenceId]
                LEFT JOIN [Campus] c ON c.[Id] = eic.[CampusId]
                LEFT JOIN [AttributeValue] av ON eicgm.[Id] = av.[EntityId] AND av.[AttributeId] = 17906
                LEFT JOIN [DefinedValue] ministry ON ministry.[Guid] = av.[Value]
            WHERE 
                t.[FinancialGatewayId] = 4 AND
                t.[TransactionTypeValueId] = 54 AND
                [TransactionDateTime] >= CAST(CONVERT(datetimeoffset,GETDATE(),127) AS DATE) AND
                [TransactionDateTime] < DATEADD (day, 1,CAST(CONVERT(datetimeoffset,GETDATE(),127) AS DATE))
        ) [a]
    GROUP BY Event, Ministry, Campus, RegistrationInstanceId, StartDate, EndDate
)

SELECT
    *
FROM 
    (
        SELECT 
            *
        FROM 
            batch_entries_CTE

        UNION ALL

        SELECT
            null,
            null,
            null,
            sum(CAST(OneTime AS decimal(12,2))),
            sum(CAST(Recurring AS decimal(12,2))),
            sum(CAST(Amount AS decimal(12,2))),
            sum(CAST(Fees AS decimal(12,2))),
            sum(CAST(Net AS decimal(12,2))),
            null,
            null,
            null
        FROM 
            batch_entries_CTE
    ) [presort]
ORDER BY 
    Amount ASC