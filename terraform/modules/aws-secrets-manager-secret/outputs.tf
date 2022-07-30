output "arn" {
  description = "Secret Resource ARN"
  value       = aws_secretsmanager_secret.secret.arn
}

output "parameter_path" {
  description = "Parameter Store path to lookup the secret ARN."
  value       = aws_ssm_parameter.parameter.name
}
