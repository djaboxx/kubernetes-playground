# Real World Kubernetes Examples

This directory contains examples of real-world Kubernetes configurations. Each section shows how different parts work together.

## Directory Structure

### cluster/
Manages the core Kubernetes cluster setup including:
- Google Kubernetes Engine (GKE) cluster configuration
- Node pool management
- Network settings
- Security configurations

### init-charts/ 
Contains initialization Helm charts for:
- Certificate management (cert-manager)
- System certificates
- Datadog monitoring setup
- Core cluster services

### operational-charts/
Contains Helm charts for running services:
- Monitoring systems
- Logging solutions
- Service management tools

### proxy/
Manages ingress and networking:
- Load balancers
- Ingress controllers
- Network routing rules
- Traffic management

### template-cluster/
Base templates for creating new clusters:
- Standardized cluster configurations
- Security settings
- Network policies
- Infrastructure setup

### template-resources/
Templates for Kubernetes resources:
- ArgoCD configurations
- Certificate settings
- Common cluster resources
- Helm chart defaults

### network-roles/
Network security and access control:
- Network policies
- Security roles
- Access controls
- Firewall rules

### external-providers/
External service integrations:
- GitHub connections
- Authentication providers
- Cloud service links

### resources/
Core Kubernetes resource definitions:
- GitHub repository settings
- Files and data configurations
- Branch management
- Resource templates