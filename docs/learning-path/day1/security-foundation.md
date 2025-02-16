# Security Foundation

This guide explains how to make your Kubernetes cluster secure. We'll cover managing secrets, handling certificates, securing pods, and controlling network traffic.

## Vault Integration

### Setting Up Vault
First, let's install HashiCorp Vault, which is like a secure digital safe:

```yaml
# Basic Vault setup that works for most teams
helm repo add hashicorp https://helm.releases.hashicorp.com
helm install vault hashicorp/vault \
  --set "server.ha.enabled=true"    # Makes Vault highly available
  --set "server.ha.replicas=3"      # Runs 3 copies for safety
```
Learn more: [Vault on Kubernetes](https://www.vaultproject.io/docs/platform/k8s)

### Managing Secrets
Vault can handle two types of secrets:

1. Dynamic Secrets (automatically created when needed)
   - Database passwords
   - Cloud access keys
   - Service account tokens
   See how: [Dynamic Secrets Guide](https://www.vaultproject.io/docs/secrets/databases)
   
2. Static Secrets (things you store yourself)
   - API keys
   - TLS certificates
   - Configuration files
   Learn more: [Static Secrets](https://www.vaultproject.io/docs/secrets/kv)

### Key Management
1. Auto-unsealing (letting Vault start safely)
   ```hcl
   # This lets Google Cloud manage your encryption keys
   seal "gcpckms" {
     project     = "project-id"
     region      = "global"
     key_ring    = "vault-keyring"
     crypto_key  = "vault-key"
   }
   ```
   More details: [Auto-unseal with GCP](https://www.vaultproject.io/docs/configuration/seal/gcpckms)

2. Key Rotation (keeping secrets fresh)
   - Keys change automatically
   - Old versions are kept safely
   - You control how often keys change
   Learn more: [Key Rotation](https://www.vaultproject.io/docs/enterprise/automated-replication)

## Certificate Management

### Installing Cert-Manager
This tool handles your HTTPS certificates automatically:

```yaml
# Basic cert-manager installation
helm repo add jetstack https://charts.jetstack.io
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set installCRDs=true  # Installs everything needed
```
More info: [Cert-Manager Basics](https://cert-manager.io/docs/installation/)

### Setting Up HTTPS
1. Setting up certificate issuing:
   ```yaml
   # This tells cert-manager how to get certificates
   apiVersion: cert-manager.io/v1
   kind: ClusterIssuer
   metadata:
     name: letsencrypt-prod
   spec:
     acme:
       server: https://acme-v02.api.letsencrypt.org/directory
       email: dave@roknsound.com  # For important notifications
       privateKeySecretRef:
         name: letsencrypt-prod
       solvers:
       - http01:
           ingress:
             class: nginx
   ```
   Learn more: [ACME Issuers](https://cert-manager.io/docs/configuration/acme/)

2. Requesting a certificate:
   ```yaml
   # Example of requesting a certificate
   apiVersion: cert-manager.io/v1
   kind: Certificate
   metadata:
     name: example-com-tls
     namespace: default
   spec:
     secretName: example-com-tls
     duration: 2160h    # 90 days
     renewBefore: 360h  # Renew 15 days before expiry
     commonName: example.com
     dnsNames:
     - example.com
     - www.example.com
     issuerRef:
       name: letsencrypt-prod
       kind: ClusterIssuer
   ```
   Details: [Certificate Resources](https://cert-manager.io/docs/usage/certificate/)

### Certificate Renewal
- Certificates renew automatically
- You get alerts if something goes wrong
- You can see when certificates will expire
More at: [Certificate Renewal](https://cert-manager.io/docs/concepts/certificate/#renewal)

## Pod Security

### Security Levels
We use three levels of security:

1. Development (less strict)
   - For testing and development
   - For system tools
   Reference: [Privileged Policy](https://kubernetes.io/docs/concepts/security/pod-security-standards/#privileged)
   
2. Basic (medium security)
   - Default settings
   - Some restrictions
   Details: [Baseline Policy](https://kubernetes.io/docs/concepts/security/pod-security-standards/#baseline)
   
3. Production (very strict)
   - For production workloads
   - Maximum security
   Learn more: [Restricted Policy](https://kubernetes.io/docs/concepts/security/pod-security-standards/#restricted)

### Security Rules
```yaml
# Example of strict security rules
apiVersion: pod-security.kubernetes.io/v1
kind: PodSecurityPolicy
metadata:
  name: restricted
spec:
  privileged: false                # No special permissions
  allowPrivilegeEscalation: false # Can't get more permissions
  requiredDropCapabilities:
    - ALL
  volumes:                        # Only allowed storage types
    - 'configMap'
    - 'emptyDir'
    - 'persistentVolumeClaim'
  hostNetwork: false              # Can't use host network
  hostIPC: false                  # Can't use host IPC
  hostPID: false                  # Can't see host processes
  runAsUser:
    rule: 'MustRunAsNonRoot'     # No running as root
  seLinux:
    rule: 'RunAsAny'
  supplementalGroups:
    rule: 'MustRunAs'
    ranges:
      - min: 1
        max: 65535
  fsGroup:
    rule: 'MustRunAs'
    ranges:
      - min: 1
        max: 65535
```
More details: [Pod Security Policies](https://kubernetes.io/docs/concepts/security/pod-security-policy/)

### Container Safety
1. Checking for Problems
   - Uses Trivy to scan containers
   - Finds security problems
   - Enforces security rules
   Learn more: [Trivy Scanner](https://github.com/aquasecurity/trivy)

2. Runtime Protection
   - Uses Falco to watch for problems
   - Monitors container behavior
   - Alerts about suspicious activity
   Reference: [Falco Documentation](https://falco.org/docs/)

## Network Policies

### Default Block-All Policy
```yaml
# Blocks all traffic by default
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
```
More info: [Default Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)

### Traffic Rules
1. Internal Traffic:
   ```yaml
   # Allows specific internal communication
   apiVersion: networking.k8s.io/v1
   kind: NetworkPolicy
   metadata:
     name: allow-internal
   spec:
     podSelector:
       matchLabels:
         app: internal
     ingress:
     - from:
       - podSelector:
           matchLabels:
             app: frontend
       ports:
       - protocol: TCP
         port: 8080
   ```

2. External Access:
   ```yaml
   # Allows access from outside
   apiVersion: networking.k8s.io/v1
   kind: NetworkPolicy
   metadata:
     name: allow-external
   spec:
     podSelector:
       matchLabels:
         app: frontend
     ingress:
     - from: []
       ports:
       - protocol: TCP
         port: 443
   ```
   Learn more: [Network Policy Examples](https://kubernetes.io/docs/concepts/services-networking/network-policies/#networkpolicy-examples)

### Network Isolation
1. Separating Environments
   - Keeps development and production separate
   - Isolates different teams
   - Creates boundaries between services
   Reference: [Namespace Isolation](https://kubernetes.io/docs/concepts/services-networking/network-policies/#networkpolicy-resource)

2. Zero-Trust Setup
   - Only allows specifically allowed traffic
   - Uses service identity for access
   - Monitors all network activity
   Details: [Zero Trust Networks](https://kubernetes.io/docs/concepts/services-networking/network-policies/#default-deny-all-ingress-and-all-egress-traffic)

## Hands-on Session: Basic Cluster Operations and Helm Fundamentals

In this hands-on session, we'll cover basic cluster operations and Helm fundamentals. Follow these steps:

1. **Install Helm**:
   - Download and install Helm: [Installation Guide](https://helm.sh/docs/intro/install/)
   - Initialize Helm: `helm init`

2. **Create a Helm Chart**:
   - Create a new Helm chart using the following command:
     ```sh
     helm create mychart
     ```

3. **Deploy the Helm Chart**:
   - Deploy the Helm chart to your cluster:
     ```sh
     helm install mychart --name myrelease
     ```

4. **Verify the Deployment**:
   - Check the status of the release:
     ```sh
     helm status myrelease
     ```

5. **Upgrade the Release**:
   - Make changes to the Helm chart and upgrade the release:
     ```sh
     helm upgrade myrelease mychart
     ```

6. **Rollback the Release**:
   - Rollback to a previous release if needed:
     ```sh
     helm rollback myrelease 1
     ```

Congratulations! You've successfully completed basic cluster operations and Helm fundamentals.
