
-- delete sample data
DELETE FROM [Category] WHERE [Guid] IN (
    N'ae3f4a8d-46d7-4520-934c-85d80167b22c', 
    N'baf88943-64ea-4a6a-8e1e-f4efc5a6ceca', 
    N'd29a2afc-bd90-428b-9065-2ffd09fb6f6b', 
    N'355ac2fd-0831-4a11-9294-5568fdfa8fc3', 
    N'ddede1a7-c02b-4322-9d5b-a73cdb9224c6'
);

-- delete pages .. do this manually


-- drop tables
ALTER TABLE [dbo].[_com_centralaz_RoomManagement_ReservationWorkflow] DROP CONSTRAINT [FK__com_centralaz_RoomManagement_ReservationWorkflow_WorkflowId]
ALTER TABLE [dbo].[_com_centralaz_RoomManagement_ReservationWorkflow] DROP CONSTRAINT [FK__com_centralaz_RoomManagement_ReservationWorkflow_ModifiedByPersonAliasId]
ALTER TABLE [dbo].[_com_centralaz_RoomManagement_ReservationWorkflow] DROP CONSTRAINT [FK__com_centralaz_RoomManagement_ReservationWorkflow_CreatedByPersonAliasId]
ALTER TABLE [dbo].[_com_centralaz_RoomManagement_ReservationWorkflow] DROP CONSTRAINT [FK__com_centralaz_RoomManagement_ReservationWorkflow_ReservationWorkflowTriggerId]
ALTER TABLE [dbo].[_com_centralaz_RoomManagement_ReservationWorkflow] DROP CONSTRAINT [FK__com_centralaz_RoomManagement_ReservationWorkflow_ReservationId]
DROP TABLE [dbo].[_com_centralaz_RoomManagement_ReservationWorkflow]
ALTER TABLE [dbo].[_com_centralaz_RoomManagement_ReservationWorkflowTrigger] DROP CONSTRAINT [FK__com_centralaz_RoomManagement_ReservationWorkflowTrigger_WorkflowTypeId]
ALTER TABLE [dbo].[_com_centralaz_RoomManagement_ReservationWorkflowTrigger] DROP CONSTRAINT [FK__com_centralaz_RoomManagement_ReservationWorkflowTrigger_ModifiedByPersonAliasId]
ALTER TABLE [dbo].[_com_centralaz_RoomManagement_ReservationWorkflowTrigger] DROP CONSTRAINT [FK__com_centralaz_RoomManagement_ReservationWorkflowTrigger_CreatedByPersonAliasId]
DROP TABLE [dbo].[_com_centralaz_RoomManagement_ReservationWorkflowTrigger]
ALTER TABLE [dbo].[_com_centralaz_RoomManagement_ReservationLocation] DROP CONSTRAINT [FK__com_centralaz_RoomManagement_ReservationLocation_ModifiedByPersonAliasId]
ALTER TABLE [dbo].[_com_centralaz_RoomManagement_ReservationLocation] DROP CONSTRAINT [FK__com_centralaz_RoomManagement_ReservationLocation_CreatedByPersonAliasId]
ALTER TABLE [dbo].[_com_centralaz_RoomManagement_ReservationLocation] DROP CONSTRAINT [FK__com_centralaz_RoomManagement_ReservationLocation_Reservation]
ALTER TABLE [dbo].[_com_centralaz_RoomManagement_ReservationLocation] DROP CONSTRAINT [FK__com_centralaz_RoomManagement_ReservationLocation_Location]
DROP TABLE [dbo].[_com_centralaz_RoomManagement_ReservationLocation]
ALTER TABLE [dbo].[_com_centralaz_RoomManagement_ReservationResource] DROP CONSTRAINT [FK__com_centralaz_RoomManagement_ReservationResource_ModifiedByPersonAliasId]
ALTER TABLE [dbo].[_com_centralaz_RoomManagement_ReservationResource] DROP CONSTRAINT [FK__com_centralaz_RoomManagement_ReservationResource_CreatedByPersonAliasId]
ALTER TABLE [dbo].[_com_centralaz_RoomManagement_ReservationResource] DROP CONSTRAINT [FK__com_centralaz_RoomManagement_ReservationResource_Reservation]
ALTER TABLE [dbo].[_com_centralaz_RoomManagement_ReservationResource] DROP CONSTRAINT [FK__com_centralaz_RoomManagement_ReservationResource_Resource]
DROP TABLE [dbo].[_com_centralaz_RoomManagement_ReservationResource]
ALTER TABLE [dbo].[_com_centralaz_RoomManagement_Resource] DROP CONSTRAINT [FK__com_centralaz_RoomManagement_Resource_ModifiedByPersonAliasId]
ALTER TABLE [dbo].[_com_centralaz_RoomManagement_Resource] DROP CONSTRAINT [FK__com_centralaz_RoomManagement_Resource_CreatedByPersonAliasId]
ALTER TABLE [dbo].[_com_centralaz_RoomManagement_Resource] DROP CONSTRAINT [FK__com_centralaz_RoomManagement_Resource_Campus]
ALTER TABLE [dbo].[_com_centralaz_RoomManagement_Resource] DROP CONSTRAINT [FK__com_centralaz_RoomManagement_Resource_Category]
DROP TABLE [dbo].[_com_centralaz_RoomManagement_Resource]
ALTER TABLE [dbo].[_com_centralaz_RoomManagement_Reservation] DROP CONSTRAINT [FK__com_centralaz_RoomManagement_Reservation_ModifiedByPersonAliasId]
ALTER TABLE [dbo].[_com_centralaz_RoomManagement_Reservation] DROP CONSTRAINT [FK__com_centralaz_RoomManagement_Reservation_CreatedByPersonAliasId]
ALTER TABLE [dbo].[_com_centralaz_RoomManagement_Reservation] DROP CONSTRAINT [FK__com_centralaz_RoomManagement_Reservation_RequesterAliasId]
ALTER TABLE [dbo].[_com_centralaz_RoomManagement_Reservation] DROP CONSTRAINT [FK__com_centralaz_RoomManagement_Reservation_ApproverPersonId]
ALTER TABLE [dbo].[_com_centralaz_RoomManagement_Reservation] DROP CONSTRAINT [FK__com_centralaz_RoomManagement_Reservation_ReservationStatus]
ALTER TABLE [dbo].[_com_centralaz_RoomManagement_Reservation] DROP CONSTRAINT [FK__com_centralaz_RoomManagement_Reservation_ReservationMinistry]
ALTER TABLE [dbo].[_com_centralaz_RoomManagement_Reservation] DROP CONSTRAINT [FK__com_centralaz_RoomManagement_Reservation_Campus]
ALTER TABLE [dbo].[_com_centralaz_RoomManagement_Reservation] DROP CONSTRAINT [FK__com_centralaz_RoomManagement_Reservation_Schedule]
DROP TABLE [dbo].[_com_centralaz_RoomManagement_Reservation]
ALTER TABLE [dbo].[_com_centralaz_RoomManagement_ReservationMinistry] DROP CONSTRAINT [FK__com_centralaz_RoomManagement_ReservationMinistry_ModifiedByPersonAliasId]
ALTER TABLE [dbo].[_com_centralaz_RoomManagement_ReservationMinistry] DROP CONSTRAINT [FK__com_centralaz_RoomManagement_ReservationMinistry_CreatedByPersonAliasId]
DROP TABLE [dbo].[_com_centralaz_RoomManagement_ReservationMinistry]
ALTER TABLE [dbo].[_com_centralaz_RoomManagement_ReservationStatus] DROP CONSTRAINT [FK__com_centralaz_RoomManagement_ReservationStatus_ModifiedByPersonAliasId]
ALTER TABLE [dbo].[_com_centralaz_RoomManagement_ReservationStatus] DROP CONSTRAINT [FK__com_centralaz_RoomManagement_ReservationStatus_CreatedByPersonAliasId]
DROP TABLE [dbo].[_com_centralaz_RoomManagement_ReservationStatus]

-- drop entity types
DELETE FROM [EntityType] WHERE [Guid] IN (
    N'839768A3-10D6-446C-A65B-B8F9EFD7808F',
    N'07084E96-2907-4741-80DF-016AB5981D12',
    N'5DFCA44E-7090-455C-8C7B-D02CF6331A0F',
    N'A9A1F735-0298-4137-BCC1-A9117B6543C9',
    N'5241B2B1-AEF2-4EB9-9737-55604069D93B',
    N'3660E6A9-B3DA-4CCB-8FC8-B182BC1A2587',
    N'CD0C935B-C3EF-465B-964E-A3AB686D8F51',
    N'35584736-8FE2-48DA-9121-3AFD07A2DA8D'
);