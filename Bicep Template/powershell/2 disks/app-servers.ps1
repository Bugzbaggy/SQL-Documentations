$disks = Get-PhysicalDisk -CanPool $true
$storagePoolName = "SAP Application"
New-StoragePool -FriendlyName $storagePoolName -PhysicalDisks $disks -ResiliencySettingNameDefault Simple -StorageSubSystemFriendlyName "Windows Storage*" -ProvisioningTypeDefault Fixed | 
New-VirtualDisk -FriendlyName $storagePoolName -UseMaximumSize -ResiliencySettingName Simple | 
Initialize-Disk -PartitionStyle GPT -PassThru |
New-Partition -DriveLetter E -UseMaximumSize |  
Format-Volume -NewFileSystemLabel "Local Disk E_Data"
