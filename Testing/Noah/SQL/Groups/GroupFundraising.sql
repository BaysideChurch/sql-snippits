WITH members AS (
SELECT
    gm.Id AS [GroupMemberId]
    ,gm.GroupId
FROM
    [GroupMember] gm
WHERE
    gm.GroupId = 943135
), fundraisingGoal AS (
    SELECT
        av.EntityId
        ,av.Value
        ,a.EntityTypeId
    FROM
        [Attribute] a
        INNER JOIN [AttributeValue] av On av.AttributeId = a.Id
    WHERE
        a.[Key] = 'IndividualFundraisingGoal'
), member_goals As (
    SELECT
        m.GroupMemberId
        ,m.GroupId
        ,fg.Value AS [FundraisingGoal]
    FROM
        members m
        INNER JOIN fundraisingGoal fg ON (fg.EntityId = m.GroupMemberId AND fg.EntityTypeId = 90)
            OR (fg.EntityId = m.GroupId AND fg.EntityTypeId = 16)
), individual_funds As (
SELECT
    SUM(ftd.Amount) AS [ContributionTotal]
    ,m.GroupMemberId
    ,MAX(m.GroupId) As [GroupId]
FROM
    [FinancialTransactionDetail] ftd
    INNER JOIN member_goals m ON m.GroupMemberId = ftd.EntityId
WHERE
    ftd.EntityTypeId = 90
GROUP BY
    m.GroupMemberId
)


SELECT * FROM individual_funds;