variable "environment" {
  description = "Environment name"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
  default     = "default"
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "apache-web"
}

variable "replicas" {
  description = "Number of application replicas"
  type        = number
  default     = 2
}

variable "apache_image" {
  description = "Apache HTTP Server image"
  type        = string
  default     = "httpd:2.4"
}

variable "index_message" {
  description = "Message to display on the index page"
  type        = string
}

variable "service_type" {
  description = "Kubernetes service type"
  type        = string
  default     = "LoadBalancer"
}