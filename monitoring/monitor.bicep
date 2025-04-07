// Azure Monitor Module
param location string = resourceGroup().location
param vm1Name string
param vm2Name string
param storageAccount1Name string
param storageAccount2Name string
param logAnalyticsWorkspaceName string = 'law-${uniqueString(resourceGroup().id)}'

// Create Log Analytics Workspace
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

// Get references to existing VMs
resource vm1 'Microsoft.Compute/virtualMachines@2022-08-01' existing = {
  name: vm1Name
}

resource vm2 'Microsoft.Compute/virtualMachines@2022-08-01' existing = {
  name: vm2Name
}

// Get references to existing Storage Accounts
resource storageAccount1 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  name: storageAccount1Name
}

resource storageAccount2 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  name: storageAccount2Name
}

// Get references to the blob services for each Storage Account
resource storageAccount1Blob 'Microsoft.Storage/storageAccounts/blobServices@2021-09-01' existing = {
  name: '${storageAccount1Name}/default'
}

resource storageAccount2Blob 'Microsoft.Storage/storageAccounts/blobServices@2021-09-01' existing = {
  name: '${storageAccount2Name}/default'
}

// VM1 Diagnostics Settings
resource vm1DiagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: vm1
  name: '${vm1Name}-diag'
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

// VM2 Diagnostics Settings
resource vm2DiagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: vm2
  name: '${vm2Name}-diag'
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

// Storage Account 1 Diagnostics Settings on Blob Service
resource storageAccount1DiagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: storageAccount1Blob
  name: '${storageAccount1Name}-diag'
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    metrics: [
      {
        category: 'Transaction'
        enabled: true
      }
    ]
    logs: [
      {
        category: 'StorageRead'
        enabled: true
      }
      {
        category: 'StorageWrite'
        enabled: true
      }
      {
        category: 'StorageDelete'
        enabled: true
      }
    ]
  }
}

// Storage Account 2 Diagnostics Settings on Blob Service
resource storageAccount2DiagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: storageAccount2Blob
  name: '${storageAccount2Name}-diag'
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    metrics: [
      {
        category: 'Transaction'
        enabled: true
      }
    ]
    logs: [
      {
        category: 'StorageRead'
        enabled: true
      }
      {
        category: 'StorageWrite'
        enabled: true
      }
      {
        category: 'StorageDelete'
        enabled: true
      }
    ]
  }
}

// VM Insights for VM1
resource vm1MonitoringExtension 'Microsoft.Compute/virtualMachines/extensions@2022-08-01' = {
  parent: vm1
  name: 'AzureMonitorLinuxAgent'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.Monitor'
    type: 'AzureMonitorLinuxAgent'
    typeHandlerVersion: '1.0'
    autoUpgradeMinorVersion: true
  }
}

// VM Insights for VM2
resource vm2MonitoringExtension 'Microsoft.Compute/virtualMachines/extensions@2022-08-01' = {
  parent: vm2
  name: 'AzureMonitorLinuxAgent'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.Monitor'
    type: 'AzureMonitorLinuxAgent'
    typeHandlerVersion: '1.0'
    autoUpgradeMinorVersion: true
  }
}
