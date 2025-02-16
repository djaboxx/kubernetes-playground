# Environment Configuration

This document describes the specific environment configuration used in our realworld Kubernetes cluster deployment.

## Regional Architecture

### Primary Region: us-central1
- Multi-zone deployment across us-central1-a, us-central1-b, us-central1-f
- Optimized for North American workloads
- Provides geographic redundancy within region

### Network Configuration
```
Primary VPC:
└── us-central1
    ├── Primary subnet: 10.2.0.0/16
    ├── Secondary Pod CIDR
    └── Secondary Service CIDR

Cross-Region Connectivity:
└── Cloud NAT
    └── Regional external IP allocation
```

### Availability Design
- Control plane distributed across 3 zones
- Node pools spread across multiple zones
- Regional persistent volumes
- Zone-aware service deployment

## Environment-Specific Settings

### Development Environment
- Workload Identity enabled for GCP service integration
- Debug logging enabled
- Relaxed node autoscaling for testing
- Development-specific node labels

### Production Environment
- Strict security policies
- Production-grade monitoring
- Restricted network policies
- High availability configuration
- Production-level node resource requests

## Resource Allocation

### Compute Resources
- Node pool machine type: n1-standard-2
- Min nodes per zone: 1
- Max nodes per zone: 5
- Node autoscaling enabled

### Storage Resources
- Regional persistent volumes
- SSD storage class default
- Automatic backup configuration

## Monitoring Configuration
- Regional monitoring
- Multi-zone metric aggregation
- Cross-zone log collection
- Regional alert routing