resource "aws_iam_policy" "this" {
  name        = var.policy_name
  path        = var.path
  description = "Policy to allow MFA management"
  policy      = data.aws_iam_policy_document.this.json
}

resource "aws_iam_group_policy_attachment" "to_groups" {
  count      = length(var.groups)
  group      = element(var.groups, count.index)
  policy_arn = aws_iam_policy.this.arn
}
