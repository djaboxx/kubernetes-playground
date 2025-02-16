output "argocd_namespace" {
  description = "The namespace where ArgoCD is deployed"
  value       = kubernetes_namespace.argocd.metadata[0].name
}

output "argocd_url" {
  description = "The URL where ArgoCD UI can be accessed"
  value       = "https://${var.domain_name}"
}

output "admin_password_command" {
  description = "Command to get the admin password for ArgoCD"
  value       = "kubectl -n ${kubernetes_namespace.argocd.metadata[0].name} get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
}