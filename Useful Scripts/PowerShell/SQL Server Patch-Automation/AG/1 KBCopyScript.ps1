<#
    .NOTES 
    Name: Distribute KB file to all SQL servers
    Author: Lexter Gapuz
	Modified by: Renz Marion Bagasbas
	Contributor: Nikolai Ramos
    
    .DESCRIPTION 
        Distribute copy of KB file to all SQL servers

        YOU WILL NEED TO LIST DOWN ALL SQL SERVERS IN THE SOURCE FILE
#> 

$computers = Get-Content "C:\Temp\SQLServer.txt" #List of all SQL servers
$fileToCopy = "C:\temp\test.txt" #KB file here
ForEach($computer in $Computers){
    $StartDate = Get-Date
	Write-Host "
	##########################################
	Distribution of KB file started...
	Time Script Started $StartDate" -ForegroundColor Green
	
	Copy-Item -Path $fileToCopy -Destination "\\$computer\D$\" #Destination path where the KB file will be stored

	$EndDate = Get-Date
	$Time = $EndDate - $StartDate
	Write-Host "
	##########################################
	Distribution of KB file at $computer completed...
	Time Script ended at $EndDate and took
	$Time" -ForegroundColor Green
}
