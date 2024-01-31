variable "account_access_type" {
  type        = string
  default     = "CURRENT_ACCOUNT"
  description = "The type of account access for the workspace. Valid values are `CURRENT_ACCOUNT` and `ORGANIZATION`. If ORGANIZATION is specified, then organizational_units must also be present"

  validation {
    condition     = contains(["CURRENT_ACCOUNT", "ORGANIZATION"], var.account_access_type)
    error_message = "Valid values are \"CURRENT_ACCOUNT\" or \"ORGANIZATION\"."
  }
}

variable "authentication_providers" {
  type        = list(string)
  default     = ["AWS_SSO"]
  description = "The authentication providers for the workspace. Valid values are `AWS_SSO`, `SAML`, or both"

  validation {
    condition = alltrue([
      for v in var.authentication_providers : contains(["AWS_SSO", "SAML"], v)
    ])
    error_message = "Valid values are \"AWS_SSO\" or \"SAML\" or or both."
  }
}

variable "configuration" {
  type        = string
  default     = null
  description = "The configuration string for the workspace that you create"
}

variable "data_sources" {
  type        = list(string)
  default     = []
  description = "The data sources for the workspace. Valid values are `AMAZON_OPENSEARCH_SERVICE`, `ATHENA`, `CLOUDWATCH`, `PROMETHEUS`, `REDSHIFT`, `SITEWISE`, `TIMESTREAM`, `XRAY`"

  validation {
    condition = alltrue([
      for v in var.data_sources : contains(["AMAZON_OPENSEARCH_SERVICE", "ATHENA", "CLOUDWATCH", "PROMETHEUS", "REDSHIFT", "SITEWISE", "TIMESTREAM", "XRAY"], v)
    ])
    error_message = "Valid values are \"AMAZON_OPENSEARCH_SERVICE\" or \"ATHENA\" or \"CLOUDWATCH\" or \"PROMETHEUS\" or \"REDSHIFT\" or \"SITEWISE\" or \"TIMESTREAM\" or \"XRAY\"."
  }
}

variable "description" {
  type        = string
  description = "The workspace description"
}

variable "grafana_version" {
  type        = string
  default     = "8.4"
  description = "Specifies the version of Grafana to support in the new workspace. If not specified, the default version for the `aws_grafana_workspace` resource will be used. See `aws_grafana_workspace` documentation for available options."
}

variable "iam_role_arn" {
  type        = string
  default     = null
  description = "The arn of the IAM role to use for grafana workspace"
}

variable "license_type" {
  type        = string
  default     = null
  description = "The type of license for the workspace license association. Valid values are `ENTERPRISE` and `ENTERPRISE_FREE_TRIAL`"

  validation {
    condition     = var.license_type == null ? true : contains(["ENTERPRISE", "ENTERPRISE_FREE_TRIAL"], var.license_type)
    error_message = "Valid values are \"ENTERPRISE\" or \"ENTERPRISE_FREE_TRIAL\"."
  }
}

variable "name" {
  type        = string
  description = "The Grafana workspace name"
}

variable "network_access_control" {
  type = object({
    prefix_list_ids = list(string)
    vpce_ids        = list(string)
  })
  default     = null
  description = "Configuration for network access to your workspace"
}

variable "notification_destinations" {
  type        = list(string)
  default     = ["SNS"]
  description = "The notification destinations. If a data source is specified here, Amazon Managed Grafana will create IAM roles and permissions needed to use these destinations. Must be set to `SNS`"
}

variable "organization_role_name" {
  type        = string
  default     = null
  description = "The role name that the workspace uses to access resources through Amazon Organizations"
}

variable "organizational_units" {
  type        = list(string)
  default     = []
  description = "The Amazon Organizations organizational units that the workspace is authorized to use data sources from"
}

variable "permission_type" {
  type        = string
  default     = "SERVICE_MANAGED"
  description = "The permission type of the workspace. If `SERVICE_MANAGED` is specified, the IAM roles and IAM policy attachments are generated automatically. If `CUSTOMER_MANAGED` is specified, the IAM roles and IAM policy attachments will not be created"

  validation {
    condition     = contains(["CUSTOMER_MANAGED", "SERVICE_MANAGED"], var.permission_type)
    error_message = "Valid values are \"CUSTOMER_MANAGED\" or \"SERVICE_MANAGED\"."
  }
}

variable "role_association" {
  type = list(object({
    group_ids = optional(list(string))
    role      = string
    user_ids  = optional(list(string))
  }))
  default     = []
  description = "List of user/group IDs to assocaite to a role"
}

variable "vpc_configuration" {
  type = object({
    security_group_ids = list(string)
    subnet_ids         = list(string)
  })
  default     = null
  description = "The configuration settings for an Amazon VPC that contains data sources for your Grafana workspace to connect to"
}

variable "workspace_api_key" {
  type = list(object({
    name            = string
    role            = string
    seconds_to_live = number
  }))
  default     = []
  description = "List of workspace API Key resources to create"
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resources"
}
