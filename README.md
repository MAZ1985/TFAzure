# Terraform Modular Infrastructure for Azure Kubernetes Service (AKS)

## 📋 Overview

This tasks implements a modular Terraform solution for provisioning Azure Kubernetes Service (AKS) clusters and deploying Apache web applications across three isolated environments: **dev**, **uat**, and **prod**.

### Key Features
- **Modular Design**: Reusable modules for AKS infrastructure and Kubernetes applications
- **Environment Isolation**: Separate resource groups, clusters, and configurations per environment
- **Load Balanced**: Each environment exposed via Azure Load Balancer
- **ConfigMap Based**: Environment-specific messages mounted as ConfigMaps
- **Scalable**: Configurable node counts and replica sets per environment

## How To Deploy Each Environment

### DEV Environment
```bash
# Navigate to dev environment.
cd ~/TFAzure/environments/dev

# Initialize Terraform.
terraform init

# Preview changes
terraform plan -out=dev.tfplan

# Apply configuration
terraform apply dev.tfplan
```

### UAT Environment
```bash
# Navigate to uat environment.
cd ~/TFAzure/environments/uat

# Initialize Terraform.
terraform init

# Preview changes
terraform plan -out=uat.tfplan

# Apply configuration
terraform apply uat.tfplan
```

### PROD Environment
```bash
# Navigate to prod environment.
cd ~/TFAzure/environments/prod

# Initialize Terraform.
terraform init

# Preview changes
terraform plan -out=prod.tfplan

# Apply configuration
terraform apply prod.tfplan
```