variable "domain_name" {
  type = string
}

variable "route53_zone_id" {
  type = string
}

variable "ec2_instances" {
  type = any
}

variable "alb_dns_name" {
  type = string
}

variable "alb_zone_id" {
  type = string
}

variable "cloudfront_domain_name" {
  type = string
}

variable "cloudfront_zone_id" {
  type = string
}

variable "subdomains" {
  type = map(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}
