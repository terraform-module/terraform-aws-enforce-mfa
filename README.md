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

  policy_name                     = "managed-mfa-enforce"
  account_id                      = data.aws_caller_identity.current.id
  groups                          = [aws_iam_group.support.name]
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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.38 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.38 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_group_policy_attachment.to_groups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy_attachment) | resource |
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | Account identification. (Optional, default '*') | `string` | `"*"` | no |
| <a name="input_groups"></a> [groups](#input\_groups) | Enforce MFA for the members in these groups. (Optional, default '[]') | `list(string)` | `[]` | no |
| <a name="input_manage_explicit_deny"></a> [manage\_explicit\_deny](#input\_manage\_explicit\_deny) | Manage explicit deny. | `bool` | `false` | no |
| <a name="input_manage_own_access_keys"></a> [manage\_own\_access\_keys](#input\_manage\_own\_access\_keys) | Allow a new AWS secret access key and corresponding AWS access key ID for the specified user. | `bool` | `false` | no |
| <a name="input_manage_own_git_credentials"></a> [manage\_own\_git\_credentials](#input\_manage\_own\_git\_credentials) | Allow managing git credentials. | `bool` | `false` | no |
| <a name="input_manage_own_signing_certificates"></a> [manage\_own\_signing\_certificates](#input\_manage\_own\_signing\_certificates) | Allow managing signing certificates. | `bool` | `false` | no |
| <a name="input_manage_own_ssh_public_keys"></a> [manage\_own\_ssh\_public\_keys](#input\_manage\_own\_ssh\_public\_keys) | Allow managing ssh public keys. | `bool` | `false` | no |
| <a name="input_path"></a> [path](#input\_path) | Path in which to create the policy. (Optional, default '/') | `string` | `"/"` | no |
| <a name="input_policy_name"></a> [policy\_name](#input\_policy\_name) | The name of the policy. | `string` | `"managed-force-mfa-policy"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The policy's ARN. |
| <a name="output_groups"></a> [groups](#output\_groups) | The groups to which policy is attached |
| <a name="output_id"></a> [id](#output\_id) | The policy's ID. |
| <a name="output_policy_json"></a> [policy\_json](#output\_policy\_json) | The above arguments serialized as a standard JSON policy document. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Commands

<!-- START makefile-doc -->
```
$ make help 
hooks                          Commit hooks setup
validate                       Validate with pre-commit hooks 
```
<!-- END makefile-doc -->

### :memo: Guidelines

 - :memo: Use a succinct title and description.
 - :bug: Bugs & feature requests can be be opened
 - :signal_strength: Support questions are better asked on [Stack Overflow](https://stackoverflow.com/)
 - :blush: Be nice, civil and polite ([as always](http://contributor-covenant.org/version/1/4/)).

## License

MIT Licensed. See [LICENSE](./LICENSE) for full details.

## How to Contribute

Submit a pull request

# Authors

Currently maintained by [Ivan Katliarchuk](https://github.com/ivankatliarchuk) and these [awesome contributors](https://github.com/terraform-module/terraform-aws-enforce-mfa/graphs/contributors).

[![ForTheBadge uses-git](http://ForTheBadge.com/images/badges/uses-git.svg)](https://GitHub.com/)

## Terraform Registry

- [Module](https://registry.terraform.io/modules/terraform-module/enforce-mfa/aws)
