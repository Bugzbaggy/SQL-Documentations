
USE [master]

CREATE LOGIN [VESTAS\ACC-SRV-TIER1] FROM WINDOWS WITH DEFAULT_DATABASE=[master];
ALTER SERVER ROLE [sysadmin] ADD MEMBER [VESTAS\ACC-SRV-TIER1];

CREATE LOGIN [VESTAS\DEL-LS-Enterprise-Sap Local Admin Rights] FROM WINDOWS WITH DEFAULT_DATABASE=[master];
ALTER SERVER ROLE [sysadmin] ADD MEMBER [VESTAS\DEL-LS-Enterprise-Sap Local Admin Rights];

GO
GO
EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'BackupDirectory', REG_SZ, N'F:\SqlBackup'
GO
EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'DefaultData', REG_SZ, N'F:\SqlData'
GO
EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'DefaultLog', REG_SZ, N'G:\Sqllog'
GO
EXEC sys.sp_configure N'show advanced options', N'1'  RECONFIGURE WITH OVERRIDE
GO
EXEC sys.sp_configure N'cost threshold for parallelism', N'50'
GO
EXEC sys.sp_configure N'max degree of parallelism', N'1'
GO
DECLARE @systemmem int,
		@systemfreemem int,
		@recommendedmemconfig int

SELECT	@systemmem = total_physical_memory_kb/1024,
		@systemfreemem = available_physical_memory_kb/1024,
		@recommendedmemconfig = @systemmem * 0.85
FROM sys.dm_os_sys_memory

SELECT @systemmem, @systemfreemem, @recommendedmemconfig

EXEC sys.sp_configure N'max server memory (MB)', @recommendedmemconfig
GO
EXEC sys.sp_configure N'backup compression default', N'1'
GO
EXEC sys.sp_configure N'optimize for ad hoc workloads', N'1'
GO
RECONFIGURE WITH OVERRIDE
GO
EXEC sys.sp_configure N'show advanced options', N'0'  RECONFIGURE WITH OVERRIDE
GO

# New-Item -ItemType Directory -Path F:\ -Name SqlData
# $InheritanceFlag = [System.Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [System.Security.AccessControl.InheritanceFlags]::ObjectInherit
# $PropagationFlag = [System.Security.AccessControl.PropagationFlags]::None
# $ntfs = Get-Acl F:\SqlData
# $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("NT SERVICE\MSSQLSERVER","FullControl",$InheritanceFlag,$PropagationFlag, "Allow")
# $ntfs.SetAccessRule($AccessRule)
# $ntfs | Set-Acl F:\SqlData

# New-Item -ItemType Directory -Path G:\ -Name SqlLog
# $InheritanceFlag = [System.Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [System.Security.AccessControl.InheritanceFlags]::ObjectInherit
# $PropagationFlag = [System.Security.AccessControl.PropagationFlags]::None
# $ntfs = Get-Acl G:\SqlLog
# $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("NT SERVICE\MSSQLSERVER","FullControl",$InheritanceFlag,$PropagationFlag, "Allow")
# $ntfs.SetAccessRule($AccessRule)
# $ntfs | Set-Acl G:\SqlLog





ALTER DATABASE [msdb] MODIFY FILE (NAME = MSDBData, FILENAME = 'F:\SqlData\MSDBData.mdf');
ALTER DATABASE [msdb] MODIFY FILE (NAME = MSDBLog, FILENAME = 'G:\Sqllog\MSDBLog.ldf');

ALTER DATABASE [model] MODIFY FILE (NAME = modeldev, FILENAME = 'F:\SqlData\model.mdf');
ALTER DATABASE [model] MODIFY FILE (NAME = modellog, FILENAME = 'G:\Sqllog\modellog.ldf');

ALTER DATABASE [tempdb] MODIFY FILE (NAME = tempdev, FILENAME = 'F:\SqlData\tempdb.mdf');
ALTER DATABASE [tempdb] MODIFY FILE (NAME = temp2, FILENAME = 'F:\SqlData\tempdb_mssql_2.ndf');
ALTER DATABASE [tempdb] MODIFY FILE (NAME = temp3, FILENAME = 'F:\SqlData\tempdb_mssql_3.ndf');
ALTER DATABASE [tempdb] MODIFY FILE (NAME = temp4, FILENAME = 'F:\SqlData\tempdb_mssql_4.ndf');
ALTER DATABASE [tempdb] MODIFY FILE (NAME = templog, FILENAME = 'G:\Sqllog\templog.ldf');
