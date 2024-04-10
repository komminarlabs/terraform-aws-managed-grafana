provider "aws" {
  region = "eu-central-1"
}

module "example_grafana_workspace" {
  source                   = "../"
  name                     = "default-workspace"
  description              = "AWS Managed Grafana service example workspace"
  account_access_type      = "CURRENT_ACCOUNT"
  authentication_providers = ["SAML"]
  permission_type          = "SERVICE_MANAGED"
  data_sources             = ["ATHENA", "TIMESTREAM", "XRAY"]

  role_association = [
    {
      role      = "ADMIN"
      group_ids = ["*******"]
    },
    {
      role     = "EDITOR"
      user_ids = ["*******"]
    }
  ]

  workspace_api_key = [
    {
      name            = "admin"
      role            = "ADMIN"
      seconds_to_live = 3600
    },
    {
      name            = "editor"
      role            = "EDITOR"
      seconds_to_live = 3600
    },
    {
      name            = "viewer"
      role            = "VIEWER"
      seconds_to_live = 3600
    }
  ]

  tags = {
    Environment = "development"
    Stack       = "grafana"
  }
}