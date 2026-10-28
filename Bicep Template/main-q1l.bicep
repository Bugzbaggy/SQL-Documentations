targetScope = 'subscription'

// Take Input from Build Sheet
param SID string = 'Q1L'
param ApplicationName string = 'SAP Q1L Quality'

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
param deploymentEnvironment string = 'tst'

/*SAP Parameters*/

@allowed([
  'Production'
  'Test'
  'Development'
  'Sandbox'
  'Pilot'
  'QA'
])
param sapEnvironment string = 'QA'


param appServers array = [
  //server1
   {
     vmName: 'azsapqcs13' 
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
     networkTags: 'AZ-WEU-SAP-QA-APP-SLT'
     IPConfiguration: [
       {
         name: 'ipconfig1'
         primaryIP: true
         IPAddress: '10.193.28.55'
       }
       {
         name: 'sap-logical-hostname-sapq1lcs01'
         primaryIP: false
         IPAddress: '10.193.28.56'
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
     vmName: 'azsapqcs14' 
     vmSize: 'Standard_D4as_V4'
     adminUserName: 'sapvmadmin'
     adminPassword: newGuid()
     operatingSystem: 'Server2019'
     availabilityZone: '3'
     UsePPG: true
     ppgName: proximityGroupZone2Name
     networkSubnet: 'application-${deploymentEnvironment}-subnet'
     enableAcceleratedNetworking: true
     useStaticIP: true
     networkTags: 'AZ-WEU-SAP-QA-APP-SLT'
     IPConfiguration: [
       {
         name: 'ipconfig1'
         primaryIP: true
         IPAddress: '10.193.28.57'
       }
       {
         name: 'sap-logical-hostname-sapq1lcs02'
         primaryIP: false
         IPAddress: '10.193.28.58'
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
     vmName: 'azsapq013' 
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
     networkTags: 'AZ-WEU-SAP-QA-APP-SLT'
     IPConfiguration: [
       {
         name: 'ipconfig1'
         primaryIP: true
         IPAddress: '10.193.28.59'
       }
       {
         name: 'sap-logical-hostname-sapq1lapp01'
         primaryIP: false
         IPAddress: '10.193.28.60'
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
   //server4
   {
     vmName: 'azsapq014' 
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
     networkTags: 'AZ-WEU-SAP-QA-APP-SLT'
     IPConfiguration: [
       {
         name: 'ipconfig1'
         primaryIP: true
         IPAddress: '10.193.28.61'
       }
       {
         name: 'sap-logical-hostname-sapq1lapp02'
         primaryIP: false
         IPAddress: '10.193.28.62'
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

//SQL server
param sqlServers array = [
  {
    vmName: 'azsapqdb12' 
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
    networkTags: 'AZ-WEU-SAP-QA-DB-MSSQL'
    isSqlVM: true
    IPConfiguration: [
      {
        name: 'ipconfig1'
        primaryIP: true
        IPAddress: '10.193.30.31'
      }
      {
        name: 'sap-logical-hostname-sapq1ldb01'
        primaryIP: false
        IPAddress: '10.193.30.32'
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
        diskSizeGB: 128
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
        vmName: 'azsapqdb13' 
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
        networkTags: 'AZ-WEU-SAP-QA-DB-MSSQL'
        isSqlVM: true
        IPConfiguration: [
          {
            name: 'ipconfig1'
            primaryIP: true
            IPAddress: '10.193.30.33'
          }
          {
            name: 'sap-logical-hostname-sapq1ldb02'
            primaryIP: false
            IPAddress: '10.193.30.34'
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
            diskSizeGB: 128
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

param load_balance array = [
  {
   loadbalanceconfig: [ 
  {
   name:'scs'
   Port: 62082
   FrontEndIP: '10.193.28.63'
   loadbal_subnet: 'app' //app or db
   }

   {
    name:'dbms'
    Port: 50000
    FrontEndIP: '10.193.30.35'
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
