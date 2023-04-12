
SELECT
    bs.database_name,
    bs.backup_start_date,
    bs.backup_finish_date,
    Duration = STUFF(CONVERT(VARCHAR(20),@EndDT-@StartDT,114),1,2,DATEDIFF(hh,0,@EndDT-@StartDT)),
    bs.is_copy_only,
    bs.server_name, 
    bs.user_name,
    bs.type,
    bm.physical_device_name
FROM msdb.dbo.backupset AS bs
INNER JOIN msdb.dbo.backupmediafamily AS bm on bs.media_set_id = bm.media_set_id