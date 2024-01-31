# terraform-aws-grafana
Terraform module to create and manage Grafana

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_influx"></a> [influx](#provider\_influx) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_okta"></a> [okta](#provider\_okta) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_codebuild_grafana_role"></a> [codebuild\_grafana\_role](#module\_codebuild\_grafana\_role) | github.com/schubergphilis/terraform-aws-mcaf-role | v0.3.1 |
| <a name="module_grafana"></a> [grafana](#module\_grafana) | github.com/schubergphilis/terraform-aws-mcaf-fargate | v0.11.0 |
| <a name="module_module_deployment"></a> [module\_deployment](#module\_module\_deployment) | app.terraform.io/fuseplatform/module-deploy/aws | 0.3.0 |

## Resources

| Name | Type |
|------|------|
| [aws_codebuild_project.grafana_database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_ecr_lifecycle_policy.grafana_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.grafana](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_security_group_rule.grafana_aurora](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_ssm_parameter.aurora_grafana_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.client_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.client_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.grafana_admin_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.grafana_influx_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [influx_authorization.grafana](https://registry.terraform.io/providers/schubergphilis/influx/latest/docs/resources/authorization) | resource |
| [null_resource.grafana_config](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.grafana_database_trigger](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [okta_app_group_assignments.default](https://registry.terraform.io/providers/okta/okta/latest/docs/resources/app_group_assignments) | resource |
| [okta_app_oauth.default](https://registry.terraform.io/providers/okta/okta/latest/docs/resources/app_oauth) | resource |
| [random_string.aurora_grafana_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.codebuild_grafana_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.task_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aurora_datamodel_ro_password"></a> [aurora\_datamodel\_ro\_password](#input\_aurora\_datamodel\_ro\_password) | Password for the Aurora Data Model Read-Only user | `string` | n/a | yes |
| <a name="input_aurora_endpoint"></a> [aurora\_endpoint](#input\_aurora\_endpoint) | Aurora database endpoint | `string` | n/a | yes |
| <a name="input_aurora_port"></a> [aurora\_port](#input\_aurora\_port) | Aurora database endpoint port | `string` | n/a | yes |
| <a name="input_aurora_security_group_id"></a> [aurora\_security\_group\_id](#input\_aurora\_security\_group\_id) | Aurora database security group id | `string` | n/a | yes |
| <a name="input_customer"></a> [customer](#input\_customer) | The customer name | `string` | n/a | yes |
| <a name="input_grafana_admin_password"></a> [grafana\_admin\_password](#input\_grafana\_admin\_password) | The admin password for the Grafana instance | `string` | n/a | yes |
| <a name="input_grafana_organisation"></a> [grafana\_organisation](#input\_grafana\_organisation) | Name of the organisation to create in Grafana | `string` | n/a | yes |
| <a name="input_influx_bucket_ids"></a> [influx\_bucket\_ids](#input\_influx\_bucket\_ids) | InfluxDB bucket ids to grant read access to | `list(string)` | n/a | yes |
| <a name="input_influx_measurements_name"></a> [influx\_measurements\_name](#input\_influx\_measurements\_name) | InfluxDB measurements table name | `string` | n/a | yes |
| <a name="input_influx_processed_name"></a> [influx\_processed\_name](#input\_influx\_processed\_name) | InfluxDB procesed table name | `string` | n/a | yes |
| <a name="input_ses_smtp_domain"></a> [ses\_smtp\_domain](#input\_ses\_smtp\_domain) | SMTP domain for SES | `string` | n/a | yes |
| <a name="input_ses_smtp_password"></a> [ses\_smtp\_password](#input\_ses\_smtp\_password) | SMTP password for SES | `string` | n/a | yes |
| <a name="input_ses_smtp_user"></a> [ses\_smtp\_user](#input\_ses\_smtp\_user) | SMTP user for SES | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to each resource | `map(string)` | n/a | yes |
| <a name="input_timezone"></a> [timezone](#input\_timezone) | Timezone | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The id of the VPC where the container needs to run | `string` | n/a | yes |
| <a name="input_vpc_private_subnet_ids"></a> [vpc\_private\_subnet\_ids](#input\_vpc\_private\_subnet\_ids) | The private subnet ids of the VPC | `list(string)` | n/a | yes |
| <a name="input_vpc_public_subnet_ids"></a> [vpc\_public\_subnet\_ids](#input\_vpc\_public\_subnet\_ids) | The public subnet ids of the VPC | `list(string)` | n/a | yes |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | Route53 zone id | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->