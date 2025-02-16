# GitOps Principles

## Overview
GitOps is a set of practices that uses Git as the single source of truth for declarative infrastructure and applications. It enables continuous delivery and operational stability by leveraging Git repositories for version control and automation.

## Key Principles

### Declarative Descriptions
All infrastructure and application configurations are described declaratively. This means that the desired state of the system is defined in code, which can be versioned and managed in Git repositories.

### Version Control
All configurations are stored in Git repositories, providing version control and auditability. This allows teams to track changes, roll back to previous versions, and collaborate effectively.

### Automated Delivery
Changes to configurations are automatically applied to the infrastructure and applications. This is achieved through continuous integration and continuous delivery (CI/CD) pipelines that monitor Git repositories for changes and trigger automated deployments.

### Continuous Reconciliation
The desired state defined in Git is continuously reconciled with the actual state of the infrastructure and applications. This ensures that any drift from the desired state is detected and corrected automatically.

## Additional Details and Examples

### Declarative Descriptions Example
Here is an example of a declarative description for a Kubernetes deployment:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: example-deployment
  namespace: default
spec:
  replicas: 3
  selector:
    matchLabels:
      app: example
  template:
    metadata:
      labels:
        app: example
    spec:
      containers:
      - name: example-container
        image: example-image:latest
        ports:
        - containerPort: 80
```
This YAML file defines the desired state of a Kubernetes deployment, including the number of replicas, container image, and port configuration.

### Version Control Example
Using Git for version control allows teams to track changes to configurations. Here is an example of a Git commit history for a Kubernetes deployment:
```
commit 1a2b3c4d5e6f7g8h9i0j
Author: Jane Doe <jane.doe@example.com>
Date:   Mon Jan 1 12:34:56 2023 -0500

    Initial commit of example deployment

commit 2b3c4d5e6f7g8h9i0j1a
Author: John Smith <john.smith@example.com>
Date:   Tue Jan 2 14:56:78 2023 -0500

    Update container image to version 1.1.0

commit 3c4d5e6f7g8h9i0j1a2b
Author: Jane Doe <jane.doe@example.com>
Date:   Wed Jan 3 16:78:90 2023 -0500

    Increase replicas to 3
```
This commit history shows the changes made to the deployment configuration, including the initial commit, an update to the container image, and an increase in the number of replicas.

### Automated Delivery Example
Automated delivery can be achieved using CI/CD pipelines. Here is an example of a GitHub Actions workflow for deploying a Kubernetes application:
```yaml
name: Deploy to Kubernetes

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout code
      uses: actions/checkout@v2

    - name: Set up Kubernetes
      uses: azure/setup-kubectl@v1
      with:
        version: 'v1.20.0'

    - name: Deploy to Kubernetes
      run: kubectl apply -f k8s/
```
This workflow triggers a deployment to Kubernetes whenever changes are pushed to the main branch of the Git repository.

### Continuous Reconciliation Example
Continuous reconciliation ensures that the actual state of the infrastructure matches the desired state defined in Git. Here is an example of using Argo CD for continuous reconciliation:
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
This Argo CD Application resource defines the desired state of an application and enables automated synchronization to ensure continuous reconciliation.

## Links to External Documentation and Resources
- [GitOps Official Website](https://www.gitops.tech/)
- [Argo CD Official Documentation](https://argo-cd.readthedocs.io/)
- [Kubernetes Official Documentation](https://kubernetes.io/docs/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
