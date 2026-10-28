USE MASTER

GO


--List of Databases with Total Size
EXEC sp_databases


--List of Databases with Total Size
USE master
GO
SELECT
bugz2.DatabaseName
,bugz2.RowSizeMB
,bugz2.LogSizeMB
,ISNULL(bugz2.total_size_mb,0) as total_size_mb
FROM(
SELECT
bugz.DatabaseName
,bugz.RowSizeMB
,bugz.LogSizeMB
,SUM(CAST(bugz.RowSizeMB + bugz.LogSizeMB as bigint)) AS total_size_mb
FROM(
SELECT     
DB_NAME(db.database_id) DatabaseName,     
(CAST(mfrows.RowSize AS FLOAT)*8)/1024 RowSizeMB,     
(CAST(mflog.LogSize AS FLOAT)*8)/1024 LogSizeMB
--ISNULL([RowSizeMB],0)+ISNULL([LogSizeMB],0) AS total_size_mb
--(CAST(mfrows.RowSize AS FLOAT)*8)/1024/1024+(CAST(mflog.LogSize AS FLOAT)*8)/1024/1024 DBSizeG,
--(CAST(mfstream.StreamSize AS FLOAT)*8)/1024 StreamSizeMB,     
--(CAST(mftext.TextIndexSize AS FLOAT)*8)/1024 TextIndexSizeMB 
FROM sys.databases db     
LEFT JOIN (SELECT database_id, 
                  SUM(CAST(size as bigint)) AS RowSize 
            FROM sys.master_files 
            WHERE type = 0 
            GROUP BY database_id, type) mfrows 
    ON mfrows.database_id = db.database_id     
LEFT JOIN (SELECT database_id, 
                  SUM(CAST(size as bigint)) AS LogSize 
            FROM sys.master_files 
            WHERE type = 1 
            GROUP BY database_id, type) mflog 
    ON mflog.database_id = db.database_id     
LEFT JOIN (SELECT database_id, 
                  SUM(CAST(size as bigint)) AS  StreamSize 
                  FROM sys.master_files 
                  WHERE type = 2 
                  GROUP BY database_id, type) mfstream 
    ON mfstream.database_id = db.database_id     
LEFT JOIN (SELECT database_id, 
                  SUM(CAST(size as bigint)) AS TextIndexSize 
                  FROM sys.master_files 
                  WHERE type = 4 
                  GROUP BY database_id, type) mftext 
    ON mftext.database_id = db.database_id 
	GROUP BY DB_NAME(db.database_id) ,
			(CAST(mfrows.RowSize AS FLOAT)*8)/1024,     
			(CAST(mflog.LogSize AS FLOAT)*8)/1024 
)bugz
GROUP BY
bugz.DatabaseName
,bugz.RowSizeMB
,bugz.LogSizeMB)bugz2

--Number or Cores
SELECT cpu_count AS [Logical CPU Count],
hyperthread_ratio AS Hyperthread_Ratio,
cpu_count/hyperthread_ratio AS Physical_CPU_Count,
--physical_memory_kb/1000 AS [Physical Memory (MB)],
sqlserver_start_time-- affinity_type_desc -- (affinity_type_desc is only in 2008 R2)
FROM sys.dm_os_sys_info