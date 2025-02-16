# Ingress NGINX Controller

## Overview
The NGINX Ingress Controller is a Kubernetes ingress controller using NGINX as a reverse proxy and load balancer. It provides HTTP and HTTPS routing, SSL termination, and advanced traffic management features.

## Features
- HTTP/HTTPS routing
- Load balancing
- SSL/TLS termination
- Path-based routing
- Host-based routing
- Rate limiting
- Authentication
- WebSocket support

## Installation

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install ingress-nginx ingress-nginx/ingress-nginx
```

## Core Concepts
1. **Ingress Resource**: Kubernetes API object defining routing rules
2. **Ingress Controller**: NGINX implementation that enforces rules
3. **Service**: Backend services receiving traffic
4. **ConfigMap**: NGINX configuration customization

## Configuration Examples

1. **Basic Ingress Resource**
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

2. **SSL/TLS Configuration**
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: tls-example-ingress
spec:
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

## Best Practices
1. **Security**
   - Enable SSL/TLS
   - Configure secure headers
   - Implement rate limiting
   - Use authentication where needed

2. **Performance**
   - Configure worker processes
   - Enable keepalive connections
   - Optimize proxy buffers
   - Configure proper timeouts

3. **Monitoring**
   - Enable metrics
   - Monitor error rates
   - Track latency
   - Set up alerts

## Common Annotations
```yaml
nginx.ingress.kubernetes.io/proxy-body-size: "10m"
nginx.ingress.kubernetes.io/proxy-connect-timeout: "30"
nginx.ingress.kubernetes.io/proxy-send-timeout: "300"
nginx.ingress.kubernetes.io/proxy-read-timeout: "300"
nginx.ingress.kubernetes.io/proxy-buffer-size: "8k"
nginx.ingress.kubernetes.io/ssl-redirect: "true"
```

## Troubleshooting
1. **Common Issues**
   - 502 Bad Gateway
   - SSL certificate problems
   - Path routing issues
   - Backend connectivity

2. **Debug Commands**
```bash
kubectl get ingress
kubectl describe ingress <name>
kubectl logs -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx
kubectl get events --field-selector type=Warning
```

## Additional Resources
- [Official Documentation](https://kubernetes.github.io/ingress-nginx/)
- [Configuration Guide](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/)
- [Annotations Reference](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations/)