function Get-VmInfo {       
    try {
        $info = Get-ComputerInfo
        $firewallConfig = Get-NetFirewallProfile -Name Domain
        
        


    }
    catch {
        Write-Error $_ -ErrorAction stop

    }

    $obj = [PSCustomObject]@{
        csName   = $info.CsName 
        csDomain = $info.CsDomain 
        timeZone = $info.TimeZone 
        domainProfileAction = $firewallConfig.DefaultInboundAction
        RAM     = $info.CsPhysicallyInstalledMemory 
    }

    Write-Output $obj      
}

