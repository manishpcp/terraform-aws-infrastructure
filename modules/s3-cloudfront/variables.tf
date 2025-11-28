variable "name_prefix" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "static_subdomain" {
  type = string
}

variable "route53_zone_id" {
  type = string
}

variable "geo_restriction_type" {
  type    = string
  default = "none"
}

variable "geo_restriction_locations" {
  type    = list(string)
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
