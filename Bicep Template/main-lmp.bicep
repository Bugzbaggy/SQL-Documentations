targetScope = 'subscription'

// Take Input from Build Sheet
param SID string = 'LMP'
param ApplicationName string = 'SAP LMP Production'

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
    vmName: 'azsappcs01' 
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
    networkTags: 'AZ-WEU-SAP-PRD-APP-J2EE'
    IPConfiguration: [
      {
        name: 'ipconfig1'
        primaryIP: true
        IPAddress: '10.71.48.22'
      }
      {
        name: 'sap-logical-hostname-saplmpcs01'
        primaryIP: false
        IPAddress: '10.71.48.23'
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
    vmName: 'azsappcs02' 
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
    networkTags: 'AZ-WEU-SAP-PRD-APP-J2EE'
    IPConfiguration: [
      {
        name: 'ipconfig1'
        primaryIP: true
        IPAddress: '10.71.48.24'
      }
      {
        name: 'sap-logical-hostname-saplmpcs02'
        primaryIP: false
        IPAddress: '10.71.48.25'
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
    //server5
  {
    vmName: 'azsapp001' 
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
    networkTags: 'AZ-WEU-SAP-PRD-APP-J2EE'
    IPConfiguration: [
      {
        name: 'ipconfig1'
        primaryIP: true
        IPAddress: '10.71.48.26'
      }
      {
        name: 'sap-logical-hostname-saplmpapp01'
        primaryIP: false
        IPAddress: '10.71.48.27'
      }
       ]
    dataDisks: [
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 64
      }
    
    ]
  } 
    //server6
  {
    vmName: 'azsapp002' 
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
    networkTags: 'AZ-WEU-SAP-PRD-APP-J2EE'
    IPConfiguration: [
      {
        name: 'ipconfig1'
        primaryIP: true
        IPAddress: '10.71.48.28'
      }
      {
        name: 'sap-logical-hostname-saplmpapp02'
        primaryIP: false
        IPAddress: '10.71.48.29'
      }
       ]
    dataDisks: [
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 64
      }
    
    ]
  } 
]

param sqlServers array = [
     //server3
     {
      vmName: 'azsappdb01' 
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
      networkTags: 'AZ-WEU-SAP-PRD-APP-J2EE'
      IPConfiguration: [
        {
          name: 'ipconfig1'
          primaryIP: true
          IPAddress: '10.71.50.14'
        }
        {
          name: 'sap-logical-hostname-sapds1db02'
          primaryIP: false
          IPAddress: '10.71.50.15'
        }
         ]
      dataDisks: [
        {
          createOption: 'empty'
          caching: 'ReadOnly'
          writeAcceleratorEnabled: false
          storageAccountType: 'Premium_LRS'
          diskSizeGB: 64
        }
        {
          createOption: 'empty'
          caching: 'ReadOnly'
          writeAcceleratorEnabled: false
          storageAccountType: 'Premium_LRS'
          diskSizeGB: 32
        }
        {
          createOption: 'empty'
          caching: 'ReadOnly'
          writeAcceleratorEnabled: false
          storageAccountType: 'Premium_LRS'
          diskSizeGB: 32
        }
        {
          createOption: 'empty'
          caching: 'None'
          writeAcceleratorEnabled: false
          storageAccountType: 'Premium_LRS'
          diskSizeGB: 32
        }
        {
          createOption: 'empty'
          caching: 'ReadOnly'
          writeAcceleratorEnabled: false
          storageAccountType: 'Premium_LRS'
          diskSizeGB: 16
        }
      
      ]
    } 
      //server4
    {
      vmName: 'azsappdb02' 
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
      networkTags: 'AZ-WEU-SAP-PRD-APP-J2EE'
      IPConfiguration: [
        {
          name: 'ipconfig1'
          primaryIP: true
          IPAddress: '10.71.50.16'
        }
        {
          name: 'sap-logical-hostname-saplmpdb02'
          primaryIP: false
          IPAddress: '10.71.50.17'
        }
         ]
      dataDisks: [
        {
          createOption: 'empty'
          caching: 'ReadOnly'
          writeAcceleratorEnabled: false
          storageAccountType: 'Premium_LRS'
          diskSizeGB: 64
        }
        {
          createOption: 'empty'
          caching: 'ReadOnly'
          writeAcceleratorEnabled: false
          storageAccountType: 'Premium_LRS'
          diskSizeGB: 32
        }
        {
          createOption: 'empty'
          caching: 'ReadOnly'
          writeAcceleratorEnabled: false
          storageAccountType: 'Premium_LRS'
          diskSizeGB: 32
        }
        {
          createOption: 'empty'
          caching: 'None'
          writeAcceleratorEnabled: false
          storageAccountType: 'Premium_LRS'
          diskSizeGB: 32
        }
        {
          createOption: 'empty'
          caching: 'ReadOnly'
          writeAcceleratorEnabled: false
          storageAccountType: 'Premium_LRS'
          diskSizeGB: 16
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

module appservers 'modules/vm_v2.bicep' = [for (server, i) in appServers: {
  name: '${server.vmName}'
  scope: resourceGroup(rg.name)
  params: {
    location: location
    vmName: '${server.vmName}'
    environment: deploymentEnvironment
    computerName: '${server.vmName}'
    adminPassword: server.adminPassword
    adminUserName: server.adminUserName
    domainJoin: false
    networkResourceGroup: networkResourceGroup
    networkSubnet: server.networkSubnet
    networkVnet: networkVnet
    networkTags:server.networkTags
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
module shareddisk1 'modules/storage/managed-shared-disk.bicep' =  {
  name: 'scs-shared-disk'
  scope: resourceGroup(rg.name)
  params: {
    diskName: 'sap-${SIDLower}-${deploymentEnvironment}-LMP_SCS'
    location: location
    maxShares: 2
    diskSize: 32
    diskSKU: 'Premium_ZRS'
    diskTier: 'P4'
  }
}
module cloudwitness 'modules/storage/storage-account.bicep' = {
  name: 'wsfc-cloudwitness'
  scope: resourceGroup(rg.name)
  params: {
    storageAccountName: 'vestassaplmp${deploymentEnvironment}cw'
    location:location
  }
}
