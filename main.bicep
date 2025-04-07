// Main Bicep Deployment File
targetScope = 'resourceGroup'

// Parameters
param location string = resourceGroup().location
@secure()
param adminPassword string

// Unique names based on resource group ID
var uniqueSuffix = uniqueString(resourceGroup().id)
var vnet1Name = 'vnet1'
var vnet2Name = 'vnet2'
var vm1Name = 'vm1'
var vm2Name = 'vm2'
var storageAccount1Name = 'storage${uniqueSuffix}1'
var storageAccount2Name = 'storage${uniqueSuffix}2'

// 1. Deploy VNETs and configure peering
module networkModule './network/vnet.bicep' = {
  name: 'networkDeployment'
  params: {
    location: location
    vnet1Name: vnet1Name
    vnet2Name: vnet2Name
  }
}

// 2. Deploy VMs in each VNET's infra subnet
module computeModule './compute/vm.bicep' = {
  name: 'computeDeployment'
  params: {
    location: location
    adminPasswordOrKey: adminPassword
    vnet1Name: vnet1Name
    vnet2Name: vnet2Name
    vm1Name: vm1Name
    vm2Name: vm2Name
  }
  dependsOn: [
    networkModule
  ]
}

// 3. Deploy Storage Accounts in each VNET's storage subnet
module storageModule './storage/storage.bicep' = {
  name: 'storageDeployment'
  params: {
    location: location
    vnet1Name: vnet1Name
    vnet2Name: vnet2Name
    storageAccount1Name: storageAccount1Name
    storageAccount2Name: storageAccount2Name
  }
  dependsOn: [
    networkModule
  ]
}

// 4. Enable Azure Monitor for all resources
module monitorModule './monitoring/monitor.bicep' = {
  name: 'monitorDeployment'
  params: {
    location: location
    vm1Name: vm1Name
    vm2Name: vm2Name
    storageAccount1Name: storageAccount1Name
    storageAccount2Name: storageAccount2Name
  }
  dependsOn: [
    computeModule
    storageModule
  ]
}
