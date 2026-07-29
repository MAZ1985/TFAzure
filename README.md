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



## Assumptions & Decisions
The node allocation for each environment is based on balancing cost efficiency, operational requirements, and system reliability.<br>
The Development (Dev) environment uses a single node because its primary purpose is application development, debugging, and feature testing, where high availability is not critical and minimizing infrastructure costs is a priority. <br>
The User Acceptance Testing (UAT) environment is provisioned with two nodes to better simulate a production-like setup while providing basic high availability, enabling more reliable testing of application behavior under realistic deployment conditions. <br>
The Production (Prod) environment is configured with three nodes to ensure higher resilience, fault tolerance, and workload distribution, allowing the system to remain available even if one node fails. This approach assumes that development workloads are lightweight, UAT requires a representative environment for validation, and production demands continuous availability, scalability, and business continuity. <br><br>

Region Selection: The East Asia region was selected because it is geographically close to Malaysia, with the assumption that this proximity would help reduce network latency and improve application responsiveness. <br>
Public IP Limitation: Initially, the Azure subscription was limited to three public IP addresses, which was insufficient to deploy three Azure Kubernetes Service (AKS) clusters, as each AKS cluster requires at least two public IP addresses. This limitation was resolved by upgrading the Azure subscription from the Free tier to the Pay-As-You-Go plan, which allowed the public IP quota to be increased. <br>
vCPU Quota Limitation: During deployment, a vCPU quota limitation was encountered for the selected virtual machine (VM) size. This issue was resolved by requesting and increasing the vCPU quota for the required VM size, enabling the successful provisioning of the AKS clusters. <br><br>

An initial approach considered deploying the Azure Kubernetes Service (AKS) clusters within a private network to address the public IP limitation. Under this design, each AKS cluster would require only a single public IP address for the external load balancer, significantly reducing public IP consumption. However, this approach was ultimately not adopted because the assignment specifies that authentication to AKS should be performed using az login with a local kubeconfig. A private AKS cluster is not directly accessible from the public internet and would require additional infrastructure, such as an Azure Bastion host, VPN, ExpressRoute, or another secure connectivity solution, to interact with the Kubernetes API server. Introducing these components would increase the deployment complexity and go beyond the scope and assumptions of the assignment.
