# Infrastructure Basics

This guide explains the core parts of Kubernetes and how to set them up on Google Cloud Platform (GKE). We'll use simple terms to explain complex concepts.

## Kubernetes Architecture Overview

Think of Kubernetes as a big system with two main parts: the control plane (the brain) and the worker nodes (the muscles).

### Control Plane Components
Here's what each part of the brain does:

- **API Server**
  - Think of this as the front desk of your cluster
  - All requests must go through here first
  - Checks if requests are allowed
  - Keeps track of everything happening
  - Learn more: [Kubernetes API Server docs](https://kubernetes.io/docs/concepts/overview/components/#kube-apiserver)
  
- **etcd**
  - The cluster's memory bank
  - Keeps track of what everything should look like
  - Makes sure data is safe and backed up
  - Very important - needs special backup care
  - Details: [etcd documentation](https://etcd.io/docs/)

- **Scheduler**
  - The cluster's task manager
  - Decides which computers run which programs
  - Makes sure everything has enough resources
  - Tries to spread work evenly
  - More info: [Kubernetes Scheduler](https://kubernetes.io/docs/concepts/scheduling-eviction/kube-scheduler/)

- **Controller Manager**
  - The cluster's maintenance team
  - Fixes problems automatically
  - Makes sure things are running correctly
  - Handles routine tasks
  - Learn more: [Controller Manager docs](https://kubernetes.io/docs/concepts/overview/components/#kube-controller-manager)

### Node Components
These are the parts that do the actual work:

- **kubelet**
  - Like a supervisor on each computer
  - Makes sure programs start and stop properly
  - Reports if something goes wrong
  - Handles basic maintenance
  - Details: [Kubelet overview](https://kubernetes.io/docs/concepts/overview/components/#kubelet)

- **kube-proxy**
  - The cluster's network manager
  - Helps programs talk to each other
  - Directs traffic to the right place
  - Handles load balancing
  - More info: [Kube-proxy](https://kubernetes.io/docs/concepts/overview/components/#kube-proxy)

- **Container Runtime**
  - The program runner
  - Usually containerd (what we use)
  - Starts and stops programs
  - Manages program resources
  - Learn more: [Container Runtime Interface](https://kubernetes.io/docs/concepts/architecture/cri/)

## GKE Cluster Setup

### Before You Start
Make sure you have:
```hcl
# Put this in your terraform configuration
terraform {
  required_providers {
    google = "~> 4.0"      # For GCP resources
    kubernetes = "~> 2.0"   # For Kubernetes resources
  }
}
```

### Setting Up Your First Cluster
Here's a basic setup that works well for most teams:

```hcl
module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "~> 25.0"

  # Basic Settings
  project_id        = var.project_id
  name             = "prod-cluster"
  region           = "us-central1"
  zones            = ["us-central1-a", "us-central1-b", "us-central1-c"]
  
  # Network Settings
  network          = "vpc-01"
  subnetwork       = "subnet-01"
  
  # High Availability Settings
  regional         = true
  
  # Network Ranges
  ip_range_pods    = "10.0.0.0/16"     # Room for 65,536 pods
  ip_range_services = "10.1.0.0/16"     # Room for 65,536 services
}
```

### Worker Node Setup
We recommend starting with two types of worker groups:

```hcl
node_pools = [
  {
    name               = "general-pool"    # For most workloads
    machine_type      = "n2-standard-4"   # 4 CPU, 16GB RAM
    min_count        = 1
    max_count        = 5                  # Scales up when busy
    disk_size_gb     = 100
    disk_type        = "pd-ssd"          # Fast storage
    auto_repair      = true              # Self-healing
    auto_upgrade     = true              # Stays up to date
    service_account  = "gke-sa@project.iam.gserviceaccount.com"
  },
  {
    name               = "high-memory-pool"  # For memory-hungry apps
    machine_type      = "n2-highmem-4"      # 4 CPU, 32GB RAM
    min_count        = 1
    max_count        = 3
    disk_size_gb     = 200                  # More storage
    disk_type        = "pd-ssd"
    auto_repair      = true
    auto_upgrade     = false                # Manual updates
  }
]
```

## Network Configuration

### VPC Setup
Your cluster needs a good network. Here's what we set up:
- A dedicated VPC (Virtual Private Cloud)
- Private IP ranges that don't conflict with others
- Separate spaces for pods and services
- Safe way to access the internet

### Pod Networking
Default settings that work well:
- Pod network: 10.0.0.0/16 (lots of room for pods)
- Service network: 10.1.0.0/16 (lots of room for services)
- NodePorts: 30000-32767 (for external access)
- Network rules enabled (for security)

### Security Groups
We set up two main security layers:

1. Control Plane Protection
   - Only allows HTTPS (port 443)
   - Lets nodes talk to each other
   - Blocks unwanted traffic

2. Worker Node Protection
   - Allows internal pod communication
   - Controls pod-to-pod traffic
   - Uses Google's secure OS

## Multi-zone/Region Setup

### Choosing Regions
Pick regions based on:
- How fast you need things to be
- Where your data needs to be
- How to handle disasters
- How much you want to spend

### Making Things Highly Available
We spread things out to prevent problems:
- Control plane runs in multiple places
- Worker nodes spread across zones
- Automatic replacement of broken nodes
- Backup region if one fails

### Load Balancing
Traffic is spread out for best performance:
- Internal load balancing for private services
- Global load balancing for public services
- Smart distribution across zones
- Regular health checks

## Security Setup

### Service Accounts
We create two main accounts:

1. For the Cluster
   ```hcl
   resource "google_service_account" "gke_sa" {
     account_id   = "gke-service-account"
     display_name = "GKE Service Account"
   }
   ```

2. For Worker Nodes
   ```hcl
   resource "google_service_account" "node_sa" {
     account_id   = "node-service-account"
     display_name = "Node Pool Service Account"
   }
   ```

### Access Control (RBAC)
Three main access levels:
1. Viewers: Can look but not touch
2. Editors: Can deploy and manage
3. Admins: Full control

### Best Security Practices

1. Give Minimum Required Access
   - Use minimal permissions
   - Create focused service accounts
   - Check access regularly
   More details: [GKE Security Best Practices](https://cloud.google.com/kubernetes-engine/docs/concepts/security-overview)

2. Keep Track of Changes
   - Turn on audit logging
   - Watch API server access
   - Monitor configuration changes
   Learn more: [GKE Audit Logging](https://cloud.google.com/kubernetes-engine/docs/how-to/audit-logging)

3. Network Safety
   - Use private clusters when possible
   - Control who can connect
   - Use network policies
   Details: [GKE Network Security](https://cloud.google.com/kubernetes-engine/docs/how-to/network-policy)

## Best Practices

### Keeping Things Secure
- Use Workload Identity (safer than keys)
- Use Google's secure OS
- Check container images
- Scan for problems regularly
More at: [GKE Security](https://cloud.google.com/kubernetes-engine/docs/concepts/security-overview)

### Making Things Scale
- Let nodes add automatically
- Set up automatic scaling
- Set resource limits
- Use cluster autoscaling
Learn more: [GKE Autoscaling](https://cloud.google.com/kubernetes-engine/docs/concepts/cluster-autoscaler)

### Watching Everything
- Use Google Cloud monitoring
- Set up custom metrics
- Save logs
- Watch the control plane
Details: [GKE Monitoring](https://cloud.google.com/kubernetes-engine/docs/how-to/monitoring)

### Saving Money
- Use cheaper nodes when possible
- Plan for interruptions
- Set good scaling limits
- Check resource usage often
More tips: [GKE Cost Optimization](https://cloud.google.com/kubernetes-engine/docs/best-practices/cost-optimization)