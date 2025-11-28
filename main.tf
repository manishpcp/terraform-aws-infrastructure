# VPC Module
module "vpc" {
  source = "./modules/vpc"

  name_prefix          = local.name_prefix
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = local.public_subnet_cidrs
  private_subnet_cidrs = local.private_subnet_cidrs
  tags                 = local.common_tags
}

# Security Groups Module
module "security_groups" {
  source = "./modules/security-groups"

  name_prefix = local.name_prefix
  vpc_id      = module.vpc.vpc_id
  vpc_cidr    = var.vpc_cidr
  tags        = local.common_tags
}

# IAM Module
module "iam" {
  source = "./modules/iam"

  name_prefix = local.name_prefix
  tags        = local.common_tags
}

# CloudWatch Module
module "cloudwatch" {
  source = "./modules/cloudwatch"

  name_prefix = local.name_prefix
  tags        = local.common_tags
}

# EC2 Instances Module
module "ec2" {
  source = "./modules/ec2"
  count  = 2

  name                     = local.ec2_instances[count.index].name
  ami_id                   = data.aws_ami.amazon_linux_2023.id
  instance_type            = var.instance_type
  key_name                 = var.key_name
  subnet_id                = module.vpc.private_subnet_ids[local.ec2_instances[count.index].subnet_index]
  vpc_security_group_ids   = [module.security_groups.ec2_security_group_id]
  iam_instance_profile     = module.iam.ec2_instance_profile_name
  docker_subdomain         = local.ec2_instances[count.index].docker_subdomain
  instance_subdomain       = local.ec2_instances[count.index].instance_subdomain
  cloudwatch_log_group     = module.cloudwatch.nginx_log_group_name
  tags                     = local.common_tags
}

# Application Load Balancer Module
module "alb" {
  source = "./modules/alb"

  name_prefix              = local.name_prefix
  vpc_id                   = module.vpc.vpc_id
  public_subnet_ids        = module.vpc.public_subnet_ids
  alb_security_group_id    = module.security_groups.alb_security_group_id
  ec2_instance_ids         = [for ec2 in module.ec2 : ec2.instance_id]
  domain_name              = var.domain_name
  alb_docker_subdomain     = local.subdomains.alb_docker
  alb_instance_subdomain   = local.subdomains.alb_instance
  route53_zone_id          = var.route53_zone_id
  tags                     = local.common_tags
}

# Route53 Module
module "route53" {
  source = "./modules/route53"

  domain_name      = var.domain_name
  route53_zone_id  = var.route53_zone_id
  ec2_instances    = module.ec2
  alb_dns_name     = module.alb.alb_dns_name
  alb_zone_id      = module.alb.alb_zone_id
  cloudfront_domain_name = module.s3_cloudfront.cloudfront_domain_name
  cloudfront_zone_id     = module.s3_cloudfront.cloudfront_zone_id
  subdomains       = local.subdomains
  tags             = local.common_tags
}

# S3 and CloudFront Module
module "s3_cloudfront" {
  source = "./modules/s3-cloudfront"

  name_prefix                = local.name_prefix
  domain_name                = var.domain_name
  static_subdomain           = local.subdomains.static_s3
  route53_zone_id            = var.route53_zone_id
  geo_restriction_type       = var.geo_restriction_type
  geo_restriction_locations  = var.geo_restriction_locations
  tags                       = local.common_tags
}

# ECR Repository for microservice
resource "aws_ecr_repository" "microservice" {
  name                 = var.ecr_repository_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = local.common_tags
}


resource "aws_ecr_lifecycle_policy" "microservice" {
  repository = aws_ecr_repository.microservice.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 10 images"
      selection = {
        tagStatus     = "any"
        countType     = "imageCountMoreThan"
        countNumber   = 10
      }
      action = {
        type = "expire"
      }
    }]
  })
}

