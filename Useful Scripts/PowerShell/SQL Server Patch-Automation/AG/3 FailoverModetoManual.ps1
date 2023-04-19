<#
    .NOTES 
    Name: Modify Availability Groups failover mode from Automatic to Manual
    Author: Renz Marion Bagasbas
	Modified by: Lexter Gapuz
	Contributor: Nikolai Ramos
        
    .DESCRIPTION 
        This step is a pre-task before installing patch for SQL servers participating in Always On Availability Groups

        YOU WILL NEED TO LIST DOWN JUST ONE NODE PER AVAILABILITY GROUP IN THE SOURCE FILE TO AVOID DUPLICATIONS
#> 

#Import-Module SQLPS -DisableNameChecking
#Install-Module SQLSERVER -Force -AllowCLobber 
#Import-Module SQLSERVER #$env:PSModulePath
$servers = Get-Content "C:\Temp\primary.txt" #Only one node per AG is required in the source file. This script will automatically detect availability replica role. 

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
      
             
      
      If($AGNode -eq $PrimaryInstance.Split('\')[0] -or $AGNode -eq $SecondaryInstance.Split('\')[0]){
        Set-Location SQLSERVER:\Sql
        $query1 = "USE [master]
        GO
        ALTER AVAILABILITY GROUP [$($AGstate.AGname)]
        MODIFY REPLICA ON N'$($PrimaryInstance)' WITH (FAILOVER_MODE = MANUAL) #Change to MANUAL or AUTOMATIC
        GO
        USE [master]
        GO
        ALTER AVAILABILITY GROUP [$($AGstate.AGname)]
        MODIFY REPLICA ON N'$($SecondaryInstance)' WITH (FAILOVER_MODE = MANUAL) #Change to MANUAL or AUTOMATIC
        GO";
        Invoke-Sqlcmd -ServerInstance $PrimaryInstance -Query $query1
        }
    
		Write-Host "
		##########################################
		Failover mode of all availability replicas
		has been changed from Automatic to Manual." -ForegroundColor Green   
    }
    
    $AGValidates = Invoke-Sqlcmd -Query "WITH AGStatus AS(
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
    Foreach($AGValidate in $AGValidates){
    
       $Objt = New-Object PSObject
       $Objt | Add-Member -MemberType NoteProperty -Name AGname -Value $AGValidate.AGname
       $Objt | Add-Member -MemberType NoteProperty -Name Instance -Value $AGValidate.Instance 
       $Objt | Add-Member -MemberType NoteProperty -Name IsPrimaryServer -Value $AGValidate.IsPrimaryServer
       $Objt | Add-Member -MemberType NoteProperty -Name HealthState -Value $AGValidate.HealthState
       $Objt | Add-Member -MemberType NoteProperty -Name Synchronous -Value $AGValidate.Synchronous
       $Objt | Add-Member -MemberType NoteProperty -Name ReadableSecondary -Value $AGValidate.ReadableSecondary
       $Objt | Add-Member -MemberType NoteProperty -Name FailoverMode -Value $AGValidate.FailoverMode
       $Objt | Add-Member -MemberType NoteProperty -Name SQLVersion -Value $SQLVersion.Column1
       $outputarray += $Objt
       
       }   
}
$outputarray | FT
#| Sort-Object $AGstate.Instance
