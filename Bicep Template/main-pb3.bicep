targetScope = 'subscription'

// Take Input from Build Sheet
param SID string = 'PB3'
param ApplicationName string = 'SAP PB3 Production'

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
    vmName: 'azsappcs23' 
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
    networkTags: 'AAZ-WEU-SAP-PRD-APP-ABAP'
    sla:'Silver'
    backup: 'BackupVault'
    IPConfiguration: [
      {
        name: 'ipconfig1'
        primaryIP: true
        IPAddress: '10.71.48.113'
      }
      {
        name: 'sap-logical-hostname-sappb3cs01'
        primaryIP: false
        IPAddress: '10.71.48.114'
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
    vmName: 'azsappcs24' 
    vmSize: 'Standard_d4ads_V5'
    adminUserName: 'sapvmadmin'
    adminPassword: newGuid()
    operatingSystem: 'Server2019'
    availabilityZone: '3'
    ppgName: proximityGroupZone2Name
    UsePPG: true
    networkSubnet: 'application-${deploymentEnvironment}-subnet'
    enableAcceleratedNetworking: true
    useStaticIP: true
    networkTags: 'AZ-WEU-SAP-PRD-APP-ABAP'
    sla:'Silver'
    backup: 'BackupVault'
    IPConfiguration: [
      {
        name: 'ipconfig1'
        primaryIP: true
        IPAddress: '10.71.48.115'
      }
      {
        name: 'sap-logical-hostname-sappb3cs02'
        primaryIP: false
        IPAddress: '10.71.48.116'
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
    vmName: 'azsapp026' 
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
    networkTags: 'AZ-WEU-SAP-PRD-APP-ABAP'
    sla:'Silver'
    backup: 'RecoveryServicesVault'
    IPConfiguration: [
      {
        name: 'ipconfig1'
        primaryIP: true
        IPAddress: '10.71.48.117'
      }
      {
        name: 'sap-logical-hostname-sappb3app01'
        primaryIP: false
        IPAddress: '10.71.48.118'
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
    vmName: 'azsapp027' 
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
    networkTags: 'AZ-WEU-SAP-PRD-APP-ABAP'
    sla:'Silver'
    backup: 'RecoveryServicesVault'
    IPConfiguration: [
      {
        name: 'ipconfig1'
        primaryIP: true
        IPAddress: '10.71.48.119'
      }
      {
        name: 'sap-logical-hostname-sappb3app02'
        primaryIP: false
        IPAddress: '10.71.48.120'
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

param sqlServers array = [
     //server3
     {
      vmName: 'azsappdb24' 
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
      networkTags: 'AZ-WEU-SAP-PRD-DB-MSSQL'
      sla:'Gold'
      backup: 'RecoveryServicesVault'
      IPConfiguration: [
        {
          name: 'ipconfig1'
          primaryIP: true
          IPAddress: '10.71.50.63'
        }
        {
          name: 'sap-logical-hostname-sappb3db01'
          primaryIP: false
          IPAddress: '10.71.50.64'
        }
         ]
      dataDisks: [
        {
          createOption: 'empty'
          caching: 'None'
          writeAcceleratorEnabled: false
          storageAccountType: 'Premium_LRS'
          diskSizeGB: 64
        }
        {
          createOption: 'empty'
          caching: 'ReadOnly'
          writeAcceleratorEnabled: false
          storageAccountType: 'Premium_LRS'
          diskSizeGB: 1024
        }
        {
          createOption: 'empty'
          caching: 'ReadOnly'
          writeAcceleratorEnabled: false
          storageAccountType: 'Premium_LRS'
          diskSizeGB: 1024
        }
                {
          createOption: 'empty'
          caching: 'None'
          writeAcceleratorEnabled: false
          storageAccountType: 'Premium_LRS'
          diskSizeGB: 256
        }
        {
          createOption: 'empty'
          caching: 'None'
          writeAcceleratorEnabled: false
          storageAccountType: 'Premium_LRS'
          diskSizeGB: 128
        }
      
      ]
    } 
      //server4
    {
      vmName: 'azsappdb25' 
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
      networkTags: 'AZ-WEU-SAP-PRD-DB-MSSQL'
      sla:'Gold'
      backup: 'RecoveryServicesVault'
      IPConfiguration: [
        {
          name: 'ipconfig1'
          primaryIP: true
          IPAddress: '10.71.50.65'
        }
        {
          name: 'sap-logical-hostname-sappb3db02'
          primaryIP: false
          IPAddress: '10.71.50.66'
        }
         ]
         dataDisks: [
         {
          createOption: 'empty'
          caching: 'None'
          writeAcceleratorEnabled: false
          storageAccountType: 'Premium_LRS'
          diskSizeGB: 64
        }
        {
          createOption: 'empty'
          caching: 'ReadOnly'
          writeAcceleratorEnabled: false
          storageAccountType: 'Premium_LRS'
          diskSizeGB: 1024
        }
        {
          createOption: 'empty'
          caching: 'ReadOnly'
          writeAcceleratorEnabled: false
          storageAccountType: 'Premium_LRS'
          diskSizeGB: 1024
        }
                {
          createOption: 'empty'
          caching: 'None'
          writeAcceleratorEnabled: false
          storageAccountType: 'Premium_LRS'
          diskSizeGB: 256
        }
        {
          createOption: 'empty'
          caching: 'None'
          writeAcceleratorEnabled: false
          storageAccountType: 'Premium_LRS'
          diskSizeGB: 128
        }
      ]
    } 
]
param load_balance array = [
  {
   loadbalanceconfig: [
  {
   name:'scs'
   Port: 62060
   FrontEndIP: '10.71.48.121'
   loadbal_subnet: 'app'
   }
  {
    name:'dbms'
    Port: 50000
    FrontEndIP: '10.71.50.67'
    loadbal_subnet: 'dbms'
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
    backup:server.backup
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
    backup:server.backup
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
module shareddisk1 'modules/storage/managed-shared-disk.bicep' =  {
  name: 'scs-shared-disk'
  scope: resourceGroup(rg.name)
  params: {
    diskName: 'sap-${SIDLower}-SCS-disk-shared01'
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
    storageAccountName: 'vestassappb3${deploymentEnvironment}cw'
    location:location
  }
}
