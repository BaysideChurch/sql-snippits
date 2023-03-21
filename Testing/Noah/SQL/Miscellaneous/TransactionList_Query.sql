SELECT 
    [Project3].[Id1] AS [Id], 
    [Project3].[Id] AS [Id1], 
    [Project3].[BatchId] AS [BatchId], 
    [Project3].[TransactionTypeValueId] AS [TransactionTypeValueId], 
    [Project3].[ScheduledTransactionId] AS [ScheduledTransactionId], 
    [Project3].[AuthorizedPersonAliasId] AS [AuthorizedPersonAliasId], 
    [Project3].[C1] AS [C1], 
    [Project3].[FutureProcessingDateTime] AS [FutureProcessingDateTime], 
    [Project3].[SourceTypeValueId] AS [SourceTypeValueId], 
    [Project3].[C4] AS [C2], 
    [Project3].[TransactionCode] AS [TransactionCode], 
    [Project3].[ForeignKey] AS [ForeignKey], 
    [Project3].[Status] AS [Status], 
    [Project3].[SettledDate] AS [SettledDate], 
    [Project3].[SettledGroupId] AS [SettledGroupId], 
    [Project3].[C2] AS [C3], 
    [Project3].[CreditCardTypeValueId] AS [CreditCardTypeValueId], 
    [Project3].[CurrencyTypeValueId] AS [CurrencyTypeValueId], 
    [Project3].[ForeignCurrencyCodeValueId] AS [ForeignCurrencyCodeValueId], 
    [Project3].[FinancialGatewayId] AS [FinancialGatewayId], 
    [Project3].[IsReconciled] AS [IsReconciled], 
    [Project3].[IsSettled] AS [IsSettled], 
    [Project3].[NonCashAssetTypeValueId] AS [NonCashAssetTypeValueId], 
    [Project3].[ProcessedDateTime] AS [ProcessedDateTime], 
    [Project3].[ShowAsAnonymous] AS [ShowAsAnonymous], 
    [Project3].[StatusMessage] AS [StatusMessage], 
    [Project3].[C3] AS [C4], 
    [Project3].[AccountId] AS [AccountId], 
    [Project3].[Amount] AS [Amount], 
    [Project3].[EntityId] AS [EntityId], 
    [Project3].[EntityTypeId] AS [EntityTypeId]
    FROM ( SELECT 
        [Limit1].[Id] AS [Id], 
        [Limit1].[AuthorizedPersonAliasId] AS [AuthorizedPersonAliasId], 
        [Limit1].[ShowAsAnonymous] AS [ShowAsAnonymous], 
        [Limit1].[BatchId] AS [BatchId], 
        [Limit1].[FinancialGatewayId] AS [FinancialGatewayId], 
        [Limit1].[FutureProcessingDateTime] AS [FutureProcessingDateTime], 
        [Limit1].[TransactionCode] AS [TransactionCode], 
        [Limit1].[TransactionTypeValueId] AS [TransactionTypeValueId], 
        [Limit1].[SourceTypeValueId] AS [SourceTypeValueId], 
        [Limit1].[ScheduledTransactionId] AS [ScheduledTransactionId], 
        [Limit1].[ProcessedDateTime] AS [ProcessedDateTime], 
        [Limit1].[IsSettled] AS [IsSettled], 
        [Limit1].[SettledGroupId] AS [SettledGroupId], 
        [Limit1].[SettledDate] AS [SettledDate], 
        [Limit1].[IsReconciled] AS [IsReconciled], 
        [Limit1].[Status] AS [Status], 
        [Limit1].[StatusMessage] AS [StatusMessage], 
        [Limit1].[NonCashAssetTypeValueId] AS [NonCashAssetTypeValueId], 
        [Limit1].[ForeignCurrencyCodeValueId] AS [ForeignCurrencyCodeValueId], 
        [Limit1].[ForeignKey] AS [ForeignKey], 
        [Limit1].[Id1] AS [Id1], 
        [Limit1].[CurrencyTypeValueId] AS [CurrencyTypeValueId], 
        [Limit1].[CreditCardTypeValueId] AS [CreditCardTypeValueId], 
        [Limit1].[C1] AS [C1], 
        [Extent4].[AccountId] AS [AccountId], 
        [Extent4].[Amount] AS [Amount], 
        [Extent4].[EntityTypeId] AS [EntityTypeId], 
        [Extent4].[EntityId] AS [EntityId], 
        [Limit1].[C2] AS [C2], 
        CASE WHEN ([Extent4].[TransactionId] IS NULL) THEN CAST(NULL AS int) ELSE 1 END AS [C3], 
        [Limit1].[C3] AS [C4]
        FROM   (SELECT [Project2].[Id] AS [Id], [Project2].[AuthorizedPersonAliasId] AS [AuthorizedPersonAliasId], [Project2].[ShowAsAnonymous] AS [ShowAsAnonymous], [Project2].[BatchId] AS [BatchId], [Project2].[FinancialGatewayId] AS [FinancialGatewayId], [Project2].[FutureProcessingDateTime] AS [FutureProcessingDateTime], [Project2].[TransactionCode] AS [TransactionCode], [Project2].[TransactionTypeValueId] AS [TransactionTypeValueId], [Project2].[SourceTypeValueId] AS [SourceTypeValueId], [Project2].[ScheduledTransactionId] AS [ScheduledTransactionId], [Project2].[ProcessedDateTime] AS [ProcessedDateTime], [Project2].[IsSettled] AS [IsSettled], [Project2].[SettledGroupId] AS [SettledGroupId], [Project2].[SettledDate] AS [SettledDate], [Project2].[IsReconciled] AS [IsReconciled], [Project2].[Status] AS [Status], [Project2].[StatusMessage] AS [StatusMessage], [Project2].[NonCashAssetTypeValueId] AS [NonCashAssetTypeValueId], [Project2].[ForeignCurrencyCodeValueId] AS [ForeignCurrencyCodeValueId], [Project2].[ForeignKey] AS [ForeignKey], [Project2].[Id1] AS [Id1], [Project2].[CurrencyTypeValueId] AS [CurrencyTypeValueId], [Project2].[CreditCardTypeValueId] AS [CreditCardTypeValueId], [Project2].[C1] AS [C1], [Project2].[C2] AS [C2], [Project2].[C3] AS [C3]
            FROM ( SELECT 
                [Project1].[Id] AS [Id], 
                [Project1].[AuthorizedPersonAliasId] AS [AuthorizedPersonAliasId], 
                [Project1].[ShowAsAnonymous] AS [ShowAsAnonymous], 
                [Project1].[BatchId] AS [BatchId], 
                [Project1].[FinancialGatewayId] AS [FinancialGatewayId], 
                [Project1].[FutureProcessingDateTime] AS [FutureProcessingDateTime], 
                [Project1].[TransactionCode] AS [TransactionCode], 
                [Project1].[TransactionTypeValueId] AS [TransactionTypeValueId], 
                [Project1].[SourceTypeValueId] AS [SourceTypeValueId], 
                [Project1].[ScheduledTransactionId] AS [ScheduledTransactionId], 
                [Project1].[ProcessedDateTime] AS [ProcessedDateTime], 
                [Project1].[IsSettled] AS [IsSettled], 
                [Project1].[SettledGroupId] AS [SettledGroupId], 
                [Project1].[SettledDate] AS [SettledDate], 
                [Project1].[IsReconciled] AS [IsReconciled], 
                [Project1].[Status] AS [Status], 
                [Project1].[StatusMessage] AS [StatusMessage], 
                [Project1].[NonCashAssetTypeValueId] AS [NonCashAssetTypeValueId], 
                [Project1].[ForeignCurrencyCodeValueId] AS [ForeignCurrencyCodeValueId], 
                [Project1].[ForeignKey] AS [ForeignKey], 
                [Project1].[Id1] AS [Id1], 
                [Project1].[CurrencyTypeValueId] AS [CurrencyTypeValueId], 
                [Project1].[CreditCardTypeValueId] AS [CreditCardTypeValueId], 
                CASE WHEN ([Project1].[TransactionDateTime] IS NULL) THEN [Project1].[FutureProcessingDateTime] ELSE [Project1].[TransactionDateTime] END AS [C1], 
                CASE WHEN ([Project1].[FutureProcessingDateTime] IS NOT NULL) THEN N'[charge pending] ' + CASE WHEN ([Project1].[Summary] IS NULL) THEN N'' ELSE [Project1].[Summary] END ELSE [Project1].[Summary] END AS [C2], 
                [Project1].[C1] AS [C3]
                FROM ( SELECT 
                    [Extent1].[Id] AS [Id], 
                    [Extent1].[AuthorizedPersonAliasId] AS [AuthorizedPersonAliasId], 
                    [Extent1].[ShowAsAnonymous] AS [ShowAsAnonymous], 
                    [Extent1].[BatchId] AS [BatchId], 
                    [Extent1].[FinancialGatewayId] AS [FinancialGatewayId], 
                    [Extent1].[TransactionDateTime] AS [TransactionDateTime], 
                    [Extent1].[FutureProcessingDateTime] AS [FutureProcessingDateTime], 
                    [Extent1].[TransactionCode] AS [TransactionCode], 
                    [Extent1].[Summary] AS [Summary], 
                    [Extent1].[TransactionTypeValueId] AS [TransactionTypeValueId], 
                    [Extent1].[SourceTypeValueId] AS [SourceTypeValueId], 
                    [Extent1].[ScheduledTransactionId] AS [ScheduledTransactionId], 
                    [Extent1].[ProcessedDateTime] AS [ProcessedDateTime], 
                    [Extent1].[IsSettled] AS [IsSettled], 
                    [Extent1].[SettledGroupId] AS [SettledGroupId], 
                    [Extent1].[SettledDate] AS [SettledDate], 
                    [Extent1].[IsReconciled] AS [IsReconciled], 
                    [Extent1].[Status] AS [Status], 
                    [Extent1].[StatusMessage] AS [StatusMessage], 
                    [Extent1].[NonCashAssetTypeValueId] AS [NonCashAssetTypeValueId], 
                    [Extent1].[ForeignCurrencyCodeValueId] AS [ForeignCurrencyCodeValueId], 
                    [Extent1].[ForeignKey] AS [ForeignKey], 
                    [Extent2].[Id] AS [Id1], 
                    [Extent2].[CurrencyTypeValueId] AS [CurrencyTypeValueId], 
                    [Extent2].[CreditCardTypeValueId] AS [CreditCardTypeValueId], 
                    (SELECT 
                        SUM([Extent3].[Amount]) AS [A1]
                        FROM [dbo].[FinancialTransactionDetail] AS [Extent3]
                        WHERE [Extent1].[Id] = [Extent3].[TransactionId]) AS [C1]
                    FROM  [dbo].[FinancialTransaction] AS [Extent1]
                    LEFT OUTER JOIN [dbo].[FinancialPaymentDetail] AS [Extent2] ON [Extent1].[FinancialPaymentDetailId] = [Extent2].[Id]
                    WHERE [Extent1].[TransactionDateTime] IS NOT NULL
                )  AS [Project1]
            )  AS [Project2]
            ORDER BY row_number() OVER (ORDER BY [Project2].[FutureProcessingDateTime] DESC, [Project2].[C1] DESC, [Project2].[Id] DESC)
            OFFSET 0 ROWS FETCH NEXT 50 ROWS ONLY  ) AS [Limit1]
        LEFT OUTER JOIN [dbo].[FinancialTransactionDetail] AS [Extent4] ON [Limit1].[Id] = [Extent4].[TransactionId]
    )  AS [Project3]
    ORDER BY [Project3].[FutureProcessingDateTime] DESC, [Project3].[C1] DESC, [Project3].[Id] DESC, [Project3].[Id1] ASC, [Project3].[C3] ASC

SELECT 
    [Extent1].[Id] AS [Id], 
    [Extent1].[PersonId] AS [PersonId], 
    [Extent2].[LastName] AS [LastName], 
    [Extent2].[NickName] AS [NickName], 
    [Extent2].[SuffixValueId] AS [SuffixValueId], 
    [Extent2].[RecordTypeValueId] AS [RecordTypeValueId]
    FROM  [dbo].[PersonAlias] AS [Extent1]
    INNER JOIN [dbo].[Person] AS [Extent2] ON [Extent1].[PersonId] = [Extent2].[Id]
    WHERE  EXISTS (SELECT 
        1 AS [C1]
        FROM [dbo].[FinancialTransaction] AS [Extent3]
        WHERE ([Extent3].[TransactionDateTime] IS NOT NULL) AND ([Extent3].[AuthorizedPersonAliasId] IS NOT NULL) AND ([Extent3].[AuthorizedPersonAliasId] = [Extent1].[Id])
    )

SELECT 
    [GroupBy1].[K1] AS [AccountId], 
    [GroupBy1].[A1] AS [C1]
    FROM ( SELECT 
        [Extent2].[AccountId] AS [K1], 
        SUM([Extent2].[Amount]) AS [A1]
        FROM  [dbo].[FinancialTransaction] AS [Extent1]
        INNER JOIN [dbo].[FinancialTransactionDetail] AS [Extent2] ON [Extent1].[Id] = [Extent2].[TransactionId]
        WHERE [Extent1].[TransactionDateTime] IS NOT NULL
        GROUP BY [Extent2].[AccountId]
    )  AS [GroupBy1]