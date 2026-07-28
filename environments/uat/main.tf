terraform {
  required_version = ">= 1.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.81.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.2.1"
    }
  }
}

provider "azurerm" {
  features {}
}

# Variables
variable "environment" {
  description = "Environment name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "node_count" {
  description = "Number of AKS nodes"
  type        = number
}

variable "vm_size" {
  description = "VM size for AKS nodes"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
}

variable "app_replicas" {
  description = "Number of application replicas"
  type        = number
}

variable "index_message" {
  description = "Message for the index page"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
}

# AKS Module
module "aks" {
  source = "../../modules/aks"
  
  environment         = var.environment
  location            = var.location
  resource_group_name = "rg-aks-${var.environment}"
  cluster_name        = "aks-${var.environment}-cluster"
  node_count          = var.node_count
  vm_size             = var.vm_size
  kubernetes_version  = var.kubernetes_version
  
  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Kubernetes Provider Configuration
provider "kubernetes" {
  host                   = module.aks.host
  client_certificate     = base64decode(module.aks.client_certificate)
  client_key             = base64decode(module.aks.client_key)
  cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
}

# Kubernetes App Module
module "kubernetes_app" {
  source = "../../modules/kubernetes_app"
  
  environment   = var.environment
  namespace     = var.namespace
  app_name      = "apache-web"
  replicas      = var.app_replicas
  index_message = var.index_message
  
  depends_on = [module.aks]
}

# Outputs
output "resource_group_name" {
  value = module.aks.resource_group_name
}

output "cluster_name" {
  value = module.aks.cluster_name
}

output "load_balancer_ip" {
  description = "Application load balancer IP"
  value       = module.kubernetes_app.load_balancer_ip
}

output "application_url" {
  description = "Application URL"
  value       = "http://${module.kubernetes_app.load_balancer_ip}"
}