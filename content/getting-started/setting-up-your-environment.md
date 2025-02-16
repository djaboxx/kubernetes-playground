# Setting Up Your Environment

This guide will help you set up a local Kubernetes development environment.

## Prerequisites

- Docker Desktop (macOS/Windows) or Docker Engine (Linux)
- kubectl - The Kubernetes command-line tool
- A code editor (VS Code recommended with Kubernetes extensions)
- Git

## Installation Steps

### 1. Docker Installation
- [Docker Desktop for macOS](https://docs.docker.com/desktop/mac/install/)
- [Docker Desktop for Windows](https://docs.docker.com/desktop/windows/install/)
- [Docker Engine for Linux](https://docs.docker.com/engine/install/)

### 2. kubectl Installation

```bash
# macOS with Homebrew
brew install kubectl

# Windows with Chocolatey
choco install kubernetes-cli

# Linux
sudo apt-get update && sudo apt-get install -y kubectl
```

### 3. Development Tools

Install a suitable IDE and extensions:
- [Visual Studio Code](https://code.visualstudio.com/)
- [Kubernetes VS Code Extension](https://marketplace.visualstudio.com/items?itemName=ms-kubernetes-tools.vscode-kubernetes-tools)

### 4. Local Kubernetes Cluster

Choose one of these options:

1. **Docker Desktop Kubernetes**
   - Open Docker Desktop
   - Go to Settings/Preferences
   - Enable Kubernetes

2. **minikube**
   ```bash
   # Install minikube
   brew install minikube  # macOS
   choco install minikube # Windows
   
   # Start cluster
   minikube start
   ```

3. **kind (Kubernetes in Docker)**
   ```bash
   # Install kind
   brew install kind     # macOS
   choco install kind    # Windows
   
   # Create cluster
   kind create cluster
   ```

## Verifying Your Setup

```bash
# Check kubectl installation
kubectl version --client

# Verify cluster connection
kubectl cluster-info

# Check node status
kubectl get nodes
```

## Next Steps

Once your environment is set up, proceed to [Basic Cluster Operations](basic-cluster-operations.md) to learn how to interact with your cluster.

## Troubleshooting

- If kubectl cannot connect to your cluster, check if your cluster is running and KUBECONFIG is properly set
- For Docker Desktop issues, ensure Kubernetes is enabled in preferences
- For minikube issues, try `minikube delete` followed by `minikube start`