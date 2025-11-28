output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "ec2_instance_ids" {
  description = "EC2 instance IDs"
  value       = [for ec2 in module.ec2 : ec2.instance_id]
}

output "ec2_private_ips" {
  description = "EC2 private IP addresses"
  value       = [for ec2 in module.ec2 : ec2.private_ip]
}

output "alb_dns_name" {
  description = "ALB DNS name"
  value       = module.alb.alb_dns_name
}

output "alb_arn" {
  description = "ALB ARN"
  value       = module.alb.alb_arn
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = module.s3_cloudfront.cloudfront_distribution_id
}

output "cloudfront_domain_name" {
  description = "CloudFront domain name"
  value       = module.s3_cloudfront.cloudfront_domain_name
}

output "s3_bucket_name" {
  description = "S3 bucket name for static website"
  value       = module.s3_cloudfront.s3_bucket_name
}

output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = aws_ecr_repository.microservice.repository_url
}

output "domain_urls" {
  description = "All configured domain URLs"
  value = {
    ec2_docker1      = "https://${local.subdomains.ec2_docker1}"
    ec2_instance1    = "https://${local.subdomains.ec2_instance1}"
    ec2_docker2      = "https://${local.subdomains.ec2_docker2}"
    ec2_instance2    = "https://${local.subdomains.ec2_instance2}"
    alb_docker       = "https://${local.subdomains.alb_docker}"
    alb_instance     = "https://${local.subdomains.alb_instance}"
    static_s3        = "https://${local.subdomains.static_s3}"
  }
}

output "cloudwatch_log_groups" {
  description = "CloudWatch log group names"
  value = {
    nginx_access = module.cloudwatch.nginx_log_group_name
  }
}

