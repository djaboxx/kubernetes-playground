# Monitoring and Observability

This guide explains how to watch your Kubernetes cluster and applications to make sure everything is running well. We'll cover how to set up monitoring tools, collect logs, create alerts, and measure performance.

## Setting Up the Monitoring Stack

### Installing Prometheus
Prometheus is like a security camera system for your cluster. Here's how to set it up:

```yaml
# values.yaml - Basic settings that work for most teams
kube-prometheus-stack:
  prometheus:
    prometheusSpec:
      retention: 15d                    # Keep data for 15 days
      storageSpec:
        volumeClaimTemplate:
          spec:
            storageClassName: standard  # Use standard storage
            resources:
              requests:
                storage: 100Gi         # Keep lots of history
      
  alertmanager:
    alertmanagerSpec:
      storage:
        volumeClaimTemplate:
          spec:
            storageClassName: standard
            resources:
              requests:
                storage: 20Gi          # Space for alerts
```
Learn more: [Prometheus Operator](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/user-guides/getting-started.md)

### Setting Up Grafana
Grafana shows your monitoring data in easy-to-read dashboards:

```yaml
grafana:
  persistence:
    enabled: true          # Save your changes
    size: 10Gi            # Space for dashboards
  
  dashboardProviders:      # Where to find dashboards
    dashboardproviders.yaml:
      apiVersion: 1
      providers:
      - name: 'default'    # Main dashboard folder
        orgId: 1
        folder: ''
        type: file
        disableDeletion: false
        editable: true
        options:
          path: /var/lib/grafana/dashboards
  
  dashboards:             # Which dashboards to show
    default:
      kubernetes-cluster:  # Overview of your cluster
        gnetId: 7249
        revision: 1
        datasource: Prometheus
      node-exporter:      # Details about each server
        gnetId: 1860
        revision: 23
        datasource: Prometheus
```
Reference: [Grafana Configuration](https://grafana.com/docs/grafana/latest/setup-grafana/configure-grafana/)

### Alert Manager Setup
Set up notifications for when things go wrong:

```yaml
alertmanager:
  config:
    global:
      resolve_timeout: 5m    # How long to wait before sending
      slack_api_url: 'https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK'
    
    route:
      group_by: ['namespace', 'severity']  # Group similar alerts
      group_wait: 30s                      # Wait for more alerts
      group_interval: 5m                   # Wait between groups
      repeat_interval: 12h                 # How often to repeat
      receiver: 'slack-notifications'      # Where to send alerts
      routes:
      - match:
          severity: critical
        receiver: 'pagerduty-critical'    # Emergency alerts
    
    receivers:
    - name: 'slack-notifications'         # Regular alerts to Slack
      slack_configs:
      - channel: '#alerts'
        send_resolved: true
        title: '[{{ .Status | toUpper }}] {{ .CommonLabels.alertname }}'
        text: "{{ range .Alerts }}{{ .Annotations.description }}\n{{ end }}"
    
    - name: 'pagerduty-critical'         # Emergency alerts to PagerDuty
      pagerduty_configs:
      - service_key: YOUR_PAGERDUTY_KEY
```
More info: [Alert Manager Configuration](https://prometheus.io/docs/alerting/latest/configuration/)

## Setting Up Logging

### Logging Stack Components
Set up tools to collect and search logs:

```yaml
# values.yaml for the logging stack
elasticsearch:           # Stores all your logs
  replicas: 3           # Run 3 copies for safety
  resources:
    requests:
      cpu: "1000m"      # Need good CPU
      memory: "2Gi"     # And plenty of memory
    limits:
      cpu: "2000m"
      memory: "4Gi"

fluentd:                # Collects logs from everywhere
  tolerations:         # Allow running on all nodes
  - key: node-role.kubernetes.io/master
    operator: Exists
    effect: NoSchedule

kibana:                # Tool for searching logs
  resources:
    requests:
      cpu: "500m"
      memory: "1Gi"
    limits:
      cpu: "1000m"
      memory: "2Gi"
```
Learn more: [EFK Stack](https://kubernetes.io/docs/tasks/debug-application-cluster/logging-elasticsearch-kibana/)

### Log Collection Rules
Tell Fluentd how to handle logs:

```yaml
# fluentd-configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: fluentd-config
data:
  fluent.conf: |
    <match kubernetes.**>     # For all Kubernetes logs
      @type elasticsearch     # Send to Elasticsearch
      host elasticsearch-master
      port 9200
      logstash_format true   # Use time-based indexes
      logstash_prefix k8s    # Start names with k8s
      <buffer>               # How to handle log flow
        @type file
        path /var/log/fluentd-buffers/kubernetes.system.buffer
        flush_mode interval
        retry_type exponential_backoff
        flush_interval 5s    # Write every 5 seconds
        retry_forever false
        retry_max_interval 30
        chunk_limit_size 2M  # Break into small pieces
        queue_limit_length 8
        overflow_action block
      </buffer>
    </match>
```
Reference: [Fluentd Configuration](https://docs.fluentd.org/configuration)

## Setting Up Alerts

### Prometheus Alert Rules
Create rules for when to send alerts:

```yaml
# prometheus-rules.yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: kubernetes-monitoring
  namespace: monitoring
spec:
  groups:
  - name: kubernetes.rules
    rules:
    - alert: KubernetesPodCrashLooping   # Alert for failing pods
      expr: rate(kube_pod_container_status_restarts_total[15m]) * 60 * 5 > 0
      for: 15m
      labels:
        severity: warning
      annotations:
        description: Pod {{ $labels.namespace }}/{{ $labels.pod }} keeps restarting
        
    - alert: KubernetesNodeNotReady     # Alert for broken nodes
      expr: kube_node_status_condition{condition="Ready",status="true"} == 0
      for: 15m
      labels:
        severity: critical
      annotations:
        description: Node {{ $labels.node }} is not responding
        
    - alert: KubernetesPodPending      # Alert for stuck deployments
      expr: kube_pod_status_phase{phase="Pending"} == 1
      for: 1h
      labels:
        severity: warning
      annotations:
        description: Pod {{ $labels.namespace }}/{{ $labels.pod }} won't start
```
More details: [Prometheus Rules](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/)

## Measuring Service Health (SLOs)

### Setting Service Goals
Define what "working well" means:

```yaml
# slo-rules.yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: slo-rules
spec:
  groups:
  - name: slo.rules
    rules:
    - record: slo:request_latency_seconds:mean  # How fast requests are
      expr: |
        rate(http_request_duration_seconds_sum[5m])
        /
        rate(http_request_duration_seconds_count[5m])
    
    - alert: HighLatency                       # Alert if too slow
      expr: |
        slo:request_latency_seconds:mean > 0.5
      for: 5m
      labels:
        severity: warning
      annotations:
        description: Responses are taking too long

    - record: slo:request_errors_total:rate5m  # How many errors
      expr: |
        rate(http_requests_total{status=~"5.."}[5m])
        /
        rate(http_requests_total[5m])
    
    - alert: HighErrorRate                     # Alert if too many errors
      expr: |
        slo:request_errors_total:rate5m > 0.01
      for: 5m
      labels:
        severity: critical
      annotations:
        description: Error rate above 1%
```
Learn more: [SLO with Prometheus](https://prometheus.io/docs/practices/slos/)

### SLO Dashboard
Create a dashboard to watch service health:

```json
{
  "dashboard": {
    "id": null,
    "title": "Service SLOs",
    "panels": [
      {
        "title": "Request Latency",       # How fast things are
        "type": "graph",
        "datasource": "Prometheus",
        "targets": [
          {
            "expr": "slo:request_latency_seconds:mean",
            "legendFormat": "Mean Latency"
          }
        ]
      },
      {
        "title": "Error Rate",            # How many errors
        "type": "graph",
        "datasource": "Prometheus",
        "targets": [
          {
            "expr": "slo:request_errors_total:rate5m",
            "legendFormat": "Error Rate"
          }
        ]
      }
    ]
  }
}
```
Reference: [Grafana Dashboard JSON](https://grafana.com/docs/grafana/latest/dashboards/json-model/)

## Additional Resources

### Official Documentation
- [Prometheus Docs](https://prometheus.io/docs/introduction/overview/)
- [Grafana Docs](https://grafana.com/docs/)
- [Elasticsearch Docs](https://www.elastic.co/guide/index.html)
- [Fluentd Docs](https://docs.fluentd.org/)

### Useful Tools
- [Prometheus Operator](https://github.com/prometheus-operator/prometheus-operator)
- [Grafana Dashboard Library](https://grafana.com/grafana/dashboards)
- [SLO Examples](https://slo.tools/)