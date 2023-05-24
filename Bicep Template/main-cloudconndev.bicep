targetScope = 'subscription'

// Take Input from Build Sheet
param SID string = 'CLOUDCONNECTOR'
param ApplicationName string = 'SAP Cloud Connector - Dev'

var SIDLower = toLower(SID)
var proximityGroupZone1Name = 'sap-${SIDLower}-1-${deploymentEnvironment}-ppg'
var rgName  = 'sap-${SIDLower}-${deploymentEnvironment}-rg'
param location string = 'westeurope'

@allowed([
  'prd'
  'tst'
  'dev'
])
param deploymentEnvironment string = 'dev'

/*SAP Parameters*/

@allowed([
  'Production'
  'Test'
  'Development'
  'Sandbox'
  'Pilot'
  'QA'
])
param sapEnvironment string = 'Development'

param appServers array = [
  {
    vmName: 'azsapd033' 
    computerName: 'azsapd033'
    vmSize: 'Standard_E4as_V4'
    adminUserName: 'sapvmadmin'
    adminPassword: newGuid()
    operatingSystem: 'Server2019'
    availabilityZone: '1'
    UsePPG: true
    networkSubnet: 'application-${deploymentEnvironment}-subnet'
    enableAcceleratedNetworking: true
    useStaticIP: true
    networkTags: 'AZ-WEU-SAP-DEV-APP-CLOUDCON'
    IPConfiguration: [
      {
        name: 'ipconfig1'
        primaryIP: true
        IPAddress: '10.192.96.110'
      }

    ]
    dataDisks: [
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'StandardSSD_LRS'
        diskSizeGB: 64
      }
    
    ]
  } 

]

module ppg_zone1 'modules/network/ppg.bicep' = {
  name: '${proximityGroupZone1Name}-deploy'
  scope: resourceGroup(rg.name)
  params: {
    location: location
    ppgName: proximityGroupZone1Name
  }
}

@description('Name of the resource group containing the subnet')
param networkResourceGroup string = 'sap-${deploymentEnvironment}-rg'
@description('Name of the VNET for the VMs to be attached to. Currently only supports one input for all VMs')
param networkVnet string = 'sap-${deploymentEnvironment}-vnet'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
  tags: {
    ApplicationName : ApplicationName
    SAPSID : SID
    SAPEnvironment : sapEnvironment
  }
}

module appservers 'modules/vm.bicep' = [for (server, i) in appServers: {
  name: '${server.vmName}'
  scope: resourceGroup(rg.name)
  params: {
    location: location
    vmName: '${server.vmName}'
    environment: deploymentEnvironment
    computerName: server.computerName
    adminPassword: server.adminPassword
    adminUserName: server.adminUserName
    domainJoin: false
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
  dependsOn: [
    ppg_zone1
  ]
}]

