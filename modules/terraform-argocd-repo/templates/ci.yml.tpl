name: CI
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4

    - name: Install kubectl
      uses: azure/setup-kubectl@v3
      with:
        version: 'latest'

    - name: Setup kubeconform
      run: |
        wget -O kubeconform.tar.gz https://github.com/yannh/kubeconform/releases/latest/download/kubeconform-linux-amd64.tar.gz
        tar xf kubeconform.tar.gz
        sudo mv kubeconform /usr/local/bin/

    - name: Validate Kubernetes manifests
      run: |
        if [ -d kubernetes/ ]; then
          echo "Validating Kubernetes manifests..."
          # First try kubectl validation
          kubectl apply --dry-run=client -f kubernetes/ || exit 1
          
          # Then do schema validation with kubeconform
          kubeconform -summary kubernetes/
        else
          echo "No kubernetes/ directory found, skipping validation"
        fi

    - name: Validate ArgoCD Application manifest
      run: |
        if [ -f argocd/application.yaml ]; then
          echo "Validating ArgoCD Application manifest..."
          # Validate against ArgoCD CRD schema
          kubectl apply --dry-run=client -f argocd/application.yaml
          
          # Additional ArgoCD-specific validation
          if ! grep -q "resources-finalizer.argocd.argoproj.io" argocd/application.yaml; then
            echo "Warning: ArgoCD resource finalizer not found in application manifest"
          fi
        else
          echo "No argocd/application.yaml found, skipping validation"
        fi