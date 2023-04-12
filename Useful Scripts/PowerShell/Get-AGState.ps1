Import-Module SQLPS -DisableNameChecking
function Get-AGState ([string]$server)
{
$state =
#Show Availability groups visible to the Server and Replica information such as Which server is the Primary
#Sync and Async modes , Readable Secondary and Failover Mode, these can all be filtered using a Where clause
#if you are running some checks, no Where clause will show you all of the information.
Invoke-Sqlcmd -Query "WITH AGStatus AS(
SELECT
name as AGname,
Replica_Server_Name,
CASE WHEN  (primary_replica  = replica_server_name) THEN  1
ELSE  '' END AS IsPrimaryServer,
--primary_recovery_health_desc,
--CASE WHEN  (primary_recovery_health_desc  = 'ONLINE') THEN  'CONNECTED'
--ELSE 'ERROR' END AS ConnectionState,
synchronization_health_desc,
secondary_role_allow_connections_desc AS ReadableSecondary,
[availability_mode]  AS [Synchronous],
Failover_Mode_Desc
FROM master.sys.availability_groups Groups
INNER JOIN master.sys.availability_replicas Replicas ON Groups.group_id = Replicas.group_id
INNER JOIN master.sys.dm_hadr_availability_group_states States ON Groups.group_id = States.group_id
)
 
Select
[AGname],
[Replica_Server_Name],
[IsPrimaryServer],
--primary_recovery_health_desc,
--ConnectionState,
synchronization_health_desc,
[Synchronous],
[ReadableSecondary],
[Failover_Mode_Desc]
FROM AGStatus
--WHERE
--IsPrimaryServer = 1
--AND Synchronous = 1
ORDER BY
AGname ASC,
IsPrimaryServer DESC;" -ServerInstance "$server";
$state | Format-Table -AutoSize;
}

Get-AGState azsapqdb01\QE2DB