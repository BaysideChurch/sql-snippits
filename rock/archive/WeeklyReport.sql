-- Bayside Weekly Report
/* Commented by LBT, Sparkability, 8/13/2020 13:50PST
DECLARE @startDate DATETIME, @endDate DATETIME
SET @startDate = '2020-08-01'
SET @endDAte = '2020-08-11';
*/
WITH batch_entries_CTE(Fund,Event,OneTime,Recurring,Amount,Fees,Net,FundId,EventId,TripId,StartDate,EndDate)
AS
(
SELECT
Fund,
Event,
SUM (CASE WHEN ScheduledTransactionId IS NULL THEN Amount ELSE 0 END) [OneTime],
SUM (CASE WHEN ScheduledTransactionId IS NOT NULL THEN Amount ELSE 0 END) [Recurring],
SUM (Amount) [Amount],
SUM (Fees) [Fees],
SUM (Net) [Net],
FundId,
EventId,
TripId,
StartDate,
EndDate
FROM (
    SELECT
      a.Name [Fund],
      CASE WHEN t.TransactionTypeValueId = 54 THEN CONCAT('Registration - ',ri.Name) WHEN t.TransactionTypeValueId != 54 AND g.Name is not null THEN g.Name ELSE 'Contribution' END [Event],
      td.Amount [Amount],
      td.FeeAmount [Fees],
      td.Amount-td.FeeAmount [Net],
      t.ScheduledTransactionId,
      a.Id [FundId],
      ri.Id [EventId],
      g.Id [TripId],
      @StartDate [StartDate],
      @EndDate [EndDate]
    FROM FinancialTransaction t
    INNER JOIN FinancialTransactionDetail td
      ON t.Id = td.TransactionId
    LEFT JOIN EntityType et
      ON et.Id = td.EntityTypeId
      AND td.EntityTypeId = 258
    LEFT JOIN Registration re
        ON re.Id = td.EntityId
    LEFT JOIN RegistrationInstance ri
      ON ri.Id = re.RegistrationInstanceId
    LEFT JOIN [GroupMember] gm ON gm.[Id] = td.[EntityId] AND td.EntityTypeId= 90
    LEFT JOIN [Group] g ON g.[Id] = gm.[GroupId]



    INNER JOIN FinancialAccount a
      ON td.AccountId = a.Id
    WHERE t.FinancialGatewayId = 4
      AND TransactionDateTime >= CAST(CONVERT(datetimeoffset,@startDate,127) AS DATE)
      AND TransactionDateTime < DATEADD (day, 1,CAST(CONVERT(datetimeoffset,@endDate,127) AS DATE)) 
    )[a]
  GROUP BY Fund, FundId, Event, EventId, TripId, StartDate, EndDate
)

SELECT
*
FROM (
  SELECT *
  FROM batch_entries_CTE

  UNION ALL

  SELECT
  null,
  null,
  sum(CAST(OneTime AS decimal(12,2))),
  sum(CAST(Recurring AS decimal(12,2))),
  sum(CAST(Amount AS decimal(12,2))),
  sum(CAST(Fees AS decimal(12,2))),
  sum(CAST(Net AS decimal(12,2))),
  null,
  null,
  null,
  null,
  null
  from batch_entries_CTE
) [presort]
ORDER BY Amount asc