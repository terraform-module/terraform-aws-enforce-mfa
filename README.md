# Module TERRAFORM-AWS-ENFORCE-MFA

Terraform module `terraform-aws-enforce-mfa`

[![](https://img.shields.io/github/license/terraform-module/terraform-aws-enforce-mfa)](https://github.com/terraform-module/terraform-aws-enforce-mfa)
![](https://img.shields.io/github/v/tag/terraform-module/terraform-aws-enforce-mfa)
[![](https://img.shields.io/github/workflow/status/terraform-module/terraform-aws-enforce-mfa/commit-check/master)](https://github.com/terraform-module/terraform-aws-enforce-mfa/actions?query=is%3Acompleted)
![](https://github.com/terraform-module/terraform-aws-enforce-mfa/workflows/commit-check/badge.svg)
![](https://github.com/terraform-module/terraform-aws-enforce-mfa/workflows/Labeler/badge.svg)
![](https://img.shields.io/issues/github/terraform-module/terraform-aws-enforce-mfa)
![](https://img.shields.io/github/issues/terraform-module/terraform-aws-enforce-mfa)
![](https://img.shields.io/github/issues-closed/terraform-module/terraform-aws-enforce-mfa)
[![](https://img.shields.io/github/languages/code-size/terraform-module/terraform-aws-enforce-mfa)](https://github.com/terraform-module/terraform-aws-enforce-mfa)
[![](https://img.shields.io/github/repo-size/terraform-module/terraform-aws-enforce-mfa)](https://github.com/terraform-module/terraform-aws-enforce-mfa)
![](https://img.shields.io/github/languages/top/terraform-module/terraform-aws-enforce-mfa?color=green&logo=terraform&logoColor=blue)
![](https://img.shields.io/github/commit-activity/m/terraform-module/terraform-aws-enforce-mfa)
![](https://img.shields.io/github/contributors/terraform-module/terraform-aws-enforce-mfa)
![](https://img.shields.io/github/last-commit/terraform-module/terraform-aws-enforce-mfa)
[![Maintenance](https://img.shields.io/badge/Maintenu%3F-oui-green.svg)](https://GitHub.com/terraform-module/terraform-aws-enforce-mfa/graphs/commit-activity)

## Documentations

- [aws-vault setup](https://github.com/99designs/aws-vault)
- [aws-cli setup](https://docs.aws.amazon.com/cli/latest/topic/config-vars.html#sourcing-credentials-from-external-processes)
- [users with self managed mfa](https://docs.aws.amazon.com/IAM/latest/UserGuide/tutorial_users-self-manage-mfa-and-creds.html)

Optional `.aws/config` setup and `aws-vault`

```sh
[profile personal]
region=us-west-2
output=json

[profile work]
region=us-west-1
output=json

[profile work]
source_profile = work
mfa_serial = arn:aws:iam::<account>:mfa/<username>
credential_process = aws-vault exec work --json

[profile personal]
source_profile = personal
mfa_serial = arn:aws:iam::<account>:mfa/<username>
credential_process = aws-vault exec work --json
```

## Usage example

Here's the gist of using it directly from github.

```hcl
data aws_caller_identity current {}

resource aws_iam_group support {
  name =  "support"
}

module enforce_mfa {
  source  = "terraform-module/enforce-mfa/aws"
  version = "0.12.0"

  policy_name                     = format("%s-managed-mfa-enforce", var.prefix)
  account_id                      = data.aws_caller_identity.current.id
  groups                          = [aws_iam_group.support.name]
  manage_own_password_without_mfa = true
  manage_own_signing_certificates  = true
  manage_own_ssh_public_keys      = true
  manage_own_git_credentials      = true
}
```

## Assumptions

## Available features

## Module Variables

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| account\_id | Account identification. (Optional, default '\*') | `string` | `"*"` | no |
| groups | Enforce MFA for the members in these groups. (Optional, default '[]') | `list(string)` | `[]` | no |
| manage\_own\_access\_keys | Allow a new AWS secret access key and corresponding AWS access key ID for the specified user. | `bool` | `false` | no |
| manage\_own\_git\_credentials | Allow managing git credentials. | `bool` | `false` | no |
| manage\_own\_password\_without\_mfa | Whethehr password management without mfa is allowd | `bool` | `true` | no |
| manage\_own\_signing\_certificates | Allow managing signing certificates. | `bool` | `false` | no |
| manage\_own\_ssh\_public\_keys | Allow managing ssh public keys. | `bool` | `false` | no |
| path | Path in which to create the policy. (Optional, default '/') | `string` | `"/"` | no |
| policy\_name | The name of the policy. | `string` | `"managed-force-mfa-policy"` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | The policy's ARN. |
| groups | The groups to which policy is attached |
| id | The policy's ID. |
| policy\_json | The above arguments serialized as a standard JSON policy document. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Commands

<!-- START makefile-doc -->
```
$ make help 
hooks                          Commit hooks setup
validate                       Validate with pre-commit hooks
changelog                      Update changelog 
```
<!-- END makefile-doc -->

### :memo: Guidelines

 - :memo: Use a succinct title and description.
 - :bug: Bugs & feature requests can be be opened
 - :signal_strength: Support questions are better asked on [Stack Overflow](https://stackoverflow.com/)
 - :blush: Be nice, civil and polite ([as always](http://contributor-covenant.org/version/1/4/)).

## License

Copyright 2019 Ivan Katliarhcuk

MIT Licensed. See [LICENSE](./LICENSE) for full details.

## How to Contribute

Submit a pull request

# Authors

Currently maintained by [Ivan Katliarchuk](https://github.com/ivankatliarchuk) and these [awesome contributors](https://github.com/terraform-module/terraform-aws-enforce-mfa/graphs/contributors).

[![ForTheBadge uses-git](http://ForTheBadge.com/images/badges/uses-git.svg)](https://GitHub.com/)

## Terraform Registry

- [Module](https://registry.terraform.io/modules/terraform-module/terraform-aws-enforce-mfa)
