variable "name" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "vpc_security_group_ids" {
  type = list(string)
}

variable "iam_instance_profile" {
  type = string
}

variable "docker_subdomain" {
  type = string
}

variable "instance_subdomain" {
  type = string
}

variable "cloudwatch_log_group" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
