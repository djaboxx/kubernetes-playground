# Prometheus Stack

## What is the Prometheus Stack?

The Prometheus Stack includes Prometheus, Grafana, and Alert Manager. These tools help monitor the cluster, visualize data, and send alerts. Prometheus collects and stores metrics, Grafana provides dashboards for visualization, and Alert Manager handles alerting based on the metrics.

## Best Practices

1. **Set up dashboards:** Use Grafana to create dashboards that visualize the metrics collected by Prometheus.
2. **Configure alerts:** Set up Alert Manager to send alerts based on specific conditions, such as high CPU usage or low memory.
3. **Monitor key metrics:** Focus on monitoring key metrics that are critical to the health and performance of your applications and cluster.

## Security Concerns

1. **Secure access:** Ensure that access to Prometheus, Grafana, and Alert Manager is restricted to authorized users.
2. **Encrypt data:** Use HTTPS to encrypt data transmitted between Prometheus, Grafana, and Alert Manager.
3. **Regularly update:** Keep Prometheus, Grafana, and Alert Manager up to date to benefit from the latest security patches and features.

## How to Deploy the Prometheus Stack with Terraform

1. **Install Terraform:** Make sure you have Terraform installed on your machine. You can download it from [Terraform's website](https://www.terraform.io/downloads).
2. **Create a Terraform configuration file:** Create a file named `main.tf` and add the following configuration:

```hcl
provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "kubernetes_deployment" "prometheus" {
  metadata {
    name      = "prometheus"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "prometheus"
      }
    }

    template {
      metadata {
        labels = {
          app = "prometheus"
        }
      }

      spec {
        container {
          name  = "prometheus"
          image = "prom/prometheus:v2.26.0"

          port {
            container_port = 9090
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "grafana" {
  metadata {
    name      = "grafana"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "grafana"
      }
    }

    template {
      metadata {
        labels = {
          app = "grafana"
        }
      }

      spec {
        container {
          name  = "grafana"
          image = "grafana/grafana:7.5.0"

          port {
            container_port = 3000
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "alertmanager" {
  metadata {
    name      = "alertmanager"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "alertmanager"
      }
    }

    template {
      metadata {
        labels = {
          app = "alertmanager"
        }
      }

      spec {
        container {
          name  = "alertmanager"
          image = "prom/alertmanager:v0.21.0"

          port {
            container_port = 9093
          }
        }
      }
    }
  }
}
```

3. **Apply the configuration:** Run the following command to apply the configuration and deploy the Prometheus Stack:

```sh
terraform init
terraform apply
```

This will create a namespace for monitoring and deploy Prometheus, Grafana, and Alert Manager in your Kubernetes cluster.
