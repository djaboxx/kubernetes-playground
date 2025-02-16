# Prometheus Stack

## Overview

The Prometheus Stack (kube-prometheus-stack) is a collection of Kubernetes manifests, Grafana dashboards, and Prometheus rules that provide easy to operate end-to-end Kubernetes cluster monitoring using Prometheus and Grafana.

## Components

1. **Prometheus** - Time series database and monitoring system
2. **Alertmanager** - Handles alerts sent by Prometheus
3. **Grafana** - Visualization and analytics platform
4. **Node Exporter** - Exports hardware and OS metrics
5. **kube-state-metrics** - Generates metrics about Kubernetes objects

## Installation

### Using Helm

```bash
# Add the Prometheus community Helm repository
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Install the kube-prometheus-stack
helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace
```

## Basic Configuration

### Prometheus Configuration

```yaml
apiVersion: monitoring.coreos.com/v1
kind: Prometheus
metadata:
  name: prometheus
  namespace: monitoring
spec:
  serviceAccountName: prometheus
  serviceMonitorSelector:
    matchLabels:
      team: frontend
  resources:
    requests:
      memory: 400Mi
  enableAdminAPI: false
```

### Alert Rules

```yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: prometheus-example-rules
  namespace: monitoring
spec:
  groups:
  - name: example
    rules:
    - alert: HighRequestLatency
      expr: job:request_latency_seconds:mean5m{job="myjob"} > 0.5
      for: 10m
      labels:
        severity: warning
      annotations:
        summary: High request latency for {{ $labels.job }}
```

## Service Monitoring

### ServiceMonitor Example

```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: example-app
  namespace: monitoring
spec:
  selector:
    matchLabels:
      app: example-app
  endpoints:
  - port: web
```

## Best Practices

1. Resource Management
   - Set appropriate resource requests and limits
   - Configure retention periods
   - Use recording rules for complex queries

2. Security
   - Disable admin API in production
   - Use network policies
   - Implement proper RBAC

3. Alerting
   - Define meaningful alert thresholds
   - Add proper annotations
   - Group related alerts

4. Data Collection
   - Use ServiceMonitor CRDs
   - Label metrics appropriately
   - Configure scrape intervals based on needs

## Grafana Dashboards

Key built-in dashboards:
- Kubernetes Cluster Overview
- Node Metrics
- Pod Resources
- API Server Performance
- Prometheus Stats

## Troubleshooting

Common issues and solutions:

1. High Memory Usage
   - Adjust retention period
   - Review recording rules
   - Check cardinality of metrics

2. Missing Metrics
   - Verify ServiceMonitor configuration
   - Check endpoint accessibility
   - Review target labels

3. Alert Issues
   - Verify PrometheusRule syntax
   - Check AlertManager configuration
   - Review alert expressions

## External Resources

- [Official Prometheus Documentation](https://prometheus.io/docs/introduction/overview/)
- [kube-prometheus-stack GitHub](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)
- [Grafana Documentation](https://grafana.com/docs/)
- [PromQL Tutorial](https://prometheus.io/docs/prometheus/latest/querying/basics/)