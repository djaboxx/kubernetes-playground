# ArgoCD Repository Templates

This directory contains template files used by the ArgoCD repository module to set up consistent GitOps workflows.

## Template Files

### ci.yml.tpl
Configures a GitHub Actions workflow for continuous integration that:
- Validates Kubernetes manifests using kubectl dry-run and kubeconform
- Is triggered on pushes to main and pull requests
- Uses pinned versions of GitHub Actions for security

### release.yml.tpl
Configures a GitHub Actions workflow for automated releases that:
- Triggers on version tags (v*)
- Generates changelog from git history
- Creates GitHub releases with proper permissions
- Uses GitHub's release action with pinned version

### application.yaml.tpl
ArgoCD Application manifest template that expects:
- `${repository_name}` - Name of the repository/application
- `${repository_url}` - Git repository URL
Configures:
- Automatic sync with pruning and self-healing
- Namespace creation
- Resource finalizers
- 10 revision history limit

### gitignore.tpl
Comprehensive .gitignore template for Kubernetes/GitOps repositories that excludes:
- Kubernetes configs and secrets
- Helm chart dependencies
- Terraform state and variables
- IDE files
- Common OS and temp files

## Usage

These templates are automatically rendered by the module using Terraform's templatefile function. Required variables are validated in the module's variables.tf.