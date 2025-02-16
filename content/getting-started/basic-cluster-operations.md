# Basic Cluster Operations

This guide covers fundamental operations you'll perform with your Kubernetes cluster.

## Cluster Management

### Viewing Cluster Status
```bash
# Check cluster information
kubectl cluster-info

# View all nodes
kubectl get nodes -o wide

# Check all namespaces
kubectl get namespaces
```

## Working with Resources

### Pods
```bash
# List all pods
kubectl get pods --all-namespaces

# Get detailed pod information
kubectl describe pod <pod-name> -n <namespace>
```

### Deployments
```bash
# Create a deployment
kubectl create deployment nginx --image=nginx

# Scale a deployment
kubectl scale deployment nginx --replicas=3

# View deployments
kubectl get deployments
```

### Services
```bash
# Expose a deployment as a service
kubectl expose deployment nginx --port=80 --type=LoadBalancer

# List services
kubectl get services
```

## Namespace Management

```bash
# Create a namespace
kubectl create namespace my-namespace

# Set context to use a namespace
kubectl config set-context --current --namespace=my-namespace
```

## Monitoring and Debugging

### Logs
```bash
# View pod logs
kubectl logs <pod-name>

# Follow pod logs
kubectl logs -f <pod-name>
```

### Resource Usage
```bash
# View resource usage
kubectl top nodes
kubectl top pods
```

## Common Operations

### Port Forwarding
```bash
# Forward local port to pod
kubectl port-forward <pod-name> 8080:80
```

### Executing Commands
```bash
# Execute command in pod
kubectl exec -it <pod-name> -- /bin/bash
```

## Best Practices

1. Always use namespaces to organize resources
2. Set resource limits for pods
3. Use labels for better organization
4. Implement health checks
5. Keep your cluster up to date

## Next Steps

After mastering these basic operations, explore:
- [Core Components](../core-components/README.md) for essential Kubernetes tools
- [Advanced Topics](../advanced-topics/README.md) for more complex operations

## External Resources

- [Official Kubernetes Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [Kubernetes Command Reference](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands)
- [Kubernetes Best Practices](https://kubernetes.io/docs/concepts/configuration/overview/)