#Import-Module SQLPS -DisableNameChecking
#Install-Module SQLSERVER -Force -AllowCLobber 
#Import-Module SQLSERVER #$env:PSModulePath
$servers = Get-Content "C:\Temp\primary.txt"

$outputarray = @()
Foreach($server in $servers){

$SQLService = (Get-service -ComputerName $server | where {($_.displayname -like "SQL Server (*") }).Name
$ServerInstanceSplit = $SQLService.Split("$")
$InstanceName = $server + '\' + $ServerInstanceSplit[1]
$SQLVersion = Invoke-Sqlcmd -Query "SELECT SUBSTRING(@@VERSION,0,68);" -ServerInstance $InstanceName


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
        
        If($AGstate.IsPrimaryServer -eq 1){
        $PrimaryInstance = $AGstate.Instance

        }Else{

        $SecondaryInstance = $AGstate.Instance

        }

        $InstanceSplit = $AGstate.Instance.Split('\')
        $AGNode = ($InstanceSplit[0])

        If($AGNode -eq $SecondaryInstance.Split('\')[0]){
        $AvailabilityDB = "SQLSERVER:\Sql\$SecondaryInstance\AvailabilityGroups\$($AGstate.AGname)\AvailabilityDatabases” 
        Get-ChildItem $AvailabilityDB | Suspend-SqlAvailabilityDatabase #Resume or Suspend
        Start-Sleep -s 2 ##Allow delay
            
            ###Commence patch installation###
            If($Service.Status -ne "Running"){
            Start-Service -Name $Service.Name
            $proc=Get-WmiObject -list Win32_Process -EnableAllPrivileges -computer $server
            $proc.create("$sqlpatch /action=patch /allinstances /IAcceptSQLServerLicenseTerms /Quiet")
            }
            ElseIf($Service.Status -eq "Running"){
            $proc=Get-WmiObject -list Win32_Process -EnableAllPrivileges -computer $server
            $proc.create("$sqlpatch /action=patch /allinstances /IAcceptSQLServerLicenseTerms /Quiet")
            }
       }
       }
         
        ####Test availability database replica state health####
        #$AGReplicaStatePath = "SQLSERVER:\Sql\$PrimaryInstance\AvailabilityGroups\$($AGstate.AGname)\DatabaseReplicaStates" 
        #Get-ChildItem $AGReplicaStatePath | Test-SqlDatabaseReplicaState

}
#$outputarray | FT
     


#| Sort-Object $AGstate.Instance
