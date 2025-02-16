# Kubernetes Basics

## What is Kubernetes?
Kubernetes is an open-source platform designed to automate deploying, scaling, and operating application containers. It groups containers that make up an application into logical units for easy management and discovery.

## Key Concepts

### Cluster
A set of nodes (machines) running containerized applications.

### Node
A single machine in the cluster.

### Pod
The smallest deployable unit in Kubernetes, which can contain one or more containers.

### Service
An abstraction that defines a logical set of Pods and a policy by which to access them.

### Namespace
A way to divide cluster resources between multiple users.

## Additional Details and Examples

### Cluster
A Kubernetes cluster consists of a set of worker machines, called nodes, that run containerized applications. Every cluster has at least one worker node. The worker node(s) host the Pods that are the components of the application workload. The control plane manages the worker nodes and the Pods in the cluster. In production environments, the control plane usually runs across multiple computers and a cluster usually runs multiple nodes, providing fault-tolerance and high availability.

### Node
A node is a worker machine in Kubernetes, which may be a VM or a physical machine, depending on the cluster. Each node contains the services necessary to run Pods and is managed by the control plane. The services on a node include the container runtime, kubelet, and kube-proxy.

### Pod
A Pod is the smallest and simplest Kubernetes object. A Pod represents a set of running containers on your cluster. Pods are the atomic unit on the Kubernetes platform. Each Pod is meant to run a single instance of a given application. If you want to scale your application horizontally (e.g., run multiple instances), you should use multiple Pods, one for each instance.

### Service
A Kubernetes Service is an abstraction which defines a logical set of Pods and a policy by which to access them. The set of Pods targeted by a Service is usually determined by a selector. Services enable loose coupling between dependent Pods. Kubernetes supports several types of services, including ClusterIP, NodePort, LoadBalancer, and ExternalName.

### Namespace
Namespaces are intended for use in environments with many users spread across multiple teams, or projects. Namespaces provide a scope for names. Names of resources need to be unique within a namespace, but not across namespaces. Namespaces are a way to divide cluster resources between multiple users.

## Links to External Documentation and Resources

- [Kubernetes Documentation](https://kubernetes.io/docs/home/)
- [Kubernetes Concepts](https://kubernetes.io/docs/concepts/)
- [Kubernetes API Reference](https://kubernetes.io/docs/reference/kubernetes-api/)
- [Kubernetes Tutorials](https://kubernetes.io/docs/tutorials/)
