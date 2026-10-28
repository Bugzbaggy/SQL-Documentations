param loadbalanceconfig array
param lbName string
param lbEnv string
param SID string
// param healthProbePort int

param location string = resourceGroup().location



@description('Name of the resource group containing the subnet')
param networkResourceGroup string
@description('Name of the VNET for the VMs to be attached to. Currently only supports one input for all VMs')
param networkVnet string
@description('Name of the subnet for the VMs to be attached to. Currently only supports one input for all VMs')


var appSubnetName = 'application-${lbEnv}-subnet'
resource app_subnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' existing = {
  name: '${networkVnet}/${appSubnetName}'
  scope: resourceGroup(networkResourceGroup)
}

var dbSubnetName = 'database-${lbEnv}-subnet'
resource dbms_subnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' existing = {
  name: '${networkVnet}/${dbSubnetName}'
  scope: resourceGroup(networkResourceGroup)
}


resource loadBalancerInternal 'Microsoft.Network/loadBalancers@2020-11-01' = {
  name: lbName
  location: location
  sku: {
    name:'Standard'
    tier: 'Regional'
  }
  properties:{
    frontendIPConfigurations: [for (lbcon, l) in loadbalanceconfig:   {
      // 1st instance
      name: 'sap-${SID}-${lbcon.name}'
      properties:{
        privateIPAllocationMethod: 'Static'
        privateIPAddress: lbcon.FrontEndIP
        privateIPAddressVersion: 'IPv4'
        subnet:{
          id: lbcon.loadbal_subnet == 'app' ? app_subnet.id : dbms_subnet.id
          }
        
      }
      zones: [
        '1'
        '2'
        '3'
      ]
    } ]
  
  probes: [for (lbcon, l) in loadbalanceconfig:    {
      name: 'sap-${SID}-${lbcon.name}-probe'
      properties:{
        port: lbcon.port
        protocol: 'Tcp'
        intervalInSeconds: 5
        numberOfProbes: 2
      }
    } ]
  
  backendAddressPools: [for (lbcon, l) in loadbalanceconfig:    {
      name: 'sap-${SID}-${lbcon.name}-backend'
      properties: {
          }
  }]
  loadBalancingRules: [for (lbcon, l) in loadbalanceconfig:    {
      name: 'sap-${SID}-${lbcon.name}-lb'
      properties: {
        frontendIPConfiguration: {
          id: resourceId('Microsoft.Network/loadBalancers/frontendIpConfigurations', lbName, 'sap-${SID}-${lbcon.name}')
        }
        frontendPort: 0
        backendPort: 0
        enableFloatingIP: true
        idleTimeoutInMinutes: 30
        protocol: 'All'
        enableTcpReset: false
        loadDistribution: 'Default'
        disableOutboundSnat: true
        backendAddressPool: {
          id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', lbName, 'sap-${SID}-${lbcon.name}-backend')
        }
        probe: {
          id: resourceId('Microsoft.Network/loadBalancers/probes', lbName, 'sap-${SID}-${lbcon.name}-probe')
        }
      }
    }]
}
}
