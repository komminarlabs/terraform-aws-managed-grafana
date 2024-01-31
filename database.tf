data "aws_iam_policy_document" "codebuild_grafana_policy" {
  statement {
    actions = [
      "ec2:CreateNetworkInterfacePermission",
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath"
    ]
    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/migrations/*",
      aws_ssm_parameter.aurora_grafana_password.arn
    ]
  }
}

module "codebuild_grafana_role" {
  source                = "github.com/schubergphilis/terraform-aws-mcaf-role?ref=v0.3.1"
  name                  = "codebuild-grafana-database"
  create_policy         = true
  principal_identifiers = ["codebuild.amazonaws.com"]
  principal_type        = "Service"
  role_policy           = data.aws_iam_policy_document.codebuild_grafana_policy.json
  tags                  = var.tags
}

resource "aws_codebuild_project" "grafana_database" {
  name         = "grafana-database"
  description  = "Provision the Grafana database"
  service_role = module.codebuild_grafana_role.arn
  tags         = var.tags

  source {
    buildspec = file("${path.module}/scripts/grafana_buildspec.yaml")
    type      = "NO_SOURCE"
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  logs_config {
    cloudwatch_logs {
      group_name = "grafana-database-logs"
      status     = "ENABLED"
    }
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
    type                        = "LINUX_CONTAINER"

    environment_variable {
      name  = "CUSTOMER"
      value = var.customer
    }

    environment_variable {
      name  = "GRAFANA_PASSWORD"
      type  = "PARAMETER_STORE"
      value = aws_ssm_parameter.aurora_grafana_password.name
    }
  }

  vpc_config {
    security_group_ids = [var.aurora_security_group_id]
    subnets            = var.vpc_private_subnet_ids
    vpc_id             = var.vpc_id
  }
}

resource "null_resource" "grafana_database_trigger" {
  triggers = {
    ssm_path = aws_ssm_parameter.aurora_grafana_password.name
  }

  provisioner "local-exec" {
    command = "${path.module}/bin/trigger -project-name=grafana-database -source-version=${local.module_version}"
  }

  depends_on = [
    aws_codebuild_project.grafana_database
  ]
}

resource "random_string" "aurora_grafana_password" {
  length  = 16
  special = false
}

resource "aws_ssm_parameter" "aurora_grafana_password" {
  name  = "/${var.customer}/aurora/grafana/password"
  type  = "SecureString"
  value = random_string.aurora_grafana_password.result
  tags  = var.tags
}

resource "aws_security_group_rule" "grafana_aurora" {
  security_group_id        = var.aurora_security_group_id
  type                     = "ingress"
  from_port                = "5432"
  to_port                  = "5432"
  protocol                 = "tcp"
  source_security_group_id = module.grafana.security_group_id
}
