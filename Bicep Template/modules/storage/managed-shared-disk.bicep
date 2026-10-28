param diskName string
param location string = resourceGroup().location
param diskSize int
param diskTier string
@allowed([
  'Premium_LRS'
  'Premium_ZRS'
  'StandardSSD_LRS'
  'StandardSSD_ZRS'
  'Standard_LRS'
  'UltraSSD_LRS'
])
param diskSKU string

param maxShares int = 0


resource disk 'Microsoft.Compute/disks@2021-12-01' = {
  name: diskName
  location: location
  properties:{
    creationData: {
      createOption: 'Empty'

    }
    maxShares: maxShares
    diskSizeGB: diskSize
    tier: diskTier
  }
  sku: {
    name: diskSKU
  }
}
