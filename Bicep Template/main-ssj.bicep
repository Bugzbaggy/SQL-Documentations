

param sqlServers array = [
  {
    vmName: 'azsapd004' 
    computerName: 'azsapd004'
    vmSize: 'Standard_E4as_V4'
    adminUserName: 'sapvmadmin'
    adminPassword: newGuid()
    operatingSystem: 'Server2019'
    sapSid: 'SSJ'
    availabilityZone: '1'
    networkSubnet: 'application-dev-subnet'
    enableAcceleratedNetworking: true
    useStaticIP: true
    IPConfiguration: [
      {
        name: 'ipconfig1'
        primaryIP: true
        IPAddress: '10.192.96.18'
      }
      {
        name: 'sap-logical-hostname-sapssj'
        primaryIP: false
        IPAddress: '10.192.96.19'
      }
      {
        name: 'sap-logical-hostname-sapssjapp01'
        primaryIP: false
        IPAddress: '10.192.96.20'
      }
    ]
    dataDisks: [
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'StandardSSD_LRS'
        diskSizeGB: 256
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



module sqlservers 'modules/vm.bicep' = [for (server, i) in sqlServers: {
  name: '${server.vmName}'
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
    useStaticIP: server.UseStaticIP
    IPConfiguration: server.IPConfiguration
    availabilityZone: server.availabilityZone
    isSqlVM: false
    dataDisks: server.dataDisks
  }
}]
