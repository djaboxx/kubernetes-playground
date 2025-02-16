# Cert-Manager

## Overview
Cert-Manager is a Kubernetes add-on that automates the management and issuance of TLS certificates from various issuing sources.

## Key Concepts
- **Issuer**: A resource that represents a certificate authority (CA) that cert-manager can use to sign certificates.
- **Certificate**: A resource that represents a certificate request and the resulting signed certificate.

## Setting Up Cert-Manager

### Step 1: Install Cert-Manager
If Cert-Manager is not already installed, you can install it using Helm:

```sh
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.5.3 --set installCRDs=true
```

### Step 2: Create an Issuer
Create an Issuer resource to represent the certificate authority (CA) that will sign the certificates:

```yaml
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: example-issuer
  namespace: default
spec:
  selfSigned: {}
```

Apply the resource:

```sh
kubectl apply -f issuer.yaml
```

### Step 3: Create a Certificate
Create a Certificate resource to request a TLS certificate:

```yaml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: example-cert
  namespace: default
spec:
  secretName: example-cert-tls
  issuerRef:
    name: example-issuer
  commonName: example.com
  dnsNames:
  - example.com
```

Apply the resource:

```sh
kubectl apply -f certificate.yaml
```

## Additional Resources
For more detailed information, refer to the following resources:

- [Cert-Manager Documentation](https://cert-manager.io/docs/)
- [Cert-Manager GitHub Repository](https://github.com/jetstack/cert-manager)
