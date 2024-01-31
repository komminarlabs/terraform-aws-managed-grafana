output "workspace" {
  description = "The Grafana workspace details"
  value       = aws_grafana_workspace.default
}

output "workspace_api_keys" {
  description = "The workspace API keys created including their attributes"
  value       = aws_grafana_workspace_api_key.default
}

output "workspace_iam_role" {
  description = "IAM role details of the Grafana workspace"
  value       = try(aws_iam_role.default, null)
}

output "license_free_trial_expiration" {
  description = "If `license_type` is set to `ENTERPRISE_FREE_TRIAL`, this is the expiration date of the free trial"
  value       = try(aws_grafana_license_association.default[0].free_trial_expiration, null)
}

output "license_expiration" {
  description = "If `license_type` is set to `ENTERPRISE`, this is the expiration date of the enterprise license"
  value       = try(aws_grafana_license_association.default[0].license_expiration, null)
}
