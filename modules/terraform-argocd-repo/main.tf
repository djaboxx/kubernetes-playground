terraform {
  required_providers {
    argocd = {
      source  = "oboukili/argocd"
      version = "~> 5.0"
    }
  }
}

locals {
  default_files = [
    {
      path = ".github/workflows/ci.yml"
      content = templatefile("${path.module}/templates/ci.yml.tpl", {})
    },
    {
      path = ".github/workflows/release.yml" 
      content = templatefile("${path.module}/templates/release.yml.tpl", {})
    },
    {
      path = ".gitignore"
      content = templatefile("${path.module}/templates/gitignore.tpl", {})
    }
  ]

  # Merge default files with any user-provided files
  managed_extra_files = concat(local.default_files, var.managed_extra_files)
}

# Create the GitHub repository using the terraform-github-repo module
module "github_repo" {
  source  = "HappyPathway/repo/github"

  name                                   = var.repository_name
  repo_org                              = var.repo_org
  github_codeowners_team                = var.github_codeowners_team
  github_repo_description               = var.github_repo_description
  github_repo_topics                    = var.github_repo_topics
  github_push_restrictions              = var.github_push_restrictions
  github_is_private                     = var.github_is_private
  github_auto_init                      = var.github_auto_init
  github_allow_merge_commit             = var.github_allow_merge_commit
  github_allow_squash_merge             = var.github_allow_squash_merge
  github_allow_rebase_merge             = var.github_allow_rebase_merge
  github_delete_branch_on_merge         = var.github_delete_branch_on_merge
  github_has_projects                   = var.github_has_projects
  github_has_issues                     = var.github_has_issues
  github_has_wiki                       = var.github_has_wiki
  github_default_branch                 = var.github_default_branch
  github_required_approving_review_count = var.github_required_approving_review_count
  github_require_code_owner_reviews     = var.github_require_code_owner_reviews
  github_dismiss_stale_reviews          = var.github_dismiss_stale_reviews
  github_enforce_admins_branch_protection = var.github_enforce_admins_branch_protection
  additional_codeowners                 = var.additional_codeowners
  prefix                                = var.prefix
  force_name                            = var.force_name
  github_org_teams                      = var.github_org_teams
  template_repo_org                     = var.template_repo_org
  template_repo                         = var.template_repo
  is_template                           = var.is_template
  admin_teams                           = var.admin_teams
  required_status_checks                = var.required_status_checks
  archived                              = var.archived
  secrets                               = var.secrets
  vars                                  = var.vars
  extra_files                           = var.extra_files
  managed_extra_files                   = local.managed_extra_files
  pull_request_bypassers                = var.pull_request_bypassers
  create_codeowners                     = var.create_codeowners
  enforce_prs                           = var.enforce_prs
  collaborators                         = var.collaborators
  archive_on_destroy                    = var.archive_on_destroy
  vulnerability_alerts                  = var.vulnerability_alerts
  gitignore_template                    = var.gitignore_template
  homepage_url                          = var.homepage_url
  security_and_analysis                 = var.security_and_analysis
}

# Configure the repository in ArgoCD 
resource "argocd_repository" "repo" {
  repo = module.github_repo.http_clone_url
  name = var.repository_name
  type = "git"

  insecure              = var.repository_insecure  
  username              = var.repository_auth.username
  password              = var.repository_auth.password
  ssh_private_key       = var.repository_auth.ssh_private_key

  depends_on = [module.github_repo]
}

# Create ArgoCD Application to manage this repository
resource "argocd_application" "app" {
  metadata {
    name      = var.repository_name
    namespace = "argocd"
  }

  spec {
    project = var.argocd_project_name

    source {
      repo_url        = argocd_repository.repo.repo
      path            = var.path
      target_revision = var.target_revision

      directory {
        recurse = true
      }
    }

    destination {
      server    = var.destination_server
      namespace = var.destination_namespace
    }

    sync_policy {
      automated {
        prune       = true
        self_heal   = true
        allow_empty = true
      }

      sync_options = [
        "CreateNamespace=true",
        "PrunePropagationPolicy=foreground",
        "PruneLast=true"
      ]
    }
  }
}