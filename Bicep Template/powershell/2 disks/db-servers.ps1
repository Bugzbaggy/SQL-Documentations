$disks = Get-PhysicalDisk -CanPool $true -DeviceNumber 26
$storagePoolName = "D1L MSSQL Data"
$driveLetter = "R"
New-StoragePool -FriendlyName $storagePoolName -PhysicalDisks $disks -ResiliencySettingNameDefault Simple -StorageSubSystemFriendlyName "Windows Storage*" -ProvisioningTypeDefault Fixed | 
New-VirtualDisk -FriendlyName $storagePoolName -UseMaximumSize -ResiliencySettingName Simple | 
Initialize-Disk -PartitionStyle GPT -PassThru |
New-Partition -DriveLetter $driveLetter -UseMaximumSize |  
Format-Volume -NewFileSystemLabel "DK1 MSSQL Data" -AllocationUnitSize 65536 -UseLargeFRS

$disks = Get-PhysicalDisk -CanPool $true -DeviceNumber 24
$storagePoolName = "D1L MSSQL Log"
$driveLetter = "S"
New-StoragePool -FriendlyName $storagePoolName -PhysicalDisks $disks -ResiliencySettingNameDefault Simple -StorageSubSystemFriendlyName "Windows Storage*" -ProvisioningTypeDefault Fixed | 
New-VirtualDisk -FriendlyName $storagePoolName -UseMaximumSize -ResiliencySettingName Simple | 
Initialize-Disk -PartitionStyle GPT -PassThru |
New-Partition -DriveLetter $driveLetter -UseMaximumSize |  
Format-Volume -NewFileSystemLabel "DK1 MSSQL Log" -AllocationUnitSize 65536 -UseLargeFRS