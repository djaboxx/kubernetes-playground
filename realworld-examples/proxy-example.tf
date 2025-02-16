terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0.0"
    }
  }
}

# Example configuration for a production environment
module "gke_proxy" {
  source = "./proxy"

  # Project and location settings
  project         = "example-project"
  region          = "us-west1"
  datacenter_name = "us-west1"
  appenv          = "prod"
  netenv          = "prod"

  # Network configuration
  subnetwork_self_link = "projects/example-vpc/regions/us-west1/subnetworks/main"
  master_host_ip       = "10.0.0.2"  # This would be your GKE cluster's private endpoint IP

  # Proxy service configuration
  endpoint_prefix = "prod-us-west1-k8s-proxy"
  instance_count = 2  # High availability setup with 2 instances
  machine_type   = "n1-standard-1"

  # Optional: Additional network tags for custom firewall rules
  extra_network_tags = ["custom-monitoring"]

  # Optional: Enable deletion protection for production
  deletion_protection = true

  # DNS configuration (if using a separate DNS project)
  dns_project = "example-dns-project"
}

# Output the proxy's internal load balancer address
output "proxy_ilb_address" {
  value       = module.gke_proxy.load_balancer_ip
  description = "The internal IP address of the proxy load balancer"
}