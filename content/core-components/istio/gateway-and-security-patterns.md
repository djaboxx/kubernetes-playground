# Gateway and Security Patterns with Istio

## Secure Gateway Configuration

### TLS and Protocol Security
```yaml
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: secure-gateway
spec:
  selector:
    istio: ingressgateway
  servers:
  - port:
      number: 443
      name: https
      protocol: HTTPS
    hosts:
    - "*.example.com"
    tls:
      credentialName: example-certs
      mode: SIMPLE
      minProtocolVersion: TLSV1_2
      cipherSuites:
      - ECDHE-ECDSA-AES128-GCM-SHA256
      - ECDHE-RSA-AES128-GCM-SHA256
```

### Benefits
- **Modern TLS Standards**: Enforce strong security protocols
- **Certificate Management**: Centralized TLS certificate handling
- **Protocol Control**: Restrict to secure protocols only
- **Cipher Suite Control**: Enforce strong encryption standards

## Authorization Policies

### Fine-grained Access Control
```yaml
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  name: api-security
spec:
  selector:
    matchLabels:
      app: api-server
  rules:
  - from:
    - source:
        namespaces: ["frontend"]
    to:
    - operation:
        methods: ["GET"]
        paths: ["/api/v1/*"]
```

### Benefits
- **Zero-Trust Architecture**: Deny-by-default security model
- **Namespace Isolation**: Control cross-namespace communication
- **Method-Level Control**: Restrict HTTP methods per path
- **Source Authentication**: Verify caller identity

## Load Balancing Patterns

### Advanced Load Balancing
```yaml
apiVersion: networking.istio.io/v1beta1
kind: DestinationRule
metadata:
  name: api-loadbalancing
spec:
  host: api-service
  trafficPolicy:
    loadBalancer:
      simple: LEAST_CONN
    connectionPool:
      tcp:
        maxConnections: 100
      http:
        maxRequestsPerConnection: 10
    outlierDetection:
      consecutive5xxErrors: 5
      interval: 10s
      baseEjectionTime: 30s
```

### Benefits
- **Smart Load Distribution**: Balance based on actual connection load
- **Circuit Breaking**: Prevent cascade failures
- **Connection Management**: Control resource usage
- **Automatic Health Management**: Remove unhealthy instances

## Best Practices
1. Use separate gateways for different security requirements
2. Implement rate limiting at the gateway level
3. Start with strict authorization policies and loosen as needed
4. Configure meaningful timeout and retry policies
5. Monitor rejected requests and authorization failures

## External Resources
- [Istio Security Features](https://istio.io/latest/docs/concepts/security/)
- [Gateway Configuration Guide](https://istio.io/latest/docs/tasks/traffic-management/ingress/ingress-control/)
- [Authorization Policy Examples](https://istio.io/latest/docs/tasks/security/authorization/)