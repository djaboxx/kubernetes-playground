# Terraform Argo CD Module

This Terraform module installs and configures Argo CD on a Kubernetes cluster using the official Helm chart.

## Features

- Configurable Argo CD components (server, controller, repo server, Redis, Dex)
- Ingress support with TLS
- Resource management for all components
- RBAC configuration
- SSO integration via Dex
- ApplicationSet controller support

## Usage

```hcl
module "argocd" {
  source = "path/to/terraform-k8s-argocd"

  namespace      = "argocd"
  chart_version  = "5.46.7"  # Specify the Argo CD chart version
  admin_password = "my-secure-password"

  # Enable ingress
  ingress_enabled = true
  ingress_hosts   = ["argocd.example.com"]
  ingress_annotations = {
    "kubernetes.io/ingress.class" = "nginx"
  }

  # Configure high availability
  controller_replicas = 2
  repo_server_replicas = 2
  
  # Resource requests and limits
  controller_resources = {
    limits = {
      cpu    = "1000m"
      memory = "1Gi"
    }
    requests = {
      cpu    = "500m"
      memory = "512Mi"
    }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| helm | ~> 2.0 |
| kubernetes | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| helm | ~> 2.0 |
| kubernetes | ~> 2.0 |

## Resources

| Name | Type |
|------|------|
| kubernetes_namespace.argocd | resource |
| helm_release.argocd | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| namespace | Namespace to install Argo CD | string | "argocd" | no |
| namespace_labels | Labels to add to the Argo CD namespace | map(string) | {} | no |
| release_name | Helm release name | string | "argocd" | no |
| chart_version | Version of the Argo CD Helm chart | string | n/a | yes |
| admin_password | Admin password for Argo CD | string | n/a | yes |
| server_extra_args | List of extra arguments for the Argo CD server | list(string) | ["--insecure"] | no |
| service_type | Service type for the Argo CD server | string | "ClusterIP" | no |
| ingress_enabled | Enable ingress for the Argo CD server | bool | false | no |
| ingress_hosts | List of hosts for the Argo CD ingress | list(string) | [] | no |
| ingress_annotations | Annotations to add to the Argo CD ingress | map(string) | {} | no |
| ingress_tls | TLS configuration for the Argo CD ingress | any | [] | no |
| controller_replicas | Number of application controller replicas | number | 1 | no |
| repo_server_replicas | Number of repo server replicas | number | 1 | no |
| applicationset_enabled | Enable ApplicationSet controller | bool | true | no |
| redis_enabled | Enable Redis | bool | true | no |
| dex_enabled | Enable dex for SSO | bool | true | no |

For more detailed information about the inputs, refer to the [variables.tf](./variables.tf) file.

## Outputs

| Name | Description |
|------|-------------|
| namespace | The namespace where Argo CD is installed |
| server_service_name | The name of the Argo CD server service |
| server_service_port | The port of the Argo CD server service |
| admin_password | The admin password for Argo CD |
| helm_release_metadata | Helm release metadata |

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This module is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.