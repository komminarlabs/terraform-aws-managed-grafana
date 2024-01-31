data "aws_iam_policy_document" "task_execution_role" {
  statement {
    actions = [
      "ssm:GetParameter"
    ]
    resources = [
      "arn:aws:ssm:*:*:parameter/${var.customer}/grafana/*",
      "arn:aws:ssm:*:*:parameter/${var.customer}/aurora/grafana/*",
      "arn:aws:ssm:*:*:parameter/${var.customer}/influx/grafana/token"
    ]
  }
}

module "grafana" {
  source                             = "github.com/schubergphilis/terraform-aws-mcaf-fargate?ref=v0.11.0"
  name                               = "grafana"
  ecs_subnet_ids                     = var.vpc_private_subnet_ids
  image                              = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/grafana:${local.grafana_version}"
  load_balancer_deregistration_delay = 0
  load_balancer_subnet_ids           = var.vpc_public_subnet_ids
  role_policy                        = data.aws_iam_policy_document.task_execution_role.json
  tags                               = var.tags
  vpc_id                             = var.vpc_id

  health_check = {
    healthy_threshold   = 3,
    interval            = 30,
    path                = "/api/health",
    unhealthy_threshold = 3
  }

  subdomain = {
    name    = "grafana"
    zone_id = var.zone_id
  }

  environment = {
    "AWS_REGION"                            = data.aws_region.current.name,
    "GF_SERVER_ROOT_URL"                    = "https://${module.grafana.fqdn}",
    "GF_DATABASE_TYPE"                      = "postgres",
    "GF_DATABASE_NAME"                      = "fuseplatform",
    "GF_DATABASE_USER"                      = "grafana",
    "GF_DATABASE_PASSWORD"                  = "ssm:///${var.customer}/aurora/grafana/password",
    "GF_DATABASE_HOST"                      = var.aurora_endpoint,
    "GF_DATABASE_PORT"                      = var.aurora_port,
    "GF_SECURITY_ADMIN_USER"                = "admin",
    "GF_SECURITY_ADMIN_PASSWORD"            = "ssm://${aws_ssm_parameter.grafana_admin_password.name}",
    "GF_SECURITY_COOKIE_SECURE"             = "true",
    "GF_SECURITY_COOKIE_SAMESITE"           = "lax",
    "GF_SECURITY_STRICT_TRANSPORT_SECURITY" = "true",
    "GF_SECURITY_X_XSS_PROTECTION"          = "true",
    "GF_SECURITY_X_CONTENT_TYPE_OPTIONS"    = "true",
    "GF_USERS_ALLOW_ORG_CREATE"             = "false",
    "GF_USERS_EDITORS_CAN_ADMIN"            = "true",
    "GF_USERS_VIEWERS_CAN_EDIT"             = "true",
    "GF_AUTH_DISABLE_LOGIN_FORM"            = "true",
    "GF_AUTH_OAUTH_AUTO_LOGIN"              = "true",
    "GF_AUTH_OKTA_NAME"                     = "Okta"
    "GF_AUTH_OKTA_ENABLED"                  = "true"
    "GF_AUTH_OKTA_CLIENT_ID"                = "ssm://${aws_ssm_parameter.client_id.name}"
    "GF_AUTH_OKTA_CLIENT_SECRET"            = "ssm://${aws_ssm_parameter.client_secret.name}"
    "GF_AUTH_OKTA_SCOPES"                   = "openid profile email groups"
    "GF_AUTH_OKTA_AUTH_URL"                 = "https://fuseplatform.okta.com/oauth2/default/v1/authorize",
    "GF_AUTH_OKTA_TOKEN_URL"                = "https://fuseplatform.okta.com/oauth2/default/v1/token",
    "GF_AUTH_OKTA_API_URL"                  = "https://fuseplatform.okta.com/oauth2/default/v1/userinfo",
    // "GF_AUTH_OKTA_ROLE_ATTRIBUTE_PATH"      = "contains(Groups[*], '${data.okta_group.platform_engineers.name}') && 'Admin'",
    "GF_AUTH_OKTA_ROLE_ATTRIBUTE_PATH"      = "contains(Groups[*], 'PlatformEngineers') && 'Admin'",
    "GF_SMTP_ENABLED"                       = "true",
    "GF_SMTP_FROM_ADDRESS"                  = "grafana@${var.ses_smtp_domain}",
    "GF_SMTP_HOST"                          = "email-smtp.eu-central-1.amazonaws.com:587",
    "GF_SMTP_PASSWORD"                      = var.ses_smtp_password,
    "GF_SMTP_STARTTLS_POLICY"               = "MandatoryStartTLS",
    "GF_SMTP_USER"                          = var.ses_smtp_user,
    "GF_USERS_ALLOW_SIGN_UP"                = "false",
    "INFLUX_V2_BUCKET_MEASUREMENTS"         = var.influx_measurements_name,
    "INFLUX_V2_BUCKET_PROCESSED"            = var.influx_processed_name,
    "INFLUX_V2_DATABASE_MEASUREMENTS"       = var.influx_measurements_name,
    "INFLUX_V2_DATABASE_PROCESSED"          = var.influx_processed_name,
    "INFLUX_V2_ORGANIZATION"                = influx_authorization.grafana.organization,
    "INFLUX_V2_TOKEN"                       = "ssm://${aws_ssm_parameter.grafana_influx_token.name}",
    "INFLUX_V2_URL"                         = influx_authorization.grafana.host,
    "TZ"                                    = var.timezone,
  }
}

resource "null_resource" "grafana_config" {
  triggers = {
    grafana_name = module.grafana.name
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/grafana.sh"

    environment = {
      GRAFANA_AUTH         = "admin:${var.grafana_admin_password}"
      GRAFANA_FQDN         = module.grafana.fqdn
      GRAFANA_ORGANIZATION = var.grafana_organisation
    }
  }

  depends_on = [
    null_resource.grafana_database_trigger
  ]
}

# When re-enabling migrate this to a JSON file instead

# resource "grafana_data_source" "datamodel" {
#   name          = "DataModel"
#   type          = "postgres"
#   url           = var.aurora_endpoint
#   username      = "datamodel_ro"
#   password      = var.aurora_datamodel_ro_password
#   database_name = "fuseplatform"
#   is_default    = false

#   depends_on = [null_resource.grafana_config]
# }

resource "aws_ssm_parameter" "grafana_admin_password" {
  name  = "/${var.customer}/grafana/grafana_admin_password"
  type  = "SecureString"
  value = var.grafana_admin_password
  tags  = var.tags
}

resource "aws_ssm_parameter" "grafana_influx_token" {
  name  = "/${var.customer}/influx/grafana/token"
  type  = "SecureString"
  value = influx_authorization.grafana.token
  tags  = var.tags
}

resource "influx_authorization" "grafana" {
  name = "grafana"

  dynamic "permission" {
    for_each = var.influx_bucket_ids
    content {
        action = "read"
        id     = permission.value
        type   = "buckets"
      }
    }
}
