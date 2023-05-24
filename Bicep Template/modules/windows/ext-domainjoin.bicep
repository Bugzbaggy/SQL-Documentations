param vmName string

@description('Name of the keyvault ')
param location string = resourceGroup().location
param ADSettings object = {
  domainName: ''
  OUPath: ''
  domainUserName: ''

}
@secure()
param ADPassword string

resource vm 'Microsoft.Compute/virtualMachines@2021-11-01' existing = {
  name: vmName
}




resource vm_ext_join_domain 'Microsoft.Compute/virtualMachines/extensions@2015-06-15' = {
  name: 'joindomain'
  parent: vm
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'JsonADDomainExtension'
    typeHandlerVersion: '1.3'
    autoUpgradeMinorVersion: true
    settings: {
      Name: ADSettings.domainName
      User: ADSettings.domainUserName
      Restart: 'true'
      Options: ''
      OUPath: ADSettings.OUPath
    }
    protectedSettings: {
      Password: ADPassword
    }
  }
}
