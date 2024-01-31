module "module_deployment" {
  source            = "app.terraform.io/fuseplatform/module-deploy/aws"
  version           = "0.3.0"
  customer          = var.customer
  subnet_ids        = var.vpc_private_subnet_ids
  tags              = local.tags
  module_code       = local.module_code
  module_repository = "terraform-aws-ft-${local.module_code}"
  module_version    = trimspace(file("${path.module}/VERSION"))

  depends_on = [
    module.grafana,
    resource.aws_ecr_repository.grafana,
    ### Disabled for LWM/SBP cleanup
    # resource.null_resource.grafana_database_trigger
  ]
}
