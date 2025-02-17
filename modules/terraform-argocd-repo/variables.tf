variable "repository_name" {
  description = "Name of the terraform workspace and optionally github repo"
  type        = string
}

variable "repo_org" {
  description = "GitHub organization where the repository will be created"
  type        = string
  default     = null
}

variable "github_codeowners_team" {
  description = "Team that should be set as code owners"
  type        = string
  default     = "terraform-reviewers"
}

variable "github_repo_description" {
  description = "Description of the GitHub repository"
  type        = string
  default     = null
}

variable "github_repo_topics" {
  description = "Github Repo Topics"
  type        = list(any)
  default     = []
}

variable "github_push_restrictions" {
  description = "Github Push Restrictions"
  type        = list(any)
  default     = []
}

variable "github_is_private" {
  description = "Whether the repository should be private"
  type        = bool
  default     = true
}

variable "github_auto_init" {
  description = "Whether to auto-initialize the repository"
  type        = bool
  default     = true
}

variable "github_allow_merge_commit" {
  description = "Whether to allow merge commits"
  type        = bool
  default     = false
}

variable "github_allow_squash_merge" {
  description = "Whether to allow squash merging"
  type        = bool
  default     = true
}

variable "github_allow_rebase_merge" {
  description = "Whether to allow rebase merging"
  type        = bool
  default     = false
}

variable "github_delete_branch_on_merge" {
  description = "Whether to delete head branches when pull requests are merged"
  type        = bool
  default     = true
}

variable "github_has_projects" {
  description = "Whether to enable projects for the repository"
  type        = bool
  default     = true
}

variable "github_has_issues" {
  description = "Whether to enable issues for the repository"
  type        = bool
  default     = false
}

variable "github_has_wiki" {
  description = "Whether to enable wiki for the repository"
  type        = bool
  default     = true
}

variable "github_default_branch" {
  description = "The default branch for the repository"
  type        = string
  default     = "main"
}

variable "github_required_approving_review_count" {
  description = "Number of approvals required for pull requests"
  type        = number
  default     = 1
}

variable "github_require_code_owner_reviews" {
  description = "Whether to require code owner reviews"
  type        = bool
  default     = true
}

variable "github_dismiss_stale_reviews" {
  description = "Whether to dismiss stale pull request approvals when new commits are pushed"
  type        = bool
  default     = true
}

variable "github_enforce_admins_branch_protection" {
  description = "Whether to enforce branch protection rules for repository administrators"
  type        = bool
  default     = true
}

variable "additional_codeowners" {
  description = "Additional teams to be added as code owners"
  type        = list(any)
  default     = []
}

variable "prefix" {
  description = "Prefix to be added to the repository name"
  type        = string
  default     = null
}

variable "force_name" {
  description = "Force naming of repo. If forced, archive management will not operate on this repo"
  type        = bool
  default     = false
}

variable "github_org_teams" {
  description = "List of teams so that module does not need to look them up"
  type        = list(any)
  default     = null
}

variable "template_repo_org" {
  description = "Organization containing the template repository"
  type        = string
  default     = null
}

variable "template_repo" {
  description = "Name of the template repository"
  type        = string
  default     = null
}

variable "is_template" {
  description = "Whether this repository is a template"
  type        = bool
  default     = false
}

variable "admin_teams" {
  description = "Teams that should have admin access to the repository"
  type        = list(any)
  default     = []
}

variable "required_status_checks" {
  description = "Required status checks for protected branches"
  type = object({
    contexts = list(string)
    strict   = optional(bool, false)
  })
  default = null
}

variable "archived" {
  description = "Whether the repository should be archived"
  type        = bool
  default     = false
}

variable "secrets" {
  description = "GitHub Action Secrets"
  type = list(object({
    name  = string,
    value = string
  }))
  default = []
}

variable "vars" {
  description = "GitHub Action Variables"
  type = list(object({
    name  = string,
    value = string
  }))
  default = []
}

variable "extra_files" {
  description = "Extra files to be added to the repository"
  type = list(object({
    path    = string,
    content = string
  }))
  default = []
}

variable "managed_extra_files" {
  description = "Managed extra files - changes to content will be updated"
  type = list(object({
    path    = string,
    content = string
  }))
  default = []
}

variable "pull_request_bypassers" {
  description = "List of users/teams that can bypass pull request requirements"
  type        = list(any)
  default     = []
}

variable "create_codeowners" {
  description = "Whether to create CODEOWNERS file"
  type        = bool
  default     = true
}

variable "enforce_prs" {
  description = "Whether to enforce pull request reviews"
  type        = bool
  default     = true
}

variable "collaborators" {
  description = "Map of repository collaborators and their permissions"
  type        = map(string)
  default     = {}
}

variable "archive_on_destroy" {
  description = "Whether to archive the repository when it is destroyed"
  type        = bool
  default     = true
}

variable "vulnerability_alerts" {
  description = "Whether to enable vulnerability alerts"
  type        = bool
  default     = false
}

variable "gitignore_template" {
  description = "Template for .gitignore file"
  type        = string
  default     = null
}

variable "homepage_url" {
  description = "URL of a page describing the project"
  type        = string
  default     = null
}

variable "security_and_analysis" {
  description = "Security and analysis settings for the repository"
  type = object({
    advanced_security = optional(object({
      status = string
    }), { status = "disabled" })
    secret_scanning = optional(object({
      status = string
    }), { status = "disabled" })
    secret_scanning_push_protection = optional(object({
      status = string
    }), { status = "disabled" })
  })
  default = {
    advanced_security = {
      status = "disabled"
    }
    secret_scanning = {
      status = "disabled"
    }
    secret_scanning_push_protection = {
      status = "disabled"
    }
  }
}

variable "repository_auth" {
  description = "Authentication configuration for ArgoCD to access the repository"
  type = object({
    username        = optional(string)
    password        = optional(string)
    ssh_private_key = optional(string)
  })
  default = {}

  validation {
    condition     = (var.repository_auth.username != null && var.repository_auth.password != null) || var.repository_auth.ssh_private_key != null || (var.repository_auth.username == null && var.repository_auth.password == null && var.repository_auth.ssh_private_key == null)
    error_message = "Either both username and password must be set, or ssh_private_key must be set, or neither."
  }
}

variable "repository_insecure" {
  description = "Whether to skip TLS verification for the repository"
  type        = bool
  default     = false
}