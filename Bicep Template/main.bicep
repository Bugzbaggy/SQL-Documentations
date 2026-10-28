param ascsServers array = [
  {
    vmName: 'sap-ye1-dev-ascsvm01' /*Control with naming convention later on*/
    computerName: 'azsapdcs01'
    vmSize: 'Standard_E4as_V4'
    adminUserName: 'sapvmadmin'
    adminPassword: newGuid()
    operatingSystem: 'Server2019'
    sapSid: 'ye1'
    availabilityZone: '2'
    networkSubnet: 'application-dev-subnet'
    enableAcceleratedNetworking: true
    useStaticIP: true
    IPConfiguration: [
      {
        name: 'ipconfig1'
        IPAdress: '10.192.96.5'
      }
      {
        name: 'sap-logical-hostname'
        IPAdress: '10.192.96.6'
      }
    ]
    dataDisks: [
      {
        createOption: 'empty'
        caching: 'None'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 32
      }
      {
        createOption: 'Attach'
      }
    ]
  }
  {
    vmName: 'sap-ye1-dev-ascsvm02' /*Control with naming convention later on*/
    computerName: 'azsapdcs02'
    vmSize: 'Standard_E4as_V4'
    adminUserName: 'sapvmadmin'
    adminPassword: newGuid()
    operatingSystem: 'Server2019'
    sapSid: 'ye1'
    availabilityZone: '3'
    networkSubnet: 'application-dev-subnet'
    enableAcceleratedNetworking: true
    useStaticIP: true
    IPConfiguration: [
      {
        name: 'ipconfig1'
        IPAdress: '10.192.96.4'
      }
      {
        name: 'sap-logical-hostname'
        IPAdress: '10.192.96.7'
      }
    ]
    dataDisks: [
      {
        createOption: 'empty'
        caching: 'None'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 32
      }
    ]

  }

]

param appServers array = [
  {
    vmName: 'sap-ye1-dev-app01' /*Control with naming convention later on*/
    computerName: 'azsapd001'
    vmSize: 'Standard_E16as_V4'
    adminUserName: 'sapvmadmin'
    adminPassword: newGuid()
    operatingSystem: 'Server2019'
    sapSid: 'ye1'
    availabilityZone: '2'
    networkSubnet: 'application-dev-subnet'
    enableAcceleratedNetworking: true
    useStaticIP: true
    IPConfiguration: [
      {
        name: 'ipconfig1'
        IPAdress: '10.192.96.8'
      }
      {
        name: 'sap-logical-hostname'
        IPAdress: '10.192.96.9'
      }
    ]
    dataDisks: [
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
        diskSizeGB: 256
      }
    ]
  }
  {
    vmName: 'sap-ye1-dev-app02' /*Control with naming convention later on*/
    computerName: 'azsapd002'
    vmSize: 'Standard_E16as_V4'
    adminUserName: 'sapvmadmin'
    adminPassword: newGuid()
    operatingSystem: 'Server2019'
    sapSid: 'ye1'
    availabilityZone: '3'
    networkSubnet: 'application-dev-subnet'
    enableAcceleratedNetworking: true
    useStaticIP: true
    IPConfiguration: [
      {
        name: 'ipconfig1'
        IPAdress: '10.192.96.12'
      }
      {
        name: 'sap-logical-hostname'
        IPAdress: '10.192.96.13'
      }
    ]
    dataDisks: [
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
        diskSizeGB: 256
      }
    ]
  }

]

param sqlServers array = [
  {
    vmName: 'sap-ye1-dev-db01' /*Control with naming convention later on*/
    computerName: 'azsapddb01'
    vmSize: 'Standard_m208s_v2'
    adminUserName: 'sapvmadmin'
    adminPassword: newGuid()
    operatingSystem: 'Server2019Gen2'
    sapSid: 'ye1'
    availabilityZone: '2'
    networkSubnet: 'database-dev-subnet'
    enableAcceleratedNetworking: true
    useStaticIP: true
    IPConfiguration: [
      {
        name: 'ipconfig1'
        IPAdress: '10.192.98.4'
      }
      {
        name: 'sap-logical-hostname'
        IPAdress: '10.192.98.5'
      }
    ]
    dataDisks: [
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 2048
      }
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 2048
      }
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 2048
      }
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 2048
      }
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 2048
      }
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 2048
      }
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 2048
      }
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 2048
      }
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 2048
      }
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 2048
      }
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 2048
      }
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 2048
      }
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 2048
      }
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 2048
      }
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 2048
      }
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 2048
      }
      {
        createOption: 'empty'
        caching: 'None'
        writeAcceleratorEnabled: true
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 2048
      }
      {
        createOption: 'empty'
        caching: 'None'
        writeAcceleratorEnabled: true
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 2048
      }
      {
        createOption: 'empty'
        caching: 'None'
        writeAcceleratorEnabled: true
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 2048
      }   
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: true
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 512
      }   
    ]
  }
  {
    vmName: 'sap-ye1-dev-db02' /*Control with naming convention later on*/
    computerName: 'azsapddb02'
    vmSize: 'Standard_m208s_v2'
    adminUserName: 'sapvmadmin'
    adminPassword: newGuid()
    operatingSystem: 'Server2019Gen2'
    sapSid: 'ye1'
    availabilityZone: '3'
    networkSubnet: 'database-dev-subnet'
    enableAcceleratedNetworking: true
    useStaticIP: true
    IPConfiguration: [
      {
        name: 'ipconfig1'
        IPAdress: '10.192.98.6'
      }
      {
        name: 'sap-logical-hostname'
        IPAdress: '10.192.98.7'
      }
    ]
    dataDisks: [
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 2048
      }
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 2048
      }
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 2048
      }
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 2048
      }
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 2048
      }
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 2048
      }
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 2048
      }
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 2048
      }
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 2048
      }
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 2048
      }
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 2048
      }
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 2048
      }
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 2048
      }
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 2048
      }
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 2048
      }
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 2048
      }
      {
        createOption: 'empty'
        caching: 'None'
        writeAcceleratorEnabled: true
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 2048
      }
      {
        createOption: 'empty'
        caching: 'None'
        writeAcceleratorEnabled: true
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 2048
      }
      {
        createOption: 'empty'
        caching: 'None'
        writeAcceleratorEnabled: true
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 2048
      }   
      {
        createOption: 'empty'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        storageAccountType: 'Premium_LRS'
        diskSizeGB: 512
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



// module ascsservers 'modules/vm.bicep' = [for (server,i) in ascsServers: {
//   name: '${server.vmName}'
//   params: {
//     location: location
//     vmName: '${server.vmName}'
//     environment: deploymentEnvironment
//     computerName: server.computerName
//     adminPassword: server.adminPassword
//     adminUserName: server.adminUserName
//     networkResourceGroup: networkResourceGroup
//     networkSubnet: server.networkSubnet
//     networkVnet: networkVnet
//     operatingSystem: server.operatingSystem
//     vmSize: server.vmSize
//     enableAcceleratedNetworking: server.enableAcceleratedNetworking
//     availabilityZone: server.availabilityZone
//     dataDisks: server.dataDisks
//   }
// }]

// module ascsloadbalancer 'modules/network/loadbalancer.bicep' = {
//   name: 'ascs-loadbalancer'
//   params: {
//     location: location
//     lbName: 'sap-ye1-dev-lb'
//     networkResourceGroup: networkResourceGroup
//     networkVnet: networkVnet
//   }
// }

// module shareddisk 'modules/storage/managed-shared-disk.bicep' = {
//   name: 'ascs-shared-disk'
//   params: {
//     diskName: 'sap-ye1-dev-ascs-disk-shared01'
//     location: location
//     maxShares: 2
//     diskSize: 64
//     diskSKU: 'Premium_ZRS'
//     diskTier: 'P6'
//   }
// }

// module cloudwitness 'modules/storage/storage-account.bicep' = {
//   name: 'wsfc-cloudwitness'
//   params: {
//     storageAccountName: 'vestassapye1devcw'
//     location:location
//   }
// }


module appservers 'modules/vm.bicep' = [for (server, i) in appServers: {
  name: 'vm-${server.vmName}'
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
    dataDisks: server.dataDisks
  }
}]

// module sqlservers 'modules/vm.bicep' = [for (server, i) in sqlServers: {
//   name: 'vm-${server.vmName}'
//   params: {
//     location: location
//     vmName: '${server.vmName}'
//     environment: deploymentEnvironment
//     computerName: server.computerName
//     adminPassword: server.adminPassword
//     adminUserName: server.adminUserName
//     networkResourceGroup: networkResourceGroup
//     networkSubnet: server.networkSubnet
//     networkVnet: networkVnet
//     operatingSystem: server.operatingSystem
//     vmSize: server.vmSize
//     enableAcceleratedNetworking: server.enableAcceleratedNetworking
//     isSqlVM: false
//     availabilityZone: server.availabilityZone
//     dataDisks: server.dataDisks
//   }
// }]
