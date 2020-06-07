output "id" {
  description = "The policy's ID."
  value       = aws_iam_policy.this.id
}

output "arn" {
  description = "The policy's ARN."
  value       = aws_iam_policy.this.arn
}

output "groups" {
  description = "The groups to which policy is attached"
  value       = element(concat(aws_iam_group_policy_attachment.to_groups.*.group, list("")), 0)
}

output "policy_json" {
  description = "The above arguments serialized as a standard JSON policy document."
  value       = data.aws_iam_policy_document.this.json
  sensitive   = true
}
