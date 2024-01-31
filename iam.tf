locals {
  create_iam_role = var.iam_role_arn == null ? true : false

  iam_data_source_policies = {
    ATHENA     = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AmazonGrafanaAthenaAccess"
    CLOUDWATCH = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AmazonGrafanaCloudWatchAccess"
    REDSHIFT   = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AmazonGrafanaRedshiftAccess"
    SITEWISE   = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWSIoTSiteWiseReadOnlyAccess"
    TIMESTREAM = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonTimestreamReadOnlyAccess"
    XRAY       = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AWSXrayReadOnlyAccess"
  }
}

data "aws_iam_policy_document" "assume_policy" {
  count = local.create_iam_role ? 1 : 0

  statement {
    sid     = "GrafanaAssume"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["grafana.${data.aws_partition.current.dns_suffix}"]
    }
  }
}

data "aws_iam_policy_document" "default" {
  count = local.create_iam_role ? 1 : 0

  dynamic "statement" {
    for_each = contains(var.data_sources, "AMAZON_OPENSEARCH_SERVICE") ? { create : true } : {}

    content {
      actions = [
        "es:ESHttpGet",
        "es:DescribeElasticsearchDomains",
        "es:ListDomainNames",
      ]
      resources = ["*"]
    }
  }

  dynamic "statement" {
    for_each = contains(var.data_sources, "AMAZON_OPENSEARCH_SERVICE") ? { create : true } : {}

    content {
      actions = ["es:ESHttpGet"]
      resources = [
        "arn:${data.aws_partition.current.partition}:es:*:*:domain/*/_msearch*",
        "arn:${data.aws_partition.current.partition}:es:*:*:domain/*/_opendistro/_ppl",
      ]
    }
  }

  dynamic "statement" {
    for_each = contains(var.data_sources, "PROMETHEUS") ? { create : true } : {}

    content {
      actions = [
        "aps:ListWorkspaces",
        "aps:DescribeWorkspace",
        "aps:QueryMetrics",
        "aps:GetLabels",
        "aps:GetSeries",
        "aps:GetMetricMetadata",
      ]
      resources = ["*"]
    }
  }

  dynamic "statement" {
    for_each = contains(var.notification_destinations, "SNS") ? { create : true } : {}

    content {
      actions   = ["sns:Publish"]
      resources = ["arn:${data.aws_partition.current.partition}:sns:*:${data.aws_caller_identity.current.account_id}:grafana*"]
    }
  }
}

resource "aws_iam_role" "default" {
  count = local.create_iam_role ? 1 : 0

  name               = "GrafanaExecutionRole-${var.name}"
  assume_role_policy = data.aws_iam_policy_document.assume_policy[0].json
  tags               = var.tags
}

resource "aws_iam_policy" "default" {
  count = local.create_iam_role ? 1 : 0

  name   = "GrafanaExecutionRolePolicy-${var.name}"
  policy = data.aws_iam_policy_document.default[0].json
  tags   = var.tags
}

resource "aws_iam_role_policy_attachment" "data_sources" {
  for_each = { for i, v in var.data_sources : v => local.iam_data_source_policies[v] if local.create_iam_role }

  role       = aws_iam_role.default[0].name
  policy_arn = each.value
}

resource "aws_iam_role_policy_attachment" "default" {
  count = local.create_iam_role ? 1 : 0

  role       = aws_iam_role.default[0].name
  policy_arn = aws_iam_policy.default[0].arn
}
