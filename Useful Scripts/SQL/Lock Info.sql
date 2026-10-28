SELECT *
FROM sys.dm_os_wait_stats dows
ORDER BY dows.wait_time_ms DESC;

select top 10* from sys.syslockinfo
where req_spid = 

exec sp_lock