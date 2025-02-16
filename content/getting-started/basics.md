# Basics

This section covers the fundamental concepts and operations needed to get started with Kubernetes.

## Kubernetes Overview

Kubernetes is an open-source platform designed to automate deploying, scaling, and operating application containers. It groups containers that make up an application into logical units for easy management and discovery.

## Key Concepts

- **Cluster**: A set of nodes that run containerized applications.
- **Node**: A single machine in a cluster, which can be a virtual or physical machine.
- **Pod**: The smallest and simplest Kubernetes object. A pod represents a set of running containers on your cluster.
- **Service**: An abstraction that defines a logical set of pods and a policy by which to access them.
- **Namespace**: A way to divide cluster resources between multiple users.

## Basic Operations

- **kubectl**: The command-line tool for interacting with the Kubernetes API server.
- **Deployments**: Manage the deployment of applications on your cluster.
- **Services**: Expose your application to the network.
- **ConfigMaps**: Manage configuration data for your applications.
- **Secrets**: Store and manage sensitive information.

For more detailed information, refer to the [Kubernetes documentation](https://kubernetes.io/docs/home/).