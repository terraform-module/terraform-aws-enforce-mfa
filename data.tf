data aws_iam_policy_document this {
  statement {
    sid    = "MFAPersonalCreate"
    effect = "Allow"
    actions = [
      "iam:CreateVirtualMFADevice",
    ]
    resources = [
      "arn:aws:iam::${var.account_id}:mfa/&{aws:username}",
      "arn:aws:iam::${var.account_id}:user/&{aws:username}",
    ]
  }

  statement {
    sid    = "AllowIndividualUserToDeactivateOnlyTheirOwnMFAOnlyWhenUsingMFA"
    effect = "Allow"
    actions = [
      "iam:DeleteVirtualMFADevice",
      "iam:DeactivateMFADevice",
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
      "iam:EnableMFADevice",
      "iam:GetUser",
      "iam:ListGroupsForUser",
    ]
    resources = [
      "arn:aws:iam::${var.account_id}:user/&{aws:username}",
    ]
  }

  statement {
    sid    = "AllowIndividualUserToManageTheirOwnMFA"
    effect = "Allow"
    actions = [
      "iam:CreateVirtualMFADevice",
      "iam:DeleteVirtualMFADevice",
      "iam:EnableMFADevice",
      "iam:ResyncMFADevice",
    ]
    resources = [
      "arn:aws:iam::${var.account_id}:user/&{aws:username}",
      "arn:aws:iam::${var.account_id}:mfa/&{aws:username}",
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
    effect = "Allow"
    actions = [
      "iam:ChangePassword",
      "iam:UpdateLoginProfile",
      "iam:UpdateUser",
      "iam:ListAttachedUserPolicies",
      "iam:ListSSHPublicKeys",
      "iam:ListAccessKeys",
      "iam:GetLoginProfile",
      "iam:ListMFADevices",
      "iam:ListVirtualMFADevices",
    ]
    resources = [
      "arn:aws:iam::${var.account_id}:user/&{aws:username}",
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
    sid    = "AllowBasicVisiiblityWhenLoggedInWithMFA"
    effect = "Allow"
    actions = [
      "iam:GetAccountSummary",
      "iam:ListAccountAliases",
      "iam:GetAccountSummary",
      "iam:ListUserTags",
      "iam:ListGroupsForUser",
      "iam:ListPolicies",
      "iam:ListUsers",
      "iam:GetGroup",
      "iam:GenerateServiceLastAccessedDetails",
      "iam:ListUserPolicies",
      "iam:GetUser",
      "iam:ListServiceSpecificCredentials",
      "iam:ListAttachedUserPolicies",
      "iam:ListVirtualMFADevices",
      "iam:ListMFADevices"
    ]
    resources = ["*", ]
    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true", ]
    }
  }

  statement {
    sid    = "BlockMostAccessUnlessSignedInWithMFA"
    effect = "Deny"
    not_actions = [
      "iam:CreateVirtualMFADevice",
      "iam:DeleteVirtualMFADevice",
      "iam:ListVirtualMFADevices",
      "iam:EnableMFADevice",
      "iam:ResyncMFADevice",
      "iam:ListAccountAliases",
      "iam:ListUsers",
      "iam:ListSSHPublicKeys",
      "iam:ListAccessKeys",
      "iam:ListServiceSpecificCredentials",
      "iam:ListMFADevices",
      "iam:GetAccountSummary",
      "sts:GetSessionToken"
    ]
    resources = ["*"]
    condition {
      test     = "BoolIfExists"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["false", ]
    }
  }

  statement {
    sid    = "BlockReadActionsUnlessSignedInWithMFA"
    effect = "Deny"

    actions = [
      "iam:ListMFADevices",
      "iam:ListVirtualMFADevices",
      "iam:ListUsers",
    ]

    resources = [
      "arn:aws:iam::${var.account_id}:user/",
      "arn:aws:iam::${var.account_id}:user/&{aws:username}",
      "arn:aws:iam::${var.account_id}:mfa/",
      "arn:aws:iam::${var.account_id}:mfa/&{aws:username}",
    ]

    condition {
      test     = "BoolIfExists"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["false", ]
    }
  }

  dynamic "statement" {
    for_each = var.manage_own_password_without_mfa ? [] : [1]

    content {
      sid    = "ChangePasswordOnlyIfMFASet"
      effect = "Deny"
      actions = [
        "iam:ChangePassword",
        "iam:CreateLoginProfile",
      ]
      resources = [
        "arn:aws:iam::${var.account_id}:user/&{aws:username}"
      ]
      condition {
        test     = "BoolIfExists"
        variable = "aws:MultiFactorAuthPresent"
        values   = ["false", ]
      }
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
}
