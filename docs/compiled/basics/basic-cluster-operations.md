# Basic Cluster Operations

## Creating a Cluster
You can create a Kubernetes cluster using various tools like Minikube, kind, or cloud providers like GKE, EKS, and AKS.

### Minikube
Minikube is a tool that lets you run Kubernetes locally. It creates a single-node Kubernetes cluster on your local machine.

Example:
```sh
minikube start
```

### kind
kind (Kubernetes IN Docker) is a tool for running local Kubernetes clusters using Docker container nodes.

Example:
```sh
kind create cluster
```

### GKE (Google Kubernetes Engine)
GKE is a managed Kubernetes service provided by Google Cloud. It allows you to create and manage Kubernetes clusters on Google Cloud Platform.

Example:
```sh
gcloud container clusters create my-cluster --zone us-central1-a
```

## Managing Pods

### Creating a Pod
You can create a Pod using `kubectl run` or `kubectl apply` with a YAML file.

Example using `kubectl run`:
```sh
kubectl run my-pod --image=nginx
```

Example using `kubectl apply`:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
  - name: nginx
    image: nginx
```
Apply the YAML file:
```sh
kubectl apply -f pod.yaml
```

### Viewing Pods
You can list all Pods in a namespace using `kubectl get pods`.

Example:
```sh
kubectl get pods
```

### Deleting a Pod
You can delete a Pod using `kubectl delete pod <pod-name>`.

Example:
```sh
kubectl delete pod my-pod
```

## Managing Services

### Creating a Service
You can create a Service using `kubectl expose` or `kubectl apply` with a YAML file.

Example using `kubectl expose`:
```sh
kubectl expose pod my-pod --port=80 --target-port=80 --name=my-service
```

Example using `kubectl apply`:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  selector:
    app: my-app
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
```
Apply the YAML file:
```sh
kubectl apply -f service.yaml
```

### Viewing Services
You can list all Services in a namespace using `kubectl get services`.

Example:
```sh
kubectl get services
```

### Deleting a Service
You can delete a Service using `kubectl delete service <service-name>`.

Example:
```sh
kubectl delete service my-service
```

## Links to External Documentation and Resources

- [Kubernetes Documentation](https://kubernetes.io/docs/home/)
- [Kubernetes API Reference](https://kubernetes.io/docs/reference/kubernetes-api/)
- [Kubernetes Tutorials](https://kubernetes.io/docs/tutorials/)
- [Minikube Documentation](https://minikube.sigs.k8s.io/docs/)
- [kind Documentation](https://kind.sigs.k8s.io/docs/)
- [GKE Documentation](https://cloud.google.com/kubernetes-engine/docs)
