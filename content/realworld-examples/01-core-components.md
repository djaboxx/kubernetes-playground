# Core Components

## Argo CD
A tool for continuous delivery in Kubernetes, ensuring applications are in sync with the Git repository.

## Cert Manager
Manages TLS certificates, automating their creation, renewal, and management.

## Ingress NGINX
Manages external access to services, providing load balancing and SSL termination.

## Prometheus Stack
Monitors the cluster, visualizes data, and sends alerts.

# Core GKE Cluster Components

## Container Cluster (google_container_cluster)

A Google Kubernetes Engine (GKE) cluster is the foundation of your Kubernetes deployment. Our implementation includes several key features:

### Basic Configuration
- Regional deployment for higher availability
- Private cluster setup for enhanced security
- Workload Identity enabled for secure cloud service access

### Why It's Important
- Provides managed Kubernetes environment
- Handles master node management automatically
- Enables automatic upgrades and security patches
- Offers integrated monitoring and logging

### Networking
- VPC-native cluster configuration
- Pod IP address management
- Network policy support

### Security Features
- Private nodes setup
- Workload Identity for secure service accounts
- Binary Authorization support

## Node Pools

Node pools are groups of worker machines that run your containerized applications. Our configuration uses:

### Standard Node Pool
- Configurable machine types
- Auto-scaling enabled
- Regional node distribution

### Why Node Pools Matter
- Enable workload isolation
- Allow for different machine types per workload
- Support autoscaling based on demand
- Provide maintenance windows for updates

### Node Configuration
- OS image hardening
- Workload Identity association
- Custom service account configuration