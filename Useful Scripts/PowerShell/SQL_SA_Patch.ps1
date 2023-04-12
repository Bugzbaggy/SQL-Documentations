$servers = Get-content 'C:\Temp\SQLServerList.txt'
 foreach($server in $Servers)
	{
		If (test-connection -computername $server -quiet)
		{
			$proc=Get-WmiObject -list Win32_Process -EnableAllPrivileges -computer $server

			$Result= $proc.create("D:\sqlserver2017-kb5013756-x64.exe /action=patch /allinstances /IAcceptSQLServerLicenseTerms /Quiet")

			$output = $LogTime + "patch has been initiated on the server" + $server

			Add-content -path D:\patch_output.txt -value ($output)
		}

		else
		{
		$LogTime = Get-Date -Format "yyyy-MM-dd hh:mm:ss"
		$output = $LogTime + "cannot connect to the server" + $server
		Add-content -path D:\Patchfailed_output.txt -value ($output)
		}
	}
