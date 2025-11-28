output "s3_bucket_name" {
  value = aws_s3_bucket.website.id
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.website.arn
}

output "s3_website_endpoint" {
  value = aws_s3_bucket_website_configuration.website.website_endpoint
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.website.id
}

output "cloudfront_distribution_arn" {
  value = aws_cloudfront_distribution.website.arn
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.website.domain_name
}

output "cloudfront_zone_id" {
  value = aws_cloudfront_distribution.website.hosted_zone_id
}

output "certificate_arn" {
  value = aws_acm_certificate.cloudfront.arn
}
