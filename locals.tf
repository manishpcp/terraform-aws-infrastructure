locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = merge(
    var.tags,
    {
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
    }
  )

  public_subnet_cidrs  = [for i in range(2) : cidrsubnet(var.vpc_cidr, 8, i)]
  private_subnet_cidrs = [for i in range(2) : cidrsubnet(var.vpc_cidr, 8, i + 10)]

  subdomains = {
    ec2_docker1      = "ec2-docker1.${var.domain_name}"
    ec2_instance1    = "ec2-instance1.${var.domain_name}"
    ec2_docker2      = "ec2-docker2.${var.domain_name}"
    ec2_instance2    = "ec2-instance2.${var.domain_name}"
    alb_docker       = "ec2-alb-docker.${var.domain_name}"
    alb_instance     = "ec2-alb-instance.${var.domain_name}"
    static_s3        = "static-s3.${var.domain_name}"
  }

  ec2_instances = [
    {
      name            = "${local.name_prefix}-ec2-1"
      subnet_index    = 0
      docker_subdomain = local.subdomains.ec2_docker1
      instance_subdomain = local.subdomains.ec2_instance1
    },
    {
      name            = "${local.name_prefix}-ec2-2"
      subnet_index    = 1
      docker_subdomain = local.subdomains.ec2_docker2
      instance_subdomain = local.subdomains.ec2_instance2
    }
  ]
}

