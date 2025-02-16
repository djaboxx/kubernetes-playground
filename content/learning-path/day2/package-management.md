# Package Management with Helm

This guide explains how to use Helm to package and manage your Kubernetes applications. We'll cover how to organize your packages, create reusable templates, and manage different versions.

## Understanding Helm Charts

### Basic Chart Structure
A Helm chart is like a recipe book for your application. Here's how to organize it:

```text
mychart/                  # Your chart's main folder
  ├── Chart.yaml         # Information about your chart
  ├── values.yaml        # Default settings
  ├── values-prod.yaml   # Production settings
  ├── values-staging.yaml# Staging settings
  ├── templates/         # Where your recipes live
  │   ├── NOTES.txt     # Instructions for users
  │   ├── _helpers.tpl  # Reusable snippets
  │   ├── deployment.yaml# How to run your app
  │   ├── service.yaml  # How to connect to your app
  │   ├── ingress.yaml  # How to access from outside
  │   └── configmap.yaml# Settings for your app
  └── charts/           # Other recipes you need
      └── dependencies/ # Other charts you depend on
```
Learn more: [Chart File Structure](https://helm.sh/docs/topics/charts/#the-chart-file-structure)

### Chart Information
Tell Helm about your chart:

```yaml
# Chart.yaml - Think of this as your recipe book's cover
apiVersion: v2
name: my-application
description: A Helm chart for my application
type: application
version: 0.1.0           # Your recipe book version
appVersion: "1.16.0"     # Your application version

# Things your recipe needs
dependencies:
  - name: redis
    version: "12.7.4"
    repository: "https://charts.bitnami.com/bitnami"
    condition: redis.enabled

# Who maintains this
maintainers:
  - name: DevOps Team
    email: devops@company.com
```
Reference: [Chart.yaml Guide](https://helm.sh/docs/topics/charts/#the-chartyaml-file)

### Managing Settings
Different settings for different situations:

1. Default Settings (values.yaml):
```yaml
# Basic settings that work for most cases
replicaCount: 1
image:
  repository: nginx    # What program to run
  tag: "1.16.0"       # Which version
  pullPolicy: IfNotPresent
service:
  type: ClusterIP     # Internal access only
  port: 80
ingress:
  enabled: false      # No external access
```

2. Production Settings (values-prod.yaml):
```yaml
# Settings for production use
replicaCount: 3                # Run more copies
resources:                     # Give more resources
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: 200m
    memory: 256Mi
monitoring:
  enabled: true               # Turn on monitoring
```
More info: [Values Files](https://helm.sh/docs/chart_template_guide/values_files/)

## Creating Charts

### Helper Functions
Make your templates easier to maintain:

```yaml
{{/* This creates standard labels */}}
{{- define "mychart.labels" -}}
app.kubernetes.io/name: {{ include "mychart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
```
Learn more: [Named Templates](https://helm.sh/docs/chart_template_guide/named_templates/)

### Application Template
A basic template for running your application:

```yaml
# templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "mychart.fullname" . }}
  labels:                                # Use our standard labels
    {{- include "mychart.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.replicaCount }}   # How many copies to run
  selector:
    matchLabels:
      {{- include "mychart.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "mychart.selectorLabels" . | nindent 8 }}
    spec:
      containers:
        - name: {{ .Chart.Name }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            - containerPort: {{ .Values.service.port }}
              protocol: TCP
```
Reference: [Template Guide](https://helm.sh/docs/chart_template_guide/getting_started/)

### Testing Your Charts
Make sure your charts work correctly:

1. Basic Tests:
```yaml
# templates/tests/test-connection.yaml
apiVersion: v1
kind: Pod
metadata:
  name: "{{ include "mychart.fullname" . }}-test-connection"
  annotations:
    "helm.sh/hook": test        # Run this as a test
spec:
  containers:
    - name: wget
      image: busybox           # Simple testing container
      command: ['wget']
      args: ['{{ include "mychart.fullname" . }}:{{ .Values.service.port }}']
  restartPolicy: Never         # Only try once
```

2. Automated Testing:
```yaml
# .github/workflows/helm-test.yaml
name: Helm Chart Test
on: [push, pull_request]       # When to test
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Check chart formatting
        run: helm lint ./charts/*
      - name: Make sure templates work
        run: |
          for chart in ./charts/*; do
            helm template "$chart"
          done
```
More details: [Chart Tests](https://helm.sh/docs/topics/chart_tests/)

## Version Control

### Version Numbers
Use clear version numbers:

```yaml
# Chart.yaml
version: 1.2.3  # MAJOR.MINOR.PATCH
appVersion: "2.0.0"  # Your program version
```
Reference: [Semantic Versioning](https://helm.sh/docs/topics/charts/#charts-and-versioning)

### Updating Versions
Script to update versions safely:

```bash
#!/bin/bash
# update-version.sh
CHART_PATH=$1
NEW_VERSION=$2

# Update the version number
sed -i "s/^version:.*/version: ${NEW_VERSION}/" "${CHART_PATH}/Chart.yaml"

# Update any dependencies
helm dependency update "${CHART_PATH}"
```

### Publishing Charts
Automatically share your charts:

```yaml
name: Release Charts         # Share new versions
on:
  push:
    branches:
      - main               # When merged to main
    paths:
      - 'charts/**'       # When charts change
jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - name: Package and Release
        run: |
          helm package charts/*
          helm repo index .
```
Learn more: [Chart Repositories](https://helm.sh/docs/topics/chart_repository/)

## Managing Custom Resources (CRDs)

### Installation Order
Keep your custom resources organized:

```yaml
# crds/
│── 01-namespace.yaml        # Create spaces first
│── 02-serviceaccount.yaml   # Then security
│── 03-role.yaml            # Then permissions
│── 04-rolebinding.yaml     # Then connections
└── 05-customresource.yaml  # Then custom things
```

### Protecting Resources
Keep important things safe:

```yaml
# Add this to prevent deletion
annotations:
  "helm.sh/resource-policy": keep
```

### Cleanup Jobs
Clean up safely when removing:

```yaml
# templates/cleanup-hook.yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ include "mychart.fullname" . }}-cleanup
  annotations:
    "helm.sh/hook": pre-delete        # Run before deletion
    "helm.sh/hook-delete-policy": hook-succeeded
spec:
  template:
    spec:
      containers:
        - name: cleanup
          image: bitnami/kubectl
          command: ['kubectl', 'delete', 'mycrd', '--all']
      restartPolicy: Never
```
Reference: [Helm Hooks](https://helm.sh/docs/topics/charts_hooks/)

## Additional Resources

### Official Documentation
- [Helm Documentation](https://helm.sh/docs/)
- [Chart Best Practices](https://helm.sh/docs/chart_best_practices/)
- [Template Guide](https://helm.sh/docs/chart_template_guide/)

### Useful Tools
- [Helm Plugin Directory](https://helm.sh/docs/community/related/)
- [Chart Testing](https://github.com/helm/chart-testing)
- [Chart Museum](https://chartmuseum.com/)