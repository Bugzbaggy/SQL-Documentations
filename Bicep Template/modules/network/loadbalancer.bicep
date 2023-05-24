param lbName string
// param healthProbePort int

param location string = resourceGroup().location



@description('Name of the resource group containing the subnet')
param networkResourceGroup string
@description('Name of the VNET for the VMs to be attached to. Currently only supports one input for all VMs')
param networkVnet string
@description('Name of the subnet for the VMs to be attached to. Currently only supports one input for all VMs')


var appSubnetName = 'application-dev-subnet'
resource app_subnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' existing = {
  name: '${networkVnet}/${appSubnetName}'
  scope: resourceGroup(networkResourceGroup)
}

var dbSubnetName = 'database-dev-subnet'
resource dbms_subnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' existing = {
  name: '${networkVnet}/${dbSubnetName}'
  scope: resourceGroup(networkResourceGroup)
}


resource loadBalancerInternal 'Microsoft.Network/loadBalancers@2020-11-01' = {
  name: lbName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'

  }
  properties: {
  }

}
