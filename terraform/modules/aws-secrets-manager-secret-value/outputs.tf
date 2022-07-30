output "version_id" {
  description = "The version ID of the stored secret version"
  value       = aws_secretsmanager_secret_version.secret.version_id
}
