--USE YourDatabase;

-- Check the fragmentation level of an index
SELECT 
    OBJECT_NAME(avg_fragmentation_in_percent.object_id) AS table_name,
    avg_fragmentation_in_percent.index_id AS index_id,
    avg_fragmentation_in_percent.index_type_desc AS index_type,
    avg_fragmentation_in_percent.avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) AS avg_fragmentation_in_percent
WHERE avg_fragmentation_in_percent.database_id = DB_ID()
    AND OBJECT_NAME(avg_fragmentation_in_percent.object_id) = 'AttributeValue'
    AND avg_fragmentation_in_percent.index_id = 1;
