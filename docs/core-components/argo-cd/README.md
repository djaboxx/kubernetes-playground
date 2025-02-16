# Argo CD

## Overview
Argo CD is a declarative, GitOps continuous delivery tool for Kubernetes. It follows the GitOps pattern where the desired application state is versioned in Git, and Argo CD ensures the cluster state matches the desired state.

## Features
- Automated deployment of applications
- Multi-cluster management
- SSO Integration
- Audit trails and compliance
- Web UI for visualization
- Health status monitoring

## Installation

```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm install argocd argo/argo-cd
```

## Core Concepts
1. **Application**: Represents a deployed application
2. **Project**: Logical grouping of applications
3. **Repository**: Source code/manifest repository
4. **Target State**: Desired state defined in Git
5. **Sync Status**: Current vs. desired state

## Best Practices
1. **Repository Structure**
   - Use a monorepo or structured multi-repo approach
   - Maintain clear separation between app code and configs

2. **Security**
   - Enable SSO integration
   - Use RBAC for access control
   - Regularly rotate secrets

3. **Monitoring**
   - Configure health checks
   - Set up notifications
   - Monitor sync status

## Common Operations
1. **Application Deployment**
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: myapp
spec:
  destination:
    namespace: default
    server: https://kubernetes.default.svc
  project: default
  source:
    path: k8s
    repoURL: https://github.com/example/myapp.git
    targetRevision: HEAD
```

2. **Sync Policy Configuration**
```yaml
spec:
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

## Troubleshooting
1. **Common Issues**
   - Application out of sync
   - Repository connection issues
   - RBAC permission problems

2. **Debug Commands**
```bash
kubectl get applications -n argocd
kubectl describe application <app-name> -n argocd
argocd app logs <app-name>
```

## Additional Resources
- [Official Documentation](https://argo-cd.readthedocs.io/)
- [Best Practices Guide](https://argo-cd.readthedocs.io/en/stable/user-guide/best_practices/)
- [Security Considerations](https://argo-cd.readthedocs.io/en/stable/operator-manual/security/)