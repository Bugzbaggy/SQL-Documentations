$servers = Get-Content "C:\Temp\primary.txt"

#$sqlpatch = “D:\SQLServer2017-KB5021126-x64.exe” 

$outputarray = @()
ForEach($server in $servers){
    #$Service = Get-service -ComputerName $server | where {($_.displayname -like "SQL Server (*") }
    
   $SQLService = (Get-service -ComputerName $server | where {($_.displayname -like "SQL Server (*") }).Name
   $ServerInstanceSplit = $SQLService.Split("$")
    #$Instance = ($server |% {Get-ChildItem -Path "SQLSERVER:\SQL\$_"}).Name
    $SQLVersion = (Invoke-Sqlcmd -Query "SELECT SUBSTRING(@@VERSION,0,53);" -ServerInstance $InstanceName).Column1
    $LogTime = Get-Date -Format "yyyy-MM-dd hh:mm:ss"
    $InstanceName = $server + '\' + $ServerInstanceSplit[1]
    
       $Objt = New-Object PSObject
       $Objt | Add-Member -MemberType NoteProperty -Name ComputerName -Value $server.ToUpper()
       $Objt | Add-Member -MemberType NoteProperty -Name InstanceName -Value $InstanceName.ToUpper()
       #$Objt | Add-Member -MemberType NoteProperty -Name Status -Value $Service.Status
       #$Objt | Add-Member -MemberType NoteProperty -Name DisplayName -Value $Service.DisplayName
       $Objt | Add-Member -MemberType NoteProperty -Name LogTime -Value $LogTime
       $Objt | Add-Member -MemberType NoteProperty -Name SQLVersion -Value $SQLVersion
       $outputarray += $Objt

       If($Service.Status -ne "Running"){

        Start-Service -Name $SQLService
        $proc=Get-WmiObject -list Win32_Process -EnableAllPrivileges -computer $server
        $proc.create("$sqlpatch /action=patch /allinstances /IAcceptSQLServerLicenseTerms /Quiet")
        #& $sqlpatch /qs /IAcceptSQLServerLicenseTerms /Action=Patch /AllInstances

       }
       ElseIf($Service.Status -eq "Running"){
       
        $proc=Get-WmiObject -list Win32_Process -EnableAllPrivileges -computer $server
        $proc.create("$sqlpatch /action=patch /allinstances /IAcceptSQLServerLicenseTerms /Quiet")
        
       }
    
    }
   #Write-Output $outputarray
   #$outputarray | Export-Csv -path "D:\PatchVersion.csv" -nti
   #notepad 'D:\PatchVersion.csv'
   
   