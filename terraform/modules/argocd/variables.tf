variable "namespace" {
  description = "The namespace to deploy ArgoCD into"
  type        = string
  default     = "argocd"
}

variable "argocd_helm_version" {
  description = "The version of the ArgoCD Helm chart to use"
  type        = string
  default     = "5.46.7"  # Latest stable version as of now
}

variable "domain_name" {
  description = "The domain name to use for ArgoCD ingress"
  type        = string
  default     = "argocd.example.com"
}