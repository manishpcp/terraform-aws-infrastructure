output "nginx_log_group_name" {
  value = aws_cloudwatch_log_group.nginx_access.name
}

output "nginx_error_log_group_name" {
  value = aws_cloudwatch_log_group.nginx_error.name
}

output "docker_log_group_name" {
  value = aws_cloudwatch_log_group.docker.name
}
