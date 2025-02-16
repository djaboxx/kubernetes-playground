# Traffic Management with Istio

## Core Concepts

### Virtual Services
Virtual Services define how requests are routed to a service. They provide a way to configure traffic rules for how requests are handled.

```yaml
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: reviews-route
spec:
  hosts:
  - reviews
  http:
  - match:
    - headers:
        end-user:
          exact: jason
    route:
    - destination:
        host: reviews
        subset: v2
  - route:
    - destination:
        host: reviews
        subset: v1
```

### Destination Rules
Destination Rules define policies that apply to traffic intended for a service after routing has occurred.

```yaml
apiVersion: networking.istio.io/v1beta1
kind: DestinationRule
metadata:
  name: reviews-destination
spec:
  host: reviews
  subsets:
  - name: v1
    labels:
      version: v1
  - name: v2
    labels:
      version: v2
```

## Traffic Management Patterns

### 1. Canary Deployments
Gradually roll out changes by routing a percentage of traffic to a new version:

```yaml
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: my-service
spec:
  hosts:
  - my-service
  http:
  - route:
    - destination:
        host: my-service
        subset: v1
      weight: 90
    - destination:
        host: my-service
        subset: v2
      weight: 10
```

### 2. Circuit Breaking
Prevent cascading failures:

```yaml
apiVersion: networking.istio.io/v1beta1
kind: DestinationRule
metadata:
  name: circuit-breaker
spec:
  host: my-service
  trafficPolicy:
    outlierDetection:
      consecutive5xxErrors: 5
      interval: 30s
      baseEjectionTime: 30s
```

### 3. Fault Injection
Test service resilience:

```yaml
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: ratings
spec:
  hosts:
  - ratings
  http:
  - fault:
      delay:
        percentage:
          value: 10.0
        fixedDelay: 5s
    route:
    - destination:
        host: ratings
        subset: v1
```

## Best Practices

1. **Traffic Splitting**
   - Start with small percentages for new versions
   - Monitor error rates before increasing traffic
   - Have rollback procedures ready

2. **Resilience**
   - Always configure timeout and retry policies
   - Use circuit breakers for dependencies
   - Implement fallback mechanisms

3. **Performance**
   - Configure resource limits for sidecars
   - Use locality-aware load balancing
   - Monitor latency impact of policies

## Monitoring Traffic Flow

```bash
# View routing configuration
istioctl analyze

# Check proxy configuration
istioctl proxy-config routes <pod-name>

# Visualize service mesh
istioctl dashboard kiali
```

## Troubleshooting

1. **Common Issues**
   - Routing conflicts
   - Certificate errors
   - Performance degradation

2. **Debug Commands**
```bash
# Check proxy logs
kubectl logs <pod-name> -c istio-proxy

# Verify configuration
istioctl analyze namespace <namespace>

# Debug routing
istioctl proxy-config dump <pod-name>
```