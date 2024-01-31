variable "aurora_datamodel_ro_password" {
  type        = string
  description = "Password for the Aurora Data Model Read-Only user"
}

variable "aurora_endpoint" {
  type        = string
  description = "Aurora database endpoint"
}

variable "aurora_port" {
  type        = string
  description = "Aurora database endpoint port"
}

variable "aurora_security_group_id" {
  type        = string
  description = "Aurora database security group id"
}

variable "customer" {
  type        = string
  description = "The customer name"
}

variable "grafana_admin_password" {
  type        = string
  description = "The admin password for the Grafana instance"
}

variable "grafana_organisation" {
  type        = string
  description = "Name of the organisation to create in Grafana"
}

variable "influx_bucket_ids" {
  type        = list(string)
  description = "InfluxDB bucket ids to grant read access to"
}

variable "influx_measurements_name" {
  type        = string
  description = "InfluxDB measurements table name"
}

variable "influx_processed_name" {
  type        = string
  description = "InfluxDB procesed table name"
}

variable "ses_smtp_domain" {
  type        = string
  description = "SMTP domain for SES"
}

variable "ses_smtp_password" {
  type        = string
  description = "SMTP password for SES"
}

variable "ses_smtp_user" {
  type        = string
  description = "SMTP user for SES"
}

variable "timezone" {
  type        = string
  description = "Timezone"
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to each resource"
}

variable "vpc_id" {
  type        = string
  description = "The id of the VPC where the container needs to run"
}

variable "vpc_private_subnet_ids" {
  type        = list(string)
  description = "The private subnet ids of the VPC"
}

variable "vpc_public_subnet_ids" {
  type        = list(string)
  description = "The public subnet ids of the VPC"
}

variable "zone_id" {
  type        = string
  description = "Route53 zone id"
}
