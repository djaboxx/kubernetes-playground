terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

locals {
  values = [
    # Default values
    yamlencode({
      global = {
        image = {
          registry = var.global_image_registry
          tag = var.global_image_tag
        }
      }
      configs = {
        cm = var.configs_cm
        rbac = var.configs_rbac
        ssh = var.configs_ssh
        tls = var.configs_tls
        repositories = var.configs_repositories
        repositoryCredentials = var.configs_repository_credentials
        secret = {
          argocdServerAdminPassword = var.admin_password
          createSecret = var.create_secret
        }
      }
      server = {
        replicas = var.replica_count
        extraArgs = var.server_extra_args
        env = var.env
        initContainers = var.init_containers
        service = {
          type = var.service_type
          annotations = var.service_annotations
        }
        ingress = {
          enabled = var.ingress_enabled
          hosts = var.ingress_hosts
          annotations = var.ingress_annotations
          tls = var.ingress_tls
        }
        route = {
          enabled = var.server_route_enabled
        }
        metrics = {
          enabled = var.server_metrics_enabled
        }
        autoscaling = {
          enabled = var.server_autoscaling_enabled
          minReplicas = var.server_autoscaling_min_replicas
          maxReplicas = var.server_autoscaling_max_replicas
        }
        volumeMounts = var.volume_mounts
        volumes = var.volumes
        nodeSelector = var.node_selector
        tolerations = var.tolerations
        affinity = var.affinity
      }
      repoServer = {
        replicas = var.repo_server_replicas
        resources = var.repo_server_resources
        metrics = {
          enabled = var.repoServer_metrics_enabled
        }
        autoscaling = {
          enabled = var.repoServer_autoscaling_enabled
          minReplicas = var.repoServer_autoscaling_min_replicas
          maxReplicas = var.repoServer_autoscaling_max_replicas
        }
      }
      applicationSet = {
        enabled = var.applicationset_enabled
        replicas = var.applicationset_replicas
        metrics = {
          enabled = var.applicationSet_metrics_enabled
        }
      }
      redis = {
        enabled = var.redis_enabled
        resources = var.redis_resources
      }
      controller = {
        replicas = var.ha_enabled ? 2 : var.controller_replicas
        resources = var.controller_resources
      }
      dex = {
        enabled = var.dex_enabled
        resources = var.dex_resources
      }
      notifications = {
        enabled = var.notifications_enabled
      }
      plugins = var.plugins
      extraObjects = var.extra_objects
    }),
    # Additional values from values_object if provided
    var.values_object != null ? yamlencode(var.values_object) : "",
    # Additional values from helm_values if provided
    var.helm_values
  ]
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.namespace
    labels = var.namespace_labels
  }
}

resource "helm_release" "argocd" {
  name       = var.release_name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.chart_version
  namespace  = kubernetes_namespace.argocd.metadata[0].name

  values = concat(
    [for v in local.values : v if v != ""],
    [for file in var.helm_value_files : file("${file}")]
  )

  # Additional Helm settings
  skip_crds              = var.skip_crds
  pass_credentials       = var.pass_credentials
  verify                 = !var.skip_schema_validation
  
  dynamic "set" {
    for_each = var.extra_set_values
    content {
      name  = set.value.name
      value = set.value.value
      type  = set.value.type
    }
  }

  depends_on = [kubernetes_namespace.argocd]
}