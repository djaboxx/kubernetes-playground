# Ingress NGINX

## Overview
Ingress NGINX is a Kubernetes ingress controller that manages access to services within a Kubernetes cluster. It routes external traffic to the appropriate services based on defined rules.

## Key Concepts
- **Ingress**: An API object that manages external access to services, typically HTTP.
- **Ingress Controller**: A daemon that watches the Kubernetes API server for Ingress resources and updates its configuration accordingly.

## Setting Up Ingress NGINX

### Install Ingress NGINX
To install Ingress NGINX, run the following command:
```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
```

### Create an Ingress Resource
To create an Ingress resource, use the following YAML configuration:
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

## Additional Details and Examples

### SSL/TLS Configuration
To enable SSL/TLS for your Ingress resource, use the following YAML configuration:
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
Apply the resource:
```sh
kubectl apply -f tls-ingress.yaml
```

### Annotations
Ingress NGINX supports various annotations to customize its behavior. Here are some common annotations:
```yaml
nginx.ingress.kubernetes.io/rewrite-target: "/"
nginx.ingress.kubernetes.io/ssl-redirect: "true"
nginx.ingress.kubernetes.io/proxy-body-size: "10m"
nginx.ingress.kubernetes.io/proxy-read-timeout: "60"
nginx.ingress.kubernetes.io/proxy-send-timeout: "60"
```

### Troubleshooting
If you encounter issues with Ingress NGINX, you can use the following commands to troubleshoot:
```sh
kubectl get ingress
kubectl describe ingress <name>
kubectl logs -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx
kubectl get events --field-selector type=Warning
```

## Links to External Documentation and Resources
- [Ingress NGINX Official Documentation](https://kubernetes.github.io/ingress-nginx/)
- [Kubernetes Ingress API Reference](https://kubernetes.io/docs/concepts/services-networking/ingress/)
- [Ingress NGINX Annotations](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations/)
