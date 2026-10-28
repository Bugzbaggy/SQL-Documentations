param location string = resourceGroup().location
param ppgName string


resource ppg 'Microsoft.Compute/proximityPlacementGroups@2021-11-01' = {
  name: ppgName
  location: location
  properties: {
    proximityPlacementGroupType: 'Standard'
  }
}
