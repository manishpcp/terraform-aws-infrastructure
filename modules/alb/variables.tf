variable "name_prefix" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "alb_security_group_id" {
  type = string
}

variable "ec2_instance_ids" {
  type = list(string)
}

variable "domain_name" {
  type = string
}

variable "alb_docker_subdomain" {
  type = string
}

variable "alb_instance_subdomain" {
  type = string
}

variable "route53_zone_id" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
