$servers = Get-Content "C:\Temp\SQLServerList.txt"

$outputarray = @()
ForEach($server in $servers){
    $Service = Get-service -ComputerName $server | where {($_.displayname -like "SQL Server (*") }
    $SQLVersion = Invoke-Sqlcmd -Query "SELECT @@VERSION;" -ServerInstance $server | Format-List

       If($Service.Status -ne "Running"){

        Start-Service -Name $Service.Name

       }Else{

       
       $Objt = New-Object PSObject
       $Objt | Add-Member -MemberType NoteProperty -Name ComputerName -Value $server.ToUpper()
       $Objt | Add-Member -MemberType NoteProperty -Name Status -Value $Service.Status
       $Objt | Add-Member -MemberType NoteProperty -Name DisplayName -Value $Service.DisplayName
       #$Objt | Add-Member -MemberType NoteProperty -Name SQLVersion -Value $SQLVersion
       $outputarray += $Objt

       }

    
    }
    Write-Output $outputarray