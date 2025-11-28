resource "aws_instance" "main" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  iam_instance_profile   = var.iam_instance_profile

  user_data = templatefile("${path.module}/user-data.sh.tpl", {
    docker_subdomain       = var.docker_subdomain
    instance_subdomain     = var.instance_subdomain
    cloudwatch_log_group   = var.cloudwatch_log_group
    region                 = data.aws_region.current.name
  })

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    encrypted             = true
    delete_on_termination = true
  }

  tags = merge(var.tags, { Name = var.name })
}

data "aws_region" "current" {}
