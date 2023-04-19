<#
    .NOTES 
    Name: Post-validation script
    Author: Renz Marion Bagasbas
	Modified by: Lexter Gapuz
	Contributor: Nikolai Ramos
    
    .DESCRIPTION 
        Post-validation script to check database status and latest SQL version installed

        YOU WILL NEED TO LIST DOWN ALL SQL SERVERS IN THE SOURCE FILE
#> 

$servers = Get-Content "C:\Temp\sa.txt" #List of all stand alone SQL servers

$outputarray = @()
$InstanceName = @()
ForEach($server in $servers){
        
    $SQLServices = (Get-service -ComputerName $server | where {($_.displayname -like "SQL Server (*") }).Name
    $SQLVersion = (Invoke-Sqlcmd -Query "SELECT SUBSTRING(@@VERSION,0,68);" -ServerInstance $InstanceName).Column1
    $LogTime = Get-Date -Format "yyyy-MM-dd hh:mm:ss"

    Foreach($SQLService in $SQLServices){
    $ServerInstanceSplit = $SQLService.Split("$")
    $InstanceName += $server + '\' + $ServerInstanceSplit[1]
    }
			
	ForEach($Instance in $InstanceName){
       
       $DBstates = Invoke-Sqlcmd -Query "SELECT name as DBName, state_desc AS Status
	    FROM sys.databases db
	    WHERE db.database_id NOT IN ('1','2','3','4')" -ServerInstance "$Instance"
	   $Objt = New-Object PSObject
       $Objt | Add-Member -MemberType NoteProperty -Name ComputerName -Value $server.ToUpper()
       $Objt | Add-Member -MemberType NoteProperty -Name InstanceName -Value $Instance.ToUpper()
       $Objt | Add-Member -MemberType NoteProperty -Name DBName -Value $DBstates.DBName.ToUpper()
       $Objt | Add-Member -MemberType NoteProperty -Name Status -Value $DBstates.Status.ToUpper()
       $Objt | Add-Member -MemberType NoteProperty -Name LogTime -Value $LogTime
       $Objt | Add-Member -MemberType NoteProperty -Name SQLVersion -Value $SQLVersion
       $outputarray += $Objt
    }   
	}
outputarray | FT
#Write-Output $outputarray
#$outputarray | Export-Csv -path "D:\SA_PatchVersionLatest.csv" -nti
#notepad 'D:\SA_PatchVersionLatest.csv'
   
   