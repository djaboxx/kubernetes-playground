# Istio Production Best Practices

## Resource Planning

### 1. Control Plane Sizing
```yaml
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
spec:
  components:
    pilot:
      k8s:
        resources:
          requests:
            cpu: 1000m
            memory: 1Gi
          limits:
            cpu: 2000m
            memory: 2Gi
    ingressGateways:
    - name: istio-ingressgateway
      k8s:
        resources:
          requests:
            cpu: 500m
            memory: 512Mi
          limits:
            cpu: 1000m
            memory: 1Gi
```

### 2. Data Plane Optimization
- Configure appropriate proxy resources
- Optimize proxy concurrency
- Set appropriate protocol detection timeouts

## High Availability Configuration

### 1. Multi-cluster Setup
```yaml
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
spec:
  values:
    global:
      multiCluster:
        enabled: true
      network: network1
    pilot:
      replicaCount: 3
      autoscaleMin: 3
      autoscaleMax: 5
```

### 2. Fault Tolerance Settings
```yaml
apiVersion: networking.istio.io/v1beta1
kind: DestinationRule
metadata:
  name: fault-tolerance
spec:
  host: myservice.default.svc.cluster.local
  trafficPolicy:
    connectionPool:
      tcp:
        maxConnections: 100
        connectTimeout: 5s
      http:
        http2MaxRequests: 1000
        maxRequestsPerConnection: 100
    outlierDetection:
      consecutive5xxErrors: 5
      interval: 30s
      baseEjectionTime: 30s
```

## Security Hardening

1. **Network Policies**
   - Implement strict namespace isolation
   - Control egress traffic
   - Secure control plane access

2. **Certificate Management**
   - Regular rotation schedule
   - Monitoring expiration
   - Backup procedures

## Performance Tuning

### 1. Gateway Optimization
```yaml
apiVersion: networking.istio.io/v1beta1
kind: Gateway
metadata:
  name: optimized-gateway
spec:
  selector:
    istio: ingressgateway
  servers:
  - port:
      number: 443
      name: https
      protocol: HTTPS
    tls:
      mode: SIMPLE
      cipherSuites:
      - ECDHE-ECDSA-AES256-GCM-SHA384
      - ECDHE-RSA-AES256-GCM-SHA384
    hosts:
    - "*"
```

### 2. Sidecar Resource Limits
```yaml
apiVersion: networking.istio.io/v1beta1
kind: Sidecar
metadata:
  name: default
  namespace: default
spec:
  egress:
  - hosts:
    - "./*"
    - "istio-system/*"
  resources:
    requests:
      cpu: 100m
      memory: 128Mi
    limits:
      cpu: 200m
      memory: 256Mi
```

## Monitoring and Alerting

### 1. Critical Metrics
- Control plane health
- Data plane connectivity
- Certificate expiration
- Resource utilization

### 2. SLO Definitions
```yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: slo-rules
spec:
  groups:
  - name: slo.rules
    rules:
    - record: slo:latency:p99
      expr: histogram_quantile(0.99, sum(rate(istio_request_duration_milliseconds_bucket[5m])) by (le))
```

## Disaster Recovery

### 1. Backup Procedures
- Control plane configuration
- Custom resources
- Certificates and secrets
- Mesh configuration

### 2. Recovery Steps
```bash
# Restore procedure outline
1. Reinstall Istio control plane
2. Apply backed-up CRDs
3. Restore secret configurations
4. Validate mesh connectivity
5. Verify service routing
```

## Upgrade Strategy

### 1. Canary Upgrades
- Test in dev environment
- Upgrade control plane first
- Rolling data plane updates
- Monitoring during upgrade

### 2. Rollback Plan
```bash
# Rollback procedure
1. Revert control plane version
2. Reset data plane proxies
3. Validate functionality
4. Check metric consistency
```

## Capacity Planning

### 1. Scaling Thresholds
- CPU utilization < 75%
- Memory usage < 80%
- Connection pool saturation
- Request queue depth

### 2. Growth Planning
- Traffic projection
- Resource reservation
- Cluster expansion strategy
- Multi-cluster considerations