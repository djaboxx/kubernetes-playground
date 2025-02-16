variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for the cluster"
  type        = string
  default     = "us-central1"
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
  default     = "learning-cluster"
}

variable "node_count" {
  description = "Initial number of nodes in the cluster (used if auto-scaling is disabled)"
  type        = number
  default     = 1
}

variable "machine_type" {
  description = "Machine type for the nodes"
  type        = string
  default     = "e2-small"  # Changed to a smaller instance type
}

variable "disk_size_gb" {
  description = "Size of the disk attached to each node (in GB)"
  type        = number
  default     = 20
}

variable "preemptible" {
  description = "Use preemptible nodes (significantly cheaper but can be terminated at any time)"
  type        = bool
  default     = true
}

variable "enable_autoscaling" {
  description = "Enable autoscaling for the node pool"
  type        = bool
  default     = true
}

variable "min_node_count" {
  description = "Minimum number of nodes when autoscaling is enabled"
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "Maximum number of nodes when autoscaling is enabled"
  type        = number
  default     = 3
}

variable "auto_repair" {
  description = "Enable auto-repair feature for the node pool"
  type        = bool
  default     = true
}

variable "auto_upgrade" {
  description = "Enable auto-upgrade feature for the node pool"
  type        = bool
  default     = true
}

variable "enable_workload_identity" {
  description = "Enable Workload Identity for secure pod-level authentication to GCP services"
  type        = bool
  default     = true
}

variable "enable_network_policy" {
  description = "Enable network policy enforcement using Calico"
  type        = bool
  default     = true
}

variable "enable_monitoring" {
  description = "Enable Cloud Operations (formerly Stackdriver) monitoring"
  type        = bool
  default     = true
}

variable "enable_logging" {
  description = "Enable Cloud Operations logging"
  type        = bool
  default     = true
}

variable "enable_binary_authorization" {
  description = "Enable Binary Authorization for container security"
  type        = bool
  default     = false
}

variable "cluster_secondary_range_name" {
  description = "Secondary IP range name for pods"
  type        = string
  default     = "k8s-pod-range"
}

variable "services_secondary_range_name" {
  description = "Secondary IP range name for services"
  type        = string
  default     = "k8s-service-range"
}
