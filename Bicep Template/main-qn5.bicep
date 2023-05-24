targetScope = 'subscription'

// Take Input from Build Sheet
param SID string = 'QN5'
param ApplicationName string = 'SAP BODS'

param SIDLower string = toLower(SID)
param proximityGroupZone1Name string = 'sap-${SIDLower}-1-${deploymentEnvironment}-ppg'
param proximityGroupZone2Name string = 'sap-${SIDLower}-2-${deploymentEnvironment}-ppg'
var rgName  = 'sap-${SIDLower}-${deploymentEnvironment}-rg'
param location string = 'westeurope'

@allowed([
  'prd'
  'tst'
  'dev'
])
param deploymentEnvironment string

/*SAP Parameters*/

@allowed([
  'Production'
  'Test'
  'Development'
  'Sandbox'
  'Pilot'
  'QA'
])
param sapEnvironment string

param sqlServers array = [
     //server3
     {
      vmName: 'azsapqdb19' 
      vmSize: 'Standard_E4as_V4'
      adminUserName: 'sapvmadmin'
      adminPassword: newGuid()
      operatingSystem: 'MSSQL2017WS2019'
      availabilityZone: '1'
      UsePPG: true
      ppgName: proximityGroupZone1Name
      networkSubnet: 'database-${deploymentEnvironment}-subnet'
      enableAcceleratedNetworking: true
      useStaticIP: true
      networkTags: 'AZ-WEU-SAP-QA-APP-BODS'
      sla:'Bronze'
      IPConfiguration: [
        {
          name: 'ipconfig1'
          primaryIP: true
          IPAddress: '10.193.30.41'
        }
       ]
      dataDisks: [
        {
          createOption: 'empty'
          caching: 'ReadOnly'
          writeAcceleratorEnabled: false
          storageAccountType: 'Standard_LRS'
          diskSizeGB: 64
        }
        {
          createOption: 'empty'
          caching: 'ReadOnly'
          writeAcceleratorEnabled: false
          storageAccountType: 'Standard_LRS'
          diskSizeGB: 512
        }
        {
          createOption: 'empty'
          caching: 'ReadOnly'
          writeAcceleratorEnabled: false
          storageAccountType: 'Standard_LRS'
          diskSizeGB: 128
        }
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

module ppg_zone1 'modules/network/ppg.bicep' = {
  name: '${proximityGroupZone1Name}-deploy'
  scope: resourceGroup(rg.name)
  params: {
    location: location
    ppgName: proximityGroupZone1Name
  }
}

module ppg_zone2 'modules/network/ppg.bicep' = {
  name: '${proximityGroupZone2Name}-deploy'
  scope: resourceGroup(rg.name)
  params: {
    location: location
    ppgName: proximityGroupZone2Name
  }
}

module sqlservers 'modules/vm_v2.bicep' = [for (server, i) in sqlServers: {
  name: '${server.vmName}'
  scope: resourceGroup(rg.name)
  params: {
    location: location
    vmName: '${server.vmName}'
    environment: deploymentEnvironment
    computerName: '${server.vmName}'
    adminPassword: server.adminPassword
    adminUserName: server.adminUserName
    networkResourceGroup: networkResourceGroup
    networkTags:server.networkTags
    sla:server.sla
    networkSubnet: server.networkSubnet
    networkVnet: networkVnet
    operatingSystem: server.operatingSystem
    vmSize: server.vmSize
    enableAcceleratedNetworking: server.enableAcceleratedNetworking
    useStaticIP: server.UseStaticIP
    IPConfiguration: server.IPConfiguration
    availabilityZone: server.availabilityZone
    UsePPG: server.usePPG
    ppgName: server.ppgName
    isSqlVM: true
    dataDisks: server.dataDisks
  }
}]



