$disk = @(
#disk1
[pscustomobject]@{
driveLetter = 'E';
storagePoolName = 'SQL_BIN';
driveName = 'SQL_BIN';
deviceID = '2';
sqlDisk = 'True'
}
#disk2
[pscustomobject]@{
driveLetter = 'F';
storagePoolName = 'SQL036 MsSQLData';
driveName = 'SQL036 MsSQLData';
deviceID = '3';
sqlDisk = 'True'
}
#disk3
[pscustomobject]@{
driveLetter = 'G';
storagePoolName = 'SQL036 MsSQLlog';
driveName = 'SQL036 MsSQLlog';
deviceID = '4';
sqlDisk = 'True'
}
#disk4
[pscustomobject]@{
driveLetter = 'H';
storagePoolName = 'SQL036 MsSQLtemp';
driveName = 'SQL036 MsSQLtemp';
deviceID = '5';
sqlDisk = 'True'
}
)

foreach($d in $disk)
{

if ($d.sqlDisk -eq 'True'){
$disks = Get-PhysicalDisk -CanPool $true -DeviceNumber $d.deviceID
New-StoragePool -FriendlyName $d.storagePoolName -PhysicalDisks $disks -ResiliencySettingNameDefault Simple -StorageSubSystemFriendlyName "Windows Storage*" -ProvisioningTypeDefault Fixed | 
New-VirtualDisk -FriendlyName $d.storagePoolName -UseMaximumSize -ResiliencySettingName Simple | 
Initialize-Disk -PartitionStyle GPT -PassThru |
New-Partition -DriveLetter $d.driveLetter -UseMaximumSize |
Format-Volume -NewFileSystemLabel $d.driveName -AllocationUnitSize 65536 -UseLargeFRS
}

else
{
$disks = Get-PhysicalDisk -CanPool $true -DeviceNumber $d.deviceID
New-StoragePool -FriendlyName $d.storagePoolName -PhysicalDisks $disks -ResiliencySettingNameDefault Simple -StorageSubSystemFriendlyName "Windows Storage*" -ProvisioningTypeDefault Fixed | 
New-VirtualDisk -FriendlyName $d.storagePoolName -UseMaximumSize -ResiliencySettingName Simple | 
Initialize-Disk -PartitionStyle GPT -PassThru |
New-Partition -DriveLetter $d.driveLetter -UseMaximumSize |
Format-Volume -NewFileSystemLabel $d.driveName
}
}
