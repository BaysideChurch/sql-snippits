-- Bayside Contribution Weekly Report
DECLARE @EventRegistrationTransactionId INT,
    @SimpleDonationGatewayId INT;
SET @EventRegistrationTransactionId = 54;
SET @SimpleDonationGatewayId = 4;

WITH batch_entries_CTE(Fund,Event,OneTime,Recurring,Amount,Fees,Net,FundId,StartDate,EndDate)
AS
(
    SELECT
        Fund,
        Event,
        SUM (CASE WHEN ScheduledTransactionId IS NULL THEN Amount ELSE 0 END) AS [OneTime],
        SUM (CASE WHEN ScheduledTransactionId IS NOT NULL THEN Amount ELSE 0 END) AS [Recurring],
        SUM (Amount) AS [Amount],
        SUM (Fees) AS [Fees],
        SUM (Net) AS [Net],
        FundId,
        StartDate,
        EndDate
    FROM (
        SELECT
            a.Name AS [Fund],
            CASE
                WHEN g.Name is not null THEN g.Name ELSE 'Contribution'
            END AS [Event],
            td.Amount AS [Amount],
            td.FeeAmount AS [Fees],
            td.Amount-td.FeeAmount AS [Net],
            t.ScheduledTransactionId,
            a.Id AS [FundId],
            @StartDate AS [StartDate],
            @EndDate AS [EndDate]
        FROM
            FinancialTransaction t
            LEFT JOIN FinancialTransactionDetail td ON t.Id = td.TransactionId
            LEFT JOIN [GroupMember] gm ON gm.[Id] = td.[EntityId] AND td.EntityTypeId= 90
            LEFT JOIN [Group] g ON g.[Id] = gm.[GroupId]
            LEFT JOIN FinancialAccount a ON td.AccountId = a.Id
        WHERE
            t.FinancialGatewayId = @SimpleDonationGatewayId
            AND t.TransactionTypeValueId != @EventRegistrationTransactionId
            AND TransactionDateTime >= CAST(CONVERT(datetimeoffset,@StartDate,127) AS DATE)
            AND TransactionDateTime < DATEADD (day, 1,CAST(CONVERT(datetimeoffset,@EndDate,127) AS DATE))
        )[a]
    GROUP BY Fund, FundId, Event, StartDate, EndDate
)

SELECT
*
FROM (
  SELECT *
  FROM batch_entries_CTE

  UNION ALL

  SELECT
    null,                                   -- Fund
    null,                                   -- Event
    sum(CAST(OneTime AS decimal(12,2))),    -- OneTime
    sum(CAST(Recurring AS decimal(12,2))),  -- Recurring
    sum(CAST(Amount AS decimal(12,2))),     -- Amount
    sum(CAST(Fees AS decimal(12,2))),       -- Fees
    sum(CAST(Net AS decimal(12,2))),        -- Net
    null,                                   -- FundId
    null,                                   -- StartDate
    null                                    -- EndDate
  FROM batch_entries_CTE
) [presort]
ORDER BY Amount asc