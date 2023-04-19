<#
    .NOTES 
    Name: SQL patching of stand alone servers
    Author: Renz Marion Bagasbas
	Modified by: Lexter Gapuz
	Contributor: Nikolai Ramos
            
    .DESCRIPTION 
        This step will automatically install SQL patch to all stand alone SQL servers

        YOU WILL NEED TO LIST DOWN ALL SQL SERVERS IN THE SOURCE FILE
#> 


$servers = Get-Content "C:\Temp\primary.txt" #List of all stand alone SQL servers

$sqlpatch = “D:\SQLServer2017-KB5021126-x64.exe” #KB file name here

$outputarray = @()
ForEach($server in $servers){
    
    $SQLService = (Get-service -ComputerName $server | where {($_.displayname -like "SQL Server (*") }).Name
    $ServerInstanceSplit = $SQLService.Split("$")
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


       }
       ElseIf($Service.Status -eq "Running"){
       
        $proc=Get-WmiObject -list Win32_Process -EnableAllPrivileges -computer $server
        $proc.create("$sqlpatch /action=patch /allinstances /IAcceptSQLServerLicenseTerms /Quiet")
        
       }
	  
	    $StartDate = Get-Date
		Write-Host "
		##########################################
		Patch installattion initiated...
		Time Script Started $StartDate
		Kindly execute post validation script after several minutes" -ForegroundColor Green
    
    }
   #Write-Output $outputarray
   #$outputarray | Export-Csv -path "D:\PatchVersion.csv" -nti
   #notepad 'D:\PatchVersion.csv'
   
   