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
![image_alt](https://github.com/MAZ1985/TFAzure/blob/main/pictures/architecture_diagram.jpg?raw=true)

This architecture consists of 3 separate Azure Kubernetes Service (AKS) environments that host the same Apache HTTP Server (httpd) application:
| Environment | Resource Group | AKS Nodes | httpd Replicas |
|-------------|:---------------|:----------|:---------------|
| Development | rg-aks-dev | 1 Node | 2 Replicas |
| UAT | rg-aks-uat | 2 Nodes | 3 Replicas |
| Production | rg-aks-prod | 3 Nodes | 6 Replicas |

Traffic from users reaches the application through an Azure Load Balancer, which distributes request across the available Apache (httpd) pods running in each AKS Cluster.

#### Seperate AKS Environments
Isolation - Development, testing, and production workloads are kept separate to prevent changes from affecting live applications.<br>
Reliability - Applications are tested in Dev and UAT before being deployed to Production.<br>
Cost Control - Resources can be sized appropriately for each environment's needs.

#### Different Numbers of Nodes
Dev (1 node) - Minimal resources to reduce cost while supporting development activities.<br>
UAT (2 nodes) - Provides a more realistic testing environment and basic high availability.<br>
Prod (3 nodes) - Improves resilience, fault tolerance, and supports higher workloads.

#### Different Numbers of Replicas
Dev (2 Replicas) - Allows testing of application deployment and load balancing.<br>
UAT (3 Replicas) - Simulate production behavior and supports application validation.<br>
Prod (6 Replicas) - Ensures high availability, better performance, and the ability to handle more user traffic.

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
##### Sample output of 'terraform plan' for dev
![image_alt](https://github.com/MAZ1985/TFAzure/blob/main/pictures/tfplan_dev.JPG?raw=true)

##### Sample output of 'terraform apply' for dev
![image_alt](https://github.com/MAZ1985/TFAzure/blob/main/pictures/tfapply_dev.JPG?raw=true)

#### Result of successful deployment for dev environment
Paste the public IP for dev environment into web browser and result should be seen as below.
![image_alt](https://github.com/MAZ1985/TFAzure/blob/main/pictures/dev_aks.JPG?raw=true)


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
##### Sample output of 'terraform plan' for uat
![image_alt](https://github.com/MAZ1985/TFAzure/blob/main/pictures/tfplan_uat.JPG?raw=true)

##### Sample output of 'terraform apply' for uat
![image_alt](https://github.com/MAZ1985/TFAzure/blob/main/pictures/tfapply_uat.JPG?raw=true)

#### Result of successful deployment for uat environment
Paste the public IP for uat environment into web browser and result should be seen as below.
![image_alt](https://github.com/MAZ1985/TFAzure/blob/main/pictures/uat_aks.JPG?raw=true)


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
##### Sample output of 'terraform plan' for prod
![image_alt](https://github.com/MAZ1985/TFAzure/blob/main/pictures/tfplan_prod.JPG?raw=true)

##### Sample output of 'terraform apply' for prod
![image_alt](https://github.com/MAZ1985/TFAzure/blob/main/pictures/tfapply_prod.JPG?raw=true)


#### Result of successful deployment for prod environment
Paste the public IP for prod environment into web browser and result should be seen as below.
![image_alt](https://github.com/MAZ1985/TFAzure/blob/main/pictures/prod_aks.JPG?raw=true)



## How Modules Are Structured
Terraform code is organized into two main parts: environments and modules.<br>
The environments directory contains separate configurations for dev, uat, and prod, each referencing reusable modules.<br>
The modules directory contains self-contained building blocks: one module (aks) provisions the AKS cluster, and another (kubernetes_app) deploys the Apache application.<br>
Each module has its own main.tf, variables.tf, and outputs.tf to define resources, accept inputs, and expose outputs.<br>
This modular structure ensures reusability, consistency, and easy scaling across environments.

#### Sample of aks and kubernetes_app module structure
![image_alt](https://github.com/MAZ1985/TFAzure/blob/main/pictures/module_structure.JPG?raw=true)
