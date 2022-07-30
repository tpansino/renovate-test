# AWS SecretsManager Secret Value Module

Stores a value in an AWS SecretsManager Secret.

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

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_secretsmanager_secret_version.secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret.secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| secret\_arn | The ARN of the secret to store a value in | `string` | n/a | yes |
| value | The value to store in the secret | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| version\_id | The version ID of the stored secret version |

<!-- END_TF_DOCS -->
