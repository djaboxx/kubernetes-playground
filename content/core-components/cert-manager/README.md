# Cert-Manager

## Overview

Cert-Manager is a native Kubernetes certificate management controller that helps with X.509 certificate issuance and management. It can issue certificates from various sources including Let's Encrypt, HashiCorp Vault, and self-signed.

## Features

- Automated certificate issuance and renewal
- Support for multiple certificate authorities
- Integration with Kubernetes Ingress resources
- Multiple issuers support (Let's Encrypt, Vault, self-signed)
- Certificate rotation and expiry monitoring

## Installation

### Using Helm (Recommended)

```bash
# Add the Jetstack Helm repository
helm repo add jetstack https://charts.jetstack.io
helm repo update

# Install cert-manager
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.5.3 \
  --set installCRDs=true
```

### Verification

Check if cert-manager pods are running:
```bash
kubectl get pods -n cert-manager
```

## Basic Configuration

### Creating a ClusterIssuer

```yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: your-email@example.com
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
    - http01:
        ingress:
          class: nginx
```

### Requesting a Certificate

```yaml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: example-cert
  namespace: default
spec:
  secretName: example-cert-tls
  duration: 2160h # 90 days
  renewBefore: 360h # 15 days
  subject:
    organizations:
      - Example Inc.
  commonName: example.com
  dnsNames:
    - example.com
    - www.example.com
  issuerRef:
    name: letsencrypt-prod
    kind: ClusterIssuer
```

## Integration Options

- Let's Encrypt (ACME)
- HashiCorp Vault
- Venafi
- Self-signed certificates
- External CAs

## Best Practices

1. Always use production ACME server for production environments
2. Implement proper monitoring for certificate expiration
3. Use ClusterIssuers for cluster-wide certificate management
4. Configure appropriate backup for certificate secrets
5. Set up alerting for certificate-related events

## Troubleshooting

Common issues and solutions:

1. Certificate not being issued
   - Check cert-manager logs
   - Verify ClusterIssuer/Issuer configuration
   - Check Certificate resource events

2. HTTP01 challenge failures
   - Verify ingress configuration
   - Check network connectivity
   - Ensure proper DNS configuration

## External Resources

- [Official Documentation](https://cert-manager.io/docs/)
- [GitHub Repository](https://github.com/cert-manager/cert-manager)
- [Troubleshooting Guide](https://cert-manager.io/docs/troubleshooting/)
- [Integration Tutorials](https://cert-manager.io/docs/tutorials/)