variable "environment" {
  description = "Environment name (dev, uat, prod)"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastasia"
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "cluster_name" {
  description = "AKS cluster name"
  type        = string
}

variable "node_count" {
  description = "Number of AKS worker nodes"
  type        = number
  default     = 1
}

variable "vm_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "standard_b2s_v2"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.35.6"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}