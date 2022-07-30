data "aws_caller_identity" "caller" {}

data "aws_region" "current" {}

module "domain_name" {
  source = "../string-case"

  string = var.domain_name
}

module "account_class" {
  source = "../string-case"

  string = var.account_class
}

data "aws_iam_policy_document" "key_policy" {
  # checkov:skip=CKV_AWS_109:Prod and stage accounts are allowed to kms:CreateGrant on dev accounts
  # checkov:skip=CKV_AWS_111:Prod and stage accounts are allowed to encrypt/decrypt with dev account keys
  version = "2012-10-17"

  statement {
    sid       = "EnableIAMUserPermissions"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]
    principals {
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.caller.account_id}:root"]
      type        = "AWS"
    }
  }

  statement {
    sid    = "AllowServiceOrServiceLinkedRoleUseOfCMK"
    effect = "Allow"
    principals {
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.caller.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
      ]
      type = "AWS"
    }
    principals {
      identifiers = [
        "logs.${data.aws_region.current.name}.amazonaws.com"
      ]
      type = "Service"
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AllowServiceLinkedRoleAttachmentPersistentResources"
    effect = "Allow"
    principals {
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.caller.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
      ]
      type = "AWS"
    }
    actions = [
      "kms:CreateGrant",
      "kms:RetireGrant",
    ]
    resources = ["*"]
    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = ["true"]
    }
  }

  dynamic "statement" {
    for_each = length(var.shared_aws_account_ids) > 0 ? [true] : []
    content {
      sid    = "EncryptAndDecryptWith${module.domain_name.alphanum}DomainAccounts"
      effect = "Allow"
      actions = [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey",
        "kms:DescribeKey",
        "kms:CreateGrant",
      ]
      resources = ["*"]
      principals {
        identifiers = [
          for _, id in var.shared_aws_account_ids :
          "arn:aws:iam::${id}:root"
        ]
        type = "AWS"
      }
    }
  }
}

resource "aws_kms_key" "kms_key" {
  description              = "${module.domain_name.raw} ${module.account_class.title} Account KMS key"
  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  deletion_window_in_days  = 30
  enable_key_rotation      = true
  policy                   = data.aws_iam_policy_document.key_policy.json

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_kms_alias" "kms_key_alias" {
  name          = "alias/${module.domain_name.kebab}-${module.account_class.kebab}-account-key"
  target_key_id = aws_kms_key.kms_key.key_id
}

resource "aws_ssm_parameter" "shared_account_keys" {
  # checkov:skip=CKV2_AWS_34:We want this to be readable by developers, see DEVO-1625
  name = "/bootstrap/domain-security/shared-account-keys"
  type = "String"
  value = jsonencode({
    for class, id in var.shared_aws_account_ids :
    class => "arn:aws:kms:${data.aws_region.current.name}:${id}:alias/${module.domain_name.kebab}-${class}-account-key"
  })
  overwrite = true
}

resource "aws_ssm_parameter" "account_key" {
  # checkov:skip=CKV2_AWS_34:We want this to be readable by developers, see DEVO-1625
  name      = "/bootstrap/domain-security/account-key"
  type      = "String"
  value     = aws_kms_key.kms_key.arn
  overwrite = true
}
