module "secret_name" {
  source = "../string-case"
  string = var.name
}

data "aws_kms_key" "kms_key_id" {
  key_id = "alias/aws/secretsmanager"
}

resource "aws_secretsmanager_secret" "secret" {
  name                    = module.secret_name.kebab
  description             = var.description
  recovery_window_in_days = var.recovery_window_days
  policy                  = var.policy_json
  tags                    = var.tags

  kms_key_id = data.aws_kms_key.kms_key_id.id
}

resource "aws_ssm_parameter" "parameter" {
  # checkov:skip=CKV2_AWS_34:We want this to be readable by developers, see DEVO-1625
  name        = var.parameter_path
  description = var.parameter_description
  type        = "String"
  value = jsonencode({
    # checkov:skip=CKV_SECRET_6:The location of the secret store is not a secret
    secret_store    = "secrets-manager" # pragma: allowlist secret
    secret_location = aws_secretsmanager_secret.secret.arn
  })
  tags = var.tags
}

module "value" {
  source = "../aws-secrets-manager-secret-value"
  count  = var.value != null ? 1 : 0

  secret_arn = aws_secretsmanager_secret.secret.arn
  value      = var.value
}
