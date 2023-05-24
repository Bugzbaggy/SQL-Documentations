param nicName string
param subnetName string
param subnetResourceGroup string

// Reference existing IP
// Take existing private IP
// Set it to static


resource nicExisting 'Microsoft.Network/networkInterfaces@2021-05-01' existing = {
  name: nicName
}
