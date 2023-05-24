

param proximityGroupZone1Name string = 'sap-sf5-1-dev-ppg'

param appServers array = [
  {
    vmName: 'azsapd005' 
    computerName: 'azsapd005'
    vmSize: 'Standard_E4as_V4'
    adminUserName: 'sapvmadmin'
    adminPassword: newGuid()
    operatingSystem: 'Server2019'
    sapSid: 'SF5'
    availabilityZone: '1'
    UsePPG: true
    networkSubnet: 'application-dev-subnet'
    enableAcceleratedNetworking: true
    useStaticIP: true
    IPConfiguration: [
      {
        name: 'ipconfig1'
        primaryIP: true
        IPAddress: '10.192.96.21'
      }
      {
        name: 'sap-logical-hostname-sapsf5'
        primaryIP: false
        IPAddress: '10.192.96.22'
      }
      {
        name: 'sap-logical-hostname-sapsf5app01'
        primaryIP: false
        IPAddress: '10.192.96.23'
      }
    ]
    dataDisks: [
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'StandardSSD_LRS'
        diskSizeGB: 512
      }
    ]
  }

]

param sqlServers array = [
  {
    vmName: 'azsapddb03' 
    computerName: 'azsapddb03'
    vmSize: 'Standard_E20as_V4'
    adminUserName: 'sapvmadmin'
    adminPassword: newGuid()
    operatingSystem: 'RHELSAPHANA'
    sapSid: 'SF5'
    availabilityZone: '1'
    usePPG: true
    networkSubnet: 'database-dev-subnet'
    enableAcceleratedNetworking: true
    useStaticIP: true
    IPConfiguration: [
      {
        name: 'ipconfig1'
        primaryIP: true
        IPAddress: '10.192.98.8'
      }
      {
        name: 'sap-logical-hostname-sapsf5db'
        primaryIP: false
        IPAddress: '10.192.98.9'
      }
    ]
    dataDisks: [
      {
        createOption: 'empty'
        caching: 'None'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 128
      }
      {
        createOption: 'empty'
        caching: 'None'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 128
      }
      {
        createOption: 'empty'
        caching: 'None'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 128
      }
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
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

module ppg_zone1 'modules/network/ppg.bicep' = {
  name: '${proximityGroupZone1Name}-deploy'
  params: {
    location: location
    ppgName: proximityGroupZone1Name
  }
}

module appservers 'modules/vm.bicep' = [for (server, i) in appServers: {
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
    UsePPG: server.usePPG
    ppgName: proximityGroupZone1Name
    isSqlVM: false
    dataDisks: server.dataDisks
  }
}]

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
    UsePPG: server.usePPG
    ppgName: proximityGroupZone1Name
    isSqlVM: false
    dataDisks: server.dataDisks
  }
}]
