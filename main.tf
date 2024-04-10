data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_grafana_license_association" "default" {
  count = var.license_type != null ? 1 : 0

  license_type = var.license_type
  workspace_id = aws_grafana_workspace.default.id
}

resource "aws_grafana_role_association" "this" {
  for_each = { for i, v in var.role_association : v.role => v }

  group_ids    = each.value.group_ids
  role         = each.value.role
  user_ids     = each.value.user_ids
  workspace_id = aws_grafana_workspace.default.id
}

resource "aws_grafana_workspace" "default" {
  account_access_type       = var.account_access_type
  authentication_providers  = var.authentication_providers
  configuration             = var.configuration
  data_sources              = var.data_sources
  description               = var.description
  grafana_version           = var.grafana_version
  name                      = var.name
  notification_destinations = var.notification_destinations
  organization_role_name    = var.organization_role_name
  organizational_units      = var.organizational_units
  permission_type           = var.permission_type
  role_arn                  = local.create_iam_role ? aws_iam_role.default[0].arn : var.iam_role_arn
  tags                      = var.tags

  dynamic "network_access_control" {
    for_each = var.network_access_control != null ? { create : true } : {}

    content {
      prefix_list_ids = var.network_access_control.prefix_list_ids
      vpce_ids        = var.network_access_control.vpce_ids
    }
  }

  dynamic "vpc_configuration" {
    for_each = var.vpc_configuration != null ? { create : true } : {}

    content {
      security_group_ids = var.vpc_configuration.security_group_ids
      subnet_ids         = var.vpc_configuration.subnet_ids
    }
  }
}

resource "aws_grafana_workspace_api_key" "default" {
  for_each = { for i, v in var.workspace_api_key : v.name => v }

  key_name        = each.value.name
  key_role        = each.value.role
  seconds_to_live = each.value.seconds_to_live
  workspace_id    = aws_grafana_workspace.default.id
}

resource "aws_grafana_workspace_saml_configuration" "default" {
  count = var.saml_configuration != null ? 1 : 0

  admin_role_values       = var.saml_configuration.admin_role_values
  allowed_organizations   = var.saml_configuration.allowed_organizations
  editor_role_values      = var.saml_configuration.editor_role_values
  email_assertion         = var.saml_configuration.email_assertion
  groups_assertion        = var.saml_configuration.groups_assertion
  idp_metadata_url        = var.saml_configuration.idp_metadata_url
  idp_metadata_xml        = var.saml_configuration.idp_metadata_xml
  login_assertion         = var.saml_configuration.login_assertion
  login_validity_duration = var.saml_configuration.login_validity_duration
  name_assertion          = var.saml_configuration.name_assertion
  org_assertion           = var.saml_configuration.org_assertion
  role_assertion          = var.saml_configuration.role_assertion
  workspace_id            = aws_grafana_workspace.default.id
}