<#
    .NOTES 
    Name: Restart servers
    Author: Renz Marion Bagasbas
	Modified by: Lexter Gapuz
	Contributor: Nikolai Ramos
        
    .DESCRIPTION 
        Automatically restart servers after SQL patch installation

        YOU WILL NEED TO LIST DOWN ALL SQL SERVERS IN THE SOURCE FILE
#> 

$computers = Get-Content "C:\Temp\primary.txt" #List of all stand alone SQL servers
ForEach($computer in $Computers){
    restart-computer -computername $computer -force
	
	Write-Host "
		##########################################
		All machines has been rebooted...
		Kindly execute final validation script
		to check database status and latest SQL version" -ForegroundColor Green
	
}
