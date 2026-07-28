output "service_name" {
  description = "Kubernetes service name"
  value       = kubernetes_service_v1.apache.metadata[0].name
}

output "namespace" {
  description = "Kubernetes namespace"
  value       = var.namespace
}

output "load_balancer_ip" {
  description = "External IP of the load balancer"
  value       = kubernetes_service_v1.apache.status[0].load_balancer[0].ingress[0].ip
}

output "deployment_name" {
  description = "Deployment name"
  value       = kubernetes_deployment_v1.apache.metadata[0].name
}