targetScope = 'subscription'

// Take Input from Build Sheet
param SID string = 'P1L'
param ApplicationName string = 'SAP P1L Production'

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
param deploymentEnvironment string = 'prd'

/*SAP Parameters*/

@allowed([
  'Production'
  'Test'
  'Development'
  'Sandbox'
  'Pilot'
  'QA'
])
param sapEnvironment string = 'Production'


param appServers array = [
 //server1
  {
    vmName: 'azsappcs21' 
    vmSize: 'Standard_D4ads_V5'
    adminUserName: 'sapvmadmin'
    adminPassword: newGuid()
    operatingSystem: 'Server2019'
    availabilityZone: '1'
    UsePPG: true
    ppgName: proximityGroupZone1Name
    networkSubnet: 'application-${deploymentEnvironment}-subnet'
    enableAcceleratedNetworking: true
    useStaticIP: true
    networkTags: 'AZ-WEU-SAP-PRD-APP-SLT'
    sla:'Gold'
    IPConfiguration: [
      {
        name: 'ipconfig1'
        primaryIP: true
        IPAddress: '10.71.48.104'
      }
      {
        name: 'sap-logical-hostname-sapp1lcs01'
        primaryIP: false
        IPAddress: '10.71.48.105'
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
    vmName: 'azsappcs22' 
    vmSize: 'Standard_D4ads_V5'
    adminUserName: 'sapvmadmin'
    adminPassword: newGuid()
    operatingSystem: 'Server2019'
    availabilityZone: '3'
    UsePPG: true
    ppgName: proximityGroupZone2Name
    networkSubnet: 'application-${deploymentEnvironment}-subnet'
    enableAcceleratedNetworking: true
    useStaticIP: true
    networkTags: 'AZ-WEU-SAP-PRD-APP-SLT'
    sla:'Gold'
    IPConfiguration: [
      {
        name: 'ipconfig1'
        primaryIP: true
        IPAddress: '10.71.48.106'
      }
      {
        name: 'sap-logical-hostname-sapp1lcs02'
        primaryIP: false
        IPAddress: '10.71.48.107'
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
    vmName: 'azsapp024' 
    vmSize: 'Standard_E4ads_V5'
    adminUserName: 'sapvmadmin'
    adminPassword: newGuid()
    operatingSystem: 'Server2019'
    availabilityZone: '1'
    UsePPG: false
    ppgName: proximityGroupZone1Name
    networkSubnet: 'application-${deploymentEnvironment}-subnet'
    enableAcceleratedNetworking: true
    useStaticIP: true
    networkTags: 'AZ-WEU-SAP-PRD-APP-SLT'
    sla:'Gold'
    IPConfiguration: [
      {
        name: 'ipconfig1'
        primaryIP: true
        IPAddress: '10.71.48.108'
      }
      {
        name: 'sap-logical-hostname-sapp1lapp01'
        primaryIP: false
        IPAddress: '10.71.48.109'
      }
      
    ]
    dataDisks: [
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 128
      }
    
    ]
  } 
  //server6
  {
    vmName: 'azsapp025' 
    vmSize: 'Standard_E4ads_V5'
    adminUserName: 'sapvmadmin'
    adminPassword: newGuid()
    operatingSystem: 'Server2019'
    availabilityZone: '3'
    UsePPG: false
    ppgName: proximityGroupZone2Name
    networkSubnet: 'application-${deploymentEnvironment}-subnet'
    enableAcceleratedNetworking: true
    useStaticIP: true
    networkTags: 'AZ-WEU-SAP-PRD-APP-SLT'
    sla:'Gold'
    IPConfiguration: [
      {
        name: 'ipconfig1'
        primaryIP: true
        IPAddress: '10.71.48.110'
      }
      {
        name: 'sap-logical-hostname-sapp1lapp02'
        primaryIP: false
        IPAddress: '10.71.48.111'
      }
      
    ]
    dataDisks: [
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 128
      }
    
    ]
  } 
  
]

//SQL server
param sqlServers array = [
  {
    vmName: 'azsappdb22' 
    vmSize: 'Standard_E4ads_V5'
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
    networkTags: 'AZ-WEU-SAP-PRD-DB-MSSQL'
    sla:'Gold'
    IPConfiguration: [
      {
        name: 'ipconfig1'
        primaryIP: true
        IPAddress: '10.71.50.57'
      }
      {
        name: 'sap-logical-hostname-sapp1ldb01'
        primaryIP: false
        IPAddress: '10.71.50.58'
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
        diskSizeGB: 128
      }
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 128
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

  {
    vmName: 'azsappdb23' 
    vmSize: 'Standard_E4ads_V5'
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
    networkTags: 'AZ-WEU-SAP-PRD-DB-MSSQL'
    sla:'Gold'
    IPConfiguration: [
      {
        name: 'ipconfig1'
        primaryIP: true
        IPAddress: '10.71.50.59'
      }
      {
        name: 'sap-logical-hostname-sapp1ldb02'
        primaryIP: false
        IPAddress: '10.71.50.60'
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
        diskSizeGB: 128
      }
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 128
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
//load balancer configuration
param load_balance array = [
  {
   loadbalanceconfig: [ 
  {
   name:'scs'
   Port: 62001
   FrontEndIP: '10.71.48.112'
   loadbal_subnet: 'app' //app or db
   }

   {
    name:'dbms'
    Port: 50000
    FrontEndIP: '10.71.50.62'
    loadbal_subnet: 'db' // app or db
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
    sla:server.sla
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


module loadbalancer 'modules/network/loadbalancer_v2.bicep' = [for (lb, i) in load_balance: {
  
  name: 'loadbalancer-${i}'
  scope: resourceGroup(rg.name)
  params: {
    location: location
    lbName: 'sap-${SIDLower}-${deploymentEnvironment}-lb'
    networkResourceGroup: networkResourceGroup
    lbEnv: deploymentEnvironment
    SID: SIDLower
    networkVnet: networkVnet
    loadbalanceconfig:lb.loadbalanceconfig

  }
  dependsOn: [
    appservers, sqlservers
  ]
}]

module shareddisk 'modules/storage/managed-shared-disk.bicep' = {
  name: 'ascs-shared-disk'
  scope: resourceGroup(rg.name)
  params: {
    diskName: 'sap-${SIDLower}-${deploymentEnvironment}-ascs-disk-shared01'
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
    storageAccountName: 'vestassap${SIDLower}${deploymentEnvironment}cw'
    location:location
  }
}
