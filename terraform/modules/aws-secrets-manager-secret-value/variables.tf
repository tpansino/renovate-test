variable "secret_arn" {
  description = "The ARN of the secret to store a value in"
  type        = string
}

variable "value" {
  description = "The value to store in the secret"
  type        = string
}
