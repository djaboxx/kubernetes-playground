# Day 2: Ingress & Security

## Ingress NGINX Controller

### What is Ingress NGINX?
Ingress NGINX is a Kubernetes ingress controller that manages access to services within a Kubernetes cluster. It routes external traffic to the appropriate services based on defined rules.

### Key Concepts
- **Ingress**: An API object that manages external access to services, typically HTTP.
- **Ingress Controller**: A daemon that watches the Kubernetes API server for Ingress resources and updates its configuration accordingly.

### Setting Up Ingress NGINX
1. **Install Ingress NGINX**:
    ```sh
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
    ```
2. **Create an Ingress Resource**:
    ```yaml
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: example-ingress
      namespace: default
    spec:
      rules:
      - host: example.com
        http:
          paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: example-service
                port:
                  number: 80
    ```
    Apply the resource:
    ```sh
    kubectl apply -f ingress.yaml
    ```

## Cert-Manager and TLS Certificates

### What is Cert-Manager?
Cert-Manager is a Kubernetes add-on that automates the management and issuance of TLS certificates from various issuing sources.

### Key Concepts
- **Issuer**: A resource that represents a certificate authority (CA) that cert-manager can use to sign certificates.
- **Certificate**: A resource that represents a certificate request and the resulting signed certificate.

### Setting Up Cert-Manager
1. **Install Cert-Manager**:
    ```sh
    helm repo add jetstack https://charts.jetstack.io
    helm repo update
    helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.5.3 --set installCRDs=true
    ```
2. **Create an Issuer**:
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
3. **Create a Certificate**:
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

## Security Best Practices

### Network Policies
Network policies are used to control the traffic flow between pods in a Kubernetes cluster.

### RBAC (Role-Based Access Control)
RBAC is used to control access to resources in a Kubernetes cluster based on the roles of individual users or groups.

### Secrets Management
Kubernetes Secrets are used to store and manage sensitive information, such as passwords, OAuth tokens, and SSH keys.

### Pod Security Policies
Pod Security Policies are used to control the security settings applied to pods in a Kubernetes cluster.

### Regular Audits
Regularly audit your Kubernetes cluster to ensure compliance with security best practices and to identify potential vulnerabilities.
