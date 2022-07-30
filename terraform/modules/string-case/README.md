# String Case

<!-- BEGIN_TF_DOCS -->

## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| string | String to change case, eg: 'GitHub Actions', 'CircleCI' | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| alphanum | Only remove any non-alphanumeric characters |
| camel | TitleCase, lower case first letter, and remove all separators |
| dot | Replace all spaces with periods |
| kebab | lower case and replace separators with hyphens |
| lower | Apply Terraform lower(). |
| pascal | TitleCase and remove all separators |
| raw | Pass-through input string |
| snake | lower case and replace separators with underscores |
| title | Apply Terraform title(). |
| upper | Apply Terraform upper(). |

<!-- END_TF_DOCS -->
