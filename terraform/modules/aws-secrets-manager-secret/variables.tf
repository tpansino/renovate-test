variable "name" {
  description = "Name of the secret.  Use raw format as the output will be converted to kebab."
  type        = string
}

variable "description" {
  description = "Description of the secret."
  type        = string
  default     = null
}

variable "parameter_description" {
  description = "Description of the SSM parameter."
  type        = string
  default     = null
}

variable "parameter_path" {
  description = "Parameter Store path to store secret ARN for discoverability."
  type        = string
}

variable "recovery_window_days" {
  description = "Specifies the number of days that AWS Secrets Manager waits before it can delete the secret. This value can be 0 to force deletion without recovery or range from 7 to 30 days. The default value is 14."
  type        = number
  default     = 14
}

variable "policy_json" {
  description = "A valid JSON document representing a resource policy."
  type        = string
  default     = null
}

variable "tags" {
  description = "Specifies a key-value map of user-defined tags that are attached to the secret."
  type        = map(string)
  default     = null
}

variable "value" {
  description = "Value to store in the secret"
  type        = string
  default     = null
}
