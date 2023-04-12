Import-Module SQLPS -DisableNameChecking

$instanceName = "azsappdb11\PA1DB"
$AGName = "SAPPA1AG"

#SMO server object
$server = New-Object Microsoft.SqlServer.Management.Smo.Server  $instanceName

#test availability group health
$AGPath = "SQLSERVER:\SQL\$($instanceName)\DEFAULT\AvailabilityGroups\$($AGName)"
Test-SqlAvailabilityGroup -Path $AGPath

#check all AG properties using SMO
$server.AvailabilityGroups[$AGName] |
Select-Object *

#test availability replica health
$AGReplicaPath = "SQLSERVER:\SQL\$($instanceName)\DEFAULT\AvailabilityGroups\$($AGName)\AvailabilityReplicas\$($instanceName)"
Test-SqlAvailabilityReplica -Path $AGReplicaPath

#check availability replica properties using SMO
$server.AvailabilityGroups[$AGName].AvailabilityReplicas | Select-Object *

#test availability database replica state health
$AGReplicaStatePath = "SQLSERVER:\SQL\$($instanceName)\DEFAULT\AvailabilityGroups\$($AGName)\DatabaseReplicaStates"

Get-ChildItem $AGReplicaStatePath |
Test-SqlDatabaseReplicaState

#check database replica state properties using SMO
$server.AvailabilityGroups[$AGName].DatabaseReplicaStates | Select-Object *