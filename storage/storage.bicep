// Storage Module
param location string = resourceGroup().location
param vnet1Name string
param vnet2Name string
param storageAccount1Name string = 'storage${uniqueString(resourceGroup().id)}1'
param storageAccount2Name string = 'storage${uniqueString(resourceGroup().id)}2'

// Get subnet references from existing VNETs
resource vnet1 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: vnet1Name
}

resource vnet2 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: vnet2Name
}

// Storage Account 1 in VNET1's storage subnet (ZRS)
resource storageAccount1 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccount1Name
  location: location
  sku: {
    name: 'Standard_ZRS'  // Zone-redundant storage
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      virtualNetworkRules: [
        {
          id: '${vnet1.id}/subnets/storage'
          action: 'Allow'
        }
      ]
    }
  }
}

// Storage Account 2 in VNET2's storage subnet (ZRS)
resource storageAccount2 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccount2Name
  location: location
  sku: {
    name: 'Standard_ZRS'  // Zone-redundant storage
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      virtualNetworkRules: [
        {
          id: '${vnet2.id}/subnets/storage'
          action: 'Allow'
        }
      ]
    }
  }
}
