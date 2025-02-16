# Day 1: Foundation

## Kubernetes Basics

### What is Kubernetes?
Kubernetes is an open-source platform designed to automate deploying, scaling, and operating application containers. It groups containers that make up an application into logical units for easy management and discovery.

### Key Concepts
- **Cluster**: A set of nodes (machines) running containerized applications.
- **Node**: A single machine in the cluster.
- **Pod**: The smallest deployable unit in Kubernetes, which can contain one or more containers.
- **Service**: An abstraction that defines a logical set of Pods and a policy by which to access them.
- **Namespace**: A way to divide cluster resources between multiple users.

## Helm Fundamentals

### What is Helm?
Helm is a package manager for Kubernetes that helps you define, install, and upgrade even the most complex Kubernetes applications.

### Key Concepts
- **Chart**: A Helm package that contains all the resource definitions necessary to run an application or service inside a Kubernetes cluster.
- **Release**: An instance of a chart running in a Kubernetes cluster.
- **Repository**: A place where charts can be collected and shared.

## Basic Cluster Operations

### Creating a Cluster
You can create a Kubernetes cluster using various tools like Minikube, kind, or cloud providers like GKE, EKS, and AKS.

### Managing Pods
- **Creating a Pod**: Use `kubectl run` or `kubectl apply` with a YAML file.
- **Viewing Pods**: Use `kubectl get pods` to list all Pods in a namespace.
- **Deleting a Pod**: Use `kubectl delete pod <pod-name>` to delete a Pod.

### Managing Services
- **Creating a Service**: Use `kubectl expose` or `kubectl apply` with a YAML file.
- **Viewing Services**: Use `kubectl get services` to list all Services in a namespace.
- **Deleting a Service**: Use `kubectl delete service <service-name>` to delete a Service.
