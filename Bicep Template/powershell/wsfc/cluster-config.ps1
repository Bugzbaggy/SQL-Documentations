
# Requirements
Install-WindowsFeature -Name Failover-Clustering -IncludeManagementTools -Restart


#Create Cluster
# Requires "Create Computer Objects on the OU in AD, to the person doing the configuration."
# Once cluster is installed, remove that permission again from named person, and switch to cluster computer object fx. saplmpdbcl$
$clusterName = 'sapqbjdbcl' # <-- Change this!
$clusterNodes = "azsapqdb14.vestas.net", "azsapqdb15.vestas.net" # <-- Change this!
New-Cluster -Name $clusterName -node $clusterNodes -NoStorage

## Post Configurations 
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters' -Name "KeepAliveTime" -Value "120000" -PropertyType DWord
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters' -Name "KeepAliveInterval" -Value "120000" -PropertyType DWord
(get-cluster).SameSubnetThreshold = 15
(get-cluster).SameSubNetDelay = 2000

## Cloud Witness - https://docs.microsoft.com/en-us/windows-server/failover-clustering/deploy-cloud-witness#to-view-and-copy-storage-access-keys
$cloudWitnessName = Read-Host -Prompt "what is the account name of the storage account?"
$cloudWitnessKey = Read-Host -Prompt "Enter storage account key from storage account."

Set-ClusterQuorum -CloudWitness -AccountName $cloudWitnessName -AccessKey $cloudWitnessKey


