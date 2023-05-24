
param location string = resourceGroup().location

param sqlSettings object = {
  sqlPort: 1433
}

param vmName string


resource vm 'Microsoft.Compute/virtualMachines@2020-12-01' existing = {
  name: vmName
}

resource sqlvm 'Microsoft.SqlVirtualMachine/sqlVirtualMachines@2021-11-01-preview' = {
  name: vm.name
  location: location
  properties: {
    virtualMachineResourceId: vm.id
    sqlManagement: 'Full'
    serverConfigurationsManagementSettings: {
      sqlConnectivityUpdateSettings: {
        connectivityType: 'PRIVATE'
        port: sqlSettings.sqlPort
      }
      sqlInstanceSettings: {
        collation: 'SQL_Latin1_General_CP850_BIN2' // Setting the required collation for SAP 
      }
    }
  }
}
