variable "domain_name" {
  description = "The domain name of the account"
  type        = string
}

variable "account_class" {
  description = "The class of this account"
  type        = string
}

variable "shared_aws_account_ids" {
  description = "Map of account class to account IDs to share resources with."
  type        = map(string)
  default     = {}
}
