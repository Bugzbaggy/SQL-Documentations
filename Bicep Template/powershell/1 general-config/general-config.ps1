function Set-PageFile {
    
    # RAM in System (MB)
        ## Size of D:\ (MB)
        $ram = (Get-ComputerInfo).CsPhyicallyInstalledMemory / 1KB ## Calculates the total server memory in MB
        $SAPPageFile = $ram * 1.5 ## Requirements for SAP is 1.5 of total server memory
        $diskSize = (Get-Volume -DriveLetter D).Size / 1MB
        
        if ($SAPPageFile -gt $diskSize) {
            Write-Host "Temporary Disk is less than calculated Page File size" -ForegroundColor Yellow
        } 
    
        $Pagefile = Get-WmiObject Win32_PagefileSetting | Where-Object {$_.name -eq "D:\pagefile.sys"}
        $Pagefile.InitialSize = $SAPPageFile / 2
        $Pagefile.MaximumSize = $SAPPageFile
        $Pagefile.put()
    }

Write-Host "Setting Page File..." -ForegroundColor Green
Set-PageFile

Write-Host "Setting timezone to Copenhagen timezone..." -ForegroundColor Green
Set-TimeZone -name "Romance Standard Time"

Write-Host "Allowing traffic through the Windows Firewall Domain Profile..." -ForegroundColor Green
Set-NetFirewallProfile -Name Domain -DefaultInboundAction Allow

Write-Host "Changing the DVD drive to B:\..." -ForegroundColor Green
$cd = $NULL
$cd = Get-WMIObject -Class Win32_CDROMDrive -ComputerName $env:COMPUTERNAME -ErrorAction Stop 
if ($cd.Drive -eq "E:")
{
   Write-Output "Changing CD Drive letter from E: to B:"
   Set-WmiInstance -InputObject ( Get-WmiObject -Class Win32_volume -Filter "DriveLetter = 'E:'" ) -Arguments @{DriveLetter='B:'}
}
