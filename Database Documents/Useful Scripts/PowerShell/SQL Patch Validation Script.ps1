##################################
#Check SQL services
$server = $env:computername
$object = Get-service -ComputerName $server  | where {($_.name -like "MSSQL$*" -or $_.name -like "MSSQLSERVER" -or $_.name -like "SQL Server (*") }
if ($object){
  $instDetails= $object |select Name,Status
  $instDetails
}else{
  Write-Host "0 SQL Server instances discovered"
}
##################################
#Monitoring the health of an Availability Group
#Replace Instance Name and AGName
Import-Module SQLPS -DisableNameChecking

$instanceName = "azsappdb11\PA1DB"
$AGName = "SAPPA1AG"

#Test availability database replica state health
$AGReplicaStatePath = "SQLSERVER:\SQL\$($instanceName)\AvailabilityGroups\$($AGName)\DatabaseReplicaStates"

Get-ChildItem $AGReplicaStatePath |
Test-SqlDatabaseReplicaState

###################################
#Check SQL Server Database Status
$sqlinstance = "azsappdb11\PA1DB"

$query = "SELECT name, state_desc as Database_status  FROM sys.databases"
Invoke-Sqlcmd -ServerInstance $sqlinstance -Query $query