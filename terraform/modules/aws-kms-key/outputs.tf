output "kms_key_alias_arn" {
  description = "ARN of KMS key alias"
  value       = aws_kms_alias.kms_key_alias.arn
}

output "kms_key_arn" {
  description = "ARN of KMS key"
  value       = aws_kms_key.kms_key.arn
}
