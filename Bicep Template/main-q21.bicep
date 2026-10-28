targetScope = 'subscription'

// Take Input from Build Sheet
param SID string = 'Q21'
param ApplicationName string = 'SAP Q21 Quality'

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


param appServers array = [
 //server1
  {
    vmName: 'azsapqcs09' 
    computerName: 'azsapqcs09'
    vmSize: 'Standard_D4as_V4'
    adminUserName: 'sapvmadmin'
    adminPassword: newGuid()
    operatingSystem: 'Server2019'
    availabilityZone: '1'
    UsePPG: true
    ppgName: proximityGroupZone1Name
    networkSubnet: 'application-${deploymentEnvironment}-subnet'
    enableAcceleratedNetworking: true
    useStaticIP: true
    IPConfiguration: [
      {
        name: 'ipconfig1'
        primaryIP: true
        IPAddress: '10.193.28.27'
      }
      {
        name: 'sap-logical-hostname-sapq21cs01'
        primaryIP: false
        IPAddress: '10.193.28.28'
      }
        ]
    dataDisks: [
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 32
      }
     
    
    ]
  } 
  //server2
  {
    vmName: 'azsapqcs10' 
    computerName: 'azsapqcs10'
    vmSize: 'Standard_D4as_V4'
    adminUserName: 'sapvmadmin'
    adminPassword: newGuid()
    operatingSystem: 'Server2019'
    availabilityZone: '3'
    ppgName: proximityGroupZone2Name
    UsePPG: true
    networkSubnet: 'application-${deploymentEnvironment}-subnet'
    enableAcceleratedNetworking: true
    useStaticIP: true
    IPConfiguration: [
      {
        name: 'ipconfig1'
        primaryIP: true
        IPAddress: '10.193.28.29'
      }
      {
        name: 'sap-logical-hostname-sapq21cs02'
        primaryIP: false
        IPAddress: '10.193.28.30'
      }
         ]
    dataDisks: [
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 32
      }
    
    
    ]
  } 
  //server3
  {
    vmName: 'azsapq009' 
    computerName: 'azsapq009'
    vmSize: 'Standard_E4as_V4'
    adminUserName: 'sapvmadmin'
    adminPassword: newGuid()
    operatingSystem: 'Server2019'
    availabilityZone: '1'
    UsePPG: false
    ppgName: proximityGroupZone1Name
    networkSubnet: 'application-${deploymentEnvironment}-subnet'
    enableAcceleratedNetworking: true
    useStaticIP: true
    IPConfiguration: [
      {
        name: 'ipconfig1'
        primaryIP: true
        IPAddress: '10.193.28.31'
      }
      {
        name: 'sap-logical-hostname-sapq21app02'
        primaryIP: false
        IPAddress: '10.193.28.32'
      }
      
    ]
    dataDisks: [
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'StandardSSD_LRS'
        diskSizeGB: 128
      }
    
    ]
  } 
  //server4
  {
    vmName: 'azsapq010' 
    computerName: 'azsapq010'
    vmSize: 'Standard_E4as_V4'
    adminUserName: 'sapvmadmin'
    adminPassword: newGuid()
    operatingSystem: 'Server2019'
    availabilityZone: '3'
    UsePPG: false
    ppgName: proximityGroupZone2Name
    networkSubnet: 'application-${deploymentEnvironment}-subnet'
    enableAcceleratedNetworking: true
    useStaticIP: true
    IPConfiguration: [
      {
        name: 'ipconfig1'
        primaryIP: true
        IPAddress: '10.193.28.33'
      }
      {
        name: 'sap-logical-hostname-sapq21app02'
        primaryIP: false
        IPAddress: '10.193.28.34'
      }
       ]
    dataDisks: [
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'StandardSSD_LRS'
        diskSizeGB: 128
      }
    
    ]
  } 
  
]

//SQL server
param sqlServers array = [
  {
    vmName: 'azsapqdb08' 
    computerName: 'azsapqdb08'
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
    isSqlVM: true
    IPConfiguration: [
      {
        name: 'ipconfig1'
        primaryIP: true
        IPAddress: '10.193.30.10'
      }
      {
        name: 'sap-logical-hostname-sapq21db01'
        primaryIP: false
        IPAddress: '10.193.30.11'
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
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'StandardSSD_LRS'
        diskSizeGB: 64
      }
      {
        createOption: 'empty'
        caching: 'None'
        writeAcceleratorEnabled: false
        storageAccountType: 'StandardSSD_LRS'
        diskSizeGB: 32
      }
    ]
  }

      {
        vmName: 'azsapqdb09' 
        computerName: 'azsapqdb09'
        vmSize: 'Standard_E4as_V4'
        adminUserName: 'sapvmadmin'
        adminPassword: newGuid()
        operatingSystem: 'MSSQL2017WS2019'
        availabilityZone: '3'
        UsePPG: true
        ppgName: proximityGroupZone2Name
        networkSubnet: 'database-${deploymentEnvironment}-subnet'
        enableAcceleratedNetworking: true
        useStaticIP: true
        isSqlVM: true
        IPConfiguration: [
          {
            name: 'ipconfig1'
            primaryIP: true
            IPAddress: '10.193.30.12'
          }
          {
            name: 'sap-logical-hostname-sapq21db01'
            primaryIP: false
            IPAddress: '10.193.30.13'
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
          {
            createOption: 'empty'
            caching: 'ReadOnly'
            writeAcceleratorEnabled: false
            storageAccountType: 'StandardSSD_LRS'
            diskSizeGB: 64
          }
          {
            createOption: 'empty'
            caching: 'None'
            writeAcceleratorEnabled: false
            storageAccountType: 'StandardSSD_LRS'
            diskSizeGB: 32
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
    ppgName: server.ppgName
    isSqlVM: false
    dataDisks: server.dataDisks
  }
  dependsOn: [
    ppg_zone1
  ]
}]


module sqlservers 'modules/vm.bicep' = [for (server, i) in sqlServers: {
  name: '${server.vmName}'
  scope: resourceGroup(rg.name)
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
    ppgName: server.ppgName
    isSqlVM: false
    dataDisks: server.dataDisks
  }
}]


module loadbalancer 'modules/network/loadbalancer.bicep' = {
  name: 'loadbalancer'
  scope: resourceGroup(rg.name)
  params: {
    location: location
    lbName: 'sap-${SIDLower}-${deploymentEnvironment}-lb'
    networkResourceGroup: networkResourceGroup
    networkVnet: networkVnet
  }
}
module shareddisk 'modules/storage/managed-shared-disk.bicep' = {
  name: 'ascs-shared-disk'
  scope: resourceGroup(rg.name)
  params: {
    diskName: 'sap-${SIDLower}-${deploymentEnvironment}-ascs-disk-shared01'
    location: location
    maxShares: 2
    diskSize: 64
    diskSKU: 'Premium_ZRS'
    diskTier: 'P6'
  }
}
module cloudwitness 'modules/storage/storage-account.bicep' = {
  name: 'wsfc-cloudwitness'
  scope: resourceGroup(rg.name)
  params: {
    storageAccountName: 'vestassap${SIDLower}${deploymentEnvironment}cw'
    location:location
  }
}
