# Secret Value Module

This module provides a way to read a secret tracked by a parameter in AWS SSM.

## Secret Location & Value

When Bootstrap stores secrets, it currently does so in AWS Secrets Manager. To
help safeguard against accidental secret deletion, Bootstrap sometimes names its
secrets with the domain name (e.g. "Shared Services") and account environment
(e.g. "Prod"). That way, a human operator can tell that the secret
`account/shared-services-prod-new-relic-faceless-credentials` might be important
to the account itself.

To help operators maintain their infrastructure-as-code (and in such a way that
they don't need to maintain whole sets of secret names for each of their
accounts), the Bootstrap also makes an
[AWS SSM](https://us-west-2.console.aws.amazon.com/systems-manager/parameters/?region=us-west-2&tab=Table)
Parameter, with a static name and the Secret's ARN as its value. For the above
example, the Parameter named
`/bootstrap/integrations/new-relic-faceless-credentials` shows the location of
the Secret, no matter what AWS account you're in.

This module reads the given `ssm_parameter_name`, and unpacks it to a secret
object. It then outputs the current string version of the secret.

## Secret Store

This module used to have logic that took the parameter's `secret_store` into
account. This caused some concern that secret values were only available after
apply (when the store logic resolves into values).

In order to keep development flowing smoothly, DevOps decided to ignore the
`secret_store` attribute of the parameter for the time being. If and when we
decide to use a different secret store we'll likely maintain a similar module in
parallel to this one.

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
| [aws_secretsmanager_secret_version.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |
| [aws_ssm_parameter.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ssm\_parameter\_name | The parameter name in SSM to look up the secret details. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| secret\_value | n/a |

<!-- END_TF_DOCS -->
