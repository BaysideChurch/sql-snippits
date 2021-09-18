-- Bayside Weekly Detail Report
/* Commented by LBT, Sparkability, 8/13/2020 13:50PST
DECLARE @startDate DATETIME, @endDate DATETIME
SET @startDate = '2020-08-01'
SET @endDAte = '2020-08-11'
SET @FundId=231
SET @EventId=6;
*/
DECLARE @SimpleDonationGatewayId INT;
SET @SimpleDonationGatewayId = 4;

SELECT
    (p.FirstName+' '+p.LastName) AS [Name],
    CAST(TransactionDateTime AS DATE)[TransactionDate],
    a.Name AS [Fund],
    g.Name AS [TripName],
    dv.Value AS [CurrencyType],
    td.Amount,
    td.FeeAmount,
    (td.Amount-td.FeeAmount) AS [Net],
    t.Id
FROM
    FinancialTransaction t
    INNER JOIN FinancialTransactionDetail td ON t.Id = td.TransactionId
    LEFT JOIN EntityType et ON et.Id = td.EntityTypeId AND td.EntityTypeId = 258
    LEFT JOIN Registration re ON re.Id = td.EntityId
    LEFT JOIN RegistrationInstance ri ON ri.Id = re.RegistrationInstanceId
    INNER JOIN FinancialAccount a ON td.AccountId = a.Id
    INNER JOIN PersonAlias PA ON t.AuthorizedPersonAliasId = PA.Id
    INNER JOIN Person p ON PA.PersonId = p.Id
    LEFT JOIN FinancialPaymentDetail fpd ON fpd.Id=t.FinancialPaymentDetailId
    LEFT JOIN DefinedValue dv ON dv.Id=fpd.CurrencyTypeValueId
    LEFT JOIN [GroupMember] gm ON gm.[Id] = td.[EntityId] AND td.EntityTypeId= 90
    LEFT JOIN [Group] g ON g.[Id] = gm.[GroupId]
WHERE
    t.FinancialGatewayId = @SimpleDonationGatewayId
    AND td.AccountId=@FundId
    AND TransactionDateTime >= CAST(CONVERT(datetimeoffset,@StartDate,127) AS DATE)
    AND TransactionDateTime < DATEADD (day, 1,CAST(CONVERT(datetimeoffset,@EndDate,127) AS DATE)) 
