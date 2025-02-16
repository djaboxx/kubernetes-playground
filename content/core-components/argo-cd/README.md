# Argo CD

## What Is Argo CD?

Argo CD is a declarative, GitOps continuous delivery tool for Kubernetes that helps you manage application deployments.

## Key Features

- Automated deployment of applications to specified target environments
- Support for multiple config management tools (Kustomize, Helm, Jsonnet)
- Web UI and CLI for application management
- Automated sync and drift detection
- Webhook integration
- SSO Integration
- Audit trails for application changes

## Installation

```bash
# Create namespace
kubectl create namespace argocd

# Install Argo CD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

## Basic Usage

### Accessing the UI
```bash
# Port forward the Argo CD API server
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Get the initial admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

### Installing the CLI
```bash
# macOS
brew install argocd

# Using curl
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64
```

## Configuration Examples

### Application Example
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: my-app
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/my-org/my-app.git
    targetRevision: HEAD
    path: k8s
  destination:
    server: https://kubernetes.default.svc
    namespace: my-app
```

## Best Practices

1. Use Git repositories as the single source of truth
2. Implement proper RBAC
3. Set up automated sync policies
4. Use app-of-apps pattern for managing multiple applications
5. Implement health checks for applications

## Further Reading

- [Official Argo CD Documentation](https://argo-cd.readthedocs.io/)
- [Continuous Delivery with Argo CD](../advanced-topics/continuous-delivery-with-argo-cd.md)
- [Security Best Practices](../advanced-topics/security-best-practices.md)

## Core Components

Argo CD consists of several key components:

1. **API Server**: Serves the Argo CD UI, CLI, and Webhook events.
2. **Repository Server**: Manages connections to Git repositories.
3. **Controller**: Monitors the state of applications and compares it with the desired state defined in Git.
4. **Redis**: Used for caching and state management.
5. **Application Controller**: Manages the lifecycle of applications.
6. **Dex**: An identity service that uses OpenID Connect to drive authentication for other apps.