terraform_version_constraint  = ">= 1.0.4"
terragrunt_version_constraint = ">= 0.31.3"

locals {
  universal_config                        = yamldecode(file(find_in_parent_folders("universal-config.yml")))
  global_config                           = yamldecode(file("global-config.yml"))
  security_portal_global_operator_profile = local.global_config.security_portal_global_operator_profile
  security_portal_global_account_slug     = local.global_config.security_portal_global_account_slug
  security_portal_global_region           = local.global_config.security_portal_global_region

  disable_remote_state = tobool(get_env("TERRAGRUNT_DISABLE_REMOTE_STATE", "false"))
}

remote_state {
  disable_init = local.disable_remote_state

  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket         = "os-${local.security_portal_global_account_slug}-${local.security_portal_global_region}-terraform-state"
    dynamodb_table = "os-${local.security_portal_global_account_slug}-terraform-state-lock"
    profile        = local.security_portal_global_operator_profile
    region         = local.security_portal_global_region
    encrypt        = true

    key = "${local.security_portal_global_account_slug}/${path_relative_to_include()}/terraform.tfstate"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
  provider "aws" {
    region  = "us-west-2"
    profile = "security-portal-global-ops"
  }
  EOF
}

retryable_errors = local.universal_config.retryable_errors
