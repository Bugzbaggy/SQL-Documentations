$instanceName = "azsapqdb10\QK1DB"  
$AGName = "SAPQK1AG"
 
 ####Test availability replica health####
$AGReplicaPath = "SQLSERVER:\SQL\$($instanceName)\AvailabilityGroups\$($AGName)\AvailabilityReplicas"
Get-ChildItem $AGReplicaPath |Format-Table -AutoSize #-Path $AGReplicaPath
 

####Test availability database replica state health####
$AGReplicaStatePath = "SQLSERVER:\SQL\$($instanceName)\AvailabilityGroups\$($AGName)\DatabaseReplicaStates" 
Get-ChildItem $AGReplicaStatePath | Test-SqlDatabaseReplicaState
