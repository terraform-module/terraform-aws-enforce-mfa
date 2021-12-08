data "aws_iam_policy_document" "this" {

  statement {
    sid    = "AllowBasicVisibilityWithoutMfa"
    effect = "Allow"
    actions = [
      "iam:ListUsers",
      "iam:GetAccountSummary",
      "iam:ListAccountAliases",
      "iam:ListVirtualMFADevices",
      "iam:GetAccountPasswordPolicy"
    ]
    resources = ["*", ]
  }

  statement {
    sid    = "MFAPersonalCreate"
    effect = "Allow"
    actions = [
      "iam:CreateVirtualMFADevice",
      "iam:DeleteVirtualMFADevice"
    ]
    resources = [
      "arn:aws:iam::${var.account_id}:mfa/&{aws:username}",
    ]
  }

  statement {
    sid    = "AllowIndividualUserToDeactivateOnlyTheirOwnMFAOnlyWhenUsingMFA"
    effect = "Allow"
    actions = [
      "iam:DeleteVirtualMFADevice",
    ]
    resources = [
      "arn:aws:iam::${var.account_id}:mfa/&{aws:username}",
      "arn:aws:iam::${var.account_id}:user/&{aws:username}",
    ]
    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true", ]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "iam:GetUser",
      "iam:ListGroupsForUser",
    ]
    resources = [
      "arn:aws:iam::${var.account_id}:user/&{aws:username}",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "iam:ListGroups",
    ]
    resources = [
      "arn:aws:iam::${var.account_id}:group/",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "iam:ListGroupPolicies",
      "iam:ListAttachedGroupPolicies",
    ]
    resources = [
      "arn:aws:iam::${var.account_id}:group/*",
    ]
  }

  statement {
    sid    = "AllowToListOnlyOwnMFA"
    effect = "Allow"
    actions = [
      "iam:ListMFADevices",
    ]
    resources = [
      "arn:aws:iam::*:mfa/*",
      "arn:aws:iam::*:user/&{aws:username}"
    ]

  }

  statement {
    sid    = "AllowManageOwnUserMFA"
    effect = "Allow"
    actions = [
      "iam:ChangePassword",
      "iam:CreateLoginProfile",
      "iam:UpdateLoginProfile",
      "iam:ListAccessKeys",
      "iam:UpdateUser",
      "iam:ListAttachedUserPolicies",
      "iam:ListSSHPublicKeys",
      "iam:ListAccessKeys",
      "iam:GetLoginProfile",
    ]
    resources = [
      "arn:aws:iam::${var.account_id}:user/&{aws:username}",
    ]
  }

  statement {
    sid    = "AllowUserToManageOwnMFA"
    effect = "Allow"

    actions = [
      "iam:CreateVirtualMFADevice",
      "iam:DeleteVirtualMFADevice",
      "iam:EnableMFADevice",
      "iam:ResyncMFADevice"
    ]

    resources = [
      "arn:aws:iam::*:mfa/&{aws:username}",
      "arn:aws:iam::*:user/&{aws:username}"
    ]
  }

  statement {
    sid    = "KeysAndCertificates"
    effect = "Allow"
    actions = [
      "iam:ListSigningCertificates",
      "iam:ListSSHPublicKeys",
      "iam:GetSSHPublicKey",
    ]
    resources = [
      "arn:aws:iam::${var.account_id}:user/&{aws:username}",
    ]
  }

  statement {
    sid    = "AllowUserToDeactivateOnlyOwnMFAWhenUsingMFA"
    effect = "Allow"
    actions = [
      "iam:DeactivateMFADevice"
    ]
    resources = [
      "arn:aws:iam::*:mfa/&{aws:username}",
      "arn:aws:iam::*:user/&{aws:username}"
    ]
    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }

  statement {
    sid    = "AllowBasicVisibilityWhenLoggedInWithMFA"
    effect = "Allow"
    actions = [
      "iam:ListUserTags",
      "iam:ListGroupsForUser",
      "iam:ListPolicies",
      "iam:GetGroup",
      "iam:GenerateServiceLastAccessedDetails",
      "iam:ListUserPolicies",
      "iam:GetUser",
      "iam:ListServiceSpecificCredentials",
      "iam:ListAttachedUserPolicies",
    ]
    resources = ["*", ]
    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true", ]
    }
  }

  dynamic "statement" {
    for_each = var.manage_own_access_keys ? [1] : []

    content {
      sid    = "AllowManageOwnAccessKeys"
      effect = "Allow"
      actions = [
        "iam:CreateAccessKey",
        "iam:DeleteAccessKey",
        "iam:ListAccessKeys",
        "iam:UpdateAccessKey",
      ]
      resources = [
        "arn:aws:iam::${var.account_id}:user/&{aws:username}"
      ]
      condition {
        test     = "BoolIfExists"
        variable = "aws:MultiFactorAuthPresent"
        values   = [var.manage_own_access_keys, ]
      }
    }
  }

  dynamic "statement" {
    iterator = item
    for_each = var.manage_own_signing_certificates ? [1] : []

    content {
      sid    = "AllowManageOwnSigningCertificates"
      effect = "Allow"
      actions = [
        "iam:DeleteSigningCertificate",
        "iam:ListSigningCertificates",
        "iam:UpdateSigningCertificate",
        "iam:UploadSigningCertificate",
      ]
      resources = [
        "arn:aws:iam::${var.account_id}:user/&{aws:username}"
      ]
      condition {
        test     = "BoolIfExists"
        variable = "aws:MultiFactorAuthPresent"
        values   = [var.manage_own_signing_certificates, ]
      }
    }
  }

  dynamic "statement" {
    for_each = var.manage_own_ssh_public_keys ? [1] : []

    content {
      sid    = "AllowManageOwnSSHPublicKeys"
      effect = "Allow"
      actions = [
        "iam:DeleteSSHPublicKey",
        "iam:UpdateSSHPublicKey",
        "iam:UploadSSHPublicKey"
      ]
      resources = [
        "arn:aws:iam::${var.account_id}:user/&{aws:username}"
      ]
      condition {
        test     = "BoolIfExists"
        variable = "aws:MultiFactorAuthPresent"
        values   = [var.manage_own_ssh_public_keys, ]
      }
    }
  }

  dynamic "statement" {
    for_each = var.manage_own_git_credentials ? [1] : []

    content {
      sid    = "AllowManageOwnGitCredentials"
      effect = "Allow"
      actions = [
        "iam:CreateServiceSpecificCredential",
        "iam:DeleteServiceSpecificCredential",
        "iam:ListServiceSpecificCredentials",
        "iam:ResetServiceSpecificCredential",
        "iam:UpdateServiceSpecificCredential",
      ]
      resources = [
        "arn:aws:iam::${var.account_id}:user/&{aws:username}"
      ]
      condition {
        test     = "BoolIfExists"
        variable = "aws:MultiFactorAuthPresent"

        values = [
          var.manage_own_git_credentials,
        ]
      }
    }
  }

  # Deny

  dynamic "statement" {
    for_each = var.manage_explicit_deny ? [1] : []

    content {
      sid    = "DenyAllExceptListedIfNoMFA"
      effect = "Deny"
      actions = [
        "iam:CreateVirtualMFADevice",
        "iam:EnableMFADevice",
        "iam:GetUser",
        "iam:ListMFADevices",
        "iam:ListVirtualMFADevices",
        "iam:ResyncMFADevice",
        "sts:GetSessionToken"
      ]
      resources = ["*"]
      condition {
        test     = "BoolIfExists"
        variable = "aws:MultiFactorAuthPresent"
        values   = ["false", ]
      }
    }
  }
}
