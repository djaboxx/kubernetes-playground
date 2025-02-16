# Kubernetes Components Documentation

This documentation covers the key components installed in this Kubernetes cluster via Helm charts.

## Core Components

1. [Argo CD](./core-components/argo-cd/README.md) - Declarative Continuous Delivery tool for Kubernetes
2. [Cert Manager](./core-components/cert-manager/README.md) - Certificate management controller
3. [Ingress Nginx](./core-components/ingress-nginx/README.md) - Ingress controller for Kubernetes
4. [Prometheus Stack](./core-components/prometheus/README.md) - Monitoring and alerting toolkit

## Features and Technologies in Our Cluster

Our Kubernetes cluster includes several important features and technologies. Here's a high-level overview of what we're installing, why we're installing it, and what it does for us.

### Argo CD

**What it is:** Argo CD is a tool for continuous delivery in Kubernetes. It helps automate the deployment of applications.

**Why we use it:** It makes sure that the applications in the cluster are always in sync with the code in the Git repository. This means fewer manual updates and more reliable deployments.

**Benefits:**
- Automates application deployment
- Ensures consistency between Git and the cluster
- Reduces manual errors

### Cert Manager

**What it is:** Cert Manager is a tool for managing certificates in Kubernetes. It automates the creation, renewal, and management of TLS certificates.

**Why we use it:** It simplifies the process of securing our applications with HTTPS, making them more secure.

**Benefits:**
- Automates certificate management
- Enhances security with HTTPS
- Reduces manual certificate handling

### Ingress NGINX

**What it is:** Ingress NGINX is a controller that manages access to services in a Kubernetes cluster. It routes external traffic to the appropriate services within the cluster.

**Why we use it:** It provides a simple way to manage external access to our applications, including load balancing and SSL termination.

**Benefits:**
- Manages external access to services
- Provides load balancing
- Simplifies SSL termination

### Prometheus Stack

**What it is:** The Prometheus Stack includes Prometheus, Grafana, and Alert Manager. These tools help monitor the cluster, visualize data, and send alerts.

**Why we use it:** It allows us to keep an eye on the health and performance of our cluster, ensuring everything runs smoothly.

**Benefits:**
- Monitors cluster health and performance
- Visualizes data with Grafana dashboards
- Sends alerts for issues

### Elasticsearch, Fluentd, and Kibana (EFK Stack)

**What it is:** The EFK Stack is a set of tools for logging. Elasticsearch stores logs, Fluentd collects logs, and Kibana allows us to search and visualize logs.

**Why we use it:** It helps us keep track of logs from all our applications, making it easier to debug and monitor them.

**Benefits:**
- Centralizes log storage
- Simplifies log collection
- Provides powerful log search and visualization with Kibana

These technologies work together to make our Kubernetes cluster more reliable, secure, and easier to manage.

## Learning Path

### Day 1: Foundation
- Kubernetes basics
- Helm fundamentals
- Basic cluster operations

### Day 2: Ingress & Security
- Ingress NGINX controller
- Cert-Manager and TLS certificates
- Security best practices

### Day 3: Continuous Delivery & Observability
- Argo CD introduction
- GitOps principles
- Application deployment patterns
- Prometheus basics
- Metrics collection
- Alert configuration
- Grafana dashboards

## Quick Links

- [Installation Guide](./installation.md)
- [Troubleshooting Guide](./troubleshooting.md)
- [Best Practices](./best-practices.md)