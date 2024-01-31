resource "aws_ecr_repository" "grafana" {
  name = "grafana"
  tags = var.tags

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "grafana_policy" {
  repository = aws_ecr_repository.grafana.name

  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Expire untagged images older than 1 day",
      "selection": {
        "tagStatus": "untagged",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": 1
      },
      "action": {
        "type": "expire"
      }
    },
    {
      "action": {
        "type": "expire"
      },
      "selection": {
        "countType": "imageCountMoreThan",
        "countNumber": 5,
        "tagStatus": "tagged",
        "tagPrefixList": [
          "7"
        ]
      },
      "description": "Expire Grafana 7 (keep 5 versions)",
      "rulePriority": 4
    }
  ]
}
EOF
}
