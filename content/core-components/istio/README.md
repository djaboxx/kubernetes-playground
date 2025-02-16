# Istio Service Mesh

## Overview
Istio is an open-source service mesh that provides a uniform way to connect, secure, control, and observe services in a Kubernetes cluster. It extends Kubernetes to establish a programmable, application-aware network using the powerful Envoy service proxy.

## Core Features
- **Traffic Management**: Intelligent routing and control of service-to-service communication
- **Security**: Automatic service-to-service and end-user authentication and authorization
- **Observability**: Detailed monitoring, logging, and tracing for all services
- **Platform Support**: Runs on any Kubernetes cluster, on-premises or cloud

## Architecture Components
1. **Control Plane**
   - istiod (Pilot, Citadel, Galley combined)
   - Configuration API server
   - Certificate authority

2. **Data Plane**
   - Envoy proxies (sidecars)
   - Ingress/Egress gateways

## Installation

### Prerequisites
- Kubernetes cluster 1.21+
- Helm 3.x
- kubectl configured

### Basic Installation
```bash
# Download Istio
curl -L https://istio.io/downloadIstio | sh -

# Add istioctl to path
export PATH=$PWD/istio-x.y.z/bin:$PATH

# Install Istio with demo profile
istioctl install --set profile=demo -y
```

### Production Installation with Helm
```bash
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update

# Install base chart
helm install istio-base istio/base -n istio-system --create-namespace

# Install istiod
helm install istiod istio/istiod -n istio-system --wait

# Install ingress gateway
helm install istio-ingress istio/gateway -n istio-system
```

## Sidecar Injection
Enable automatic sidecar injection for a namespace:
```bash
kubectl label namespace default istio-injection=enabled
```

## Next Steps
- [Traffic Management Guide](./traffic-management.md)
- [Security Configuration](./security.md)
- [Observability Setup](./observability.md)
- [Automation Guide](./automation.md)
- [Production Best Practices](./production-best-practices.md)