# Bicep Template Deployment Summary

**Author:** Shahzeb Faisal  
**GitHub Repository:** [Bicep-Shahzeb-Ass](https://github.com/ShahzebFaisal5649/Bicep-Shahzeb-Ass)

---

## 📄 Overview

This deployment automates Azure infrastructure using **Bicep templates** with the **Azure CLI**. The structure includes modular Bicep files for key resources:

- Virtual Machine  
- Virtual Network (VNet)  
- Storage Account  
- Monitoring  

---

## 🚀 Deployment Workflow

### ✅ 1. Azure CLI Setup

```bash
# Login to Azure
az login

# Set subscription (if needed)
az account set --subscription "<your-subscription-id>"
```

---

### ✅ 2. Resource Group Creation

```bash
az group create --name rg-cs5304-shahzebfaisal5649 --location eastus
```

Creates a resource group in East US for all resources.

---

### ✅ 3. Bicep Template Structure

| Bicep File      | Purpose                                  |
|------------------|-------------------------------------------|
| `main.bicep`     | Root file that links all module templates |
| `vm.bicep`       | Deploys a Virtual Machine                 |
| `vnet.bicep`     | Defines a Virtual Network                 |
| `storage.bicep`  | Creates a Storage Account                 |
| `monitor.bicep`  | Sets up Azure Monitor/Diagnostics         |

---

### ✅ 4. Deployment Command

```bash
az deployment group create \
  --resource-group rg-cs5304-shahzebfaisal5649 \
  --template-file main.bicep
```

Triggers the deployment process for all modules referenced in `main.bicep`.

---

## ⚙️ Parameters Used

Each module accepts parameters passed from `main.bicep`. Example:

```bicep
module vm 'vm.bicep' = {
  name: 'vmModule'
  params: {
    vmName: 'myVM'
    adminUsername: 'azureuser'
    adminPassword: 'Pa$$w0rd123'
  }
}
```

These parameters allow dynamic VM configuration.

---

## 🔍 Validation & Visualization

### View Deployed Resources:

```bash
az resource list --resource-group rg-cs5304-shahzebfaisal5649 --output table
```

### Export & Visualize via Azure Portal:

1. Navigate to your **resource group**
2. Click **"Export Template"** to download the ARM template
3. Screenshot resource visual and exported JSON

📸 Images:
- `rg-cs5304-shahzebfaisal5649.png`
- `AzureExportedTemplate.png`

---

## 🧩 Challenges Faced

- Debugging syntax and parameter mismatches  
- Resource provisioning delays  
- Correct module referencing in `main.bicep`

---

## 🛠️ Deployment Steps

### 1. Deploy Bicep Templates Using Azure CLI

#### a. Subscription-level Deployment

```bash
az deployment sub create \
  --location "eastus" \
  --template-file main.bicep \
  --parameters adminUsername="azureadmin" adminPasswordOrKey="YourPassword123!"
```

#### b. Resource Group-level Deployment

```bash
az deployment group create \
  --resource-group rg-cs5304-shahzebfaisal5649 \
  --template-file main.bicep \
  --parameters @parameters.json
```

---

### 2. Parameters Used

| Parameter Name       | Description                           | Example Value       |
|----------------------|---------------------------------------|---------------------|
| `adminUsername`      | Username for VMs                      | `azureadmin`        |
| `adminPasswordOrKey` | Password or SSH key for authentication| `YourPassword123!`  |
| `location`           | Azure region                          | `eastus`            |
| `vmSize`             | Size of the VMs                       | `Standard_B1s`      |

Parameters can be passed inline or stored in `parameters.json`.

---

## 🏗️ Deployed Architecture

### 🔗 1. VNet Peering

Two virtual networks `vnet1` and `vnet2` are connected using **VNet peering**.

---

### 🌐 2. Full Resource Deployment Architecture

A diagram illustrates the relationships between:

- Virtual Machines  
- Virtual Networks  
- Storage Accounts  
- Azure Monitoring Resources  

---

Feel free to clone the repo, test the deployment, and adapt the templates to your use case! 🚀
