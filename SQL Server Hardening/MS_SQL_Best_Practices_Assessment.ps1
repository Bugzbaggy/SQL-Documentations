<#
    .NOTES 
    Name: SQL Assessment API
    Author: Renz Marion Bagasbas
	            
    .DESCRIPTION 
        Microsoft's Best Practices Checker provides a mechanism to evaluate the configuration of SQL Servers, Azure SQL VMs, and Managed Instances for best practices both server and database level.

        YOU WILL NEED TO LIST DOWN ALL SQL SERVERS IN THE SOURCE FILE
#> 


$dbservers = Get-Content "C:\Temp\test.txt" #List of all SQL servers

$outputarray = @()
ForEach($server in $dbservers){
    Write-host -nonewline "."
    $SQLService = (Get-service -ComputerName $server | where {($_.displayname -like "SQL Server (*") }).Name
    $ServerInstanceSplit = $SQLService.Split("$")
    $InstanceName = $server + '\' + $ServerInstanceSplit[1]
    
        $StartDate = Get-Date
		Write-Host "
		##########################################
		SQL Vulnerability Assessment initiated for $InstanceName...
		Time Script Started $StartDate" -ForegroundColor Green

       If($Service.Status -ne "Running"){
		
        Start-Service -Name $SQLService
        # Running server scope rules
		Get-SqlInstance -ServerInstance $($InstanceName) | 
		Invoke-SqlAssessment -FlattenOutput |
		Write-SqlTableData -ServerInstance 'azsapqdb01\QE2DB' -DatabaseName SQLAssessment -SchemaName bpc -TableName Results -Force
        #Change the SQL server instance for the preferred location of assessment result

		# Running database scope rules
		Get-SqlDatabase -ServerInstance $($InstanceName) | 
		Invoke-SqlAssessment -FlattenOutput |
		Write-SqlTableData -ServerInstance 'azsapqdb01\QE2DB' -DatabaseName SQLAssessment -SchemaName bpc -TableName Results -Force 
        #Change the SQL server instance for the preferred location of assessment result

       }
       ElseIf($Service.Status -eq "Running"){
       
        # Running server scope rules
		Get-SqlInstance -ServerInstance $($InstanceName) | 
		Invoke-SqlAssessment -FlattenOutput |
		Write-SqlTableData -ServerInstance 'azsapqdb01\QE2DB' -DatabaseName SQLAssessment -SchemaName bpc -TableName Results -Force
		#Change the SQL server instance for the preferred location of assessment result

		# Running database scope rules
		Get-SqlDatabase -ServerInstance $($InstanceName) | 
		Invoke-SqlAssessment -FlattenOutput |
		Write-SqlTableData -ServerInstance 'azsapqdb01\QE2DB' -DatabaseName SQLAssessment -SchemaName bpc -TableName Results -Force
        #Change the SQL server instance for the preferred location of assessment result
		
       }
	
    $EndDate = Get-Date
    $Time = $EndDate - $StartDate
    Write-Host "
    ##########################################
    Assessment results for $InstanceName saved...
    Time Script ended at $EndDate and took
    $Time" -ForegroundColor Green	  
    
    }

   

