output "certificate_arn" {
  value = aws_acm_certificate.ec2.arn
}

output "alb_docker_fqdn" {
  value = aws_route53_record.alb_docker.fqdn
}

output "alb_instance_fqdn" {
  value = aws_route53_record.alb_instance.fqdn
}

output "cloudfront_fqdn" {
  value = aws_route53_record.cloudfront.fqdn
}
