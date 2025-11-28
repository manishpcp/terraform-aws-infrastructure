resource "aws_cloudwatch_log_group" "nginx_access" {
  name              = "/aws/ec2/${var.name_prefix}/nginx/access"
  retention_in_days = 7
  tags = merge(var.tags, { Name = "${var.name_prefix}-nginx-access" })
}

resource "aws_cloudwatch_log_group" "nginx_error" {
  name              = "/aws/ec2/${var.name_prefix}/nginx/error"
  retention_in_days = 7
  tags = merge(var.tags, { Name = "${var.name_prefix}-nginx-error" })
}

resource "aws_cloudwatch_log_group" "docker" {
  name              = "/aws/ec2/${var.name_prefix}/docker"
  retention_in_days = 7
  tags = merge(var.tags, { Name = "${var.name_prefix}-docker" })
}
