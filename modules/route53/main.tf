resource "aws_acm_certificate" "ec2" {
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.tags, { Name = "ec2-direct-cert" })
}

resource "aws_route53_record" "ec2_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.ec2.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.route53_zone_id
}

resource "aws_acm_certificate_validation" "ec2" {
  certificate_arn         = aws_acm_certificate.ec2.arn
  validation_record_fqdns = [for record in aws_route53_record.ec2_cert_validation : record.fqdn]
}

resource "aws_route53_record" "alb_docker" {
  zone_id = var.route53_zone_id
  name    = var.subdomains.alb_docker
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "alb_instance" {
  zone_id = var.route53_zone_id
  name    = var.subdomains.alb_instance
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cloudfront" {
  zone_id = var.route53_zone_id
  name    = var.subdomains.static_s3
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_zone_id
    evaluate_target_health = false
  }
}
