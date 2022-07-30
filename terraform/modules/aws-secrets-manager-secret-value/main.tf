data "aws_secretsmanager_secret" "secret" {
  arn = var.secret_arn
}

resource "aws_secretsmanager_secret_version" "secret" {
  secret_id     = data.aws_secretsmanager_secret.secret.id
  secret_string = var.value
}
