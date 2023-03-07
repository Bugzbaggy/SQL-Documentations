--query to see the tempdb space usage
USE tempdb
SELECT GETDATE() AS runtime,
    SUM(user_object_reserved_page_count) * 8 AS usr_obj_kb,
    SUM(internal_object_reserved_page_count) * 8 AS internal_obj_kb,
    SUM(version_store_reserved_page_count) * 8 AS version_store_kb,
    SUM(unallocated_extent_page_count) * 8 AS freespace_kb,
    SUM(mixed_extent_page_count) * 8 AS mixedextent_kb
FROM sys.dm_db_file_space_usage;

--sessions using the version stores in TempDB
select hostname,elapsed_time_seconds,session_id, is_snapshot, blocked, lastwaittype, cpu, physical_io,  open_tran, cmd 
from sys.dm_tran_active_snapshot_database_transactions a
join master..sysprocesses b
on a.session_id=b.spid 
order by a.elapsed_time_seconds desc

--Query to check Version Store performance counters
SELECT * 
FROM sys.dm_os_performance_counters
WHERE counter_name IN ( 'Longest Transaction Running Time' ,'Version Store Size (KB)' ,'Version Cleanup rate (KB/s)' ,'Version Generation rate (KB/s)' )

--Query to find the transaction utilizing version store in primary replica
SELECT GETDATE() AS runtime
	,a.*
	,b.kpid
	,b.blocked
	,b.lastwaittype
	,b.waitresource
	,db_name(b.dbid) AS database_name
	,b.cpu
	,b.physical_io
	,b.memusage
	,b.login_time
	,b.last_batch
	,b.open_tran
	,b.STATUS
	,b.hostname
	,b.program_name
	,b.cmd
	,b.loginame
	,request_id
FROM sys.dm_tran_active_snapshot_database_transactions a
INNER JOIN sys.sysprocesses b ON a.session_id = b.spid

-- QUERY TO CHECK ROOT BLOCKERS
SET NOCOUNT ON
GO
SELECT SPID, BLOCKED, REPLACE (REPLACE (T.TEXT, CHAR(10), ' '), CHAR (13), ' ' ) AS BATCH
INTO #T
FROM sys.sysprocesses R CROSS APPLY sys.dm_exec_sql_text(R.SQL_HANDLE) T
GO
WITH BLOCKERS (SPID, BLOCKED, LEVEL, BATCH)
AS
(
SELECT SPID,
BLOCKED,
CAST (REPLICATE ('0', 4-LEN (CAST (SPID AS VARCHAR))) + CAST (SPID AS VARCHAR) AS VARCHAR (1000)) AS LEVEL,
BATCH FROM #T R
WHERE (BLOCKED = 0 OR BLOCKED = SPID)
AND EXISTS (SELECT * FROM #T R2 WHERE R2.BLOCKED = R.SPID AND R2.BLOCKED <> R2.SPID)
UNION ALL
SELECT R.SPID,
R.BLOCKED,
CAST (BLOCKERS.LEVEL + RIGHT (CAST ((1000 + R.SPID) AS VARCHAR (100)), 4) AS VARCHAR (1000)) AS LEVEL,
R.BATCH FROM #T AS R
INNER JOIN BLOCKERS ON R.BLOCKED = BLOCKERS.SPID WHERE R.BLOCKED > 0 AND R.BLOCKED <> R.SPID
)
SELECT N'    ' + REPLICATE (N'|         ', LEN (LEVEL)/4 - 1) +
CASE WHEN (LEN(LEVEL)/4 - 1) = 0
THEN 'HEAD -  '
ELSE '|------  ' END
+ CAST (SPID AS NVARCHAR (10)) + N' ' + BATCH AS BLOCKING_TREE
FROM BLOCKERS ORDER BY LEVEL ASC
GO
DROP TABLE #T
GO

exec sp_WhoIsActive
@show_sleeping_spids=0,
--@get_transaction_info = 1,
@find_block_leaders = 1,
--@sort_order = '[tempdb_allocations] DESC'
@sort_order = '[blocked_session_count] DESC'

