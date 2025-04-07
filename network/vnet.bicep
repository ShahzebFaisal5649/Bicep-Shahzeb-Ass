// VNET Module
param location string = resourceGroup().location
param vnet1Name string = 'vnet1'
param vnet2Name string = 'vnet2'
param vnet1AddressPrefix string = '10.0.0.0/16'
param vnet2AddressPrefix string = '10.1.0.0/16'
param vnet1InfraSubnetPrefix string = '10.0.0.0/24'
param vnet1StorageSubnetPrefix string = '10.0.1.0/24'
param vnet2InfraSubnetPrefix string = '10.1.0.0/24'
param vnet2StorageSubnetPrefix string = '10.1.1.0/24'

// First VNET
resource vnet1 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: vnet1Name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnet1AddressPrefix
      ]
    }
    subnets: [
      {
        name: 'infra'
        properties: {
          addressPrefix: vnet1InfraSubnetPrefix
        }
      }
      {
        name: 'storage'
        properties: {
          addressPrefix: vnet1StorageSubnetPrefix
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
              locations: [
                location
              ]
            }
          ]
        }
      }
    ]
  }
}

// Second VNET
resource vnet2 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: vnet2Name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnet2AddressPrefix
      ]
    }
    subnets: [
      {
        name: 'infra'
        properties: {
          addressPrefix: vnet2InfraSubnetPrefix
        }
      }
      {
        name: 'storage'
        properties: {
          addressPrefix: vnet2StorageSubnetPrefix
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
              locations: [
                location
              ]
            }
          ]
        }
      }
    ]
  }
}

// VNET Peering - VNET1 to VNET2 using parent property
resource vnet1ToVnet2Peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-07-01' = {
  parent: vnet1
  name: 'peering-to-${vnet2Name}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: vnet2.id
    }
  }
}

// VNET Peering - VNET2 to VNET1 using parent property
resource vnet2ToVnet1Peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-07-01' = {
  parent: vnet2
  name: 'peering-to-${vnet1Name}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: vnet1.id
    }
  }
}
