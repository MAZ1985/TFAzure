# Terraform Modular Infrastructure for Azure Kubernetes Service (AKS)

## 📋 Overview

This tasks implements a modular Terraform solution for provisioning Azure Kubernetes Service (AKS) clusters and deploying Apache web applications across three isolated environments: **dev**, **uat**, and **prod**.

### Key Features
- **Modular Design**: Reusable modules for AKS infrastructure and Kubernetes applications
- **Environment Isolation**: Separate resource groups, clusters, and configurations per environment
- **Load Balanced**: Each environment exposed via Azure Load Balancer
- **ConfigMap Based**: Environment-specific messages mounted as ConfigMaps
- **Scalable**: Configurable node counts and replica sets per environment

## Architecture Overview
### Architecture Diagram
![image_alt](https://github.com/MAZ1985/TFAzure/blob/main/architecture_diagram.jpg?raw=true)

## How To Deploy Each Environment

### DEV Environment
```bash
# Navigate to dev environment.
cd ~/TFAzure/environments/dev

# Initialize Terraform.
terraform init

# Preview changes
terraform plan -out=tfplan

# Apply configuration
terraform apply tfplan
```

### UAT Environment
```bash
# Navigate to uat environment.
cd ~/TFAzure/environments/uat

# Initialize Terraform.
terraform init

# Preview changes
terraform plan -out=tfplan

# Apply configuration
terraform apply tfplan
```

### PROD Environment
```bash
# Navigate to prod environment.
cd ~/TFAzure/environments/prod

# Initialize Terraform.
terraform init

# Preview changes
terraform plan -out=tfplan

# Apply configuration
terraform apply tfplan
```
