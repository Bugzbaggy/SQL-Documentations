SELECT DISTINCT @@servername AS InstanceName, dovs.logical_volume_name AS LogicalName,
dovs.volume_mount_point AS Drive,
CAST(CONVERT(INT,dovs.available_bytes/1048576.0)/1048576.0 AS DECIMAL(10,2) ) AS FreeSpaceInTB,
CAST(CONVERT(INT,dovs.total_bytes/1048576.0)/1048576.0 AS DECIMAL(10,2) ) AS TotalSpaceInTB
FROM sys.master_files mf
CROSS APPLY sys.dm_os_volume_stats(mf.database_id, mf.FILE_ID) dovs
ORDER BY FreeSpaceInTB ASC
