SELECT
    TOP 1000
    g.[Id] As [GroupId]
    ,g.[Name] As [GroupName]
    ,g.[IsActive]
    ,g.[IsArchived]
    ,dv.[Id] As [DataViewId]

FROM
    [DataView] dv
    INNER JOIN [GroupSync] gs ON gs.[SyncDataViewId] = dv.[Id]
    INNER JOIN [Group] g ON g.[Id] = gs.[GroupId] AND (g.[IsArchived] = 1 OR g.[IsActive] = 0)

