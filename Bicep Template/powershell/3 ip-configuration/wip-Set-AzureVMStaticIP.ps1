function Set-AzureVMStaticIP {
    param (
        # Comma Seperated list of logical host names, used to setting the Back Connections
        [Parameter()]
        [array]
        $logicalHostNames,
        # Comma Seperated list of DNS Servers
        [Parameter()]
        [array]
        $DNSServers,
        # Name of the Interface to configure the IP configurations on. 
        [Parameter(AttributeValues)]
        [string]
        $InterfaceName
    )

    $ErrorActionPreference = 'Stop'

    # Gets the json object from IMDS - As Windows Server 2019 does not ship with PS6+, we're using the less optimal approach. 
    $Proxy=New-Object System.Net.WebProxy
    $WebSession=New-Object Microsoft.PowerShell.Commands.WebRequestSession
    $WebSession.Proxy=$Proxy
    $json = Invoke-RestMethod -Headers @{"Metadata"="true"} -Method GET -Uri "http://169.254.169.254/metadata/instance?api-version=2021-02-01" -WebSession $WebSession 

    $network = $json.network.interface.IPv4
    $subnetMask = $network.subnet.prefix
    $interface = Get-NetAdapter -name $InterfaceName
    $ifIndex = interface.ifIndex

    $defaultGW = (Get-NetIPConfiguration -InterfaceIndex $interface.ifIndex)
    
    try {
        Write-Host -ForegroundColor Green "Setting the primary IP on the network adapter $interface"
        
        $primaryIP = $network.IpAddress[0]
        Set-NetIPInterface -InterfaceIndex $ifIndex -Dhcp Disabled
        New-NetIPAddress -InterfaceIndex $ifIndex -AddressFamily IPv4 -IPAddress $primaryIP -PrefixLength $subnetMask -DefaultGateway $defaultGW
        Set-DnsClientServerAddress -InterfaceIndex $ifIndex -ServerAddresses $DNSServers -PassThru
    }
    catch {
        Write-Host "An error has occurred while attempting to set the primary IP configurations."
        Write-Host $_
    }

    try {
        Write-Host -ForegroundColor Green "Setting the IP configurations for logical host names"

        $logicalHostIPs = $network.IpAddress.privateIpAddress[+1..255] # by using +1 we skip the first value in the array, which is the primary IP. 
        
        foreach ($hostnameIP in $logicalHostIPs) {
            
            Write-Host $hostnameIP
            # Configure IP addresses for Logical Host Names, those should always be set to SkipAsSource
            New-NetIPAddress -InterfaceIndex $ifIndex -AddressFamily IPv4 -IPAddress $hostnameIP -PrefixLength $subnetMask -SkipAsSource $true
        }
    }
    catch {
        Write-Host "An error has occurred while attempting to set the secondary IP configurations."
        Write-Host $_
    }

    


# # Change the values here based on the number of Logical Host Names defined
New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0' -Name "BackConnectionHostNames" -Value $logicalHostNames -PropertyType MultiString
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters' -Name "DisableStrictNameChecking" -Value "1" -PropertyType DWord
        
}
##Example
# Set-AzureVMStaticIP -InterfaceName "Ethernet" -DnsServers "10.0.10.80", "10.0.10.81" -logicalHostNames "sapSID","sapSID.vestas.net","SAPSIDapp01","SAPSIDapp01.vestas.net"

Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0' -Name "BackConnectionHostNames"