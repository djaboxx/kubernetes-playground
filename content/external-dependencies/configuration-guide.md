# External Dependency Configuration Guide

## ArgoCD Configuration

### High Availability Setup
```yaml
# Best practice configuration for HA
apiVersion: argoproj.io/v1alpha1
kind: ArgoCD
metadata:
  name: argocd
spec:
  ha:
    enabled: true
  redis:
    ha:
      enabled: true
  controller:
    replicas: 2
  server:
    replicas: 3
    env:
    - name: ARGOCD_API_SERVER_REPLICAS
      value: "3"
```

### RBAC Configuration
```yaml
# Project-based RBAC
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: restricted-project
spec:
  sourceRepos:
    - 'https://github.com/yourorg/*'
  destinations:
    - namespace: 'restricted-*'
      server: 'https://kubernetes.default.svc'
  roles:
    - name: developer
      policies:
        - p, proj:restricted-project:developer, applications, get, restricted-project/*, allow
        - p, proj:restricted-project:developer, applications, sync, restricted-project/*, allow
```

## Cert-Manager Setup

### ClusterIssuer Configuration
```yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: letsencrypt-prod-account-key
    solvers:
    - http01:
        ingress:
          class: nginx
```

### Certificate Monitoring
```yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: cert-manager-alerts
spec:
  groups:
  - name: certificate
    rules:
    - alert: CertificateExpiringSoon
      expr: certmanager_certificate_expiration_timestamp_seconds - time() < 604800
      labels:
        severity: warning
      annotations:
        message: Certificate is expiring in less than 7 days
```

## External DNS Configuration

### Provider Setup
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: external-dns
spec:
  template:
    spec:
      containers:
      - name: external-dns
        args:
        - --source=service
        - --source=ingress
        - --provider=google
        - --registry=txt
        - --txt-owner-id=my-cluster
        - --policy=sync
        - --interval=1m
```

### Rate Limiting
```yaml
spec:
  template:
    spec:
      containers:
      - name: external-dns
        env:
        - name: EXTERNAL_DNS_PROVIDER_API_RETRIES
          value: "3"
        - name: EXTERNAL_DNS_REGISTRY_INTERVAL
          value: "10m"
```

## Authentication Provider Integration

### OAuth2 Proxy Configuration
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: oauth2-proxy
spec:
  template:
    spec:
      containers:
      - name: oauth2-proxy
        args:
        - --provider=github
        - --email-domain=*
        - --upstream=file:///dev/null
        - --http-address=0.0.0.0:4180
        - --cookie-secure=true
        - --cookie-samesite=lax
        env:
        - name: OAUTH2_PROXY_CLIENT_ID
          valueFrom:
            secretKeyRef:
              name: oauth-secrets
              key: client-id
        - name: OAUTH2_PROXY_CLIENT_SECRET
          valueFrom:
            secretKeyRef:
              name: oauth-secrets
              key: client-secret
        - name: OAUTH2_PROXY_COOKIE_SECRET
          valueFrom:
            secretKeyRef:
              name: oauth-secrets
              key: cookie-secret
```

### Session Management
```yaml
spec:
  template:
    spec:
      containers:
      - name: oauth2-proxy
        args:
        - --session-store-type=redis
        - --redis-connection-url=redis://redis:6379
        - --session-lifetime=8h
        - --cookie-refresh=4h
```

## Important Notes

1. Secret Management
   - Always use Kubernetes secrets for sensitive data
   - Consider using external secret management (HashiCorp Vault, AWS Secrets Manager)
   - Implement proper secret rotation

2. Monitoring
   - Set up Prometheus rules for all components
   - Configure proper alerting
   - Implement comprehensive logging

3. Network Policies
   - Implement strict network policies
   - Use proper ingress/egress rules
   - Configure proper security contexts