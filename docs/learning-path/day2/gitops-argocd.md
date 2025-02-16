# GitOps with ArgoCD

This guide explains how to use ArgoCD to automatically deploy and manage your applications. We'll cover how ArgoCD works, how to set it up, and how to use it effectively.

## How ArgoCD Works

### Main Components
Think of ArgoCD like a robot that keeps your applications running exactly the way you want them to:

1. API Server (The Command Center)
   - Takes orders about what to deploy
   - Checks if you're allowed to make changes
   - Keeps track of all your applications
   Learn more: [API Server Guide](https://argo-cd.readthedocs.io/en/stable/operator-manual/server-commands/argocd-server/)

2. Repository Server (The Blueprint Reader)
   - Reads your deployment instructions
   - Understands different types of instructions (Helm, Kustomize)
   - Figures out what needs to change
   Details: [Repo Server Guide](https://argo-cd.readthedocs.io/en/stable/operator-manual/server-commands/argocd-repo-server/)

3. Application Controller (The Worker)
   - Makes sure everything is running correctly
   - Fixes things that aren't right
   - Reports back on how things are doing
   Reference: [Controller Guide](https://argo-cd.readthedocs.io/en/stable/operator-manual/server-commands/argocd-application-controller/)

### Setting Up for High Availability
This setup keeps ArgoCD running even if parts of it fail:

```yaml
# Example of a highly available ArgoCD setup
apiVersion: argoproj.io/v1alpha1
kind: ArgoCD
metadata:
  name: argocd
spec:
  # Makes everything run multiple copies
  ha:
    enabled: true
  
  # Makes sure the database is reliable
  redis:
    ha:
      enabled: true
  
  # Runs multiple copies of the worker
  controller:
    replicas: 2
    
  # Runs multiple copies of the command center
  server:
    replicas: 3
    env:
    - name: ARGOCD_API_SERVER_REPLICAS
      value: "3"
```
More details: [High Availability Setup](https://argo-cd.readthedocs.io/en/stable/operator-manual/high_availability/)

## Setting Up ArgoCD

### Basic Installation
Here's how to install ArgoCD using Helm:

```bash
# Add the ArgoCD chart repository
helm repo add argo https://argoproj.github.io/argo-helm

# Install ArgoCD
helm install argocd argo/argo-cd \
  --namespace argocd \
  --create-namespace \
  --values values.yaml
```
Installation guide: [Getting Started](https://argo-cd.readthedocs.io/en/stable/getting_started/)

### Connecting to GitHub
This lets your team log in with their GitHub accounts:

```yaml
# GitHub SSO Configuration
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-cm
data:
  # Sets up GitHub login
  dex.config: |
    connectors:
      - type: github
        id: github
        name: GitHub
        config:
          clientID: $GITHUB_CLIENT_ID
          clientSecret: $GITHUB_CLIENT_SECRET
          orgs:
          - name: your-org
```
Learn more: [SSO Configuration](https://argo-cd.readthedocs.io/en/stable/operator-manual/user-management/)

### Setting Up Permissions
Control who can do what in ArgoCD:

```yaml
# Basic permission setup
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-rbac-cm
data:
  policy.csv: |
    # Team leads can do everything
    p, role:org-admin, applications, *, */*, allow
    p, role:org-admin, clusters, get, *, allow
    
    # Developers can view everything
    p, role:org-reader, applications, get, */*, allow
    
    # Assign roles to teams
    g, your-org:team-devops, role:org-admin
```
Reference: [RBAC Configuration](https://argo-cd.readthedocs.io/en/stable/operator-manual/rbac/)

## Managing Multiple Applications

### Using ApplicationSets
ApplicationSets help you manage many applications at once:

```yaml
# Example of deploying the same app to multiple clusters
apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
metadata:
  name: guestbook
spec:
  # List of where to deploy
  generators:
  - list:
      elements:
      - cluster: development
        url: https://kubernetes.default.svc
      - cluster: staging
        url: https://staging-cluster
      - cluster: production
        url: https://production-cluster
  
  # What to deploy
  template:
    metadata:
      name: '{{cluster}}-guestbook'
    spec:
      project: default
      source:
        repoURL: https://github.com/argoproj/argocd-example-apps
        targetRevision: HEAD
        path: guestbook
      destination:
        server: '{{url}}'
        namespace: guestbook
```
More info: [ApplicationSet Guide](https://argo-cd.readthedocs.io/en/stable/operator-manual/applicationset/)

### Safely Rolling Out Changes

1. Canary Deployments (Testing with a small group first):
```yaml
# Gradually roll out a new version
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata:
  name: rollout-canary
spec:
  replicas: 5
  strategy:
    canary:
      # Start with 20% of users
      steps:
      - setWeight: 20
      - pause: {duration: 1h}  # Watch for problems
      # Move to 40% if all is well
      - setWeight: 40
      - pause: {duration: 1h}
      # And so on...
      - setWeight: 60
      - pause: {duration: 1h}
      - setWeight: 80
      - pause: {duration: 1h}
```

2. Blue-Green Deployments (Quick switch between versions):
```yaml
# Run old and new versions side by side
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata:
  name: rollout-bluegreen
spec:
  strategy:
    blueGreen:
      # Service for the current version
      activeService: active-service
      # Service for testing the new version
      previewService: preview-service
      # Don't switch automatically
      autoPromotionEnabled: false
```
Learn more: [Rollout Strategies](https://argo-rollouts.readthedocs.io/en/stable/)

## Moving Code to Production

### Moving Between Environments
Here's how to safely promote your code:

```yaml
# Example of staging environment setup
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: promotion-app
spec:
  # Where to get the code
  source:
    path: environments/staging
    repoURL: https://github.com/your-org/gitops
    targetRevision: HEAD
  
  # Where to deploy it
  destination:
    namespace: staging
    server: https://kubernetes.default.svc
  
  # How to handle changes
  syncPolicy:
    automated:
      prune: true    # Remove old stuff
      selfHeal: true # Fix if someone changes things manually
```

### Safety Checks
Make sure changes are safe:

```yaml
# Example of deployment with checks
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: gated-app
spec:
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    # Run tests before applying
    syncOptions:
    - Validate=true
    - CreateNamespace=true
  
  # Ignore certain differences
  ignoreDifferences:
  - group: apps
    kind: Deployment
    jsonPointers:
    - /spec/replicas
```

### Rolling Back Changes
Two ways to undo changes:

1. Automatic Rollback:
```yaml
# Configuration for automatic rollback
spec:
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    # Try 5 times if something fails
    retry:
      limit: 5
      backoff:
        duration: 5s
        factor: 2
        maxDuration: 3m
```

2. Manual Rollback:
```bash
# See previous versions
argocd app history myapp

# Go back to a specific version
argocd app rollback myapp --to-revision=2
```

## Hands-on Session: Deploying Applications Using ArgoCD

In this hands-on session, we'll deploy an application using ArgoCD. Follow these steps:

1. **Install ArgoCD CLI**:
   - Download and install the ArgoCD CLI: [CLI Installation Guide](https://argo-cd.readthedocs.io/en/stable/cli_installation/)
   - Verify the installation:
     ```sh
     argocd version
     ```

2. **Login to ArgoCD**:
   - Login to your ArgoCD server:
     ```sh
     argocd login <ARGOCD_SERVER>
     ```

3. **Create a New Application**:
   - Create a new application in ArgoCD:
     ```sh
     argocd app create my-app \
       --repo https://github.com/argoproj/argocd-example-apps.git \
       --path guestbook \
       --dest-server https://kubernetes.default.svc \
       --dest-namespace default
     ```

4. **Sync the Application**:
   - Sync the application to deploy it:
     ```sh
     argocd app sync my-app
     ```

5. **Verify the Deployment**:
   - Check the status of the application:
     ```sh
     argocd app get my-app
     ```

Congratulations! You've successfully deployed an application using ArgoCD.

## Additional Resources

### Official Guides
- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [Best Practices Guide](https://argo-cd.readthedocs.io/en/stable/user-guide/best_practices/)
- [Security Considerations](https://argo-cd.readthedocs.io/en/stable/operator-manual/security/)

### Tools and Plugins
- [CLI Installation](https://argo-cd.readthedocs.io/en/stable/cli_installation/)
- [UI Extensions](https://argo-cd.readthedocs.io/en/stable/operator-manual/extensions/)
- [Notification System](https://argocd-notifications.readthedocs.io/)
