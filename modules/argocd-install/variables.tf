variable "namespace" {
  description = "Namespace to install Argo CD"
  type        = string
  default     = "argocd"
}

variable "namespace_labels" {
  description = "Labels to add to the Argo CD namespace"
  type        = map(string)
  default     = {}
}

variable "release_name" {
  description = "Helm release name"
  type        = string
  default     = "argocd"
}

variable "chart_version" {
  description = "Version of the Argo CD Helm chart"
  type        = string
}

variable "server_extra_args" {
  description = "List of extra arguments for the Argo CD server"
  type        = list(string)
  default     = ["--insecure"]
}

variable "service_type" {
  description = "Service type for the Argo CD server"
  type        = string
  default     = "ClusterIP"
}

variable "service_annotations" {
  description = "Annotations to add to the Argo CD server service"
  type        = map(string)
  default     = {}
}

variable "ingress_enabled" {
  description = "Enable ingress for the Argo CD server"
  type        = bool
  default     = false
}

variable "ingress_hosts" {
  description = "List of hosts for the Argo CD ingress"
  type        = list(string)
  default     = []
}

variable "ingress_annotations" {
  description = "Annotations to add to the Argo CD ingress"
  type        = map(string)
  default     = {}
}

variable "ingress_tls" {
  description = "TLS configuration for the Argo CD ingress"
  type        = any
  default     = []
}

variable "admin_password" {
  description = "Admin password for Argo CD"
  type        = string
  sensitive   = true
}

variable "create_secret" {
  description = "Create the argocd-secret"
  type        = bool
  default     = true
}

variable "admin_enabled" {
  description = "Enable local admin user"
  type        = bool
  default     = true
}

variable "reconciliation_timeout" {
  description = "Timeout for application reconciliation"
  type        = string
  default     = "180s"
}

variable "server_url" {
  description = "External URL for Argo CD"
  type        = string
  default     = ""
}

variable "rbac_config" {
  description = "RBAC configuration for Argo CD"
  type        = map(string)
  default     = {}
}

variable "repo_server_replicas" {
  description = "Number of repo server replicas"
  type        = number
  default     = 1
}

variable "repo_server_resources" {
  description = "Resource requests and limits for repo server"
  type        = map(object({
    limits = map(string)
    requests = map(string)
  }))
  default     = {}
}

variable "applicationset_enabled" {
  description = "Enable ApplicationSet controller"
  type        = bool
  default     = true
}

variable "applicationset_replicas" {
  description = "Number of ApplicationSet controller replicas"
  type        = number
  default     = 1
}

variable "redis_enabled" {
  description = "Enable Redis"
  type        = bool
  default     = true
}

variable "redis_resources" {
  description = "Resource requests and limits for Redis"
  type        = map(object({
    limits = map(string)
    requests = map(string)
  }))
  default     = {}
}

variable "controller_replicas" {
  description = "Number of application controller replicas"
  type        = number
  default     = 1
}

variable "controller_resources" {
  description = "Resource requests and limits for application controller"
  type        = map(object({
    limits = map(string)
    requests = map(string)
  }))
  default     = {}
}

variable "dex_enabled" {
  description = "Enable dex for SSO"
  type        = bool
  default     = true
}

variable "dex_resources" {
  description = "Resource requests and limits for dex"
  type        = map(object({
    limits = map(string)
    requests = map(string)
  }))
  default     = {}
}

variable "extra_set_values" {
  description = "Extra values to pass to the Helm chart using set"
  type        = list(object({
    name  = string
    value = string
    type  = string
  }))
  default     = []
}

variable "helm_values" {
  description = "Additional values to pass to the Helm chart (as yaml/json)"
  type        = string
  default     = ""
}

variable "helm_value_files" {
  description = "List of Helm value files to use"
  type        = list(string)
  default     = []
}

variable "ignore_missing_value_files" {
  description = "Ignore missing Helm value files"
  type        = bool
  default     = false
}

variable "pass_credentials" {
  description = "Pass credentials to all Helm API calls"
  type        = bool
  default     = false
}

variable "skip_crds" {
  description = "Skip CRD installation step"
  type        = bool
  default     = false
}

variable "skip_schema_validation" {
  description = "Skip Helm schema validation"
  type        = bool
  default     = false
}

variable "values_object" {
  description = "Additional values in raw yaml to pass to Helm (alternative to values)"
  type        = any
  default     = null
}

variable "ha_enabled" {
  description = "Enable high availability mode"
  type        = bool
  default     = false
}

variable "notifications_enabled" {
  description = "Enable Argo CD notifications controller"
  type        = bool
  default     = false
}

variable "configs_cm" {
  description = "ArgoCD ConfigMap additional properties. For more information: https://argo-cd.readthedocs.io/en/stable/operator-manual/argocd-cm.yaml"
  type        = map(string)
  default     = {}
}

variable "configs_rbac" {
  description = "ArgoCD RBAC policy ConfigMap additional properties. For more information: https://argo-cd.readthedocs.io/en/stable/operator-manual/rbac"
  type        = map(string)
  default     = {}
}

variable "configs_ssh" {
  description = "ArgoCD SSH known hosts data for connecting repositories. For more information: https://argo-cd.readthedocs.io/en/stable/operator-manual/argocd-ssh-known-hosts-cm.yaml"
  type        = map(string)
  default     = {}
}

variable "configs_tls" {
  description = "ArgoCD TLS certificate configurations. For more information: https://argo-cd.readthedocs.io/en/stable/operator-manual/argocd-tls-certs-cm.yaml"
  type        = map(string)
  default     = {}
}

variable "configs_repositories" {
  description = "ArgoCD repositories list. For more information: https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/#repositories"
  type        = map(string)
  default     = {}
}

variable "configs_repository_credentials" {
  description = "ArgoCD repository credentials list. For more information: https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/#repository-credentials"
  type        = map(string)
  default     = {}
}

variable "server_metrics_enabled" {
  description = "Deploy metrics service"
  type        = bool
  default     = false
}

variable "server_route_enabled" {
  description = "Enable route creation for OpenShift"
  type        = bool
  default     = false
}

variable "server_autoscaling_enabled" {
  description = "Enable Horizontal Pod Autoscaling"
  type        = bool
  default     = false
}

variable "server_autoscaling_min_replicas" {
  description = "Minimum number of replicas for autoscaling"
  type        = number
  default     = 1
}

variable "server_autoscaling_max_replicas" {
  description = "Maximum number of replicas for autoscaling"
  type        = number
  default     = 5
}

variable "repoServer_metrics_enabled" {
  description = "Deploy metrics service for repo server"
  type        = bool
  default     = false
}

variable "repoServer_autoscaling_enabled" {
  description = "Enable Horizontal Pod Autoscaling for repo server"
  type        = bool
  default     = false
}

variable "repoServer_autoscaling_min_replicas" {
  description = "Minimum number of replicas for repo server autoscaling"
  type        = number
  default     = 1
}

variable "repoServer_autoscaling_max_replicas" {
  description = "Maximum number of replicas for repo server autoscaling"
  type        = number
  default     = 5
}

variable "applicationSet_enabled" {
  description = "Enable Application Set controller"
  type        = bool
  default     = true
}

variable "applicationSet_metrics_enabled" {
  description = "Deploy metrics service for ApplicationSet controller"
  type        = bool
  default     = false
}

variable "global_image_registry" {
  description = "Global Docker image registry for all Argo CD components"
  type        = string
  default     = ""
}

variable "global_image_tag" {
  description = "Global Docker image tag for all Argo CD components"
  type        = string
  default     = ""
}

variable "init_containers" {
  description = "Init containers to add to the Argo CD server pod"
  type        = list(map(string))
  default     = []
}

variable "replica_count" {
  description = "The number of Argo CD server replicas"
  type        = number
  default     = 1
}

variable "extra_objects" {
  description = "Additional Kubernetes manifests to deploy with Argo CD"
  type        = list(any)
  default     = []
}

variable "env" {
  description = "Environment variables to pass to Argo CD server"
  type        = list(map(string))
  default     = []
}

variable "plugins" {
  description = "Argo CD plugins to install"
  type = list(object({
    name    = string
    version = string
    repo    = string
  }))
  default = []
}

variable "volume_mounts" {
  description = "Additional volume mounts for the Argo CD server pod"
  type = list(object({
    name          = string
    mountPath     = string
    readOnly      = bool
    subPath       = string
  }))
  default = []
}

variable "volumes" {
  description = "Additional volumes for the Argo CD server pod"
  type = list(object({
    name                    = string
    persistentVolumeClaim   = map(string)
    configMap              = map(string)
    secret                 = map(string)
    emptyDir              = map(string)
  }))
  default = []
}

variable "node_selector" {
  description = "Node selector for Argo CD server pods"
  type        = map(string)
  default     = {}
}

variable "tolerations" {
  description = "Tolerations for Argo CD server pods"
  type        = list(map(string))
  default     = []
}

variable "affinity" {
  description = "Affinity settings for Argo CD server pods"
  type        = map(string)
  default     = {}
}