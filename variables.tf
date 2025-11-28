variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "domain_name" {
  description = "Root domain name"
  type        = string
}

variable "route53_zone_id" {
  description = "Route53 hosted zone ID"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "geo_restriction_type" {
  description = "CloudFront geo-restriction type"
  type        = string
  default     = "whitelist"
}

variable "geo_restriction_locations" {
  description = "List of country codes for geo-restriction"
  type        = list(string)
  default     = ["US", "IN"]
}

variable "github_repo" {
  description = "GitHub repository for microservice"
  type        = string
  default     = ""
}

variable "ecr_repository_name" {
  description = "ECR repository name"
  type        = string
  default     = "microservice"
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}

