output "argocd_namespace" {
  description = "The namespace ArgoCD was installed in"
  value       = kubernetes_namespace.argocd.metadata[0].name
}

output "argocd_server_service" {
  description = "Name of the ArgoCD server service"
  value       = "${helm_release.argocd.name}-server"
}

output "argocd_url" {
  description = "URL of the ArgoCD server"
  value       = var.service_type == "LoadBalancer" ? "https://<LoadBalancer-IP>" : "Use kubectl port-forward service/argocd-server -n ${kubernetes_namespace.argocd.metadata[0].name} 8080:443"
}

output "namespace" {
  description = "The namespace where Argo CD is installed"
  value       = kubernetes_namespace.argocd.metadata[0].name
}

output "server_service_name" {
  description = "The name of the Argo CD server service"
  value       = "${var.release_name}-argocd-server"
}

output "server_service_port" {
  description = "The port of the Argo CD server service"
  value       = 443
}

output "admin_password" {
  description = "The admin password for Argo CD"
  value       = var.admin_password
  sensitive   = true
}

output "helm_release_metadata" {
  description = "Helm release metadata"
  value       = helm_release.argocd.metadata
}