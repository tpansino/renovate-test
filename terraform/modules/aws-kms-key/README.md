# AWS KMS Key Module

<!-- BEGIN_TF_DOCS -->

## Requirements

| Name | Version |
|------|---------|
| aws | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| account\_class | ../string-case | n/a |
| domain\_name | ../string-case | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_kms_alias.kms_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_ssm_parameter.account_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.shared_account_keys](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_caller_identity.caller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.key_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| account\_class | The class of this account | `string` | n/a | yes |
| domain\_name | The domain name of the account | `string` | n/a | yes |
| shared\_aws\_account\_ids | Map of account class to account IDs to share resources with. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| kms\_key\_alias\_arn | ARN of KMS key alias |
| kms\_key\_arn | ARN of KMS key |

<!-- END_TF_DOCS -->
