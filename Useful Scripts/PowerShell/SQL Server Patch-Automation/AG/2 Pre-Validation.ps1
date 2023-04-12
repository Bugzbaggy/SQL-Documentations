#Import-Module SQLPS -DisableNameChecking
$servers = Get-Content "C:\Temp\primary.txt"

$outputarray = @()
Foreach($server in $servers){

$SQLService = (Get-service -ComputerName $server | where {($_.displayname -like "SQL Server (*") }).Name
$ServerInstanceSplit = $SQLService.Split("$")
$InstanceName = $server + '\' + $ServerInstanceSplit[1]
$SQLVersion = Invoke-Sqlcmd -Query "SELECT SUBSTRING(@@VERSION,0,68);" -ServerInstance $InstanceName
$LogTime = Get-Date -Format "yyyy-MM-dd hh:mm:ss"

$AGstates = Invoke-Sqlcmd -Query "WITH AGStatus AS(
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
[Replica_Server_Name] AS Instance,
[IsPrimaryServer],
--primary_recovery_health_desc,
--ConnectionState,
synchronization_health_desc AS HealthState ,
[Synchronous],
[ReadableSecondary],
[Failover_Mode_Desc] AS FailoverMode
FROM AGStatus
--WHERE
--IsPrimaryServer = 1
--AND Synchronous = 1
ORDER BY
AGname ASC,
IsPrimaryServer DESC;" -ServerInstance "$InstanceName" 

    Foreach($AGstate in $AGstates){
    
       $Objt = New-Object PSObject
       $Objt | Add-Member -MemberType NoteProperty -Name AGname -Value $AGstate.AGname
       $Objt | Add-Member -MemberType NoteProperty -Name Instance -Value $AGstate.Instance 
       $Objt | Add-Member -MemberType NoteProperty -Name IsPrimaryServer -Value $AGstate.IsPrimaryServer
       $Objt | Add-Member -MemberType NoteProperty -Name HealthState -Value $AGstate.HealthState
       $Objt | Add-Member -MemberType NoteProperty -Name Synchronous -Value $AGstate.Synchronous
       $Objt | Add-Member -MemberType NoteProperty -Name ReadableSecondary -Value $AGstate.ReadableSecondary
       $Objt | Add-Member -MemberType NoteProperty -Name FailoverMode -Value $AGstate.FailoverMode
	   $Objt | Add-Member -MemberType NoteProperty -Name LogTime -Value $LogTime
       $Objt | Add-Member -MemberType NoteProperty -Name SQLVersion -Value $SQLVersion.Column1
       $outputarray += $Objt

      
       }

}
$outputarray | FT
 Write-Output $outputarray
 $outputarray | Export-Csv -path "D:\PatchVersionPrevious.csv" -nti
 notepad 'D:\PatchVersionPrevious.csv'