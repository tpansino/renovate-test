variable "string" {
  type        = string
  description = "String to change case, eg: 'GitHub Actions', 'CircleCI'"
}

locals {
  kebab  = lower(replace(var.string, "/[ _]/", "-"))
  pascal = replace(title(lower(replace(var.string, "/[_-]/", " "))), " ", "")
}

output "raw" {
  description = "Pass-through input string"
  value       = var.string
}

output "alphanum" {
  description = "Only remove any non-alphanumeric characters"
  value       = replace(var.string, "/[^a-zA-Z0-9]/", "")
}

output "kebab" {
  description = "lower case and replace separators with hyphens"
  value       = local.kebab
}

output "snake" {
  description = "lower case and replace separators with underscores"
  value       = replace(local.kebab, "-", "_")
}

output "pascal" {
  description = "TitleCase and remove all separators"
  value       = local.pascal
}

output "camel" {
  description = "TitleCase, lower case first letter, and remove all separators"
  value       = "${lower(substr(local.pascal, 0, 1))}${trimprefix(local.pascal, substr(local.pascal, 0, 1))}"
}

output "dot" {
  description = "Replace all spaces with periods"
  value       = lower(replace(var.string, " ", "."))
}

output "title" {
  description = "Apply Terraform title()."
  value       = title(var.string)
}

output "lower" {
  description = "Apply Terraform lower()."
  value       = lower(var.string)
}

output "upper" {
  description = "Apply Terraform upper()."
  value       = upper(var.string)
}
