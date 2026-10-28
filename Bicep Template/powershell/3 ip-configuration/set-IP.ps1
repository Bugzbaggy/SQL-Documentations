# Rework this into getting the IP configuration from IMDS and assigning the IPs that way through. 

$interface = Get-NetAdapter -Name Ethernet
$subnetMask = 23 ## 24 if DB or WEB, 23 if App


Set-NetIPInterface -InterfaceIndex $interface.ifIndex -Dhcp Disabled
New-NetIPAddress -InterfaceIndex $interface.ifIndex -AddressFamily IPv4 -IPAddress "10.192.96.54" -PrefixLength $subnetMask -DefaultGateway "10.192.96.1"
Set-DnsClientServerAddress -InterfaceIndex $interface.ifIndex -ServerAddresses "10.0.10.80", "10.0.10.81" -PassThru

# Configure IP addresses for Logical Host Names, those should always be set to SkipAsSource
New-NetIPAddress -InterfaceIndex $interface.ifIndex -AddressFamily IPv4 -IPAddress "10.192.96.55" -PrefixLength $subnetMask -SkipAsSource $true
New-NetIPAddress -InterfaceIndex $interface.ifIndex -AddressFamily IPv4 -IPAddress "10.192.96.56" -PrefixLength $subnetMask -SkipAsSource $true

# Change the values here based on the number of Logical Host Names defined
$logicalHostNames = "sapd21","sapd21.vestas.net","sapd21app01","sapd21app01.vestas.net"
New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0' -Name "BackConnectionHostNames" -Value $logicalHostNames -PropertyType MultiString
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters' -Name "DisableStrictNameChecking" -Value "1" -PropertyType DWordreg