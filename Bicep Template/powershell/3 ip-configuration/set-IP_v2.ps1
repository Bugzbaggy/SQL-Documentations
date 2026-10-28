# Rework this into getting the IP configuration from IMDS and assigning the IPs that way through. 

$logicalIPs = '10.71.50.30'
$logicalHostNames = "sapp11db01","sapp11db01.vestas.net"

#####################################################################################
$interface = Get-NetAdapter | ?{$_.Name -match 'Ethernet*' -and $_.InterfaceDescription -match 'Microsoft Hyper-V Network Adapter*'}
$PrimaryIP = (Get-NetIPAddress -InterfaceIndex $interface.ifIndex | ?{$_.AddressFamily -eq 'IPv4'}).IPAddress
$defaultGateway = ((Get-NetIPConfiguration -InterfaceIndex $interface.ifIndex).IPv4DefaultGateway).nextHop
Set-NetIPInterface -InterfaceIndex $interface.ifIndex -Dhcp Disabled
if (($defaultGateway -eq '10.192.96.1') -or ($defaultGateway -eq '10.71.48.1') -or ($defaultGateway -eq '10.193.28.1')) {
New-NetIPAddress -InterfaceIndex $interface.ifIndex -AddressFamily IPv4 -IPAddress $PrimaryIP -PrefixLength 23 -DefaultGateway $defaultGateway
foreach ($IPs in $logicalIPs) {
New-NetIPAddress -InterfaceIndex $interface.ifIndex -AddressFamily IPv4 -IPAddress $IPs -PrefixLength 23 -SkipAsSource $true
}
}
else {
New-NetIPAddress -InterfaceIndex $interface.ifIndex -AddressFamily IPv4 -IPAddress $PrimaryIP -PrefixLength 24 -DefaultGateway $defaultGateway
foreach ($IPs in $logicalIPs) {
New-NetIPAddress -InterfaceIndex $interface.ifIndex -AddressFamily IPv4 -IPAddress $IPs -PrefixLength 24 -SkipAsSource $true
}
}

Set-DnsClientServerAddress -InterfaceIndex $interface.ifIndex -ServerAddresses "10.0.10.80", "10.0.10.81" -PassThru

# Configure IP addresses for Logical Host Names, those should always be set to SkipAsSource

# Change the values here based on the number of Logical Host Names defined

New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0' -Name "BackConnectionHostNames" -Value $logicalHostNames -PropertyType MultiString
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters' -Name "DisableStrictNameChecking" -Value "1" -PropertyType DWord