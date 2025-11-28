# AWS Configuration
aws_region  = "us-east-1"
environment = "production"
project_name = "my-infrastructure"

# Domain Configuration
domain_name      = "themangoking.au"
route53_zone_id  = "Z02157903850DICUOJ23I"  # Your Route53 hosted zone ID

# EC2 Configuration
instance_type = "t3.small"
key_name      = "assignment"  # Your EC2 key pair name

# VPC Configuration
vpc_cidr           = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b"]

# CloudFront Geo-Restriction
geo_restriction_type      = "whitelist"
geo_restriction_locations = ["US", "IN", "GB", "CA", "AU"]

# GitHub Configuration
github_repo         = "manishpcp/terraform-aws-infrastructure"
ecr_repository_name = "custom-microservice"

# Tags
tags = {
  Project     = "AWS-Infrastructure"
  Environment = "Production"
  ManagedBy   = "Terraform"
  Owner       = "DevOps-Team"
}

