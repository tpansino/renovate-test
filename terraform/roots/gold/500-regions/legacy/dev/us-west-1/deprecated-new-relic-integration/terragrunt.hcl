include {
  path = find_in_parent_folders()
}

dependency "bootstrap" {
  config_path = find_in_parent_folders("200-bootstrap")

  skip_outputs = local.skip_outputs
  mock_outputs = local.skip_outputs ? {
    new_relic_secret_credentials = {
      account_id = "mock"
      api_key    = "mock"
    }
  } : null
}

locals {
  path_params = jsondecode(run_cmd("--terragrunt-quiet", "${find_in_parent_folders("scripts")}/identify_path_params.py", get_terragrunt_dir(), get_parent_terragrunt_dir()))
  env_type    = local.path_params.env_type
  region      = local.path_params.region

  global_config                           = yamldecode(file(find_in_parent_folders("global-config.yml")))
  security_portal_global_operator_profile = local.global_config.security_portal_global_operator_profile

  phase_config    = yamldecode(file(find_in_parent_folders("phase-config.yml")))
  domain_config   = local.phase_config.domain
  env_type_config = local.domain_config.env_types[local.env_type]
  region_config   = local.env_type_config.regions[local.region]

  skip_outputs = tobool(get_env("TERRAGRUNT_SKIP_OUTPUTS", "false"))
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
  provider "aws" {
    region  = "${local.region}"
    profile = "${local.security_portal_global_operator_profile}"
    assume_role {
      role_arn = "${local.env_type_config.bootstrap_role_arn}"
    }
    default_tags {
      tags = {
        "ManagedByIAC" = "true"
        "IACDeploymentRoot" = "git@github.com:OpenSesame/devops-infrastructure-bootstrap.git//prod/${path_relative_to_include()}/terragrunt.hcl"
        "OwnedBy"            = "@OpenSesame/devops"
      }
    }
  }
  provider "newrelic" {
    account_id = "${dependency.bootstrap.outputs.new_relic_secret_credentials["account_id"]}"
    api_key    = "${dependency.bootstrap.outputs.new_relic_secret_credentials["api_key"]}"
    region     = "US"
  }
  EOF
}

inputs = {
  name                = "Legacy Dev"
  newrelic_account_id = dependency.bootstrap.outputs.new_relic_secret_credentials["account_id"]
  newrelic_api_key    = dependency.bootstrap.outputs.new_relic_secret_credentials["api_key"]
}
