# Kubernetes Cluster Configuration

This document explains the core cluster configuration used in our real-world setup.

## Core Components

### GKE Cluster (google_container_cluster)
The main cluster resource creates a Google Kubernetes Engine (GKE) cluster with the following key features:

- Regional cluster deployment for high availability
- Private cluster option for enhanced security
- Custom VPC network and subnetwork configuration
- Network policy support using Calico
- Workload identity for secure pod authentication
- Security group integration for RBAC

### Node Pools
The cluster uses custom node pools instead of the default pool, providing:

- Configurable machine types per pool
- Autoscaling capabilities
- Custom service account for node authentication
- Node metadata security configuration
- Custom network tags for firewall rules

### Backup Configuration
The cluster includes automated backup capabilities:

- Scheduled backups using cron configuration
- Namespace-level backup selection
- Volume data and secrets inclusion
- KMS encryption for backup security
- Configurable retention policies

## Security Features

1. **Authentication & Authorization**
   - RBAC integration with security groups
   - Workload identity for pod-level authentication
   - Disabled legacy metadata endpoints
   - Shielded nodes support

2. **Network Security**
   - Private cluster option
   - Network policy enforcement
   - Custom master authorized networks
   - VPC-native networking

3. **Data Protection**
   - KMS encryption for backups
   - Configurable backup retention
   - Volume data protection

## Operations

1. **Node Management**
   - Automatic node repairs (configurable)
   - Node upgrade management
   - Initial node count control
   - Pod density management

2. **Monitoring & Backup**
   - Scheduled backup plans
   - Namespace-specific backups
   - Retention policy enforcement
   - Backup encryption

## Network Configuration

1. **VPC Setup**
   - Custom VPC network integration
   - Subnetwork configuration
   - Secondary IP ranges for pods and services
   - Network tags for firewall rules

2. **Cluster Networking**
   - Private cluster options
   - Master authorized networks
   - Network policy enforcement
   - Service CIDR configuration