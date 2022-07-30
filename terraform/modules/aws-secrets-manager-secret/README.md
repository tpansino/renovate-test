# AWS SecretsManager Secret Module

<!-- BEGIN_TF_DOCS -->

## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 1.0 |
| aws | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| secret\_name | ../string-case | n/a |
| value | ../aws-secrets-manager-secret-value | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_secretsmanager_secret.secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_ssm_parameter.parameter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_kms_key.kms_key_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the secret.  Use raw format as the output will be converted to kebab. | `string` | n/a | yes |
| parameter\_path | Parameter Store path to store secret ARN for discoverability. | `string` | n/a | yes |
| description | Description of the secret. | `string` | `null` | no |
| parameter\_description | Description of the SSM parameter. | `string` | `null` | no |
| policy\_json | A valid JSON document representing a resource policy. | `string` | `null` | no |
| recovery\_window\_days | Specifies the number of days that AWS Secrets Manager waits before it can delete the secret. This value can be 0 to force deletion without recovery or range from 7 to 30 days. The default value is 14. | `number` | `14` | no |
| tags | Specifies a key-value map of user-defined tags that are attached to the secret. | `map(string)` | `null` | no |
| value | Value to store in the secret | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | Secret Resource ARN |
| parameter\_path | Parameter Store path to lookup the secret ARN. |

<!-- END_TF_DOCS -->
