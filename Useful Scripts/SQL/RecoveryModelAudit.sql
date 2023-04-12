DECLARE @tracefile VARCHAR(500)
DECLARE @ProcessInfoSPID VARCHAR(20) 
CREATE TABLE [dbo].[#SQLerrorlog]( 
[LogDate] DATETIME NULL,
[ProcessInfo] VARCHAR(10) NULL,
[Text] VARCHAR(MAX) NULL
)
/* Valid parameters for sp_readerrorlog 1 – Error log: 0 = current, 1 = Archive #1, 2 = Archive #2, etc… 2 – Log file type: 1 or NULL = error log, 2 = SQL Agent log 3 – Search string 1 4 – Search string 2  Change parameters to meet your needs */
--— Read error log looking for the words RECOVERY
--–and either FULL, SIMPLE or BULK_LOGGED indicating a change from prior state
INSERT INTO #SQLerrorlog
EXEC sp_readerrorlog 0, 1, 'RECOVERY', 'FULL'
INSERT INTO #SQLerrorlog
EXEC sp_readerrorlog 0, 1, 'RECOVERY', 'SIMPLE' 
INSERT INTO #SQLerrorlog
EXEC sp_readerrorlog 0, 1, 'RECOVERY', 'BULK_LOGGED'
UPDATE #SQLerrorlog
SET ProcessInfo = SUBSTRING(ProcessInfo,5,20)
FROM #SQLerrorlog
WHERE ProcessInfo LIKE 'spid%'
--— Get path of default trace file
SELECT @tracefile = CAST(value AS VARCHAR(500))
FROM sys.fn_trace_getinfo(DEFAULT)
WHERE traceid = 1 AND property = 2
--— Get objects altered from the default trace
SELECT IDENTITY(int, 1, 1) AS RowNumber, * INTO #temp_trc
FROM sys.fn_trace_gettable(@tracefile, default) g 
--— default = read all trace files
WHERE g.EventClass = 164 
SELECT t.DatabaseID, t.DatabaseName, t.NTUserName, t.NTDomainName, t.HostName, t.ApplicationName, t.LoginName, t.SPID, t.StartTime, l.Text
FROM #temp_trc t JOIN #SQLerrorlog l ON t.SPID = l.ProcessInfo
WHERE t.StartTime > GETDATE()-1 
--— filter by time within the last 24 hours
ORDER BY t.StartTime DESC 
DROP TABLE #temp_trc
DROP TABLE #SQLerrorlog
GO