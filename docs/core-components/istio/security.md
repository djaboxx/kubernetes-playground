# Istio Security Guide

## Authentication

### 1. Peer Authentication
Controls service-to-service authentication:

```yaml
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: default
  namespace: istio-system
spec:
  mtls:
    mode: STRICT
```

### 2. Request Authentication
Validates JWT tokens for end-user authentication:

```yaml
apiVersion: security.istio.io/v1beta1
kind: RequestAuthentication
metadata:
  name: jwt-example
  namespace: foo
spec:
  selector:
    matchLabels:
      app: hello
  jwtRules:
  - issuer: "https://accounts.google.com"
    jwksUri: "https://www.googleapis.com/oauth2/v3/certs"
```

## Authorization

### Service-to-Service Authorization
```yaml
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  name: httpbin
  namespace: default
spec:
  selector:
    matchLabels:
      app: httpbin
  rules:
  - from:
    - source:
        principals: ["cluster.local/ns/default/sa/sleep"]
    to:
    - operation:
        methods: ["GET"]
        paths: ["/info*"]
```

## mTLS Configuration

### 1. Global mTLS
Enable mesh-wide mTLS:

```yaml
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: default
  namespace: istio-system
spec:
  mtls:
    mode: STRICT
```

### 2. Namespace-level mTLS
```yaml
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: default
  namespace: your-namespace
spec:
  mtls:
    mode: PERMISSIVE
```

## Security Best Practices

1. **Authentication**
   - Enable mTLS across the mesh
   - Use STRICT mode in production
   - Implement JWT validation for external traffic

2. **Authorization**
   - Follow principle of least privilege
   - Use namespace-level policies
   - Regularly audit policies

3. **Key Management**
   - Rotate certificates regularly
   - Monitor certificate expiration
   - Secure root CA credentials

## Implementation Steps

1. **Enable Security Features**
```bash
# Verify mTLS status
istioctl analyze

# Check authentication policies
kubectl get peerauthentication --all-namespaces

# Verify authorization policies
kubectl get authorizationpolicy --all-namespaces
```

2. **Monitor Security**
```bash
# Check proxy certificates
istioctl proxy-status

# Verify mTLS configuration
istioctl authn tls-check <pod-name>

# Debug authorization
istioctl analyze -n <namespace>
```

## Troubleshooting

### Common Issues
1. **Certificate Problems**
   - Expired certificates
   - Missing root certificates
   - Trust domain misconfigurations

2. **Authorization Failures**
   - Policy conflicts
   - RBAC misconfiguration
   - Selector mismatches

### Debug Commands
```bash
# Check proxy certificates
istioctl proxy-config secret <pod-name>

# Verify policy enforcement
istioctl x describe pod <pod-name>

# Test authorization policies
istioctl experimental authz check <pod-name>
```

## Security Monitoring

1. **Key Metrics to Watch**
   - mTLS connection success rate
   - Authentication failures
   - Authorization denials
   - Certificate rotation events

2. **Integration with Security Tools**
   - SIEM systems
   - Audit logging
   - Compliance monitoring