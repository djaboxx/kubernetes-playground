# Ingress NGINX

## Overview

The NGINX Ingress Controller for Kubernetes provides HTTP and HTTPS routing to services within your Kubernetes cluster. It serves as an essential component for exposing your applications to the outside world.

## Features

- Layer 7 load balancing
- TLS/SSL termination
- Name-based virtual hosting
- Path-based routing
- Rate limiting
- SSL passthrough
- WebSocket support
- Multiple protocols support (HTTP, HTTPS, TCP, UDP)

## Installation

### Using Helm

```bash
# Add the ingress-nginx repository
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

# Install the ingress-nginx controller
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace
```

### Verification

```bash
# Check if the controller pod is running
kubectl get pods -n ingress-nginx

# Check the created services
kubectl get svc -n ingress-nginx
```

## Basic Configuration

### Simple HTTP Ingress

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: minimal-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - http:
      paths:
      - path: /testpath
        pathType: Prefix
        backend:
          service:
            name: test
            port:
              number: 80
```

### HTTPS Configuration with TLS

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: tls-example-ingress
spec:
  ingressClassName: nginx
  tls:
  - hosts:
      - example.com
    secretName: example-tls
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

## Common Annotations

Important annotations for customizing behavior:

```yaml
nginx.ingress.kubernetes.io/ssl-redirect: "true"
nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
nginx.ingress.kubernetes.io/ssl-passthrough: "true"
nginx.ingress.kubernetes.io/proxy-body-size: "8m"
nginx.ingress.kubernetes.io/proxy-connect-timeout: "15"
```

## Best Practices

1. Always enable TLS for production environments
2. Use rate limiting for public endpoints
3. Configure appropriate resource limits
4. Implement proper monitoring
5. Use separate ingress resources for different applications
6. Configure default backend for 404 handling

## Advanced Features

### SSL Passthrough
Useful for applications that handle their own TLS termination:

```yaml
metadata:
  annotations:
    nginx.ingress.kubernetes.io/ssl-passthrough: "true"
```

### Rate Limiting
Protect your services from overload:

```yaml
metadata:
  annotations:
    nginx.ingress.kubernetes.io/limit-rps: "10"
    nginx.ingress.kubernetes.io/limit-connections: "5"
```

### Rewrite Rules
Modify incoming requests:

```yaml
metadata:
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$2
spec:
  rules:
  - http:
      paths:
      - path: /api(/|$)(.*)
        pathType: Prefix
```

## Troubleshooting

Common issues and solutions:

1. 404 Errors
   - Check path configuration
   - Verify service and port names
   - Check backend service is running

2. SSL/TLS Issues
   - Verify certificate secret exists
   - Check TLS configuration
   - Validate certificate validity

3. Performance Issues
   - Monitor resource usage
   - Check for bottlenecks
   - Review rate limiting settings

## External Resources

- [Official Documentation](https://kubernetes.github.io/ingress-nginx/)
- [GitHub Repository](https://github.com/kubernetes/ingress-nginx)
- [Configuration Guide](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/)
- [Annotations List](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations/)

## Networking and Security Components
...content from 02-networking-security.md...