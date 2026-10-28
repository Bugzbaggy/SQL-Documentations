targetScope = 'resourceGroup'

@description('Defines the naming of the Resource Virtual Machine in Azure')
param vmName string

@description('Defines the computer name in Windows, subject to the limitations of naming')
@maxLength(15)
param computerName string

param vmSize string
param location string = resourceGroup().location
@allowed([
  'prd'
  'tst'
  'dev'
])
param environment string

param adminUserName string
@secure()
param adminPassword string
@allowed([
  'Server2016'
  'Server2019'
  'Server2019Gen2'
  'SUSE15'
  'MSSQL2017WS2019'
  'RHELSAPHANA'
])
param operatingSystem string

@allowed([
  '1'
  '2'
  '3'
])
param availabilityZone string


var operatingSystemValues = {
  Server2016: {
    PublisherValue: 'MicrosoftWindowsServer'
    OfferValue: 'WindowsServer'
    SkuValue: '2016-Datacenter'
  }
  Server2019: {
    PublisherValue: 'MicrosoftWindowsServer'
    OfferValue: 'WindowsServer'
    SkuValue: '2019-Datacenter'
  }
  Server2019Gen2: {
    PublisherValue: 'MicrosoftWindowsServer'
    OfferValue: 'WindowsServer'
    SkuValue: '2019-datacenter-gensecond'
  }
  SUSE15: {
    PublisherValue: 'suse'
    OfferValue: 'sles-15-sp2-byos'
    SkuValue: 'gen2'
  }
  MSSQL2017WS2019: {
    PublisherValue: 'MicrosoftSQLServer'
    OfferValue: 'sql2017-ws2019'
    SkuValue: environment == 'prd' ? 'enterprisedbengineonly' : 'sqldev' 
  }
  RHELSAPHANA: {
    PublisherValue: 'RedHat'
    OfferValue: 'RHEL-SAP-HA'
    SkuValue: '8_4'
  }
}

param enableAcceleratedNetworking bool
param useStaticIP bool = false
param IPConfiguration array
param UsePPG bool = false
param ppgName string
param domainJoin bool = false
param domainName string = ''
param domJoinUserName string = ''
@secure()
param domJoinPassword string = ''

param dataDisks array

@description('Name of the resource group containing the subnet')
param networkResourceGroup string
@description('Name of the VNET for the VMs to be attached to. Currently only supports one input for all VMs')
param networkVnet string
@description('Name of the subnet for the VMs to be attached to. Currently only supports one input for all VMs')
param networkSubnet string

/*
*****************
SQL Resources
*****************
*/
param isSqlVM bool = false



/*
*****************
Existing resources reference
*****************
*/
resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' existing = {
  name: '${networkVnet}/${networkSubnet}'
  scope: resourceGroup(networkResourceGroup)
}

resource kv 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
  name: 'keyvault-name'
}

resource ppg 'Microsoft.Compute/proximityPlacementGroups@2021-11-01' existing = if (UsePPG) {
  name: ppgName
}
/*
*****************
Resources
*****************
*/



resource vm 'Microsoft.Compute/virtualMachines@2020-12-01' =  {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: computerName
      adminUsername: adminUserName
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: operatingSystemValues[operatingSystem].PublisherValue
        offer: operatingSystemValues[operatingSystem].OfferValue
        sku: operatingSystemValues[operatingSystem].SkuValue
        version: 'latest'
      }
      osDisk: {
        name: '${vmName}-disk-os'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
      dataDisks: [for (item, l) in dataDisks: {
        lun: l
        name: '${vmName}-disk-lun${l}'
        createOption: item.createOption
        caching: item.caching
        writeAcceleratorEnabled: item.writeAcceleratorEnabled
        diskSizeGB: item.diskSizeGB
        managedDisk: {
          storageAccountType: item.storageAccountType
        }
      }]
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
    diagnosticsProfile:{
      bootDiagnostics:{
        enabled: true
      }
    }
    proximityPlacementGroup: UsePPG ? {
     id: ppg.id
    } : null
  }
  zones: [
    availabilityZone
  ]
}


var fullIpConfigurations = [for (interface, i) in (IPConfiguration): {

  name: interface.name
  properties: {
    primary: interface.primaryIP
    subnet: {
      id: subnet.id
    }
    privateIPAllocationMethod: useStaticIP ? 'Static' : 'Dynamic'
    privateIPAddress: interface.IPAddress
  }
}]

resource nic 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: '${vmName}-nic'
  location: location
  properties: {
    ipConfigurations:fullIpConfigurations
    enableAcceleratedNetworking: enableAcceleratedNetworking
  }
}


module extdomainjoin 'windows/ext-domainjoin.bicep' = if (domainJoin == true){
  name: '${vmName}-ext-domainjoin'
#disable-next-line explicit-values-for-loc-params
  params: {
    ADPassword: domJoinPassword
    vmName: vm.name
    ADSettings: {
        domainName: domainName
        OUPath: 'OU=Default Computers,DC=vestas,DC=net'
        domainUserName: domJoinUserName
        Options: '3'
    }
  }
}

module sql 'sql/sql-vm.bicep' = if (isSqlVM == true) {
  name: '${vmName}-sql-vm'
#disable-next-line explicit-values-for-loc-params
  params: {
    vmName: vm.name
  }
  
}
