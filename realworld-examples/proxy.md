# Kubernetes Proxy for Private GKE Clusters

This guide explains how to set up a proxy service that lets you securely access private GKE (Google Kubernetes Engine) clusters across different projects.

## What is this for?

When you have a private GKE cluster, its control plane (the master API) is only accessible from within the VPC network. If you need to access the cluster from other VPC networks or peered projects, you need a proxy. This module sets up that proxy system.

## How it Works

The module creates two main parts:

1. **Proxy Servers**
   - Multiple servers that run for high availability
   - Handle secure HTTPS traffic (port 443)
   - Connect to your GKE cluster's private endpoint
   - Have health monitoring built in

2. **Internal Load Balancer**
   - Spreads traffic across all proxy servers
   - Checks if proxy servers are healthy
   - Can be accessed from anywhere in your VPC network

## Example Usage

```hcl
module "k8s_proxy" {
  source = "./proxy"
  
  # Basic settings
  project         = "my-project"
  region          = "us-west1"
  datacenter_name = "us-west1"
  
  # Network settings
  netenv               = "prod"
  subnetwork_self_link = "projects/my-vpc/regions/us-west1/subnetworks/main"
  master_host_ip       = "10.0.0.2"  # Your GKE cluster's private IP
  
  # Proxy settings
  endpoint_prefix = "prod-us-west1-k8s-proxy"
  instance_count = 2  # Number of proxy servers for redundancy
  machine_type   = "n1-standard-1"
}
```

## Important Settings

- `instance_count`: How many proxy servers to run (default: 1)
- `machine_type`: Size of the proxy servers (default: n1-standard-1)
- `master_host_ip`: The private IP of your GKE cluster's control plane
- `endpoint_prefix`: Name prefix for your proxy (example: dev-us-west1-k8s-proxy)

## Security Features

1. HTTPS Only: All traffic uses secure HTTPS (port 443)
2. Health Checks: Regular checks make sure the proxy is working
3. Private Network: Works within your VPC for better security
4. High Availability: Can run multiple servers to prevent downtime

## Common Issues

If you can't access your cluster through the proxy:
1. Check that your VPC peering is set up correctly
2. Verify the master_host_ip is correct
3. Make sure your firewall rules allow traffic to port 443
4. Check the health check status in Google Cloud Console