terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0.0"
    }
  }
}

# Example values - replace with your own
locals {
  host_project_id    = "my-network-project"
  service_project_id = "my-gke-project"
}

module "gke_network_roles" {
  source = "./network-roles"

  host_project_id    = local.host_project_id
  service_project_id = local.service_project_id
}

# Optional: Verify the setup by checking the service project has access
data "google_project" "service_project" {
  project_id = local.service_project_id
}

output "service_project_number" {
  value = data.google_project.service_project.number
  description = "The project number of the service project"
}