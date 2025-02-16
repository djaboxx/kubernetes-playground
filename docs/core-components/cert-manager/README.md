# Cert-Manager

## Overview
Cert-Manager is a native Kubernetes certificate management controller. It simplifies the process of obtaining, renewing and using SSL/TLS certificates in your Kubernetes cluster.

## Features
- Automatic certificate issuance and renewal
- Support for multiple certificate authorities (Let's Encrypt, HashiCorp Vault, etc.)
- ACME protocol support (HTTP01 and DNS01 challenges)
- Custom resource definitions for certificates
- Integration with Ingress resources

## Installation

```bash
helm repo add jetstack https://charts.jetstack.io
helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --set installCRDs=true
```

## Core Concepts
1. **Issuer/ClusterIssuer**: Represents a certificate authority (CA)
2. **Certificate**: Request for a TLS certificate
3. **CertificateRequest**: Low-level resource for certificate generation
4. **Orders and Challenges**: ACME protocol resources

## Configuration Examples

1. **ClusterIssuer for Let's Encrypt Production**
```yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: dave@roknsound.com
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
    - http01:
        ingress:
          class: nginx
```

2. **Certificate Request**
```yaml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: example-com-tls
spec:
  secretName: example-com-tls
  issuerRef:
    name: letsencrypt-prod
    kind: ClusterIssuer
  dnsNames:
  - example.com
  - www.example.com
```

## Best Practices
1. **Production Setup**
   - Use ClusterIssuer for cluster-wide certificate management
   - Set appropriate rate limits
   - Monitor certificate expiration

2. **Security**
   - Use production CAs for production environments
   - Secure ACME account keys
   - Regular auditing of certificates

3. **Resource Management**
   - Set resource requests and limits
   - Configure appropriate renewal windows
   - Clean up unused certificates

## Troubleshooting
1. **Common Issues**
   - ACME challenge failures
   - DNS configuration problems
   - Rate limiting issues

2. **Debug Commands**
```bash
kubectl describe certificate <name>
kubectl describe certificaterequest <name>
kubectl describe challenge <name>
kubectl get events --field-selector type=Warning
```

## Monitoring
1. **Key Metrics**
   - Certificate expiration
   - Renewal success rate
   - ACME challenge duration

2. **Prometheus Integration**
```yaml
prometheus:
  enabled: true
  servicemonitor:
    enabled: true
```

## Additional Resources
- [Official Documentation](https://cert-manager.io/docs/)
- [Supported Issuer Types](https://cert-manager.io/docs/configuration/)
- [Troubleshooting Guide](https://cert-manager.io/docs/troubleshooting/)