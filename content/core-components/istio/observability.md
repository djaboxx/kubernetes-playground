# Istio Observability Guide

## Components Overview

### 1. Metrics
- Proxy-level metrics
- Service-level metrics
- Control plane metrics
- Protocol-specific metrics

### 2. Distributed Tracing
- Request tracing across services
- Latency analysis
- Dependency mapping

### 3. Access Logging
- Envoy proxy logs
- Control plane logs
- Application logs correlation

## Setup Instructions

### Prometheus Integration
```yaml
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
spec:
  meshConfig:
    enablePrometheusMerge: true
  values:
    telemetry:
      v2:
        prometheus:
          configOverride:
            inboundSidecar:
              metrics:
                - name: requests_total
                  dimensions:
                    destination_service: destination.service.name
                    response_code: response.code
```

### Grafana Dashboard Installation
```bash
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.18/samples/addons/grafana.yaml
```

### Jaeger Setup
```bash
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.18/samples/addons/jaeger.yaml
```

## Monitoring Configuration

### 1. Metrics Collection
Default metrics include:
- Request volume
- Request duration
- Request size
- Response size
- Error rates

### 2. Custom Metrics
```yaml
apiVersion: telemetry.istio.io/v1alpha1
kind: Telemetry
metadata:
  name: mesh-default
  namespace: istio-system
spec:
  metrics:
  - providers:
    - name: prometheus
    overrides:
    - match:
        metric: REQUEST_COUNT
        mode: CLIENT_AND_SERVER
      tagOverrides:
        custom_tag:
          value: custom_value
```

## Distributed Tracing

### 1. Trace Configuration
```yaml
apiVersion: telemetry.istio.io/v1alpha1
kind: Telemetry
metadata:
  name: tracing-config
spec:
  tracing:
  - randomSamplingPercentage: 100.0
    providers:
    - name: jaeger
    customTags:
      environment:
        literal:
          value: production
```

### 2. Sampling Configuration
- Configure sampling rates based on traffic volume
- Adjust based on environment (dev/prod)
- Consider resource implications

## Visualization Tools

### 1. Kiali
- Service mesh topology
- Real-time traffic flow
- Health monitoring
- Configuration validation

### 2. Grafana Dashboards
- Mesh Overview
- Service Dashboard
- Workload Dashboard
- Performance Dashboard

## Best Practices

1. **Performance Optimization**
   - Set appropriate sampling rates
   - Configure retention periods
   - Monitor resource usage

2. **Data Collection**
   - Use selective tag propagation
   - Implement custom metrics judiciously
   - Configure appropriate log levels

3. **Dashboard Organization**
   - Create role-specific views
   - Set up alerting thresholds
   - Maintain dashboard consistency

## Troubleshooting

### Common Issues
1. **Metric Collection**
   - Missing data points
   - Incorrect aggregation
   - High cardinality problems

2. **Tracing Issues**
   - Broken traces
   - Missing spans
   - Sampling problems

### Debug Commands
```bash
# Check Prometheus targets
kubectl -n istio-system port-forward svc/prometheus 9090:9090

# Verify tracing setup
kubectl -n istio-system port-forward svc/jaeger-query 16686:16686

# Access Kiali dashboard
istioctl dashboard kiali
```

## Integration Examples

### 1. Alert Configuration
```yaml
groups:
- name: istio-alerts
  rules:
  - alert: HighLatency
    expr: histogram_quantile(0.95, rate(istio_request_duration_milliseconds_bucket[5m])) > 500
    for: 1m
    labels:
      severity: warning
    annotations:
      description: "High latency detected for service {{ $labels.destination_service }}"
```

### 2. Custom Dashboard Example
```yaml
apiVersion: "networking.istio.io/v1alpha3"
kind: EnvoyFilter
metadata:
  name: custom-stats
spec:
  configPatches:
  - applyTo: HTTP_FILTER
    match:
      context: SIDECAR_OUTBOUND
    patch:
      operation: ADD
      value:
        name: custom.stats
        typed_config:
          "@type": type.googleapis.com/udpa.type.v1.TypedStruct
          type_url: type.googleapis.com/envoy.extensions.filters.http.wasm.v3.Wasm
          value:
            config:
              metrics:
              - name: custom_metric
                tags:
                - name: source_service
                  value: node.metadata['WORKLOAD_NAME']
```