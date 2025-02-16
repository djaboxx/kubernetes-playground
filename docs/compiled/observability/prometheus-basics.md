# Prometheus Basics

## What is Prometheus?
Prometheus is an open-source monitoring and alerting toolkit designed for reliability and scalability.

## Key Concepts
- **Metrics**: Data points collected from monitored systems.
- **Targets**: Systems that Prometheus monitors for metrics.
- **Scraping**: The process of collecting metrics from targets.
- **Alerting**: The process of generating alerts based on collected metrics.

## Setting Up Prometheus
1. **Install Prometheus**:
    ```sh
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    helm repo update
    helm install prometheus prometheus-community/prometheus --namespace monitoring --create-namespace
    ```
2. **Access the Prometheus UI**:
    ```sh
    kubectl port-forward svc/prometheus-server -n monitoring 9090:80
    ```
    Open your browser and navigate to `http://localhost:9090`.

## Additional Details and Examples

### Metrics
Metrics are the fundamental data points collected by Prometheus. They can be categorized into four types:
- **Counter**: A cumulative metric that increases over time.
- **Gauge**: A metric that represents a single numerical value that can arbitrarily go up and down.
- **Histogram**: A metric that samples observations and counts them in configurable buckets.
- **Summary**: Similar to a histogram, but also provides quantiles.

### Targets
Targets are the systems that Prometheus monitors for metrics. They are defined in the Prometheus configuration file (`prometheus.yml`). Example:
```yaml
scrape_configs:
  - job_name: 'example'
    static_configs:
      - targets: ['localhost:9090']
```

### Scraping
Scraping is the process of collecting metrics from targets. Prometheus scrapes metrics from targets at regular intervals. Example:
```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s
```

### Alerting
Alerting is the process of generating alerts based on collected metrics. Prometheus uses alerting rules to define conditions that trigger alerts. Example:
```yaml
groups:
- name: example-alerts
  rules:
  - alert: HighCPUUsage
    expr: node_cpu_seconds_total{mode="idle"} < 20
    for: 5m
    labels:
      severity: critical
    annotations:
      summary: "High CPU usage detected"
      description: "CPU usage is above 80% for more than 5 minutes."
```

## Links to Relevant External Documentation and Resources
- [Prometheus Documentation](https://prometheus.io/docs/introduction/overview/)
- [Prometheus GitHub Repository](https://github.com/prometheus/prometheus)
- [Prometheus Helm Chart](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus)
