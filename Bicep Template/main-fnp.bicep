targetScope = 'subscription'

// Take Input from Build Sheet
param SID string = 'FNP'
param ApplicationName string = 'SAP FRUN'

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
    vmName: 'azsappcs03' 
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
    networkTags: 'AZ-WEU-SAP-PRD-APP-FRUN'
    IPConfiguration: [
      {
        name: 'ipconfig1'
        primaryIP: true
        IPAddress: '10.71.48.68'
      }
      {
        name: 'sap-logical-hostname-sapfnpcs01'
        primaryIP: false
        IPAddress: '10.71.48.69'
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
    vmName: 'azsappcs04' 
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
    networkTags: 'AZ-WEU-SAP-PRD-APP-FRUN'
    IPConfiguration: [
      {
        name: 'ipconfig1'
        primaryIP: true
        IPAddress: '10.71.48.70'
      }
      {
        name: 'sap-logical-hostname-sapfnpcs02'
        primaryIP: false
        IPAddress: '10.71.48.71'
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
    vmName: 'azsapp003' 
    vmSize: 'Standard_E8as_V4'
    adminUserName: 'sapvmadmin'
    adminPassword: newGuid()
    operatingSystem: 'Server2019'
    availabilityZone: '1'
    UsePPG: true
    ppgName: proximityGroupZone1Name
    networkSubnet: 'application-${deploymentEnvironment}-subnet'
    enableAcceleratedNetworking: true
    useStaticIP: true
    networkTags: 'AZ-WEU-SAP-PRD-APP-FRUN'
    IPConfiguration: [
      {
        name: 'ipconfig1'
        primaryIP: true
        IPAddress: '10.71.48.72'
      }
      {
        name: 'sap-logical-hostname-sapfnpapp01'
        primaryIP: false
        IPAddress: '10.71.48.73'
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
  //server4
  {
    vmName: 'azsapp004' 
    vmSize: 'Standard_E8as_V4'
    adminUserName: 'sapvmadmin'
    adminPassword: newGuid()
    operatingSystem: 'Server2019'
    availabilityZone: '1'
    UsePPG: true
    ppgName: proximityGroupZone1Name
    networkSubnet: 'application-${deploymentEnvironment}-subnet'
    enableAcceleratedNetworking: true
    useStaticIP: true
    networkTags: 'AZ-WEU-SAP-PRD-APP-FRUN'
    IPConfiguration: [
      {
        name: 'ipconfig1'
        primaryIP: true
        IPAddress: '10.71.48.74'
      }
      {
        name: 'sap-logical-hostname-sapfnpapp02'
        primaryIP: false
        IPAddress: '10.71.48.75'
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

    //server5
  {
   vmName: 'azsapp005' 
   vmSize: 'Standard_E8as_V4'
   adminUserName: 'sapvmadmin'
   adminPassword: newGuid()
   operatingSystem: 'Server2019'
   availabilityZone: '3'
   UsePPG: true
   ppgName: proximityGroupZone2Name
   networkSubnet: 'application-${deploymentEnvironment}-subnet'
   enableAcceleratedNetworking: true
   useStaticIP: true
   networkTags: 'AZ-WEU-SAP-PRD-APP-FRUN'
   IPConfiguration: [
     {
      name: 'ipconfig1'
      primaryIP: true
      IPAddress: '10.71.48.76'
     }
     {
      name: 'sap-logical-hostname-sapfnpapp03'
      primaryIP: false
      IPAddress: '10.71.48.77'
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
   vmName: 'azsapp006'
   vmSize: 'Standard_E8as_V4'
   adminUserName: 'sapvmadmin'
   adminPassword: newGuid()
   operatingSystem: 'Server2019'
   availabilityZone: '3'
   UsePPG: true
   ppgName: proximityGroupZone2Name
   networkSubnet: 'application-${deploymentEnvironment}-subnet'
   enableAcceleratedNetworking: true
   useStaticIP: true
   networkTags: 'AZ-WEU-SAP-PRD-APP-FRUN'
   IPConfiguration: [
     {
      name: 'ipconfig1'
      primaryIP: true
      IPAddress: '10.71.48.78'
     }
     {
      name: 'sap-logical-hostname-sapfnpapp03'
      primaryIP: false
      IPAddress: '10.71.48.79'
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

//DB server RHELSAPHANA
param sqlServers array = [
  {
    vmName: 'azsappdb03'
    vmSize: 'Standard_M64ls'
    adminUserName: 'sapvmadmin'
    adminPassword: newGuid()
    operatingSystem: 'RHELSAPHANA'
    availabilityZone: '1'
    UsePPG: false
    ppgName: proximityGroupZone1Name
    networkSubnet: 'database-${deploymentEnvironment}-subnet'
    enableAcceleratedNetworking: true
    useStaticIP: true
    networkTags: 'AZ-WEU-SAP-PRD-DB-HANA'
    IPConfiguration: [
      {
        name: 'ipconfig1'
        primaryIP: true
        IPAddress: '10.71.50.41'
      }
      {
        name: 'sap-logical-hostname-sapfnpdb01'
        primaryIP: false
        IPAddress: '10.71.50.42'
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
        caching: 'None'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 128
      }
      {
        createOption: 'empty'
        caching: 'None'
        writeAcceleratorEnabled: true
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 128
      }
      {
        createOption: 'empty'
        caching: 'None'
        writeAcceleratorEnabled: true
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 128
      }
      {
        createOption: 'empty'
        caching: 'None'
        writeAcceleratorEnabled: true
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 128
      }
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 512
      }
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 64
      }

    ]
  }

  {
    vmName: 'azsappdb04'
    vmSize: 'Standard_M64ls'
    adminUserName: 'sapvmadmin'
    adminPassword: newGuid()
    operatingSystem: 'RHELSAPHANA'
    availabilityZone: '3'
    UsePPG: false
    ppgName: proximityGroupZone2Name
    networkSubnet: 'database-${deploymentEnvironment}-subnet'
    enableAcceleratedNetworking: true
    useStaticIP: true
    networkTags: 'AZ-WEU-SAP-PRD-DB-HANA'
    IPConfiguration: [
      {
        name: 'ipconfig1'
        primaryIP: true
        IPAddress: '10.71.50.43'
      }
      {
        name: 'sap-logical-hostname-sapfnpdb02'
        primaryIP: false
        IPAddress: '10.71.50.44'
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
        caching: 'None'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 128
      }
      {
        createOption: 'empty'
        caching: 'None'
        writeAcceleratorEnabled: true
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 128
      }
      {
        createOption: 'empty'
        caching: 'None'
        writeAcceleratorEnabled: true
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 128
      }
      {
        createOption: 'empty'
        caching: 'None'
        writeAcceleratorEnabled: true
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 128
      }
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 512
      }
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

//load balancer configuration
param load_balance array = [
  {
   loadbalanceconfig: [
  {
   name:'ascs'
   Port: 62040
   FrontEndIP: '10.71.48.80'
   loadbal_subnet: 'app'
   }
   {
    name:'ers'
    Port: 62041
    FrontEndIP: '10.71.48.81'
    loadbal_subnet: 'app'
    }
    {
     name:'dbms'
     Port: 625
     FrontEndIP: '10.71.50.45'
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
    isSqlVM: false
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
