
param webServers array = [
  {
    vmName: 'sap-wd0-dev-wd01' /*Control with naming convention later on*/
    computerName: 'azsapdwd01'
    vmSize: 'Standard_E4as_V4'
    adminUserName: 'sapvmadmin'
    adminPassword: newGuid()
    operatingSystem: 'Server2019'
    sapSid: 'wd0'
    availabilityZone: '2'
    networkSubnet: 'web-dev-subnet'
    enableAcceleratedNetworking: true
    dataDisks: [
      {
        createOption: 'empty'
        caching: 'None'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 64
      }
    ]
  }
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
        diskSizeGB: 64
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



module webservers 'modules/vm.bicep' = [for (server, i) in webServers: {
  name: 'vm-${server.vmName}'
  params: {
    location: location
    vmName: '${server.vmName}'
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

