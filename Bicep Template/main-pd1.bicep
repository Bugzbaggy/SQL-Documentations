targetScope = 'subscription'

// Take Input from Build Sheet
param SID string = 'PD1'
param ApplicationName string = 'SAP PD1 Production'

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
    vmName: 'azsappcs07' 
    computerName: 'azsappcs07'
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
        IPAddress: '10.71.48.4'
      }
      {
        name: 'sap-logical-hostname-sappd1cs01'
        primaryIP: false
        IPAddress: '10.71.48.5'
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
    vmName: 'azsappcs08' 
    computerName: 'azsappcs08'
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
        IPAddress: '10.71.48.6'
      }
      {
        name: 'sap-logical-hostname-sappd1cs02'
        primaryIP: false
        IPAddress: '10.71.48.7'
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
    vmName: 'azsapp009' 
    computerName: 'azsapp009'
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
        IPAddress: '10.71.48.8'
      }
      {
        name: 'sap-logical-hostname-sappd1app01'
        primaryIP: false
        IPAddress: '10.71.48.9'
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
    vmName: 'azsapp010' 
    computerName: 'azsapp010'
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
        IPAddress: '10.71.48.10'
      }
      {
        name: 'sap-logical-hostname-sappd1app02'
        primaryIP: false
        IPAddress: '10.71.48.11'
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
    vmName: 'azsappdb07' 
    computerName: 'azsappdb07'
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
    networkTags: 'AZ-WEU-SAP-PRD-DB-MSSQL'
    IPConfiguration: [
      {
        name: 'ipconfig1'
        primaryIP: true
        IPAddress: '10.71.50.4'
      }
      {
        name: 'sap-logical-hostname-sappd1db01'
        primaryIP: false
        IPAddress: '10.71.50.5'
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
        vmName: 'azsappdb08' 
        computerName: 'azsappdb08'
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
        networkTags: 'AZ-WEU-SAP-PRD-DB-MSSQL'
        IPConfiguration: [
          {
            name: 'ipconfig1'
            primaryIP: true
            IPAddress: '10.71.50.6'
          }
          {
            name: 'sap-logical-hostname-sappd1db02'
            primaryIP: false
            IPAddress: '10.71.50.7'
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
   Port: 62002
   FrontEndIP: '10.71.48.12'
   loadbal_subnet: 'app' //app or db
   }

   {
    name:'dbms'
    Port: 50000
    FrontEndIP: '10.71.50.8'
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
    computerName: server.computerName
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
    computerName: server.computerName
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
