# ArgoCD GitHub Repository Module

This Terraform module creates a GitHub repository using the [HappyPathway/repo/github](https://registry.terraform.io/modules/HappyPathway/repo/github/latest) module and configures it in ArgoCD for GitOps management.

## Features

- Creates a new GitHub repository
- Configures the repository in ArgoCD automatically
- Supports multiple authentication methods:
  - Username/password
  - SSH private key
- Configurable repository visibility and initialization

## Usage

```hcl
module "gitops_repo" {
  source = "./modules/argocd-repos"

  repository_name        = "my-gitops-repo"
  repository_description = "Repository for GitOps configurations"
  repository_visibility  = "private"
  repository_auto_init   = true

  # ArgoCD authentication (using SSH key)
  repository_auth = {
    ssh_private_key = file("~/.ssh/argocd_repo_key")
  }
}

# Using HTTPS with username/password or token
module "gitops_repo_https" {
  source = "./modules/argocd-repos"

  repository_name        = "my-gitops-repo"
  repository_description = "Repository for GitOps configurations"
  
  repository_auth = {
    username = "git-user"
    password = "personal-access-token"
  }
}
```

## Requirements

- ArgoCD must be installed and configured in your cluster
- GitHub credentials/token must be configured for the HappyPathway/repo/github module
- ArgoCD provider must be configured with proper authentication

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| repository_name | Name of the GitHub repository to create | string | - | yes |
| repository_description | Description of the GitHub repository | string | "" | no |
| repository_visibility | Visibility of the GitHub repository (public, private, internal) | string | "private" | no |
| repository_auto_init | Whether to initialize the repository with a README | bool | true | no |
| repository_auth | Authentication details for ArgoCD to access the repository | object | {} | no |
| repository_insecure | Allow insecure server connections when using HTTPS | bool | false | no |

## Outputs

| Name | Description |
|------|-------------|
| repository_url | Git clone URL of the created repository |
| repository_id | ArgoCD repository ID |
| repository_name | Name of the created repository |

## Notes

- The module assumes you have proper permissions to create repositories in the target GitHub organization/account
- Make sure to handle sensitive values (tokens, SSH keys) securely using Terraform's sensitive value handling
- Consider using GitHub Apps or SSH keys for authentication instead of personal access tokens for better security