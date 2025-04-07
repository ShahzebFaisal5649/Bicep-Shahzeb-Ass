// VM Module
param location string = resourceGroup().location
param adminUsername string = 'azureuser'
@secure()
param adminPasswordOrKey string

param vnet1Name string
param vnet2Name string
param vm1Name string = 'vm1'
param vm2Name string = 'vm2'
param vmSize string = 'Standard_B2s'

// Get subnet references from existing VNETs
resource vnet1 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: vnet1Name
}

resource vnet2 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: vnet2Name
}

// Public IP for VM1
resource vm1PublicIP 'Microsoft.Network/publicIPAddresses@2022-07-01' = {
  name: '${vm1Name}-pip'
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
  sku: {
    name: 'Basic'
  }
}

// Public IP for VM2
resource vm2PublicIP 'Microsoft.Network/publicIPAddresses@2022-07-01' = {
  name: '${vm2Name}-pip'
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
  sku: {
    name: 'Basic'
  }
}

// Network Interface for VM1
resource vm1Nic 'Microsoft.Network/networkInterfaces@2022-07-01' = {
  name: '${vm1Name}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: '${vnet1.id}/subnets/infra'
          }
          publicIPAddress: {
            id: vm1PublicIP.id
          }
        }
      }
    ]
  }
}

// Network Interface for VM2
resource vm2Nic 'Microsoft.Network/networkInterfaces@2022-07-01' = {
  name: '${vm2Name}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: '${vnet2.id}/subnets/infra'
          }
          publicIPAddress: {
            id: vm2PublicIP.id
          }
        }
      }
    ]
  }
}

// VM1 in VNET1's infra subnet
resource vm1 'Microsoft.Compute/virtualMachines@2022-08-01' = {
  name: vm1Name
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vm1Name
      adminUsername: adminUsername
      adminPassword: adminPasswordOrKey
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '18.04-LTS'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: vm1Nic.id
        }
      ]
    }
  }
}

// VM2 in VNET2's infra subnet
resource vm2 'Microsoft.Compute/virtualMachines@2022-08-01' = {
  name: vm2Name
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vm2Name
      adminUsername: adminUsername
      adminPassword: adminPasswordOrKey
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '18.04-LTS'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: vm2Nic.id
        }
      ]
    }
  }
}
