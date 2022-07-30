terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    newrelic = {
      source  = "newrelic/newrelic"
      version = "~> 2.48.0"
    }
  }
}

variable "name" {
  type = string
}

variable "newrelic_account_id" {
  type = string
}

variable "newrelic_api_key" {
  type = string
}

resource "newrelic_api_access_key" "ingest_license" {
  account_id  = var.newrelic_account_id
  key_type    = "INGEST"
  ingest_type = "LICENSE"
  name        = "${var.name} Deprecated Ingest - License"
  notes       = "INGEST LICENSE Key for ${var.name} Deprecated Access. Deployed by devops-infrastructure-bootstrap (phase 456)"
}

module "secret" {
  source = "../../../../../../..//modules/aws-secrets-manager-secret"

  name                  = "account/deprecated-new-relic-faceless-credentials"
  description           = "DEPRECATED New Relic account credentials. Use account/new-relic-faceless-credentials instead. Referenced by the /bootstrap/integrations/new-relic-faceless-user-credentials SSM parameter."
  parameter_path        = "/bootstrap/integrations/new-relic-faceless-user-credentials"
  parameter_description = "DEPRECATED. Use /bootstrap/integrations/new-relic-faceless-credentials instead. This has to be named this way because legacy-infrastructure-static references it in its roots."
}

module "value" {
  source = "../../../../../../..//modules/aws-secrets-manager-secret-value"

  secret_arn = module.secret.arn
  value = jsonencode({
    account_id     = var.newrelic_account_id
    api_key        = var.newrelic_api_key
    ingest_license = newrelic_api_access_key.ingest_license.key
  })
}
