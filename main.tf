locals {
  grafana_version = "8.5.3-1"
  module_code     = "grafana"
  module_version  = trimspace(file("${path.module}/VERSION"))
  tags            = merge(var.tags, { "Feature" = local.module_code })
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
