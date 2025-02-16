# Network Roles for GKE with Shared VPC

This guide explains how to set up the required permissions when using Google Kubernetes Engine (GKE) with Shared VPC networks.

## What is this for?

When you use a Shared VPC in Google Cloud, you have two types of projects:
- A host project that owns the network
- Service projects that use the network

For GKE clusters in service projects to use the shared network, they need special permissions. This module sets up those permissions automatically.

## What permissions does it set up?

1. **Network User Role**: Gives the service project permission to use the host project's network. This is granted to:
   - The Google Cloud Services account
   - The Container Engine Robot account

2. **Host Service Agent User Role**: Lets the GKE service account in the service project work with network resources in the host project.

## How to use it

You'll need two pieces of information:
- The host project ID (the project that owns the network)
- The service project ID (the project where your GKE cluster will run)

Example:
```hcl
module "network_roles" {
  source            = "./network-roles"
  host_project_id   = "your-host-project"
  service_project_id = "your-service-project"
}
```

## Why is this needed?

Without these permissions:
- Your GKE cluster won't be able to create network resources like load balancers
- Pods in your cluster might not be able to communicate properly
- Network-related features like ingress controllers might fail

## Common Issues

If you see errors about network access or permissions when creating a GKE cluster, check that:
1. These roles are properly set up
2. You're using the correct project IDs
3. The shared VPC is properly configured in both projects