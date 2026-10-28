$server = $env:computername 
$object = Get-service -ComputerName $server  | where {($_.displayname -like "SQL Server (*") } 
if ($object){ 
  $instDetails= $object |select Name,Status 
  $instDetails 
}else{ 
  Write-Host "0 SQL Server instances discovered" 
} 