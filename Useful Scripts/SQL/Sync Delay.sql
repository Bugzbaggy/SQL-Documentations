--SYNC DELAY
;WITH 
       AG_Stats AS 
                    (
                    SELECT AR.replica_server_name,
                              HARS.role_desc, 
                              Db_name(DRS.database_id) [DBName], 
                              DRS.last_commit_time
                    FROM   sys.dm_hadr_database_replica_states DRS 
                    INNER JOIN sys.availability_replicas AR ON DRS.replica_id = AR.replica_id 
                    INNER JOIN sys.dm_hadr_availability_replica_states HARS ON AR.group_id = HARS.group_id 
                           AND AR.replica_id = HARS.replica_id 
                    ),
       Pri_CommitTime AS 
                    (
                    SELECT replica_server_name
                                 , DBName
                                 , last_commit_time
                    FROM   AG_Stats
                    WHERE  role_desc = 'PRIMARY'
                    ),
       Sec_CommitTime AS 
                    (
                    SELECT replica_server_name
                                 , DBName
                                 , last_commit_time
                    FROM   AG_Stats
                    WHERE  role_desc = 'SECONDARY'
                    )
SELECT p.replica_server_name [primary_replica]
       , p.[DBName] AS [DatabaseName]
       , s.replica_server_name [secondary_replica]
       , DATEDIFF(ss,s.last_commit_time,p.last_commit_time) AS [Sync_Lag_Secs]
FROM Pri_CommitTime p
LEFT JOIN Sec_CommitTime s ON [s].[DBName] = [p].[DBName]
ORDER BY [Sync_Lag_Secs] desc
 
 
--REDO LAG
 
;WITH 
       AG_Stats AS 
                    (
                    SELECT AR.replica_server_name,
                              HARS.role_desc, 
                              Db_name(DRS.database_id) [DBName], 
                              DRS.redo_queue_size redo_queue_size_KB,
                              DRS.redo_rate redo_rate_KB_Sec
                    FROM   sys.dm_hadr_database_replica_states DRS 
                    INNER JOIN sys.availability_replicas AR ON DRS.replica_id = AR.replica_id 
                    INNER JOIN sys.dm_hadr_availability_replica_states HARS ON AR.group_id = HARS.group_id 
                           AND AR.replica_id = HARS.replica_id 
                    ),
       Pri_CommitTime AS 
                    (
                    SELECT replica_server_name
                                 , DBName
                                 , redo_queue_size_KB
                                 , redo_rate_KB_Sec
                    FROM   AG_Stats
                    WHERE  role_desc = 'PRIMARY'
                    ),
       Sec_CommitTime AS 
                    (
                    SELECT replica_server_name
                                 , DBName
                                 --Send queue and rate will be NULL if secondary is not online and synchronizing
                                 , redo_queue_size_KB
                                 , redo_rate_KB_Sec
                    FROM   AG_Stats
                    WHERE  role_desc = 'SECONDARY'
                    )
SELECT p.replica_server_name [primary_replica]
       , p.[DBName] AS [DatabaseName]
       , s.replica_server_name [secondary_replica]
       , CAST(s.redo_queue_size_KB / s.redo_rate_KB_Sec AS BIGINT) [Redo_Lag_Secs]
FROM Pri_CommitTime p
LEFT JOIN Sec_CommitTime s ON [s].[DBName] = [p].[DBName]
ORDER BY [Redo_Lag_Secs] desc
 
--Redo size queue
SELECT ag.name AS [availability_group_name]
, d.name AS [database_name]
, ar.replica_server_name AS [replica_instance_name]
, drs.truncation_lsn , drs.log_send_queue_size
, drs.redo_queue_size
FROM sys.availability_groups ag
INNER JOIN sys.availability_replicas ar
    ON ar.group_id = ag.group_id
INNER JOIN sys.dm_hadr_database_replica_states drs
    ON drs.replica_id = ar.replica_id
INNER JOIN sys.databases d
    ON d.database_id = drs.database_id
WHERE drs.is_local=0
and d.name = 'LIB_G1A_RTP'
ORDER BY ag.name ASC, d.name ASC, drs.truncation_lsn ASC, ar.replica_server_name ASC