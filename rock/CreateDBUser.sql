CREATE USER RockUserStage
FOR LOGIN RockUserStage

GO
EXEC sp_addrolemember 'db_owner', 'RockUserStage'