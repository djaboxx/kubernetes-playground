# Istio Automation Guide

## GitOps Integration

### ArgoCD Setup

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: istio-system
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/your-org/gitops-repo.git
    path: istio/base
    targetRevision: HEAD
  destination:
    server: https://kubernetes.default.svc
    namespace: istio-system
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

## CI/CD Pipeline Integration

### 1. Pre-deployment Checks
```yaml
steps:
- name: istio-analyze
  script: |
    istioctl analyze -A
    istioctl verify-install
```

### 2. Canary Deployment Automation
```yaml
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: automated-canary
  annotations:
    flagger.app/canary: "true"
spec:
  hosts:
  - app.example.com
  gateways:
  - app-gateway
  http:
  - route:
    - destination:
        host: app-primary
      weight: 100
    - destination:
        host: app-canary
      weight: 0
```

## Operational Tasks Automation

### 1. Certificate Rotation
```bash
#!/bin/bash
# cert-rotation.sh
istioctl x precheck
istioctl proxy-status
istioctl upgrade
kubectl rollout restart deployment -n istio-system istiod
```

### 2. Configuration Validation
```bash
#!/bin/bash
# validate-config.sh
istioctl analyze
istioctl experimental wait --for=distribution CustomResourceDefinition/virtualservices.networking.istio.io
```

## Infrastructure as Code

### 1. Terraform Integration
```hcl
resource "kubernetes_namespace" "istio_system" {
  metadata {
    name = "istio-system"
    labels = {
      istio-injection = "disabled"
    }
  }
}

resource "helm_release" "istio_base" {
  name       = "istio-base"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "base"
  namespace  = kubernetes_namespace.istio_system.metadata[0].name
}
```

### 2. Helm Value Automation
```yaml
global:
  proxy:
    autoInject: enabled
    resources:
      requests:
        cpu: 100m
        memory: 128Mi
      limits:
        cpu: 200m
        memory: 256Mi

gateways:
  istio-ingressgateway:
    autoscaleMin: 2
    autoscaleMax: 5

telemetry:
  enabled: true
  v2:
    enabled: true
```

## Monitoring Automation

### 1. Alert Configuration
```yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: istio-alerts
  namespace: monitoring
spec:
  groups:
  - name: istio.rules
    rules:
    - alert: IstioHighLatency
      expr: histogram_quantile(0.95, sum(rate(istio_request_duration_milliseconds_bucket[5m])) by (le, destination_service)) > 500
      for: 5m
      labels:
        severity: warning
      annotations:
        description: "Service {{ $labels.destination_service }} has high latency"
```

### 2. Automated Reporting
```python
#!/usr/bin/env python3
# generate_istio_report.py

from kubernetes import client, config
import pandas as pd
import datetime

def get_istio_metrics():
    # Implementation for collecting and formatting metrics
    pass

def generate_report():
    metrics = get_istio_metrics()
    report = pd.DataFrame(metrics)
    report.to_excel(f"istio-report-{datetime.date.today()}.xlsx")
```

## Maintenance Automation

### 1. Health Checks
```bash
#!/bin/bash
# health-check.sh

check_istio_components() {
    kubectl get pods -n istio-system
    istioctl proxy-status
    istioctl analyze -A
}

check_mesh_health() {
    istioctl experimental metrics all
    istioctl experimental describe pod -n default
}

main() {
    check_istio_components
    check_mesh_health
}

main