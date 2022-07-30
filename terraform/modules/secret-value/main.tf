variable "ssm_parameter_name" {
  description = "The parameter name in SSM to look up the secret details."
  type        = string
}

data "aws_ssm_parameter" "this" {
  name = var.ssm_parameter_name
}

locals {
  param = jsondecode(data.aws_ssm_parameter.this.value)
}

data "aws_secretsmanager_secret_version" "this" {
  secret_id = local.param["secret_location"]
}

output "secret_value" {
  sensitive = true
  value     = data.aws_secretsmanager_secret_version.this.secret_string
}
