# Maintenance Procedures

This guide explains how to keep your Kubernetes cluster healthy and running smoothly. We'll cover backup procedures, updates, performance tuning, and cost management.

## Backup and Recovery

### Setting Up Backups
Velero is like an automatic save system for your cluster. Here's how to set it up:

```yaml
# velero-install.yaml - Basic backup settings that work for most teams
apiVersion: velero.io/v1
kind: Backup
metadata:
  name: daily-backup
  namespace: velero
spec:
  schedule: "0 1 * * *"    # Run at 1 AM every day
  template:
    includedNamespaces:    # What to save
      - "*"               # Everything except...
    excludedNamespaces:
      - kube-system      # System stuff (already backed up elsewhere)
    includeClusterResources: true   # Save cluster settings too
    storageLocation: default        # Where to save backups
    volumeSnapshotLocations:        # Where to save disk copies
      - default
    ttl: 720h                      # Keep for 30 days
```
Learn more: [Velero Backup Configuration](https://velero.io/docs/main/backup-configuration/)

### Recovery Steps
Two ways to recover when things go wrong:

1. Recovering Everything:
```bash
#!/bin/bash
# cluster-recovery.sh - Step by step recovery

# 1. First, make a new cluster
terraform apply -var-file=prod.tfvars

# 2. Install Velero with your cloud settings
velero install \
  --provider gcp \
  --plugins velero/velero-plugin-for-gcp:v1.4.0 \
  --bucket $BUCKET_NAME \
  --secret-file ./credentials-velero

# 3. Bring back your backup
velero restore create --from-backup latest
```

2. Recovering Just One Part:
```yaml
# Bring back just what you need
apiVersion: velero.io/v1
kind: Restore
metadata:
  name: namespace-restore
  namespace: velero
spec:
  backupName: daily-backup           # Which backup to use
  includedNamespaces:                # What to bring back
  - production
  restorePVs: true                  # Include disk data
```
Reference: [Velero Restore Guide](https://velero.io/docs/main/restore-reference/)

## Upgrading Kubernetes

### Version Updates
Safe way to upgrade your cluster:

```bash
#!/bin/bash
# k8s-upgrade.sh - Careful upgrade process

# 1. First upgrade the control plane
gcloud container clusters upgrade cluster-name \
  --master --cluster-version=1.25

# 2. Then upgrade each group of computers one at a time
for pool in $(gcloud container node-pools list --cluster cluster-name --format="value(name)")
do
  echo "Upgrading node pool: $pool"
  gcloud container clusters upgrade cluster-name \
    --node-pool=$pool \
    --cluster-version=1.25
done
```

### Checking Everything Works
Make sure nothing broke during the upgrade:

```yaml
# upgrade-validation.yaml - Tests after upgrade
apiVersion: batch/v1
kind: Job
metadata:
  name: upgrade-validation
spec:
  template:
    spec:
      containers:
      - name: validation
        image: bitnami/kubectl
        command: ["/bin/sh", "-c"]
        args:
        - |
          kubectl get nodes -o wide          # Check all computers
          kubectl get pods --all-namespaces  # Check all programs
          kubectl get deployments --all-namespaces  # Check all setups
      restartPolicy: Never
```
More details: [GKE Upgrade Guide](https://cloud.google.com/kubernetes-engine/docs/how-to/upgrading-a-cluster)

## Making Things Run Better

### Resource Management
1. Automatic Vertical Scaling (making programs bigger or smaller):
```yaml
# Let programs ask for what they need
apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
metadata:
  name: my-app-vpa
spec:
  targetRef:
    apiVersion: "apps/v1"
    kind: Deployment
    name: my-app
  updatePolicy:
    updateMode: "Auto"          # Change size automatically
  resourcePolicy:
    containerPolicies:
    - containerName: '*'        # For all containers
      minAllowed:              # Don't go smaller than
        cpu: 100m
        memory: 128Mi
      maxAllowed:              # Don't go bigger than
        cpu: 1
        memory: 1Gi
```

2. Automatic Horizontal Scaling (running more or fewer copies):
```yaml
# Add or remove copies based on usage
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: my-app-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: my-app
  minReplicas: 2              # Never fewer than 2
  maxReplicas: 10             # Never more than 10
  metrics:
  - type: Resource
    resource:
      name: cpu               # Watch CPU usage
      target:
        type: Utilization
        averageUtilization: 80
  - type: Resource
    resource:
      name: memory           # Watch memory usage
      target:
        type: Utilization
        averageUtilization: 80
```
Learn more: [Kubernetes Autoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/)

## Managing Costs

### Setting Limits
Control how much resources teams can use:

```yaml
# Example limits for a team
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-quota
  namespace: production
spec:
  hard:
    requests.cpu: "20"           # Can ask for 20 CPUs
    requests.memory: 40Gi        # Can ask for 40GB memory
    limits.cpu: "40"            # Can use up to 40 CPUs
    limits.memory: 80Gi         # Can use up to 80GB memory
    pods: "50"                  # Can run 50 programs
```

### Watching Costs
Set up cost monitoring:

```yaml
# cost-exporter.yaml - Track spending
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kubecost
  namespace: kubecost
spec:
  selector:
    matchLabels:
      app: kubecost
  template:
    metadata:
      labels:
        app: kubecost
    spec:
      containers:
      - name: cost-model
        image: kubecost/cost-model:latest
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 500m
            memory: 256Mi
```

### Cost Alerts
Get warned about high costs:

```yaml
# Set up spending alerts
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: cost-alerts
spec:
  groups:
  - name: costs
    rules:
    - alert: HighCostWarning           # Daily spending alert
      expr: |
        sum(
          rate(container_cpu_usage_seconds_total[24h]) * on(node) group_left()
          node_cpu_hourly_cost
        ) > 1000
      for: 6h
      labels:
        severity: warning
      annotations:
        description: Daily cost exceeds $1000
    
    - alert: BudgetExceeded           # Weekly spending alert
      expr: |
        sum(
          rate(container_cpu_usage_seconds_total[7d]) * on(node) group_left()
          node_cpu_hourly_cost
        ) > 5000
      for: 1d
      labels:
        severity: critical
      annotations:
        description: Weekly cost exceeds $5000
```
Reference: [KubeCost Documentation](https://guide.kubecost.com/)

## Additional Resources

### Official Guides
- [Velero Documentation](https://velero.io/docs/)
- [GKE Maintenance Guide](https://cloud.google.com/kubernetes-engine/docs/how-to/maintenance-window-overview)
- [Kubernetes Resource Management](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)
- [Cost Optimization Guide](https://cloud.google.com/architecture/framework/cost-optimization)

### Useful Tools
- [KubeCost](https://www.kubecost.com/)
- [GKE Usage Metering](https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-usage-metering)
- [Resource Quotas](https://kubernetes.io/docs/concepts/policy/resource-quotas/)