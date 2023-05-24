
param webServers array = [
  {
    vmName: 'sap-ye1-dev-wd02' /*Control with naming convention later on*/
    computerName: 'azsapdwd02'
    vmSize: 'Standard_E4as_V4'
    adminUserName: 'sapvmadmin'
    adminPassword: newGuid()
    operatingSystem: 'Server2019'
    sapSid: 'wd1'
    availabilityZone: '3'
    networkSubnet: 'web-dev-subnet'
    enableAcceleratedNetworking: true
    dataDisks: [
      {
        createOption: 'empty'
        caching: 'None'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 32
      }
      {
        createOption: 'Attach'
        caching: 'None'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 32
      }
    ]
  }

]


param location string = resourceGroup().location

/*SAP Parameters*/

@allowed([
  'Production'
  'Test'
  'Development'
  'Sandbox'
])
param deploymentEnvironment string

@description('Name of the resource group containing the subnet')
param networkResourceGroup string = 'sap-dev-rg'
@description('Name of the VNET for the VMs to be attached to. Currently only supports one input for all VMs')
param networkVnet string = 'sap-dev-vnet'


module ascsloadbalancer 'modules/network/loadbalancer.bicep' = {
  name: 'ascs-loadbalancer'
  params: {
    location: location
    lbName: 'sap-ye1-dev-lb'
    networkResourceGroup: networkResourceGroup
    networkVnet: networkVnet
  }
}


module cloudwitness 'modules/storage/storage-account.bicep' = {
  name: 'wsfc-cloudwitness'
  params: {
    storageAccountName: 'vestassapye1devcw'
    location:location
  }
}


module webservers 'modules/vm.bicep' = [for (server, i) in webServers: {
  name: 'vm-${server.vmName}-${i}'
  params: {
    location: location
    vmName: '${server.vmName}-${i}'
    environment: deploymentEnvironment
    computerName: server.computerName
    adminPassword: server.adminPassword
    adminUserName: server.adminUserName
    networkResourceGroup: networkResourceGroup
    networkSubnet: server.networkSubnet
    networkVnet: networkVnet
    operatingSystem: server.operatingSystem
    vmSize: server.vmSize
    enableAcceleratedNetworking: server.enableAcceleratedNetworking
    availabilityZone: server.availabilityZone
    dataDisks: server.dataDisks
  }
}]

