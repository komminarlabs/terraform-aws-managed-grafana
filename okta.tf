//data "okta_group" "platform_engineers" {
//  name = "PlatformEngineers"
//}

resource "okta_app_oauth" "default" {
  label                      = "Grafana - ${var.customer}"
  status                     = "ACTIVE"
  type                       = "web"
  consent_method             = "TRUSTED"
  grant_types                = ["authorization_code", "implicit"]
  hide_ios                   = false
  hide_web                   = false
  login_mode                 = "SPEC"
  login_scopes               = ["openid", "profile", "email"]
  login_uri                  = "https://${module.grafana.fqdn}/"
  logo                       = "${path.module}/images/grafana.png"
  redirect_uris              = ["https://${module.grafana.fqdn}/login/okta"]
  response_types             = ["id_token", "code"]
  token_endpoint_auth_method = "client_secret_jwt"

  lifecycle {
    ignore_changes = [groups, users]
  }
}

resource "okta_app_group_assignments" "default" {
  app_id = okta_app_oauth.default.id

  group {
    id       = "00g250db23hDx2God417"
    priority = 1
  }
}

resource "aws_ssm_parameter" "client_id" {
  name  = "/${var.customer}/grafana/client_id"
  type  = "SecureString"
  value = okta_app_oauth.default.client_id
  tags  = var.tags
}

resource "aws_ssm_parameter" "client_secret" {
  name  = "/${var.customer}/grafana/client_secret"
  type  = "SecureString"
  value = okta_app_oauth.default.client_secret
  tags  = var.tags
}
