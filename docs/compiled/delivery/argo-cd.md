# Argo CD

## Overview
Argo CD is a declarative, GitOps continuous delivery tool for Kubernetes. It automates the deployment of applications to Kubernetes clusters.

## Key Concepts
- **Application**: A resource that defines the desired state of an application in a Kubernetes cluster.
- **Project**: A resource that groups applications and provides RBAC policies.
- **Repository**: A Git repository that contains the application manifests.

## Setting Up Argo CD
1. **Install Argo CD**:
    ```sh
    kubectl create namespace argocd
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
    ```
2. **Access the Argo CD UI**:
    ```sh
    kubectl port-forward svc/argocd-server -n argocd 8080:443
    ```
    Open your browser and navigate to `https://localhost:8080`.

## Additional Details and Examples

### Creating an Application
To create an application in Argo CD, you need to define an Application resource. Here is an example:
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: example-app
  namespace: argocd
spec:
  project: default
  source:
    repoURL: 'https://github.com/your-repo/your-app.git'
    targetRevision: HEAD
    path: 'path/to/your/app'
  destination:
    server: 'https://kubernetes.default.svc'
    namespace: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```
Apply the resource:
```sh
kubectl apply -f application.yaml
```

### Creating a Project
To create a project in Argo CD, you need to define a Project resource. Here is an example:
```yaml
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: example-project
  namespace: argocd
spec:
  description: 'Example project'
  sourceRepos:
    - 'https://github.com/your-repo/*'
  destinations:
    - namespace: '*'
      server: 'https://kubernetes.default.svc'
  clusterResourceWhitelist:
    - group: '*'
      kind: '*'
  namespaceResourceBlacklist:
    - group: '*'
      kind: 'Event'
```
Apply the resource:
```sh
kubectl apply -f project.yaml
```

## Links to External Documentation and Resources
- [Argo CD Official Documentation](https://argo-cd.readthedocs.io/)
- [Argo CD GitHub Repository](https://github.com/argoproj/argo-cd)
- [Argo CD Best Practices](https://argo-cd.readthedocs.io/en/stable/user-guide/best_practices/)
- [Argo CD Security Considerations](https://argo-cd.readthedocs.io/en/stable/operator-manual/security/)
