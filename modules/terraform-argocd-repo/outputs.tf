output "repository_url" {
  description = "Git clone URL of the created repository"
  value       = module.github_repo.http_clone_url
}

output "repository_ssh_url" {
  description = "SSH clone URL of the created repository"
  value       = module.github_repo.ssh_clone_url
}

output "repository_id" {
  description = "The ID of the created repository"
  value       = module.github_repo.repo_id
}

output "repository_name" {
  description = "The name of the created repository"
  value       = var.repository_name
}

output "argocd_repository_id" {
  description = "The ID of the ArgoCD repository configuration"
  value       = argocd_repository.repo.id
}